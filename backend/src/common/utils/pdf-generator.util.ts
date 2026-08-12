import { Logger } from '@nestjs/common';

const logger = new Logger('PdfGenerator');

/**
 * TODO (V2 scope, see spec §12): plug a real PDF engine (e.g. pdf-lib / Puppeteer) here to
 * render lease contracts and payment receipts as downloadable PDF binaries.
 *
 * For this MVP pass we return a structured JSON stub describing what the document WOULD
 * contain, and log the "generation" so the flow is observable end-to-end without a PDF
 * dependency. Controllers expose this stub as the endpoint response body instead of a
 * `application/pdf` stream.
 */
export function generatePdfStub(kind: 'lease-contract' | 'payment-receipt', payload: Record<string, unknown>) {
  logger.log(`[STUB] Would generate ${kind} PDF for payload: ${JSON.stringify(payload)}`);
  return {
    documentType: kind,
    generatedAt: new Date().toISOString(),
    format: 'json-stub',
    note: 'PDF binary generation is out of scope for this MVP pass (see TODO in pdf-generator.util.ts). This is a structured stand-in for the future PDF content.',
    content: payload,
  };
}
