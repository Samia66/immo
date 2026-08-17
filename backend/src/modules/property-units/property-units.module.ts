import { Module } from '@nestjs/common';
import { PropertyUnitsController } from './property-units.controller';
import { PropertyUnitsService } from './property-units.service';
import { PropertyUnitsRepository } from './property-units.repository';

@Module({
  controllers: [PropertyUnitsController],
  providers: [PropertyUnitsService, PropertyUnitsRepository],
  exports: [PropertyUnitsService],
})
export class PropertyUnitsModule {}
