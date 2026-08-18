import { Module } from '@nestjs/common';
import { ConfigModule, ConfigService } from '@nestjs/config';
import { ScheduleModule } from '@nestjs/schedule';
import { ThrottlerModule, ThrottlerGuard } from '@nestjs/throttler';
import { APP_FILTER, APP_GUARD, APP_INTERCEPTOR } from '@nestjs/core';

import configuration, { AppConfig } from './config/configuration';
import { validationSchema } from './config/validation.schema';

import { PrismaModule } from './prisma/prisma.module';
import { HealthModule } from './health/health.module';

import { AuthModule } from './modules/auth/auth.module';
import { OrganizationsModule } from './modules/organizations/organizations.module';
import { UsersModule } from './modules/users/users.module';
import { RolesModule } from './modules/roles/roles.module';
import { PermissionsModule } from './modules/permissions/permissions.module';
import { PropertiesModule } from './modules/properties/properties.module';
import { PropertyUnitsModule } from './modules/property-units/property-units.module';
import { OwnersModule } from './modules/owners/owners.module';
import { TenantsModule } from './modules/tenants/tenants.module';
import { LeasesModule } from './modules/leases/leases.module';
import { PaymentsModule } from './modules/payments/payments.module';
import { ExpensesModule } from './modules/expenses/expenses.module';
import { MaintenanceModule } from './modules/maintenance/maintenance.module';
import { VisitsModule } from './modules/visits/visits.module';
import { NotificationsModule } from './modules/notifications/notifications.module';
import { DashboardModule } from './modules/dashboard/dashboard.module';
import { AuditLogModule } from './modules/audit-log/audit-log.module';
import { TenantInvitationsModule } from './modules/tenant-invitations/tenant-invitations.module';
import { OwnerInvitationsModule } from './modules/owners/owner-invitations/owner-invitations.module';
import { ReceiptsModule } from './modules/receipts/receipts.module';
import { WorkersModule } from './modules/workers/workers.module';

import { AllExceptionsFilter } from './common/filters/all-exceptions.filter';
import { PrismaExceptionFilter } from './common/filters/prisma-exception.filter';
import { LoggingInterceptor } from './common/interceptors/logging.interceptor';
import { TenantInterceptor } from './common/interceptors/tenant.interceptor';
import { AuditInterceptor } from './common/interceptors/audit.interceptor';

@Module({
  imports: [
    ConfigModule.forRoot({ isGlobal: true, load: [configuration], validationSchema }),
    ScheduleModule.forRoot(),
    ThrottlerModule.forRootAsync({
      imports: [ConfigModule],
      inject: [ConfigService],
      useFactory: (config: ConfigService<AppConfig, true>) => ({
        throttlers: [
          {
            ttl: config.get('security.throttleTtl', { infer: true }) * 1000,
            limit: config.get('security.throttleLimit', { infer: true }),
          },
        ],
      }),
    }),

    PrismaModule,
    HealthModule,

    AuthModule,
    OrganizationsModule,
    UsersModule,
    RolesModule,
    PermissionsModule,
    PropertiesModule,
    PropertyUnitsModule,
    OwnersModule,
    TenantsModule,
    LeasesModule,
    PaymentsModule,
    ExpensesModule,
    MaintenanceModule,
    VisitsModule,
    NotificationsModule,
    DashboardModule,
    AuditLogModule,
    TenantInvitationsModule,
    OwnerInvitationsModule,
    ReceiptsModule,
    WorkersModule,
  ],
  providers: [
    { provide: APP_GUARD, useClass: ThrottlerGuard },
    { provide: APP_INTERCEPTOR, useClass: LoggingInterceptor },
    { provide: APP_INTERCEPTOR, useClass: TenantInterceptor },
    { provide: APP_INTERCEPTOR, useClass: AuditInterceptor },
    // Registration order matters: Nest matches the LAST bound filter whose @Catch() types
    // include the thrown exception, so the more specific PrismaExceptionFilter must be bound
    // after the catch-all AllExceptionsFilter to take precedence for Prisma errors.
    { provide: APP_FILTER, useClass: AllExceptionsFilter },
    { provide: APP_FILTER, useClass: PrismaExceptionFilter },
  ],
})
export class AppModule {}
