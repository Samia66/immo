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
import { MaintenancePriority } from '../../../../core/models/enums';
import { MaintenanceApiService } from '../../services/maintenance-api.service';
import { CreateMaintenanceRequestDto } from '../../models/maintenance.model';
import { Property } from '../../../properties/models/property.model';
import { PropertiesApiService } from '../../../properties/services/properties-api.service';

@Component({
  selector: 'app-maintenance-form',
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
  templateUrl: './maintenance-form.component.html',
})
export class MaintenanceFormComponent implements OnInit {
  private readonly fb = inject(FormBuilder);
  private readonly api = inject(MaintenanceApiService);
  private readonly propertiesApi = inject(PropertiesApiService);
  private readonly router = inject(Router);
  private readonly notificationService = inject(NotificationService);

  readonly priorities = Object.values(MaintenancePriority);
  readonly properties = signal<Property[]>([]);
  readonly saving = signal(false);

  readonly form = this.fb.nonNullable.group({
    propertyId: ['', [Validators.required]],
    category: ['', [Validators.required]],
    description: ['', [Validators.required]],
    priority: [MaintenancePriority.NORMALE],
  });

  ngOnInit(): void {
    this.propertiesApi.list({ limit: 100 }).subscribe((res) => this.properties.set(res.data));
  }

  submit(): void {
    if (this.form.invalid) {
      this.form.markAllAsTouched();
      return;
    }
    const dto: CreateMaintenanceRequestDto = this.form.getRawValue();
    this.saving.set(true);
    this.api
      .create(dto)
      .pipe(finalize(() => this.saving.set(false)))
      .subscribe({
        next: (request) => {
          this.notificationService.success('Demande créée.');
          this.router.navigate(['/app/maintenance', request.id]);
        },
      });
  }

  cancel(): void {
    this.router.navigate(['/app/maintenance']);
  }
}
