import { Component, OnInit, inject, output } from '@angular/core';
import { FormBuilder, ReactiveFormsModule } from '@angular/forms';
import { MatButtonModule } from '@angular/material/button';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatIconModule } from '@angular/material/icon';
import { MatInputModule } from '@angular/material/input';
import { MatSelectModule } from '@angular/material/select';
import { debounceTime, distinctUntilChanged } from 'rxjs';
import { PropertyStatus, PropertyType } from '../../../../core/models/enums';
import { PropertyFilters } from '../../models/property.model';

@Component({
  selector: 'app-property-filters',
  standalone: true,
  imports: [ReactiveFormsModule, MatButtonModule, MatFormFieldModule, MatIconModule, MatInputModule, MatSelectModule],
  templateUrl: './property-filters.component.html',
  styleUrl: './property-filters.component.scss',
})
export class PropertyFiltersComponent implements OnInit {
  private readonly fb = inject(FormBuilder);

  readonly filtersChange = output<PropertyFilters>();

  readonly types = Object.values(PropertyType);
  readonly statuses = Object.values(PropertyStatus);

  readonly form = this.fb.group({
    search: [''],
    type: [null as PropertyType | null],
    status: [null as PropertyStatus | null],
    city: [''],
    minRent: [null as number | null],
    maxRent: [null as number | null],
  });

  ngOnInit(): void {
    this.form.valueChanges.pipe(debounceTime(350), distinctUntilChanged()).subscribe(() => this.emit());
  }

  reset(): void {
    this.form.reset({ search: '', type: null, status: null, city: '', minRent: null, maxRent: null });
    this.emit();
  }

  private emit(): void {
    const raw = this.form.getRawValue();
    const filters: PropertyFilters = {
      search: raw.search || undefined,
      type: raw.type ?? undefined,
      status: raw.status ?? undefined,
      city: raw.city || undefined,
      minRent: raw.minRent ?? undefined,
      maxRent: raw.maxRent ?? undefined,
    };
    this.filtersChange.emit(filters);
  }
}
