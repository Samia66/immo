import { Module } from '@nestjs/common';
import { OwnerInvitationsController } from './owner-invitations.controller';
import { OwnerInvitationsService } from './owner-invitations.service';
import { AuthModule } from '../../auth/auth.module';

@Module({
  imports: [AuthModule],
  controllers: [OwnerInvitationsController],
  providers: [OwnerInvitationsService],
  exports: [OwnerInvitationsService],
})
export class OwnerInvitationsModule {}
