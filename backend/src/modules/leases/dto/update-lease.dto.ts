import { PartialType, OmitType } from '@nestjs/swagger';
import { CreateLeaseDto } from './create-lease.dto';

export class UpdateLeaseDto extends PartialType(OmitType(CreateLeaseDto, ['propertyUnitId', 'tenantId'] as const)) {}
