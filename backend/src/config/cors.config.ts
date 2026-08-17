import { CorsOptions } from '@nestjs/common/interfaces/external/cors-options.interface';

// Matches http(s)://localhost:<any-port> and http(s)://127.0.0.1:<any-port>, with no port at all
// also allowed. Dev tools (Angular CLI, `flutter run -d chrome`/`-d web-server`) pick a fresh,
// unpredictable port on every run, so pinning CORS_ORIGINS to one exact port is impractical.
const LOCALHOST_ORIGIN_PATTERN = /^https?:\/\/(localhost|127\.0\.0\.1)(:\d+)?$/;

export function buildCorsConfig(allowedOrigins: string[], isDevelopment: boolean): CorsOptions {
  return {
    origin: (origin, callback) => {
      // Allow non-browser tools (curl, health checks) with no Origin header.
      if (!origin || allowedOrigins.includes(origin)) {
        return callback(null, true);
      }
      // Dev convenience only: any localhost port is trusted. Never applies in production, where
      // the explicit CORS_ORIGINS allowlist above remains the sole source of truth.
      if (isDevelopment && LOCALHOST_ORIGIN_PATTERN.test(origin)) {
        return callback(null, true);
      }
      // Reject via `false`, not an Error: passing an Error here makes the `cors` middleware
      // forward it to Express's error handler, which surfaces as an opaque 500 instead of a
      // clean CORS rejection (the browser blocks the response either way for a disallowed origin).
      return callback(null, false);
    },
    credentials: true,
    methods: ['GET', 'POST', 'PATCH', 'PUT', 'DELETE', 'OPTIONS'],
    allowedHeaders: ['Content-Type', 'Authorization'],
  };
}
