import { Controller, Get, Param, Query, UseGuards } from '@nestjs/common';
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
  download(@CurrentUser() user: AuthenticatedUser, @Param('id', ParseUuidPipe) id: string) {
    return this.service.download(id, user);
  }
}
