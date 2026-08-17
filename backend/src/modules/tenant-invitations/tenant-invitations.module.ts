import { Module } from '@nestjs/common';
import { LeaseTenantInvitationsController, TenantInvitationsController } from './tenant-invitations.controller';
import { TenantInvitationsService } from './tenant-invitations.service';
import { AuthModule } from '../auth/auth.module';
import { TenantsModule } from '../tenants/tenants.module';

@Module({
  imports: [AuthModule, TenantsModule],
  controllers: [LeaseTenantInvitationsController, TenantInvitationsController],
  providers: [TenantInvitationsService],
  exports: [TenantInvitationsService],
})
export class TenantInvitationsModule {}
