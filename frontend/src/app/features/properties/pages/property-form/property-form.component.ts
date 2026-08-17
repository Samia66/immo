import { Component, OnInit, inject, signal } from '@angular/core';
import { FormBuilder, ReactiveFormsModule, Validators } from '@angular/forms';
import { ActivatedRoute, Router } from '@angular/router';
import { MatButtonModule } from '@angular/material/button';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatInputModule } from '@angular/material/input';
import { MatProgressSpinnerModule } from '@angular/material/progress-spinner';
import { MatSelectModule } from '@angular/material/select';
import { finalize } from 'rxjs';
import { PageHeaderComponent } from '../../../../shared/components/page-header/page-header.component';
import { NotificationService } from '../../../../core/services/notification.service';
import { PropertyType } from '../../../../core/models/enums';
import { PropertiesApiService } from '../../services/properties-api.service';
import { CreatePropertyDto } from '../../models/property.model';
import { Owner } from '../../../owners/models/owner.model';
import { OwnersApiService } from '../../../owners/services/owners-api.service';

@Component({
  selector: 'app-property-form',
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
  templateUrl: './property-form.component.html',
  styleUrl: './property-form.component.scss',
})
export class PropertyFormComponent implements OnInit {
  private readonly fb = inject(FormBuilder);
  private readonly api = inject(PropertiesApiService);
  private readonly ownersApi = inject(OwnersApiService);
  private readonly route = inject(ActivatedRoute);
  private readonly router = inject(Router);
  private readonly notificationService = inject(NotificationService);

  readonly types = Object.values(PropertyType);
  readonly owners = signal<Owner[]>([]);
  readonly loading = signal(false);
  readonly saving = signal(false);

  readonly propertyId = this.route.snapshot.paramMap.get('id');
  readonly isEdit = !!this.propertyId;

  readonly form = this.fb.nonNullable.group({
    title: ['', [Validators.required, Validators.maxLength(160)]],
    description: [''],
    type: [PropertyType.APPARTEMENT, [Validators.required]],
    addressLine: ['', [Validators.required]],
    city: ['', [Validators.required]],
    district: [''],
    latitude: [null as number | null],
    longitude: [null as number | null],
    ownerId: ['', [Validators.required]],
  });

  ngOnInit(): void {
    this.ownersApi.list({ limit: 100 }).subscribe((res) => this.owners.set(res.data));

    if (this.propertyId) {
      this.loading.set(true);
      this.api.getById(this.propertyId).subscribe({
        next: (property) => {
          this.form.patchValue({
            title: property.title,
            description: property.description ?? '',
            type: property.type,
            addressLine: property.addressLine,
            city: property.city,
            district: property.district ?? '',
            latitude: property.latitude ?? null,
            longitude: property.longitude ?? null,
            ownerId: property.ownerId,
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
    const dto: CreatePropertyDto = {
      title: raw.title,
      description: raw.description || undefined,
      type: raw.type,
      addressLine: raw.addressLine,
      city: raw.city,
      district: raw.district || undefined,
      latitude: raw.latitude ?? undefined,
      longitude: raw.longitude ?? undefined,
      ownerId: raw.ownerId,
    };

    this.saving.set(true);
    const request$ = this.isEdit
      ? this.api.update(this.propertyId as string, dto)
      : this.api.create(dto);

    request$.pipe(finalize(() => this.saving.set(false))).subscribe({
      next: (property) => {
        this.notificationService.success(this.isEdit ? 'Bien mis à jour.' : 'Bien créé.');
        this.router.navigate(['/app/properties', property.id]);
      },
    });
  }

  cancel(): void {
    this.router.navigate(['/app/properties']);
  }
}
