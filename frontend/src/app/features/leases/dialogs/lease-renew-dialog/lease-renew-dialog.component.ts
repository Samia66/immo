import { Component, inject } from '@angular/core';
import { FormBuilder, ReactiveFormsModule, Validators } from '@angular/forms';
import { MatButtonModule } from '@angular/material/button';
import { MatDialogModule, MatDialogRef } from '@angular/material/dialog';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatInputModule } from '@angular/material/input';

export interface LeaseRenewDialogResult {
  newEndDate: string;
}

/** Minimal dialog asking for the lease's new end date — feeds `LeasesApiService.renew`. */
@Component({
  selector: 'app-lease-renew-dialog',
  standalone: true,
  imports: [ReactiveFormsModule, MatDialogModule, MatButtonModule, MatFormFieldModule, MatInputModule],
  templateUrl: './lease-renew-dialog.component.html',
})
export class LeaseRenewDialogComponent {
  readonly dialogRef = inject(MatDialogRef<LeaseRenewDialogComponent, LeaseRenewDialogResult | undefined>);
  private readonly fb = inject(FormBuilder);

  readonly form = this.fb.nonNullable.group({
    newEndDate: ['', [Validators.required]],
  });

  confirm(): void {
    if (this.form.invalid) {
      this.form.markAllAsTouched();
      return;
    }
    this.dialogRef.close({ newEndDate: this.form.getRawValue().newEndDate });
  }
}
