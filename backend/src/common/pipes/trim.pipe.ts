import { ArgumentMetadata, Injectable, PipeTransform } from '@nestjs/common';

/** Trims all top-level string fields of an incoming request body. */
@Injectable()
export class TrimPipe implements PipeTransform {
  transform(value: any, metadata: ArgumentMetadata) {
    if (metadata.type !== 'body' || value === null || typeof value !== 'object') {
      return value;
    }
    for (const key of Object.keys(value)) {
      if (typeof value[key] === 'string') {
        value[key] = value[key].trim();
      }
    }
    return value;
  }
}
