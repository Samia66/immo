import { DatePipe } from '@angular/common';
import { Component, OnInit, inject } from '@angular/core';
import { MatButtonModule } from '@angular/material/button';
import { MatIconModule } from '@angular/material/icon';
import { MatListModule } from '@angular/material/list';
import { PageHeaderComponent } from '../../../../shared/components/page-header/page-header.component';
import { EmptyStateComponent } from '../../../../shared/components/empty-state/empty-state.component';
import { NotificationService } from '../../../../core/services/notification.service';
import { AppNotification } from '../../../../core/models';

@Component({
  selector: 'app-notification-list',
  standalone: true,
  imports: [DatePipe, MatButtonModule, MatIconModule, MatListModule, PageHeaderComponent, EmptyStateComponent],
  templateUrl: './notification-list.component.html',
  styleUrl: './notification-list.component.scss',
})
export class NotificationListComponent implements OnInit {
  readonly notificationService = inject(NotificationService);

  ngOnInit(): void {
    this.notificationService.list().subscribe();
    this.notificationService.refreshUnreadCount().subscribe();
  }

  markAsRead(notification: AppNotification): void {
    if (!notification.isRead) {
      this.notificationService.markAsRead(notification.id).subscribe();
    }
  }

  markAllAsRead(): void {
    this.notificationService.markAllAsRead().subscribe();
  }
}
