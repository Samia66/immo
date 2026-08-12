import { Component, inject } from '@angular/core';
import { Router, RouterLink, RouterLinkActive, RouterOutlet } from '@angular/router';
import { MatButtonModule } from '@angular/material/button';
import { MatIconModule } from '@angular/material/icon';
import { MatToolbarModule } from '@angular/material/toolbar';
import { AuthService } from '../../../core/services/auth.service';
import { ThemeService } from '../../../core/services/theme.service';

/**
 * Distinct shell for the SUPER_ADMIN area (spec §9: "/super-admin (shell distinct)") — a plain
 * toolbar + horizontal nav rather than the tenant shell's sidebar, since super-admin operates
 * outside any organization context.
 */
@Component({
  selector: 'app-super-admin-shell',
  standalone: true,
  imports: [RouterOutlet, RouterLink, RouterLinkActive, MatToolbarModule, MatButtonModule, MatIconModule],
  templateUrl: './super-admin-shell.component.html',
  styleUrl: './super-admin-shell.component.scss',
})
export class SuperAdminShellComponent {
  private readonly authService = inject(AuthService);
  private readonly router = inject(Router);
  readonly themeService = inject(ThemeService);

  logout(): void {
    this.authService.logout().subscribe(() => this.router.navigate(['/auth/login']));
  }
}
