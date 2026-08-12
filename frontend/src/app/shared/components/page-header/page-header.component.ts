import { Component, input } from '@angular/core';
import { RouterLink } from '@angular/router';
import { MatButtonModule } from '@angular/material/button';
import { MatIconModule } from '@angular/material/icon';

export interface Breadcrumb {
  label: string;
  link?: string;
}

@Component({
  selector: 'app-page-header',
  standalone: true,
  imports: [RouterLink, MatButtonModule, MatIconModule],
  template: `
    <div class="page-header">
      <div class="page-header__text">
        @if (breadcrumbs().length) {
          <nav class="page-header__breadcrumbs">
            @for (crumb of breadcrumbs(); track crumb.label; let last = $last) {
              @if (crumb.link && !last) {
                <a [routerLink]="crumb.link">{{ crumb.label }}</a>
                <span>/</span>
              } @else {
                <span class="page-header__breadcrumb-current">{{ crumb.label }}</span>
              }
            }
          </nav>
        }
        <h1 class="page-header__title">{{ title() }}</h1>
        @if (subtitle()) {
          <p class="page-header__subtitle">{{ subtitle() }}</p>
        }
      </div>
      <div class="page-header__actions">
        <ng-content />
      </div>
    </div>
  `,
  styles: [
    `
      .page-header {
        display: flex;
        flex-wrap: wrap;
        gap: 1rem;
        align-items: flex-start;
        justify-content: space-between;
        margin-bottom: 1.5rem;
      }
      .page-header__breadcrumbs {
        display: flex;
        gap: 0.4rem;
        font-size: 0.8rem;
        color: var(--immo-text-muted);
        margin-bottom: 0.25rem;

        a {
          color: var(--immo-text-muted);
          text-decoration: none;
        }
        a:hover {
          color: var(--immo-accent);
        }
      }
      .page-header__breadcrumb-current {
        color: var(--immo-text);
      }
      .page-header__title {
        margin: 0;
        font-size: 1.5rem;
        font-weight: 700;
        color: var(--immo-text);
      }
      .page-header__subtitle {
        margin: 0.25rem 0 0;
        color: var(--immo-text-muted);
        font-size: 0.9rem;
      }
      .page-header__actions {
        display: flex;
        gap: 0.5rem;
        flex-wrap: wrap;
      }
    `,
  ],
})
export class PageHeaderComponent {
  readonly title = input.required<string>();
  readonly subtitle = input<string | null>(null);
  readonly breadcrumbs = input<Breadcrumb[]>([]);
}
