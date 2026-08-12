import { CorsOptions } from '@nestjs/common/interfaces/external/cors-options.interface';

export function buildCorsConfig(allowedOrigins: string[]): CorsOptions {
  return {
    origin: (origin, callback) => {
      // Allow non-browser tools (curl, health checks) with no Origin header.
      if (!origin || allowedOrigins.includes(origin)) {
        return callback(null, true);
      }
      return callback(new Error(`Origin ${origin} not allowed by CORS`), false);
    },
    credentials: true,
    methods: ['GET', 'POST', 'PATCH', 'PUT', 'DELETE', 'OPTIONS'],
    allowedHeaders: ['Content-Type', 'Authorization'],
  };
}
