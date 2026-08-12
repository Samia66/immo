import { Component, inject, signal } from '@angular/core';
import { MatButtonModule } from '@angular/material/button';
import { MAT_DIALOG_DATA, MatDialogModule, MatDialogRef } from '@angular/material/dialog';
import { MatProgressSpinnerModule } from '@angular/material/progress-spinner';
import { finalize } from 'rxjs';
import { FileUploadComponent } from '../../../../shared/components/file-upload/file-upload.component';
import { NotificationService } from '../../../../core/services/notification.service';
import { PropertiesApiService } from '../../services/properties-api.service';

export interface PropertyPhotoDialogData {
  propertyId: string;
}

@Component({
  selector: 'app-property-photo-dialog',
  standalone: true,
  imports: [MatDialogModule, MatButtonModule, MatProgressSpinnerModule, FileUploadComponent],
  templateUrl: './property-photo-dialog.component.html',
})
export class PropertyPhotoDialogComponent {
  readonly dialogRef = inject(MatDialogRef<PropertyPhotoDialogComponent>);
  readonly data: PropertyPhotoDialogData = inject(MAT_DIALOG_DATA);
  private readonly api = inject(PropertiesApiService);
  private readonly notificationService = inject(NotificationService);

  readonly files = signal<File[]>([]);
  readonly uploading = signal(false);

  onFilesSelected(files: File[]): void {
    this.files.set(files);
  }

  upload(): void {
    if (!this.files().length) {
      return;
    }
    this.uploading.set(true);
    this.api
      .uploadImages(this.data.propertyId, this.files())
      .pipe(finalize(() => this.uploading.set(false)))
      .subscribe({
        next: () => {
          this.notificationService.success('Photos envoyées.');
          this.dialogRef.close(true);
        },
      });
  }
}
