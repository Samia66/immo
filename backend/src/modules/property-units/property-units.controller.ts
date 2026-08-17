import { Body, Controller, Delete, Get, Param, Patch, UseGuards } from '@nestjs/common';
import { ApiBearerAuth, ApiTags } from '@nestjs/swagger';
import { PropertyUnitsService } from './property-units.service';
import { UpdatePropertyUnitDto } from './dto';
import { JwtAuthGuard, PermissionsGuard } from '../../common/guards';
import { Permissions, Audit } from '../../common/decorators';
import { ParseUuidPipe } from '../../common/pipes';

/** Direct-access routes for a single unit. Nested list/create routes live on PropertiesController. */
@ApiTags('property-units')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard, PermissionsGuard)
@Controller('property-units')
export class PropertyUnitsController {
  constructor(private readonly service: PropertyUnitsService) {}

  @Get(':id')
  @Permissions('properties:read')
  findOne(@Param('id', ParseUuidPipe) id: string) {
    return this.service.findOne(id);
  }

  @Patch(':id')
  @Permissions('properties:update')
  update(@Param('id', ParseUuidPipe) id: string, @Body() dto: UpdatePropertyUnitDto) {
    return this.service.update(id, dto);
  }

  @Delete(':id')
  @Permissions('properties:delete')
  @Audit('DELETE', 'PropertyUnit')
  remove(@Param('id', ParseUuidPipe) id: string) {
    return this.service.remove(id);
  }
}
