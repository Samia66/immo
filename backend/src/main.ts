import { NestFactory } from '@nestjs/core';
import { NestExpressApplication } from '@nestjs/platform-express';
import { ConfigService } from '@nestjs/config';
import { ValidationPipe } from '@nestjs/common';
import { DocumentBuilder, SwaggerModule } from '@nestjs/swagger';
import helmet from 'helmet';
import cookieParser from 'cookie-parser';
import { join } from 'path';
import { AppModule } from './app.module';
import { AppConfig } from './config/configuration';
import { buildCorsConfig } from './config/cors.config';
import { UPLOADS_ROOT } from './common/utils/file-storage.util';

async function bootstrap() {
  const app = await NestFactory.create<NestExpressApplication>(AppModule, { cors: false });
  const config = app.get(ConfigService<AppConfig, true>);

  app.use(helmet());
  app.use(cookieParser());
  app.enableCors(
    buildCorsConfig(
      config.get('corsOrigins', { infer: true }),
      config.get('nodeEnv', { infer: true }) !== 'production',
    ),
  );
  app.useStaticAssets(join(process.cwd(), UPLOADS_ROOT), { prefix: '/uploads' });

  app.useGlobalPipes(
    new ValidationPipe({
      whitelist: true,
      forbidNonWhitelisted: true,
      transform: true,
      transformOptions: { enableImplicitConversion: true },
    }),
  );

  const apiPrefix = config.get('apiPrefix', { infer: true });
  app.setGlobalPrefix(apiPrefix, { exclude: ['health'] });

  const swaggerConfig = new DocumentBuilder()
    .setTitle('Immo SaaS API')
    .setDescription('API de la plateforme SaaS de gestion immobilière (multi-tenant)')
    .setVersion('1.0')
    .addBearerAuth()
    .build();
  const document = SwaggerModule.createDocument(app, swaggerConfig);
  SwaggerModule.setup(`${apiPrefix}/docs`, app, document);

  const port = config.get('port', { infer: true });
  await app.listen(port);
  // eslint-disable-next-line no-console
  console.log(`Immo backend listening on port ${port} (prefix: /${apiPrefix}, docs: /${apiPrefix}/docs)`);
}

bootstrap();
