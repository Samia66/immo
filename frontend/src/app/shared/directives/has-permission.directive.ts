import {
  Directive,
  EmbeddedViewRef,
  Input,
  TemplateRef,
  ViewContainerRef,
  effect,
  inject,
} from '@angular/core';
import { AuthService } from '../../core/services/auth.service';

/**
 * Structural directive mirroring backend permission codes (`"<module>:<action>"`).
 * Usage: `*appHasPermission="'properties:create'"`.
 * This is UI-level defense in depth only — the backend remains the source of truth.
 */
@Directive({
  selector: '[appHasPermission]',
  standalone: true,
})
export class HasPermissionDirective {
  private readonly templateRef = inject(TemplateRef<unknown>);
  private readonly viewContainer = inject(ViewContainerRef);
  private readonly authService = inject(AuthService);

  private viewRef: EmbeddedViewRef<unknown> | null = null;
  private requiredPermission: string | string[] | null = null;

  @Input() set appHasPermission(value: string | string[] | null) {
    this.requiredPermission = value;
  }

  constructor() {
    effect(() => {
      // Depend on the current user signal so the view updates on login/logout.
      this.authService.currentUser();
      this.updateView();
    });
  }

  private updateView(): void {
    const allowed = this.isAllowed();
    if (allowed && !this.viewRef) {
      this.viewRef = this.viewContainer.createEmbeddedView(this.templateRef);
    } else if (!allowed && this.viewRef) {
      this.viewContainer.clear();
      this.viewRef = null;
    }
  }

  private isAllowed(): boolean {
    if (!this.requiredPermission) {
      return true;
    }
    const codes = Array.isArray(this.requiredPermission)
      ? this.requiredPermission
      : [this.requiredPermission];
    return codes.some((code) => this.authService.hasPermission(code));
  }
}
