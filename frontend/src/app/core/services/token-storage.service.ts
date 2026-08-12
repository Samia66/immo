import { Injectable } from '@angular/core';

const ACCESS_TOKEN_KEY = 'immo_access_token';

/**
 * Stores the short-lived JWT access token.
 * The refresh token itself is never handled here: it lives in an HttpOnly
 * cookie set by the API and is never readable from JavaScript.
 */
@Injectable({ providedIn: 'root' })
export class TokenStorageService {
  private accessToken: string | null = null;

  constructor() {
    this.accessToken = localStorage.getItem(ACCESS_TOKEN_KEY);
  }

  getAccessToken(): string | null {
    return this.accessToken;
  }

  setAccessToken(token: string | null): void {
    this.accessToken = token;
    if (token) {
      localStorage.setItem(ACCESS_TOKEN_KEY, token);
    } else {
      localStorage.removeItem(ACCESS_TOKEN_KEY);
    }
  }

  clear(): void {
    this.setAccessToken(null);
  }
}
