import { Component, inject, input } from '@angular/core';
import { RouterLink, RouterLinkActive } from '@angular/router';
import { MatIconModule } from '@angular/material/icon';
import { MatListModule } from '@angular/material/list';
import { MatTooltipModule } from '@angular/material/tooltip';
import { AuthService } from '../../core/services/auth.service';
import { HasPermissionDirective } from '../../shared/directives/has-permission.directive';
import { RoleName } from '../../core/models';
import { NAV_ITEMS, SETTINGS_NAV_ITEMS } from './nav-item';

@Component({
  selector: 'app-sidebar',
  standalone: true,
  imports: [
    RouterLink,
    RouterLinkActive,
    MatIconModule,
    MatListModule,
    MatTooltipModule,
    HasPermissionDirective,
  ],
  templateUrl: './sidebar.component.html',
  styleUrl: './sidebar.component.scss',
})
export class SidebarComponent {
  private readonly authService = inject(AuthService);

  readonly collapsed = input(false);

  readonly navItems = NAV_ITEMS;
  readonly settingsNavItems = SETTINGS_NAV_ITEMS;

  get isAdmin(): boolean {
    return this.authService.hasRole(RoleName.ADMIN_AGENCE);
  }
}
