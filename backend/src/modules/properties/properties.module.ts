import { Module } from '@nestjs/common';
import { PropertiesController } from './properties.controller';
import { PropertiesService } from './properties.service';
import { PropertiesRepository } from './properties.repository';
import { PropertyImagesService } from './property-images/property-images.service';
import { PropertyUnitsModule } from '../property-units/property-units.module';

@Module({
  imports: [PropertyUnitsModule],
  controllers: [PropertiesController],
  providers: [PropertiesService, PropertiesRepository, PropertyImagesService],
  exports: [PropertiesService],
})
export class PropertiesModule {}
