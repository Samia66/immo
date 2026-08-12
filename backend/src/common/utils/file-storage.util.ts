import { BadRequestException } from '@nestjs/common';
import { diskStorage } from 'multer';
import { extname, join } from 'path';
import { v4 as uuidv4 } from 'uuid';
import * as fs from 'fs';

const IMAGE_MIME_TYPES = ['image/png', 'image/jpeg', 'image/jpg', 'image/webp'];
const DOCUMENT_MIME_TYPES = [...IMAGE_MIME_TYPES, 'application/pdf'];

export const UPLOADS_ROOT = process.env.UPLOADS_DIR || './uploads';

function ensureDir(dir: string) {
  if (!fs.existsSync(dir)) {
    fs.mkdirSync(dir, { recursive: true });
  }
}

/**
 * Builds a Multer disk storage config that writes into `uploads/<subfolder>/` using
 * a randomly generated filename (never the original client-supplied name).
 */
export function buildDiskStorage(subfolder: string) {
  const dest = join(UPLOADS_ROOT, subfolder);
  ensureDir(dest);
  return diskStorage({
    destination: (_req, _file, cb) => {
      ensureDir(dest);
      cb(null, dest);
    },
    filename: (_req, file, cb) => {
      const unique = `${Date.now()}-${uuidv4()}${extname(file.originalname).toLowerCase()}`;
      cb(null, unique);
    },
  });
}

export function imageFileFilter(
  _req: any,
  file: Express.Multer.File,
  cb: (error: Error | null, accept: boolean) => void,
) {
  if (!IMAGE_MIME_TYPES.includes(file.mimetype)) {
    return cb(new BadRequestException('Type de fichier non autorisé (images uniquement: png, jpg, webp).'), false);
  }
  cb(null, true);
}

export function documentFileFilter(
  _req: any,
  file: Express.Multer.File,
  cb: (error: Error | null, accept: boolean) => void,
) {
  if (!DOCUMENT_MIME_TYPES.includes(file.mimetype)) {
    return cb(new BadRequestException('Type de fichier non autorisé (images ou PDF uniquement).'), false);
  }
  cb(null, true);
}

export function publicUrlFor(subfolder: string, filename: string): string {
  return `/uploads/${subfolder}/${filename}`;
}

export const MAX_UPLOAD_SIZE_BYTES = (Number(process.env.MAX_UPLOAD_SIZE_MB) || 10) * 1024 * 1024;
