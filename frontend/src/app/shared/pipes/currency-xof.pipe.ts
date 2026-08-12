import { Pipe, PipeTransform } from '@angular/core';

/** Formats amounts in West African CFA francs (no decimals, thin-space thousands separator). */
@Pipe({
  name: 'currencyXof',
  standalone: true,
})
export class CurrencyXofPipe implements PipeTransform {
  private readonly formatter = new Intl.NumberFormat('fr-FR', {
    maximumFractionDigits: 0,
    minimumFractionDigits: 0,
  });

  transform(value: number | string | null | undefined): string {
    if (value === null || value === undefined || value === '') {
      return '—';
    }
    const numeric = typeof value === 'string' ? Number(value) : value;
    if (Number.isNaN(numeric)) {
      return '—';
    }
    return `${this.formatter.format(numeric)} F`;
  }
}
