import { Component, OnInit, inject, signal } from '@angular/core';
import { FormBuilder, ReactiveFormsModule, Validators } from '@angular/forms';
import { MatButtonModule } from '@angular/material/button';
import { MatDialogModule, MatDialogRef } from '@angular/material/dialog';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatInputModule } from '@angular/material/input';
import { MatProgressSpinnerModule } from '@angular/material/progress-spinner';
import { MatSelectModule } from '@angular/material/select';
import { finalize } from 'rxjs';
import { Role } from '../../../core/models/user.model';
import { NotificationService } from '../../../core/services/notification.service';
import { SettingsApiService } from '../services/settings-api.service';

@Component({
  selector: 'app-user-create-dialog',
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
  templateUrl: './user-create-dialog.component.html',
})
export class UserCreateDialogComponent implements OnInit {
  readonly dialogRef = inject(MatDialogRef<UserCreateDialogComponent>);
  private readonly fb = inject(FormBuilder);
  private readonly api = inject(SettingsApiService);
  private readonly notificationService = inject(NotificationService);

  readonly roles = signal<Role[]>([]);
  readonly saving = signal(false);

  readonly form = this.fb.nonNullable.group({
    firstName: ['', [Validators.required]],
    lastName: ['', [Validators.required]],
    email: ['', [Validators.required, Validators.email]],
    phone: [''],
    roleId: ['', [Validators.required]],
  });

  ngOnInit(): void {
    this.api.listRoles().subscribe((roles) => this.roles.set(roles));
  }

  submit(): void {
    if (this.form.invalid) {
      this.form.markAllAsTouched();
      return;
    }
    const raw = this.form.getRawValue();
    this.saving.set(true);
    this.api
      .createUser({
        email: raw.email,
        firstName: raw.firstName,
        lastName: raw.lastName,
        phone: raw.phone || undefined,
        roleId: raw.roleId,
      })
      .pipe(finalize(() => this.saving.set(false)))
      .subscribe({
        next: () => {
          this.notificationService.success('Invitation envoyée.');
          this.dialogRef.close(true);
        },
      });
  }
}
