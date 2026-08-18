import { Logger } from '@nestjs/common';
import PDFDocument from 'pdfkit';

const logger = new Logger('PdfGenerator');

/**
 * TODO (V2 scope, see spec §12): plug a real PDF engine here to render lease contracts as
 * downloadable PDF binaries (payment receipts now use `generatePaymentReceiptPdf` below instead).
 *
 * For this MVP pass we return a structured JSON stub describing what the document WOULD
 * contain, and log the "generation" so the flow is observable end-to-end without a PDF
 * dependency. Controllers expose this stub as the endpoint response body instead of a
 * `application/pdf` stream.
 */
export function generatePdfStub(kind: 'lease-contract', payload: Record<string, unknown>) {
  logger.log(`[STUB] Would generate ${kind} PDF for payload: ${JSON.stringify(payload)}`);
  return {
    documentType: kind,
    generatedAt: new Date().toISOString(),
    format: 'json-stub',
    note: 'PDF binary generation is out of scope for this MVP pass (see TODO in pdf-generator.util.ts). This is a structured stand-in for the future PDF content.',
    content: payload,
  };
}

export interface PaymentReceiptPdfPayload {
  reference: string;
  organizationName: string;
  tenantName: string;
  propertyTitle: string;
  unitLabel: string;
  amountDue: number;
  amountPaid: number;
  dueDate: Date;
  paidAt: Date | null;
  method: string | null;
  status: string;
}

function formatDateFr(date: Date): string {
  return new Date(date).toLocaleDateString('fr-FR');
}

function formatAmountFr(amount: number): string {
  return `${amount.toLocaleString('fr-FR')} F CFA`;
}

/** Renders an actual PDF binary for a payment receipt using pdfkit (pure-JS, no native/browser
 * dependency, so it runs fine in any Node server environment). */
export function generatePaymentReceiptPdf(payload: PaymentReceiptPdfPayload): Promise<Buffer> {
  return new Promise((resolve, reject) => {
    const doc = new PDFDocument({ size: 'A4', margin: 50 });
    const chunks: Buffer[] = [];
    doc.on('data', (chunk: Buffer) => chunks.push(chunk));
    doc.on('end', () => resolve(Buffer.concat(chunks)));
    doc.on('error', reject);

    doc.fontSize(20).text('Quittance de loyer', { align: 'center' });
    doc.moveDown(0.5);
    doc.fontSize(10).fillColor('#555555').text(payload.organizationName, { align: 'center' });
    doc.moveDown(2);

    doc.fillColor('#000000').fontSize(11);
    doc.text(`Référence : ${payload.reference}`);
    doc.text(`Locataire : ${payload.tenantName}`);
    doc.text(`Bien : ${payload.propertyTitle} - ${payload.unitLabel}`);
    doc.moveDown();
    doc.text(`Échéance : ${formatDateFr(payload.dueDate)}`);
    if (payload.paidAt) doc.text(`Date de paiement : ${formatDateFr(payload.paidAt)}`);
    if (payload.method) doc.text(`Moyen de paiement : ${payload.method}`);
    doc.moveDown();

    doc.fontSize(14).text(`Montant dû : ${formatAmountFr(payload.amountDue)}`);
    doc.text(`Montant payé : ${formatAmountFr(payload.amountPaid)}`);
    doc.moveDown();

    doc.fontSize(10).fillColor('#555555').text(`Statut : ${payload.status}`);
    doc.moveDown(3);

    doc
      .fontSize(9)
      .fillColor('#888888')
      .text(`Document généré automatiquement le ${formatDateFr(new Date())}.`, { align: 'center' });

    doc.end();
  });
}
