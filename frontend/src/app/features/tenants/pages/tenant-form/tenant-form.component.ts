import { Component, OnInit, inject, signal } from '@angular/core';
import { FormBuilder, ReactiveFormsModule, Validators } from '@angular/forms';
import { ActivatedRoute, Router } from '@angular/router';
import { MatButtonModule } from '@angular/material/button';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatInputModule } from '@angular/material/input';
import { MatProgressSpinnerModule } from '@angular/material/progress-spinner';
import { finalize } from 'rxjs';
import { PageHeaderComponent } from '../../../../shared/components/page-header/page-header.component';
import { NotificationService } from '../../../../core/services/notification.service';
import { TenantsApiService } from '../../services/tenants-api.service';
import { CreateTenantDto } from '../../models/tenant.model';

@Component({
  selector: 'app-tenant-form',
  standalone: true,
  imports: [ReactiveFormsModule, MatButtonModule, MatFormFieldModule, MatInputModule, MatProgressSpinnerModule, PageHeaderComponent],
  templateUrl: './tenant-form.component.html',
})
export class TenantFormComponent implements OnInit {
  private readonly fb = inject(FormBuilder);
  private readonly api = inject(TenantsApiService);
  private readonly route = inject(ActivatedRoute);
  private readonly router = inject(Router);
  private readonly notificationService = inject(NotificationService);

  readonly tenantId = this.route.snapshot.paramMap.get('id');
  readonly isEdit = !!this.tenantId;
  readonly loading = signal(false);
  readonly saving = signal(false);

  readonly form = this.fb.nonNullable.group({
    fullName: ['', [Validators.required]],
    phone: ['', [Validators.required]],
    email: [''],
    profession: [''],
    employer: [''],
    monthlyIncome: [null as number | null],
  });

  ngOnInit(): void {
    if (this.tenantId) {
      this.loading.set(true);
      this.api.getById(this.tenantId).subscribe({
        next: (tenant) => {
          this.form.patchValue({
            fullName: tenant.fullName,
            phone: tenant.phone,
            email: tenant.email ?? '',
            profession: tenant.profession ?? '',
            employer: tenant.employer ?? '',
            monthlyIncome: tenant.monthlyIncome ?? null,
          });
          this.loading.set(false);
        },
        error: () => this.loading.set(false),
      });
    }
  }

  submit(): void {
    if (this.form.invalid) {
      this.form.markAllAsTouched();
      return;
    }
    const raw = this.form.getRawValue();
    const dto: CreateTenantDto = {
      fullName: raw.fullName,
      phone: raw.phone,
      email: raw.email || undefined,
      profession: raw.profession || undefined,
      employer: raw.employer || undefined,
      monthlyIncome: raw.monthlyIncome ?? undefined,
    };

    this.saving.set(true);
    const request$ = this.isEdit ? this.api.update(this.tenantId as string, dto) : this.api.create(dto);
    request$.pipe(finalize(() => this.saving.set(false))).subscribe({
      next: () => {
        this.notificationService.success(this.isEdit ? 'Locataire mis à jour.' : 'Locataire créé.');
        this.router.navigate(['/app/tenants']);
      },
    });
  }

  cancel(): void {
    this.router.navigate(['/app/tenants']);
  }
}
