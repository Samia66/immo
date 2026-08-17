import { DatePipe } from '@angular/common';
import { Component, inject } from '@angular/core';
import { MatButtonModule } from '@angular/material/button';
import { MAT_DIALOG_DATA, MatDialogModule, MatDialogRef } from '@angular/material/dialog';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatIconModule } from '@angular/material/icon';
import { MatInputModule } from '@angular/material/input';
import { NotificationService } from '../../../../core/services/notification.service';
import { InvitationResult } from '../../models/lease.model';

/**
 * Shows the result of `POST /leases/:id/invite`: the activation code and a ready-to-share
 * message, with a copy-to-clipboard button — mirrors the temp-password pattern in
 * `user-create-dialog.component.ts`.
 */
@Component({
  selector: 'app-lease-invite-dialog',
  standalone: true,
  imports: [DatePipe, MatDialogModule, MatButtonModule, MatFormFieldModule, MatIconModule, MatInputModule],
  templateUrl: './lease-invite-dialog.component.html',
})
export class LeaseInviteDialogComponent {
  readonly dialogRef = inject(MatDialogRef<LeaseInviteDialogComponent>);
  readonly data: InvitationResult = inject(MAT_DIALOG_DATA);
  private readonly notificationService = inject(NotificationService);

  copyMessage(): void {
    navigator.clipboard.writeText(this.data.shareMessage).then(
      () => this.notificationService.success('Message copié.'),
      () => this.notificationService.error('Impossible de copier le message.'),
    );
  }

  copyCode(): void {
    navigator.clipboard.writeText(this.data.code).then(
      () => this.notificationService.success('Code copié.'),
      () => this.notificationService.error('Impossible de copier le code.'),
    );
  }

  close(): void {
    this.dialogRef.close();
  }
}
