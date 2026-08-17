import { Component, OnInit, inject } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { MatButtonModule } from '@angular/material/button';
import { MatChipsModule } from '@angular/material/chips';
import { MatDialog } from '@angular/material/dialog';
import { MatIconModule } from '@angular/material/icon';
import { MatProgressSpinnerModule } from '@angular/material/progress-spinner';
import { MatTabsModule } from '@angular/material/tabs';
import { MatTooltipModule } from '@angular/material/tooltip';
import { HasPermissionDirective } from '../../../../shared/directives/has-permission.directive';
import { PageHeaderComponent } from '../../../../shared/components/page-header/page-header.component';
import { EmptyStateComponent } from '../../../../shared/components/empty-state/empty-state.component';
import { ConfirmDialogComponent } from '../../../../shared/components/confirm-dialog/confirm-dialog.component';
import { CurrencyXofPipe } from '../../../../shared/pipes/currency-xof.pipe';
import { StatusLabelPipe } from '../../../../shared/pipes/status-label.pipe';
import { NotificationService } from '../../../../core/services/notification.service';
import { PropertiesStore } from '../../store/properties.store';
import { PropertiesApiService } from '../../services/properties-api.service';
import { PropertyPhotoDialogComponent } from '../../dialogs/property-photo-dialog/property-photo-dialog.component';
import { UnitFormDialogComponent } from '../../dialogs/unit-form-dialog/unit-form-dialog.component';
import { PropertyUnit } from '../../models/property.model';

@Component({
  selector: 'app-property-detail',
  standalone: true,
  imports: [
    MatButtonModule,
    MatChipsModule,
    MatIconModule,
    MatProgressSpinnerModule,
    MatTabsModule,
    MatTooltipModule,
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

  addUnit(): void {
    const ref = this.dialog.open(UnitFormDialogComponent, {
      width: '640px',
      data: { propertyId: this.propertyId },
    });
    ref.afterClosed().subscribe((changed) => {
      if (changed) {
        this.store.loadOne(this.propertyId);
      }
    });
  }

  editUnit(unit: PropertyUnit): void {
    const ref = this.dialog.open(UnitFormDialogComponent, {
      width: '640px',
      data: { propertyId: this.propertyId, unit },
    });
    ref.afterClosed().subscribe((changed) => {
      if (changed) {
        this.store.loadOne(this.propertyId);
      }
    });
  }

  removeUnit(unit: PropertyUnit): void {
    const ref = this.dialog.open(ConfirmDialogComponent, {
      data: {
        title: 'Supprimer le logement',
        message: `Confirmez-vous la suppression de "${unit.label ?? unit.reference}" ?`,
        danger: true,
      },
    });
    ref.afterClosed().subscribe((confirmed) => {
      if (!confirmed) {
        return;
      }
      this.api.deleteUnit(unit.id).subscribe({
        next: () => {
          this.notificationService.success('Logement supprimé.');
          this.store.loadOne(this.propertyId);
        },
      });
    });
  }
}
