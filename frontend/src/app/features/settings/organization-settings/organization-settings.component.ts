import { Component, OnInit, inject, signal } from '@angular/core';
import { FormBuilder, ReactiveFormsModule, Validators } from '@angular/forms';
import { MatButtonModule } from '@angular/material/button';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatInputModule } from '@angular/material/input';
import { MatProgressSpinnerModule } from '@angular/material/progress-spinner';
import { finalize } from 'rxjs';
import { PageHeaderComponent } from '../../../shared/components/page-header/page-header.component';
import { NotificationService } from '../../../core/services/notification.service';
import { SettingsApiService } from '../services/settings-api.service';

@Component({
  selector: 'app-organization-settings',
  standalone: true,
  imports: [ReactiveFormsModule, MatButtonModule, MatFormFieldModule, MatInputModule, MatProgressSpinnerModule, PageHeaderComponent],
  templateUrl: './organization-settings.component.html',
})
export class OrganizationSettingsComponent implements OnInit {
  private readonly fb = inject(FormBuilder);
  private readonly api = inject(SettingsApiService);
  private readonly notificationService = inject(NotificationService);

  readonly loading = signal(true);
  readonly saving = signal(false);

  readonly form = this.fb.nonNullable.group({
    name: ['', [Validators.required]],
    email: [''],
    phone: [''],
    address: [''],
  });

  readonly code = signal('');
  readonly subscriptionPlan = signal('');

  ngOnInit(): void {
    this.api.getMyOrganization().subscribe({
      next: (org) => {
        this.form.patchValue({
          name: org.name,
          email: org.email ?? '',
          phone: org.phone ?? '',
          address: org.address ?? '',
        });
        this.code.set(org.code);
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
      .updateMyOrganization(this.form.getRawValue())
      .pipe(finalize(() => this.saving.set(false)))
      .subscribe({ next: () => this.notificationService.success('Organisation mise à jour.') });
  }
}
