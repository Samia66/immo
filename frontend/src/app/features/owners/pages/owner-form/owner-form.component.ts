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
import { OwnersApiService } from '../../services/owners-api.service';
import { CreateOwnerDto } from '../../models/owner.model';

@Component({
  selector: 'app-owner-form',
  standalone: true,
  imports: [ReactiveFormsModule, MatButtonModule, MatFormFieldModule, MatInputModule, MatProgressSpinnerModule, PageHeaderComponent],
  templateUrl: './owner-form.component.html',
})
export class OwnerFormComponent implements OnInit {
  private readonly fb = inject(FormBuilder);
  private readonly api = inject(OwnersApiService);
  private readonly route = inject(ActivatedRoute);
  private readonly router = inject(Router);
  private readonly notificationService = inject(NotificationService);

  readonly ownerId = this.route.snapshot.paramMap.get('id');
  readonly isEdit = !!this.ownerId;
  readonly loading = signal(false);
  readonly saving = signal(false);

  readonly form = this.fb.nonNullable.group({
    fullName: ['', [Validators.required]],
    phone: ['', [Validators.required]],
    email: [''],
    address: [''],
    bankName: [''],
    bankAccountIban: [''],
  });

  ngOnInit(): void {
    if (this.ownerId) {
      this.loading.set(true);
      this.api.getById(this.ownerId).subscribe({
        next: (owner) => {
          this.form.patchValue({
            fullName: owner.fullName,
            phone: owner.phone,
            email: owner.email ?? '',
            address: owner.address ?? '',
            bankName: owner.bankName ?? '',
            bankAccountIban: owner.bankAccountIban ?? '',
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
    const dto: CreateOwnerDto = {
      fullName: raw.fullName,
      phone: raw.phone,
      email: raw.email || undefined,
      address: raw.address || undefined,
      bankName: raw.bankName || undefined,
      bankAccountIban: raw.bankAccountIban || undefined,
    };

    this.saving.set(true);
    const request$ = this.isEdit ? this.api.update(this.ownerId as string, dto) : this.api.create(dto);
    request$.pipe(finalize(() => this.saving.set(false))).subscribe({
      next: () => {
        this.notificationService.success(this.isEdit ? 'Propriétaire mis à jour.' : 'Propriétaire créé.');
        this.router.navigate(['/app/owners']);
      },
    });
  }

  cancel(): void {
    this.router.navigate(['/app/owners']);
  }
}
