import { ArgumentsHost, Catch, ExceptionFilter, HttpStatus, Logger } from '@nestjs/common';
import { Response, Request } from 'express';
import { Prisma } from '@prisma/client';

/**
 * Maps Prisma known-request errors to sensible HTTP responses so services never need to
 * translate low-level DB error codes themselves.
 */
@Catch(Prisma.PrismaClientKnownRequestError, Prisma.PrismaClientValidationError)
export class PrismaExceptionFilter implements ExceptionFilter {
  private readonly logger = new Logger('PrismaExceptionFilter');

  catch(exception: Prisma.PrismaClientKnownRequestError | Prisma.PrismaClientValidationError, host: ArgumentsHost) {
    const ctx = host.switchToHttp();
    const response = ctx.getResponse<Response>();
    const request = ctx.getRequest<Request>();

    let status = HttpStatus.BAD_REQUEST;
    let message = 'Erreur de base de données.';

    if (exception instanceof Prisma.PrismaClientKnownRequestError) {
      switch (exception.code) {
        case 'P2002': {
          const target = (exception.meta?.target as string[] | undefined)?.join(', ') ?? 'champ';
          status = HttpStatus.CONFLICT;
          message = `Une ressource avec ce ${target} existe déjà.`;
          break;
        }
        case 'P2025':
          status = HttpStatus.NOT_FOUND;
          message = 'Ressource introuvable.';
          break;
        case 'P2003':
          status = HttpStatus.BAD_REQUEST;
          message = 'Référence invalide (clé étrangère).';
          break;
        case 'P2014':
          status = HttpStatus.BAD_REQUEST;
          message = 'Relation invalide entre les ressources.';
          break;
        default:
          status = HttpStatus.BAD_REQUEST;
          message = `Erreur de base de données (${exception.code}).`;
      }
    } else {
      status = HttpStatus.BAD_REQUEST;
      message = 'Requête invalide.';
    }

    this.logger.warn(`${request.method} ${request.url} -> ${status}: ${message}`);

    response.status(status).json({
      statusCode: status,
      error: 'Bad Request',
      message,
      path: request.url,
      timestamp: new Date().toISOString(),
    });
  }
}
