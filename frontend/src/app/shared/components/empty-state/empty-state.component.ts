import { Component, input } from '@angular/core';
import { MatIconModule } from '@angular/material/icon';

@Component({
  selector: 'app-empty-state',
  standalone: true,
  imports: [MatIconModule],
  template: `
    <div class="empty-state">
      <mat-icon class="empty-state__icon">{{ icon() }}</mat-icon>
      <p class="empty-state__message">{{ message() }}</p>
      <ng-content />
    </div>
  `,
  styles: [
    `
      .empty-state {
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
        gap: 0.5rem;
        padding: 3rem 1rem;
        text-align: center;
        color: var(--immo-text-muted);
      }
      .empty-state__icon {
        font-size: 2.5rem;
        height: 2.5rem;
        width: 2.5rem;
        opacity: 0.5;
      }
      .empty-state__message {
        margin: 0;
        font-size: 0.9rem;
      }
    `,
  ],
})
export class EmptyStateComponent {
  readonly message = input('Aucune donnée disponible.');
  readonly icon = input('inbox');
}
