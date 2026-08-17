# ImmoSaaS V2 — Architecture cible (Étapes 1 à 9)

**Statut :** document d'architecture, pas encore de code. À valider avant de lancer l'implémentation (étapes 10+).
**Contexte :** ce document redéfinit le modèle métier central du système déjà existant (backend NestJS/Prisma, admin Angular, mobile Flutter). La section 0 explique précisément ce qui est réutilisé, adapté ou remplacé — l'essentiel de l'infrastructure technique (auth JWT/refresh, multi-tenant, `PropertyUnit`, workflow de contrat, mécanisme invitation/OTP) est conservé ; ce qui change est **qui fait quoi et depuis où**.

---

## 0. Réconciliation avec l'existant

| Aspect | Avant (V1) | Maintenant (V2) |
|---|---|---|
| Qui crée les biens/locataires/contrats | `ADMIN_AGENCE` via le back-office Angular | `GESTIONNAIRE` via le mobile |
| Rôle d'Angular | Back-office complet de l'agence | Console **plateforme** réservée à `SUPER_ADMIN` (orgs, abonnements, stats globales) |
| Inscription initiale | `POST /auth/register` crée une Organisation + un `ADMIN_AGENCE` | `POST /auth/register` crée une Organisation + un `GESTIONNAIRE` |
| Visibilité des biens pour un gestionnaire | Tous les biens de l'organisation (accès plat) | Uniquement les biens qu'il gère, via `PropertyManagement`/`ManagerOwner` (accès scopé) |
| Propriétaire → compte utilisateur | Fiche `Owner` créée par un admin, liaison manuelle (`link-user`) jamais vraiment exposée en UI — **c'est le trou que vous venez de repérer** | Le gestionnaire invite le propriétaire (code + OTP), la liaison + la relation `ManagerOwner` se créent automatiquement à l'activation |
| Locataire → compte utilisateur | Déjà résolu : invitation par contrat + OTP (construit lors du rollout précédent) | **Inchangé dans le principe**, juste rattaché au nouveau modèle `TenantInvitation` explicite et au `managerId` du bail |
| `PropertyUnit`, workflow de contrat 9 états, JWT+refresh, isolation multi-tenant par `organizationId`, mailer/OTP stubs | Déjà construits | **Réutilisés tels quels** |
| `ADMIN_AGENCE`, `AGENT_IMMOBILIER` | Rôles actifs, back-office complet | Conservés dans l'enum pour compatibilité mais **retirés du flux principal** — non prioritaires pour cette V2 |

**Principe directeur pour l'implémentation à venir :** on ne repart pas de zéro. On ajoute les nouveaux modèles (`ManagerOwner`, `PropertyManagement`, `OwnerInvitation`, `TenantInvitation`), on adapte le scoping des requêtes existantes (`properties`, `owners`, `leases`, `tenants`, `maintenance`, `dashboard`) pour filtrer par la relation gestionnaire↔propriétaire↔bien plutôt que par `organizationId` seul, et on **déplace** les écrans de gestion quotidienne d'Angular vers Flutter plutôt que de les dupliquer.

---

## 1. Architecture fonctionnelle

```
                              IMMOSAAS
                                 │
                 ┌───────────────┴───────────────┐
                 │                                 │
        Back-office Web Angular              Application Mobile Flutter
         (SUPER_ADMIN uniquement)                    (une seule app)
                 │                                 │
         Supervision plateforme        ┌────────────┼────────────┐
         (orgs, abonnements,           │            │            │
          stats globales, audit)  GESTIONNAIRE  PROPRIETAIRE  LOCATAIRE
                                   (opérateur    (consultation (occupant,
                                    métier)       de son        consultation
                                                   patrimoine)   + actions)
```

Backend commun : NestJS → Prisma → PostgreSQL → REST → JWT+Refresh → RBAC/Permissions.

---

## 2. Diagramme des relations métier

```
Organization (tenant racine)
   │
   ├── User (role: SUPER_ADMIN | GESTIONNAIRE | PROPRIETAIRE | LOCATAIRE | ...)
   │
   ├── GESTIONNAIRE ──ManagerOwner (ACTIVE)──> PROPRIETAIRE
   │        │                                        │
   │        │                                        │ possède
   │        │                                        ▼
   │        └──PropertyManagement (ACTIVE)──>  Property (Bien)
   │                                                 │
   │                                                 ▼
   │                                          PropertyUnit (Logement)
   │                                                 │
   │                                                 ▼
   │                                              Lease (Contrat)
   │                                            /    │      \
   │                                    Owner──┘   Manager    └──Tenant (Locataire)
   │                                  (dénormalisé   (dénormalisé
   │                                   pour scoping)  pour scoping)
   │                                                 │
   │                                     ┌────────────┼────────────┐
   │                                     ▼            ▼            ▼
   │                                  Payment    LeaseDocument  MaintenanceRequest
   │                                     │
   │                                     ▼
   │                                  Receipt (Quittance)
   │
   ├── OwnerInvitation  (GESTIONNAIRE → futur PROPRIETAIRE)
   └── TenantInvitation (rattachée à un Lease → futur LOCATAIRE)
```

**Règle clé (section 15/49 du cahier des charges) :** `Lease.ownerId` et `Lease.managerId` sont **dénormalisés** au moment de la création du contrat (copiés depuis `PropertyUnit.property.ownerId` et depuis la `PropertyManagement` active) pour que tout le scoping en aval (paiements, maintenance, documents) se fasse par simple filtre sur ces colonnes, sans jointures profondes répétées — mais la vérification d'autorisation, elle, repart toujours des relations sources (`ManagerOwner`/`PropertyManagement` actives), jamais de la valeur dénormalisée seule, pour éviter qu'un changement de gestionnaire en cours de route laisse un accès obsolète.

---

## 3. Modèle Prisma (delta par rapport à l'existant)

Modèles **déjà en place et réutilisés sans changement de structure** : `Organization`, `User`, `Role`, `Permission`, `RolePermission`, `RefreshToken`, `Property`, `PropertyUnit`, `Tenant`, `TenantDocument`, `Lease` *(+2 champs)*, `LeaseAmendment`, `Payment`, `Expense`, `MaintenanceRequest`, `MaintenanceAttachment`, `Notification`, `AuditLog`, `OtpCode`.

Modèle **renommé conceptuellement** : `Owner` reste tel quel (déjà doté de `userId` pour la liaison portail).

Modèle **remplacé** : l'`Invitation` générique existante (liée à un `Lease`) devient `TenantInvitation` (même rôle, nom aligné sur le cahier des charges) ; son mécanisme (code unique, OTP, activation) est repris à l'identique pour `OwnerInvitation`.

```prisma
// -------------------- NOUVEAU : relation Gestionnaire ↔ Propriétaire --------------------

enum ManagerRelationStatus {
  ACTIVE
  SUSPENDED
  ENDED
}

model ManagerOwner {
  id             String   @id @default(uuid())
  organizationId String
  organization   Organization @relation(fields: [organizationId], references: [id])

  managerId      String              // User.id (role GESTIONNAIRE)
  manager        User     @relation("ManagerOwnerManager", fields: [managerId], references: [id])
  ownerId        String              // Owner.id
  owner          Owner    @relation(fields: [ownerId], references: [id])

  status         ManagerRelationStatus @default(ACTIVE)
  startDate      DateTime @default(now())
  endDate        DateTime?

  createdAt      DateTime @default(now())
  updatedAt      DateTime @updatedAt

  @@unique([managerId, ownerId])
  @@index([organizationId, managerId, status])
  @@index([ownerId])
}

// -------------------- NOUVEAU : relation Gestionnaire ↔ Bien --------------------

model PropertyManagement {
  id             String   @id @default(uuid())
  organizationId String
  organization   Organization @relation(fields: [organizationId], references: [id])

  propertyId     String
  property       Property @relation(fields: [propertyId], references: [id])
  managerId      String
  manager        User     @relation("PropertyManagementManager", fields: [managerId], references: [id])

  status         ManagerRelationStatus @default(ACTIVE)
  startDate      DateTime @default(now())
  endDate        DateTime?

  createdAt      DateTime @default(now())
  updatedAt      DateTime @updatedAt

  @@index([organizationId, managerId, status])
  @@index([propertyId, status])
}

// -------------------- NOUVEAU : invitation propriétaire --------------------

enum OwnerInvitationStatus {
  PENDING
  ACCEPTED
  EXPIRED
  CANCELLED
}

model OwnerInvitation {
  id             String   @id @default(uuid())
  organizationId String
  organization   Organization @relation(fields: [organizationId], references: [id])

  managerId      String
  manager        User     @relation("OwnerInvitationManager", fields: [managerId], references: [id])

  firstName      String
  lastName       String
  email          String?
  phone          String?

  code           String   @unique          // ex: "IMMO-7K42P"
  status         OwnerInvitationStatus @default(PENDING)
  expiresAt      DateTime
  acceptedAt     DateTime?
  ownerId        String?                   // rempli après acceptation (Owner créé/lié)

  createdAt      DateTime @default(now())

  @@index([organizationId, managerId, status])
}

// -------------------- RENOMMÉ (ex-Invitation) : invitation locataire --------------------

enum TenantInvitationStatus {
  PENDING
  ACCEPTED
  EXPIRED
  CANCELLED
}

model TenantInvitation {
  id             String   @id @default(uuid())
  organizationId String
  organization   Organization @relation(fields: [organizationId], references: [id])

  leaseId        String
  lease          Lease    @relation(fields: [leaseId], references: [id])

  code           String   @unique
  status         TenantInvitationStatus @default(PENDING)
  expiresAt      DateTime
  acceptedAt     DateTime?
  acceptedByUserId String?

  createdAt      DateTime @default(now())

  @@index([organizationId, status])
}

// -------------------- Lease : 2 champs dénormalisés en plus --------------------

model Lease {
  // ...champs existants (id, reference, propertyUnitId, tenantId, status 9 états, etc.)
  ownerId    String   // dénormalisé depuis propertyUnit.property.ownerId à la création
  managerId  String   // dénormalisé depuis la PropertyManagement active à la création
  owner      Owner    @relation(fields: [ownerId], references: [id])
  manager    User     @relation("LeaseManager", fields: [managerId], references: [id])
  // ...
}

// -------------------- Receipt explicite (actuellement implicite via Payment.receiptUrl) --------------------

model Receipt {
  id          String   @id @default(uuid())
  paymentId   String   @unique
  payment     Payment  @relation(fields: [paymentId], references: [id])
  url         String
  period      String            // ex: "2026-09"
  amount      Decimal  @db.Decimal(12, 2)
  generatedAt DateTime @default(now())
}
```

`ManagerOwner`, `PropertyManagement`, `OwnerInvitation`, `TenantInvitation`, `Receipt` rejoignent `TENANT_SCOPED_MODELS` dans le middleware Prisma existant.

---

## 4. Rôles et permissions

**Rôles actifs (V2) :** `SUPER_ADMIN`, `GESTIONNAIRE`, `PROPRIETAIRE`, `LOCATAIRE`.
**Conservés mais hors flux principal :** `ADMIN_AGENCE`, `AGENT_IMMOBILIER` (existent déjà, pas de permissions nouvelles ajoutées pour eux dans cette V2).

Nouveaux codes de permission (module → code) :
```
owners.view · owners.invite · owners.update · owners.manage
properties.view · properties.create · properties.update · properties.delete
units.view · units.create · units.update · units.delete
leases.view · leases.create · leases.update · leases.terminate
tenants.view · tenants.create · tenants.update
payments.view · payments.create · payments.validate
receipts.view · receipts.generate
documents.view · documents.generate
maintenance.view · maintenance.create · maintenance.assign · maintenance.update · maintenance.close
dashboard.view
notifications.view
```

| Permission | GESTIONNAIRE | PROPRIETAIRE | LOCATAIRE |
|---|:---:|:---:|:---:|
| owners.view/invite/update/manage | ✅ | ❌ | ❌ |
| properties.* | ✅ | 🟡 view (siens) | ❌ |
| units.* | ✅ | 🟡 view (siens) | ❌ |
| leases.view/create/update/terminate | ✅ | 🟡 view (siens) | 🟡 view (le sien) |
| tenants.* | ✅ | ❌ | ❌ |
| payments.view/create/validate | ✅ | 🟡 view (siens) | 🟡 view (les siens) |
| receipts.* | ✅ generate, 🟡 view | 🟡 view | 🟡 view (les siennes) |
| maintenance.* | ✅ | 🟡 view | 🟡 create + view (les siennes) |
| dashboard.view | ✅ (`/dashboard/manager`) | ✅ (`/dashboard/owner`) | ✅ (`/dashboard/tenant`) |

`SUPER_ADMIN` : toutes permissions, hors scoping tenant.

---

## 5. Workflow d'inscription et d'invitation

### 5.1 Inscription (auto → Gestionnaire)

```
Mobile: [Créer un compte] → formulaire (prénom, nom, email, téléphone, mot de passe)
   ↓
POST /auth/register  { firstName, lastName, email, phone, password }
   ↓ (transaction)
   crée Organization (nouvelle, dédiée à ce gestionnaire)
   crée les rôles système de l'org (GESTIONNAIRE, PROPRIETAIRE, LOCATAIRE, ...)
   crée User { role: GESTIONNAIRE }
   ↓
retourne { accessToken, user } → mobile redirige vers ManagerDashboard
```

### 5.2 Invitation d'un propriétaire

```
GESTIONNAIRE (mobile, "Mes propriétaires" → "+ Inviter")
   ↓
POST /owners/invitations { firstName, lastName, email?, phone? }
   ↓
backend : génère code unique (IMMO-XXXXX), OwnerInvitation.status=PENDING, expiresAt=+7j
   ↓
gestionnaire partage le code (copier / WhatsApp / SMS / lien) — hors périmètre backend
   ↓
PROPRIETAIRE (mobile, "Créer un compte" → "J'ai reçu une invitation")
   ↓
GET /owners/invitations/:code   (aperçu public : nom du gestionnaire, org)
   ↓
POST /auth/otp/request { contact, purpose: REGISTER_OWNER }
POST /owners/invitations/accept { code, contact, otpCode, password, firstName, lastName }
   ↓ (transaction)
   crée User { role: PROPRIETAIRE }
   crée (ou lie) Owner { userId }
   crée ManagerOwner { managerId, ownerId, status: ACTIVE }
   OwnerInvitation.status = ACCEPTED
   ↓
retourne { accessToken, user } → mobile redirige vers OwnerDashboard
```

### 5.3 Invitation d'un locataire (déjà largement construit, adapté au nouveau nommage)

```
GESTIONNAIRE crée Tenant → sélectionne PropertyUnit → crée Lease (dénormalise ownerId/managerId)
   ↓
POST /leases/:id/invite → TenantInvitation { code, expiresAt }
   ↓
LOCATAIRE : "J'ai reçu une invitation" → code → OTP (purpose ACTIVATE_TENANT) → mot de passe
   ↓
POST /tenant-invitations/:code/activate → crée User{LOCATAIRE}, lie Tenant.userId, connecte au bail
```

---

## 6. API REST complète (delta)

```
AUTH
POST /auth/register            (crée org + GESTIONNAIRE)
POST /auth/login
POST /auth/refresh
POST /auth/logout
POST /auth/forgot-password
POST /auth/reset-password
POST /auth/otp/request
POST /auth/otp/verify

OWNERS (vue gestionnaire)
GET    /owners                          (scopé : uniquement les owners du gestionnaire, via ManagerOwner ACTIVE)
GET    /owners/:id
PATCH  /owners/:id
POST   /owners/invitations              permission owners.invite
GET    /owners/invitations
POST   /owners/invitations/:id/cancel
GET    /owners/invitations/:code        (public, preview)
POST   /owners/invitations/accept       (public, body {code, contact, otpCode, password, firstName, lastName})

PROPERTIES
GET    /properties                      (scopé via PropertyManagement ACTIVE)
POST   /properties                      body inclut ownerId obligatoire — backend vérifie ManagerOwner ACTIVE(manager, ownerId)
GET    /properties/:id
PATCH  /properties/:id
DELETE /properties/:id

PROPERTY UNITS
GET    /properties/:id/units
POST   /properties/:id/units
PATCH  /property-units/:id
DELETE /property-units/:id

TENANTS
GET    /tenants                         (scopé : locataires des baux du gestionnaire)
POST   /tenants
GET    /tenants/:id
PATCH  /tenants/:id

LEASES
GET    /leases                          (scopé managerId = requester.userId, ou ownerId pour un PROPRIETAIRE, ou tenantId pour un LOCATAIRE)
POST   /leases                          vérifie : unité gérée par le gestionnaire, propriétaire correct, unité libre
GET    /leases/:id
PATCH  /leases/:id
POST   /leases/:id/send | /acknowledge | /accept | /refuse | /cancel | /terminate   (déjà existants)
POST   /leases/:id/invite → TenantInvitation
GET    /tenant-invitations/:code
POST   /tenant-invitations/:code/activate

PAYMENTS / RECEIPTS
GET    /payments
POST   /payments
GET    /payments/:id
POST   /payments/:id/record
GET    /receipts
GET    /receipts/:id/download

MAINTENANCE
GET    /maintenance
POST   /maintenance
GET    /maintenance/:id
PATCH  /maintenance/:id
POST   /maintenance/:id/comments

DASHBOARD
GET /dashboard/manager    (agrège tous les biens/unités où PropertyManagement.managerId=requester, status ACTIVE)
GET /dashboard/owner       (déjà existant — biens où Owner.userId=requester)
GET /dashboard/tenant      (déjà existant)
```

**Sécurité (rappel des règles absolues du cahier des charges, section 69) :** aucun `ownerId`/`managerId` envoyé par le client n'est jamais utilisé tel quel pour le scoping — le backend dérive toujours le périmètre depuis `requester.userId` + les tables de relation (`ManagerOwner`, `PropertyManagement`), et vérifie la relation à *chaque* écriture (ex. `POST /properties` avec un `ownerId` non géré par ce gestionnaire → `403`).

---

## 7. Architecture NestJS (modules)

```
src/modules/
  auth/                (existant, +registerAsManager, +otp déjà là)
  users/ roles/ permissions/     (existants)
  organizations/                 (existant, scope réduit à SUPER_ADMIN)
  owners/                        (existant, + owner-invitations/, scoping ManagerOwner)
  manager-owner/                 (NOUVEAU — CRUD relation + résolution de scope)
  properties/ property-units/    (existants, scoping PropertyManagement ajouté)
  property-management/           (NOUVEAU — CRUD relation gestionnaire↔bien)
  tenants/                       (existant)
  leases/                        (existant, + ownerId/managerId dénormalisés)
  tenant-invitations/            (renommage du module invitations/ existant)
  payments/ expenses/            (existants)
  receipts/                      (NOUVEAU — génération/consultation quittance dédiée)
  maintenance/                   (existant)
  notifications/                 (existant)
  dashboard/                     (existant, dashboard/manager adapté au scoping PropertyManagement)
  audit-log/                     (existant)
```

---

## 8. Architecture Flutter (mobile)

```
lib/
  core/ (api, auth, router, storage, theme, utils)     — réutilisé tel quel
  features/
    auth/                        — réutilisé + écran d'inscription générique (→ GESTIONNAIRE)
    manager/                     — À CONSTRUIRE EN GRAND : c'est maintenant le module principal
      owners/        (liste "Mes propriétaires", inviter, détail)
      properties/     (déjà en partie construit — adapter au scoping PropertyManagement)
      property_units/
      tenants/        (créer/lister locataires)
      leases/         (créer contrat, workflow, inviter locataire)
      payments/       (suivi paiements/impayés)
      maintenance/    (déjà construit)
    owner/            (déjà construit — dashboard, biens en lecture seule)
    tenant/           (déjà construit — logement, contrat, paiements, quittances, maintenance)
  shared/ (models, widgets)
```

Navigation (bottom nav) par rôle : conforme aux sections 52-54 du cahier des charges (Gestionnaire : Accueil/Propriétaires/Biens/Contrats/Paiements + menu ; Propriétaire : Accueil/Mes biens/Contrats/Paiements/Notifications + menu ; Locataire : inchangé).

---

## 9. Architecture Angular (recentrée SUPER_ADMIN)

```
src/app/features/
  auth/                    — connexion SUPER_ADMIN uniquement
  organizations/           — superviser toutes les organisations (déjà construit)
  users/ roles/ permissions/  — gestion plateforme (comptes staff, pas les gestionnaires/propriétaires/locataires métier)
  subscriptions/           — NOUVEAU (mentionné au cahier des charges, pas encore construit)
  audit/                   — logs globaux (déjà construit au niveau organisation, à étendre cross-org)
  settings/                — configuration plateforme
```

Les modules `properties/`, `owners/`, `tenants/`, `leases/`, `payments/`, `maintenance/` actuellement dans Angular **restent dans le code** (aucune suppression proposée pour l'instant) mais **sortent du flux d'usage quotidien** — ils deviennent, au mieux, un outil de support/dépannage pour `SUPER_ADMIN`, plus la voie normale de gestion.

---

## Prochaine étape

Ce document couvre les étapes 1 à 9 demandées. Avant de lancer l'étape 10 (génération du backend module par module), confirmez notamment :

1. **Le sort d'Angular** : on garde les pages properties/owners/tenants/leases telles quelles (accès `SUPER_ADMIN` de secours), ou on les retire complètement du périmètre actif ?
2. **`ADMIN_AGENCE`/`AGENT_IMMOBILIER`** : on les laisse dormants dans l'enum (aucun risque), ou vous voulez déjà les retirer ?
3. **Le nom affiché de l'organisation auto-créée** à l'inscription d'un gestionnaire (ex. « Espace de {prénom} {nom} », modifiable ensuite) — un défaut vous convient ?

Dès validation, j'enchaîne sur l'implémentation (étapes 10-12 : backend puis Flutter puis ajustement Angular), en réutilisant au maximum l'existant comme détaillé en section 0.
