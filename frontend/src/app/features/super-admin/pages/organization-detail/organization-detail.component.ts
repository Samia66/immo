import { Component, OnInit, inject, signal } from '@angular/core';
import { ActivatedRoute } from '@angular/router';
import { FormBuilder, ReactiveFormsModule, Validators } from '@angular/forms';
import { MatButtonModule } from '@angular/material/button';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatInputModule } from '@angular/material/input';
import { MatProgressSpinnerModule } from '@angular/material/progress-spinner';
import { MatSelectModule } from '@angular/material/select';
import { finalize } from 'rxjs';
import { PageHeaderComponent } from '../../../../shared/components/page-header/page-header.component';
import { NotificationService } from '../../../../core/services/notification.service';
import { SubscriptionPlan } from '../../../../core/models/enums';
import { SuperAdminApiService } from '../../services/super-admin-api.service';

@Component({
  selector: 'app-organization-detail',
  standalone: true,
  imports: [ReactiveFormsModule, MatButtonModule, MatFormFieldModule, MatInputModule, MatProgressSpinnerModule, MatSelectModule, PageHeaderComponent],
  templateUrl: './organization-detail.component.html',
})
export class OrganizationDetailComponent implements OnInit {
  private readonly fb = inject(FormBuilder);
  private readonly api = inject(SuperAdminApiService);
  private readonly route = inject(ActivatedRoute);
  private readonly notificationService = inject(NotificationService);

  readonly organizationId = this.route.snapshot.paramMap.get('id') ?? '';
  readonly plans = Object.values(SubscriptionPlan);
  readonly loading = signal(true);
  readonly saving = signal(false);

  readonly form = this.fb.nonNullable.group({
    name: ['', [Validators.required]],
    email: [''],
    phone: [''],
    address: [''],
  });

  readonly subscriptionPlan = signal<SubscriptionPlan>(SubscriptionPlan.FREE);

  ngOnInit(): void {
    this.api.getOrganization(this.organizationId).subscribe({
      next: (org) => {
        this.form.patchValue({
          name: org.name,
          email: org.email ?? '',
          phone: org.phone ?? '',
          address: org.address ?? '',
        });
        this.subscriptionPlan.set(org.subscriptionPlan);
        this.loading.set(false);
      },
      error: () => this.loading.set(false),
    });
  }

  submit(): void {
    if (this.form.invalid) {
      this.form.markAllAsTouched();
      return;
    }
    this.saving.set(true);
    this.api
      .updateOrganization(this.organizationId, this.form.getRawValue())
      .pipe(finalize(() => this.saving.set(false)))
      .subscribe({ next: () => this.notificationService.success('Organisation mise à jour.') });
  }

  changePlan(plan: SubscriptionPlan): void {
    this.api.updateSubscription(this.organizationId, plan).subscribe({
      next: () => {
        this.subscriptionPlan.set(plan);
        this.notificationService.success("Plan d'abonnement mis à jour.");
      },
    });
  }
}
