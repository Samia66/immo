import { Body, Controller, Delete, Get, Param, Patch, Post, Query, UseGuards } from '@nestjs/common';
import { ApiBearerAuth, ApiTags } from '@nestjs/swagger';
import { ExpensesService } from './expenses.service';
import { CreateExpenseDto, UpdateExpenseDto, QueryExpenseDto, ExpenseReportQueryDto } from './dto';
import { JwtAuthGuard, PermissionsGuard } from '../../common/guards';
import { Permissions, CurrentUser } from '../../common/decorators';
import { ParseUuidPipe } from '../../common/pipes';
import { AuthenticatedUser } from '../../common/interfaces';

@ApiTags('expenses')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard, PermissionsGuard)
@Controller('expenses')
export class ExpensesController {
  constructor(private readonly service: ExpensesService) {}

  @Get('reports')
  @Permissions('expenses:read_reports')
  report(@CurrentUser() user: AuthenticatedUser, @Query() query: ExpenseReportQueryDto) {
    return this.service.report(user.organizationId, query);
  }

  @Get()
  @Permissions('expenses:read')
  findAll(@CurrentUser() user: AuthenticatedUser, @Query() query: QueryExpenseDto) {
    return this.service.findAll(user.organizationId, query);
  }

  @Post()
  @Permissions('expenses:create')
  create(@CurrentUser() user: AuthenticatedUser, @Body() dto: CreateExpenseDto) {
    return this.service.create(user.organizationId, dto);
  }

  @Patch(':id')
  @Permissions('expenses:update')
  update(@Param('id', ParseUuidPipe) id: string, @Body() dto: UpdateExpenseDto) {
    return this.service.update(id, dto);
  }

  @Delete(':id')
  @Permissions('expenses:delete')
  remove(@Param('id', ParseUuidPipe) id: string) {
    return this.service.remove(id);
  }
}
