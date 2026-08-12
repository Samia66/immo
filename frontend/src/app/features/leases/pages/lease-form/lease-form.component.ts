import { Component, OnInit, inject, signal } from '@angular/core';
import { FormBuilder, ReactiveFormsModule, Validators } from '@angular/forms';
import { Router } from '@angular/router';
import { MatButtonModule } from '@angular/material/button';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatInputModule } from '@angular/material/input';
import { MatProgressSpinnerModule } from '@angular/material/progress-spinner';
import { MatSelectModule } from '@angular/material/select';
import { finalize } from 'rxjs';
import { PageHeaderComponent } from '../../../../shared/components/page-header/page-header.component';
import { NotificationService } from '../../../../core/services/notification.service';
import { PaymentFrequency } from '../../../../core/models/enums';
import { LeasesApiService } from '../../services/leases-api.service';
import { CreateLeaseDto } from '../../models/lease.model';
import { Property } from '../../../properties/models/property.model';
import { PropertiesApiService } from '../../../properties/services/properties-api.service';
import { Tenant } from '../../../tenants/models/tenant.model';
import { TenantsApiService } from '../../../tenants/services/tenants-api.service';

/**
 * NOTE (simplification): the specification suggests a multi-step wizard for lease creation.
 * To keep the MVP functional end-to-end within scope, this is a single-page reactive form
 * covering the same CreateLeaseDto fields; splitting it into steps is a pure UI enhancement
 * that can be layered on later without touching the API contract.
 */
@Component({
  selector: 'app-lease-form',
  standalone: true,
  imports: [
    ReactiveFormsModule,
    MatButtonModule,
    MatFormFieldModule,
    MatInputModule,
    MatProgressSpinnerModule,
    MatSelectModule,
    PageHeaderComponent,
  ],
  templateUrl: './lease-form.component.html',
})
export class LeaseFormComponent implements OnInit {
  private readonly fb = inject(FormBuilder);
  private readonly api = inject(LeasesApiService);
  private readonly propertiesApi = inject(PropertiesApiService);
  private readonly tenantsApi = inject(TenantsApiService);
  private readonly router = inject(Router);
  private readonly notificationService = inject(NotificationService);

  readonly frequencies = Object.values(PaymentFrequency);
  readonly properties = signal<Property[]>([]);
  readonly tenants = signal<Tenant[]>([]);
  readonly saving = signal(false);

  readonly form = this.fb.nonNullable.group({
    propertyId: ['', [Validators.required]],
    tenantId: ['', [Validators.required]],
    startDate: ['', [Validators.required]],
    endDate: [''],
    rentAmount: [0, [Validators.required, Validators.min(0)]],
    depositAmount: [0, [Validators.required, Validators.min(0)]],
    paymentFrequency: [PaymentFrequency.MENSUEL, [Validators.required]],
    indexationRate: [null as number | null],
  });

  ngOnInit(): void {
    this.propertiesApi.list({ limit: 100 }).subscribe((res) => this.properties.set(res.data));
    this.tenantsApi.list({ limit: 100 }).subscribe((res) => this.tenants.set(res.data));
  }

  submit(): void {
    if (this.form.invalid) {
      this.form.markAllAsTouched();
      return;
    }
    const raw = this.form.getRawValue();
    const dto: CreateLeaseDto = {
      propertyId: raw.propertyId,
      tenantId: raw.tenantId,
      startDate: raw.startDate,
      endDate: raw.endDate || undefined,
      rentAmount: raw.rentAmount,
      depositAmount: raw.depositAmount,
      paymentFrequency: raw.paymentFrequency,
      indexationRate: raw.indexationRate ?? undefined,
    };

    this.saving.set(true);
    this.api
      .create(dto)
      .pipe(finalize(() => this.saving.set(false)))
      .subscribe({
        next: (lease) => {
          this.notificationService.success('Contrat créé.');
          this.router.navigate(['/app/leases', lease.id]);
        },
      });
  }

  cancel(): void {
    this.router.navigate(['/app/leases']);
  }
}
