import * as Joi from 'joi';

/**
 * Fail-fast validation of process.env at boot (see spec §14.1: "Secrets & configuration").
 */
export const validationSchema = Joi.object({
  NODE_ENV: Joi.string().valid('development', 'production', 'test').default('development'),
  PORT: Joi.number().default(3000),
  API_PREFIX: Joi.string().default('api'),
  CORS_ORIGINS: Joi.string().default('http://localhost:4200'),

  DATABASE_URL: Joi.string().required(),

  JWT_ACCESS_SECRET: Joi.string().min(16).required(),
  JWT_ACCESS_EXPIRES_IN: Joi.string().default('15m'),
  JWT_REFRESH_SECRET: Joi.string().min(16).required(),
  JWT_REFRESH_EXPIRES_IN: Joi.string().default('30d'),

  BCRYPT_SALT_ROUNDS: Joi.number().min(10).default(12),
  LOGIN_MAX_ATTEMPTS: Joi.number().default(5),
  LOGIN_LOCK_MINUTES: Joi.number().default(15),
  THROTTLE_TTL: Joi.number().default(60),
  THROTTLE_LIMIT: Joi.number().default(100),

  UPLOADS_DIR: Joi.string().default('./uploads'),
  MAX_UPLOAD_SIZE_MB: Joi.number().default(10),

  FRONTEND_URL: Joi.string().default('http://localhost:4200'),
  POSTGRES_PASSWORD: Joi.string().optional(),
});
