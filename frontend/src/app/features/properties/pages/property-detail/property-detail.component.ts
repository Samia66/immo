import { Component, OnInit, inject } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { MatButtonModule } from '@angular/material/button';
import { MatChipsModule } from '@angular/material/chips';
import { MatDialog } from '@angular/material/dialog';
import { MatIconModule } from '@angular/material/icon';
import { MatProgressSpinnerModule } from '@angular/material/progress-spinner';
import { MatTabsModule } from '@angular/material/tabs';
import { HasPermissionDirective } from '../../../../shared/directives/has-permission.directive';
import { PageHeaderComponent } from '../../../../shared/components/page-header/page-header.component';
import { EmptyStateComponent } from '../../../../shared/components/empty-state/empty-state.component';
import { CurrencyXofPipe } from '../../../../shared/pipes/currency-xof.pipe';
import { StatusLabelPipe } from '../../../../shared/pipes/status-label.pipe';
import { NotificationService } from '../../../../core/services/notification.service';
import { PropertiesStore } from '../../store/properties.store';
import { PropertiesApiService } from '../../services/properties-api.service';
import { PropertyPhotoDialogComponent } from '../../dialogs/property-photo-dialog/property-photo-dialog.component';

@Component({
  selector: 'app-property-detail',
  standalone: true,
  imports: [
    MatButtonModule,
    MatChipsModule,
    MatIconModule,
    MatProgressSpinnerModule,
    MatTabsModule,
    HasPermissionDirective,
    PageHeaderComponent,
    EmptyStateComponent,
    CurrencyXofPipe,
    StatusLabelPipe,
  ],
  templateUrl: './property-detail.component.html',
  styleUrl: './property-detail.component.scss',
})
export class PropertyDetailComponent implements OnInit {
  readonly store = inject(PropertiesStore);
  private readonly api = inject(PropertiesApiService);
  private readonly route = inject(ActivatedRoute);
  private readonly router = inject(Router);
  private readonly dialog = inject(MatDialog);
  private readonly notificationService = inject(NotificationService);

  readonly propertyId = this.route.snapshot.paramMap.get('id') ?? '';

  ngOnInit(): void {
    this.store.loadOne(this.propertyId);
  }

  openPhotoDialog(): void {
    const ref = this.dialog.open(PropertyPhotoDialogComponent, {
      width: '560px',
      data: { propertyId: this.propertyId },
    });
    ref.afterClosed().subscribe((changed) => {
      if (changed) {
        this.store.loadOne(this.propertyId);
      }
    });
  }

  edit(): void {
    this.router.navigate(['/app/properties', this.propertyId, 'edit']);
  }

  deleteImage(imageId: string): void {
    this.api.deleteImage(this.propertyId, imageId).subscribe({
      next: () => {
        this.notificationService.success('Photo supprimée.');
        this.store.loadOne(this.propertyId);
      },
    });
  }
}
