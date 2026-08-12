import { Component, OnInit, inject } from '@angular/core';
import { RouterOutlet } from '@angular/router';
import { AuthService } from './core/services/auth.service';
import { ThemeService } from './core/services/theme.service';

@Component({
  selector: 'app-root',
  standalone: true,
  imports: [RouterOutlet],
  templateUrl: './app.html',
  styleUrl: './app.scss',
})
export class App implements OnInit {
  private readonly authService = inject(AuthService);
  // Injected eagerly so its constructor effect applies the persisted/system theme immediately.
  private readonly themeService = inject(ThemeService);

  ngOnInit(): void {
    this.authService.bootstrap().subscribe();
  }
}
