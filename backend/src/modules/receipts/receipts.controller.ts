import { Controller, Get, Param, Query, Res, UseGuards } from '@nestjs/common';
import type { Response } from 'express';
import { ApiBearerAuth, ApiTags } from '@nestjs/swagger';
import { ReceiptsService } from './receipts.service';
import { QueryReceiptDto } from './dto';
import { JwtAuthGuard, PermissionsGuard } from '../../common/guards';
import { Permissions, CurrentUser } from '../../common/decorators';
import { ParseUuidPipe } from '../../common/pipes';
import { AuthenticatedUser } from '../../common/interfaces';

@ApiTags('receipts')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard, PermissionsGuard)
@Controller('receipts')
export class ReceiptsController {
  constructor(private readonly service: ReceiptsService) {}

  @Get()
  @Permissions('payments:read')
  findAll(@CurrentUser() user: AuthenticatedUser, @Query() query: QueryReceiptDto) {
    return this.service.findAll(user.organizationId, query);
  }

  @Get(':id/download')
  @Permissions('payments:read_receipt')
  async download(
    @CurrentUser() user: AuthenticatedUser,
    @Param('id', ParseUuidPipe) id: string,
    @Res() res: Response,
  ) {
    const pdf = await this.service.download(id, user);
    res.set({
      'Content-Type': 'application/pdf',
      'Content-Disposition': `attachment; filename="quittance-${id}.pdf"`,
    });
    res.send(pdf);
  }
}
