import { Component, OnInit, computed, inject } from '@angular/core';
import { Router } from '@angular/router';
import { MatCardModule } from '@angular/material/card';
import { MatChipsModule } from '@angular/material/chips';
import { MatProgressSpinnerModule } from '@angular/material/progress-spinner';
import { PageHeaderComponent } from '../../../../shared/components/page-header/page-header.component';
import { MaintenanceStatus } from '../../../../core/models/enums';
import { MaintenanceStore } from '../../store/maintenance.store';
import { MaintenanceRequest } from '../../models/maintenance.model';

const COLUMNS: { status: MaintenanceStatus; label: string }[] = [
  { status: MaintenanceStatus.NOUVELLE, label: 'Nouvelle' },
  { status: MaintenanceStatus.VALIDEE, label: 'Validée' },
  { status: MaintenanceStatus.ASSIGNEE, label: 'Assignée' },
  { status: MaintenanceStatus.EN_COURS, label: 'En cours' },
  { status: MaintenanceStatus.TERMINEE, label: 'Terminée' },
  { status: MaintenanceStatus.CLOTUREE, label: 'Clôturée' },
];

/**
 * NOTE (simplification): a read-only board grouped by status. The spec's drag-and-drop kanban
 * (CDK drag/drop reordering triggering status transitions) is out of scope for the MVP pass —
 * status changes are still made from the maintenance detail page.
 */
@Component({
  selector: 'app-maintenance-board',
  standalone: true,
  imports: [PageHeaderComponent, MatCardModule, MatChipsModule, MatProgressSpinnerModule],
  templateUrl: './maintenance-board.component.html',
  styleUrl: './maintenance-board.component.scss',
})
export class MaintenanceBoardComponent implements OnInit {
  readonly store = inject(MaintenanceStore);
  private readonly router = inject(Router);

  readonly columns = COLUMNS;

  readonly grouped = computed(() => {
    const requests = this.store.requests();
    const map = new Map<MaintenanceStatus, MaintenanceRequest[]>();
    for (const column of COLUMNS) {
      map.set(
        column.status,
        requests.filter((r) => r.status === column.status),
      );
    }
    return map;
  });

  ngOnInit(): void {
    this.store.loadAllForBoard();
  }

  openDetail(request: MaintenanceRequest): void {
    this.router.navigate(['/app/maintenance', request.id]);
  }
}
