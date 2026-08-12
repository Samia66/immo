import { Component, input } from '@angular/core';
import { MatIconModule } from '@angular/material/icon';

export type StatTrend = 'up' | 'down' | 'neutral';

@Component({
  selector: 'app-stat-card',
  standalone: true,
  imports: [MatIconModule],
  templateUrl: './stat-card.component.html',
  styleUrl: './stat-card.component.scss',
})
export class StatCardComponent {
  readonly label = input.required<string>();
  readonly value = input.required<string | number>();
  readonly icon = input('insights');
  readonly trend = input<StatTrend>('neutral');
  readonly trendLabel = input<string | null>(null);
  readonly accent = input<'primary' | 'success' | 'warn' | 'info'>('primary');
}
