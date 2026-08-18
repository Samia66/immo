import { Body, Controller, Get, Param, Post, Query, Res, UseGuards } from '@nestjs/common';
import type { Response } from 'express';
import { ApiBearerAuth, ApiTags } from '@nestjs/swagger';
import { PaymentsService } from './payments.service';
import { CreatePaymentDto, RecordPaymentDto, QueryPaymentDto } from './dto';
import { JwtAuthGuard, PermissionsGuard } from '../../common/guards';
import { Permissions, CurrentUser, Audit } from '../../common/decorators';
import { ParseUuidPipe } from '../../common/pipes';
import { AuthenticatedUser } from '../../common/interfaces';

@ApiTags('payments')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard, PermissionsGuard)
@Controller('payments')
export class PaymentsController {
  constructor(private readonly service: PaymentsService) {}

  @Get('overdue')
  @Permissions('payments:read_overdue')
  overdue(@CurrentUser() user: AuthenticatedUser, @Query() query: QueryPaymentDto) {
    return this.service.overdue(user.organizationId, query);
  }

  @Get('me')
  @Permissions('payments:read_own')
  myPayments(@CurrentUser('id') userId: string, @Query() query: QueryPaymentDto) {
    return this.service.myPayments(userId, query);
  }

  @Get()
  @Permissions('payments:read')
  findAll(@CurrentUser() user: AuthenticatedUser, @Query() query: QueryPaymentDto) {
    return this.service.findAll(user.organizationId, query);
  }

  @Get(':id')
  @Permissions('payments:read_detail')
  findOne(@CurrentUser() user: AuthenticatedUser, @Param('id', ParseUuidPipe) id: string) {
    return this.service.findOne(id, user);
  }

  @Get(':id/receipt.pdf')
  @Permissions('payments:read_receipt')
  async receipt(
    @CurrentUser() user: AuthenticatedUser,
    @Param('id', ParseUuidPipe) id: string,
    @Res() res: Response,
  ) {
    const pdf = await this.service.receipt(id, user);
    res.set({
      'Content-Type': 'application/pdf',
      'Content-Disposition': `attachment; filename="quittance-${id}.pdf"`,
    });
    res.send(pdf);
  }

  @Post()
  @Permissions('payments:create')
  create(@CurrentUser() user: AuthenticatedUser, @Body() dto: CreatePaymentDto) {
    return this.service.create(user.organizationId, dto);
  }

  @Post(':id/record')
  @Permissions('payments:record')
  @Audit('PAYMENT_RECORDED', 'Payment')
  record(@Param('id', ParseUuidPipe) id: string, @Body() dto: RecordPaymentDto) {
    return this.service.record(id, dto);
  }
}
