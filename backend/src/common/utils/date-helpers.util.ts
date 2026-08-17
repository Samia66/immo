/** Small date helpers used by lease/payment/maintenance business logic and cron jobs. */

export function addMonths(date: Date, months: number): Date {
  const result = new Date(date);
  result.setMonth(result.getMonth() + months);
  return result;
}

export function addDays(date: Date, days: number): Date {
  const result = new Date(date);
  result.setDate(result.getDate() + days);
  return result;
}

export function frequencyToMonths(frequency: 'MENSUEL' | 'TRIMESTRIEL' | 'SEMESTRIEL' | 'ANNUEL'): number {
  switch (frequency) {
    case 'MENSUEL':
      return 1;
    case 'TRIMESTRIEL':
      return 3;
    case 'SEMESTRIEL':
      return 6;
    case 'ANNUEL':
      return 12;
    default:
      return 1;
  }
}

export function startOfDay(date: Date = new Date()): Date {
  const result = new Date(date);
  result.setHours(0, 0, 0, 0);
  return result;
}

export function endOfDay(date: Date = new Date()): Date {
  const result = new Date(date);
  result.setHours(23, 59, 59, 999);
  return result;
}

export function daysBetween(a: Date, b: Date): number {
  const msPerDay = 1000 * 60 * 60 * 24;
  return Math.round((startOfDay(b).getTime() - startOfDay(a).getTime()) / msPerDay);
}

/** Adds `months` calendar months to `date`, then pins the result to day-of-month `day`. Assumes
 * `day` <= 28 (see CreateLeaseDto.rentDueDay validation), so it's always a valid date regardless
 * of the resulting month's length. */
export function addMonthsSnapToDay(date: Date, months: number, day: number): Date {
  const result = addMonths(date, months);
  result.setDate(day);
  return result;
}

/** The first occurrence of day-of-month `day` on or after `date`: same month if `day` hasn't
 * passed yet, otherwise the next month. Used to align a lease's first rent payment to its
 * `rentDueDay` regardless of which day of the month the lease actually starts on. */
export function firstDueDateOnOrAfter(date: Date, day: number): Date {
  const result = new Date(date);
  if (result.getDate() <= day) {
    result.setDate(day);
  } else {
    result.setMonth(result.getMonth() + 1);
    result.setDate(day);
  }
  return result;
}

export function monthKey(date: Date): string {
  const y = date.getFullYear();
  const m = `${date.getMonth() + 1}`.padStart(2, '0');
  return `${y}-${m}`;
}
