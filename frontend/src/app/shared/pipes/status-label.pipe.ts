import { Pipe, PipeTransform } from '@angular/core';

const LABELS: Record<string, string> = {
  // Property
  DISPONIBLE: 'Disponible',
  OCCUPE: 'Occupé',
  RESERVE: 'Réservé',
  MAINTENANCE: 'En maintenance',
  // Lease (9-state workflow — see core/models/enums.ts LeaseStatus)
  BROUILLON: 'Brouillon',
  ENVOYE: 'Envoyé',
  CONSULTE: 'Consulté',
  ACCEPTE: 'Accepté',
  ACTIF: 'Actif',
  REFUSE: 'Refusé',
  EXPIRE: 'Expiré',
  RESILIE: 'Résilié',
  // Payment
  EN_ATTENTE: 'En attente',
  PARTIEL: 'Partiel',
  PAYE: 'Payé',
  EN_RETARD: 'En retard',
  ANNULE: 'Annulé',
  // Maintenance
  NOUVELLE: 'Nouvelle',
  VALIDEE: 'Validée',
  ASSIGNEE: 'Assignée',
  EN_COURS: 'En cours',
  TERMINEE: 'Terminée',
  CLOTUREE: 'Clôturée',
  BASSE: 'Basse',
  NORMALE: 'Normale',
  HAUTE: 'Haute',
  URGENTE: 'Urgente',
  // Property types
  MAISON: 'Maison',
  APPARTEMENT: 'Appartement',
  STUDIO: 'Studio',
  BUREAU: 'Bureau',
  TERRAIN: 'Terrain',
  BOUTIQUE: 'Boutique',
  // Payment frequency / method
  MENSUEL: 'Mensuel',
  TRIMESTRIEL: 'Trimestriel',
  SEMESTRIEL: 'Semestriel',
  ANNUEL: 'Annuel',
  ESPECES: 'Espèces',
  VIREMENT: 'Virement',
  MOBILE_MONEY: 'Mobile Money',
  CHEQUE: 'Chèque',
  CARTE: 'Carte',
};

/** Translates backend enum codes (French business terms) into display labels. */
@Pipe({
  name: 'statusLabel',
  standalone: true,
})
export class StatusLabelPipe implements PipeTransform {
  transform(value: string | null | undefined): string {
    if (!value) {
      return '—';
    }
    return LABELS[value] ?? value;
  }
}
