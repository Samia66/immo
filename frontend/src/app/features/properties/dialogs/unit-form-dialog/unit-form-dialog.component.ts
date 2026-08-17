import { Component, inject, signal } from '@angular/core';
import { FormBuilder, ReactiveFormsModule, Validators } from '@angular/forms';
import { MatButtonModule } from '@angular/material/button';
import { MAT_DIALOG_DATA, MatDialogModule, MatDialogRef } from '@angular/material/dialog';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatInputModule } from '@angular/material/input';
import { MatProgressSpinnerModule } from '@angular/material/progress-spinner';
import { MatSelectModule } from '@angular/material/select';
import { finalize } from 'rxjs';
import { PropertyStatus, PropertyType } from '../../../../core/models/enums';
import { NotificationService } from '../../../../core/services/notification.service';
import { PropertiesApiService } from '../../services/properties-api.service';
import { CreatePropertyUnitDto, PropertyUnit, UpdatePropertyUnitDto } from '../../models/property.model';

export interface UnitFormDialogData {
  propertyId: string;
  unit?: PropertyUnit;
}

/** Create/edit dialog for a `PropertyUnit`, opened from `property-detail`'s "Logements" section. */
@Component({
  selector: 'app-unit-form-dialog',
  standalone: true,
  imports: [
    ReactiveFormsModule,
    MatDialogModule,
    MatButtonModule,
    MatFormFieldModule,
    MatInputModule,
    MatProgressSpinnerModule,
    MatSelectModule,
  ],
  templateUrl: './unit-form-dialog.component.html',
})
export class UnitFormDialogComponent {
  readonly dialogRef = inject(MatDialogRef<UnitFormDialogComponent>);
  readonly data: UnitFormDialogData = inject(MAT_DIALOG_DATA);
  private readonly fb = inject(FormBuilder);
  private readonly api = inject(PropertiesApiService);
  private readonly notificationService = inject(NotificationService);

  readonly types = Object.values(PropertyType);
  readonly statuses = Object.values(PropertyStatus);
  readonly saving = signal(false);
  readonly isEdit = !!this.data.unit;

  readonly form = this.fb.nonNullable.group({
    reference: [this.data.unit?.reference ?? '', [Validators.required]],
    label: [this.data.unit?.label ?? ''],
    floor: [this.data.unit?.floor ?? ''],
    type: [this.data.unit?.type ?? PropertyType.APPARTEMENT, [Validators.required]],
    rooms: [this.data.unit?.rooms ?? (null as number | null)],
    surfaceM2: [this.data.unit?.surfaceM2 ?? (null as number | null)],
    monthlyRent: [this.data.unit?.monthlyRent ?? 0, [Validators.required, Validators.min(0)]],
    monthlyCharges: [this.data.unit?.monthlyCharges ?? (null as number | null)],
    status: [this.data.unit?.status ?? PropertyStatus.DISPONIBLE, [Validators.required]],
    description: [this.data.unit?.description ?? ''],
  });

  submit(): void {
    if (this.form.invalid) {
      this.form.markAllAsTouched();
      return;
    }
    const raw = this.form.getRawValue();
    this.saving.set(true);

    if (this.isEdit && this.data.unit) {
      const dto: UpdatePropertyUnitDto = {
        reference: raw.reference,
        label: raw.label || undefined,
        floor: raw.floor || undefined,
        type: raw.type,
        rooms: raw.rooms ?? undefined,
        surfaceM2: raw.surfaceM2 ?? undefined,
        monthlyRent: raw.monthlyRent,
        monthlyCharges: raw.monthlyCharges ?? undefined,
        status: raw.status,
        description: raw.description || undefined,
      };
      this.api
        .updateUnit(this.data.unit.id, dto)
        .pipe(finalize(() => this.saving.set(false)))
        .subscribe({
          next: () => {
            this.notificationService.success('Logement mis à jour.');
            this.dialogRef.close(true);
          },
        });
      return;
    }

    const dto: CreatePropertyUnitDto = {
      reference: raw.reference,
      label: raw.label || undefined,
      floor: raw.floor || undefined,
      type: raw.type,
      rooms: raw.rooms ?? undefined,
      surfaceM2: raw.surfaceM2 ?? undefined,
      monthlyRent: raw.monthlyRent,
      monthlyCharges: raw.monthlyCharges ?? undefined,
      description: raw.description || undefined,
    };
    this.api
      .createUnit(this.data.propertyId, dto)
      .pipe(finalize(() => this.saving.set(false)))
      .subscribe({
        next: () => {
          this.notificationService.success('Logement créé.');
          this.dialogRef.close(true);
        },
      });
  }
}
