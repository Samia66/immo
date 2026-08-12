import { Component, inject, output } from '@angular/core';
import { Router } from '@angular/router';
import { MatBadgeModule } from '@angular/material/badge';
import { MatButtonModule } from '@angular/material/button';
import { MatIconModule } from '@angular/material/icon';
import { MatMenuModule } from '@angular/material/menu';
import { MatToolbarModule } from '@angular/material/toolbar';
import { AuthService } from '../../core/services/auth.service';
import { NotificationService } from '../../core/services/notification.service';
import { ThemeService } from '../../core/services/theme.service';
import { ROLE_LABELS } from '../../core/models/enums';

@Component({
  selector: 'app-topbar',
  standalone: true,
  imports: [MatToolbarModule, MatIconModule, MatButtonModule, MatMenuModule, MatBadgeModule],
  templateUrl: './topbar.component.html',
  styleUrl: './topbar.component.scss',
})
export class TopbarComponent {
  private readonly authService = inject(AuthService);
  private readonly router = inject(Router);

  readonly themeService = inject(ThemeService);
  readonly notificationService = inject(NotificationService);

  readonly toggleSidenav = output<void>();

  readonly currentUser = this.authService.currentUser;
  readonly roleLabels = ROLE_LABELS;

  logout(): void {
    this.authService.logout().subscribe(() => this.router.navigate(['/auth/login']));
  }

  goToNotifications(): void {
    this.router.navigate(['/app/notifications']);
  }
}
