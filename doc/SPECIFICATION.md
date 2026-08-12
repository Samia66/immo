# Cahier des charges technique — Plateforme SaaS de Gestion Immobilière

**Stack :** Angular 20 (standalone + Signals) · NestJS 11 · Prisma ORM · PostgreSQL
**Type :** SaaS multi-organisations (multi-tenant)
**Statut :** Spécification v1.0 — base pour démarrage de développement

---

## Sommaire

1. [Vue d'ensemble & principes d'architecture](#1-vue-densemble--principes-darchitecture)
2. [Architecture multi-tenant](#2-architecture-multi-tenant)
3. [Structure des dossiers — Backend NestJS](#3-structure-des-dossiers--backend-nestjs)
4. [Structure des dossiers — Frontend Angular](#4-structure-des-dossiers--frontend-angular)
5. [Modèle de données Prisma complet](#5-modèle-de-données-prisma-complet)
6. [DTOs principaux](#6-dtos-principaux)
7. [Endpoints REST](#7-endpoints-rest)
8. [Flux métier détaillés](#8-flux-métier-détaillés)
9. [Navigation Angular & guards](#9-navigation-angular--guards)
10. [Matrice de permissions par rôle](#10-matrice-de-permissions-par-rôle)
11. [Exemple de dashboard](#11-exemple-de-dashboard)
12. [Plan de développement (MVP → V2 → V3)](#12-plan-de-développement-mvp--v2--v3)
13. [Déploiement Docker + PostgreSQL](#13-déploiement-docker--postgresql)
14. [Bonnes pratiques sécurité & performance](#14-bonnes-pratiques-sécurité--performance)

---

## 1. Vue d'ensemble & principes d'architecture

### 1.1 Objectif

Plateforme SaaS permettant à plusieurs agences immobilières, sociétés de gestion locative ou
propriétaires professionnels (« **organisations** ») de gérer, **de façon totalement isolée les unes
des autres**, leurs biens, propriétaires, locataires, contrats, paiements, charges,
maintenances et équipes.

### 1.2 Vue d'architecture logique

```
                        ┌─────────────────────────────┐
                        │        Angular 20 SPA        │
                        │  (standalone + Signals)      │
                        └──────────────┬───────────────┘
                                       │ HTTPS / JSON REST
                                       │ JWT Access (Bearer) + Refresh (HttpOnly cookie)
                        ┌──────────────▼───────────────┐
                        │        NestJS API Gateway     │
                        │  Helmet · CORS · RateLimit    │
                        │  ValidationPipe · Interceptors│
                        ├───────────────────────────────┤
                        │   Modules métier (feature)    │
                        │  Auth · Users · Properties …   │
                        ├───────────────────────────────┤
                        │  TenantContext (AsyncLocal /   │
                        │  Request-scoped) → organizationId
                        ├───────────────────────────────┤
                        │        Prisma ORM Client       │
                        └──────────────┬───────────────┘
                                       │
                        ┌──────────────▼───────────────┐
                        │         PostgreSQL             │
                        │  (Row-level isolation par      │
                        │   organizationId + RLS option) │
                        └───────────────────────────────┘

        Services transverses : Mailer (SMTP) · SMS Gateway (extensible) ·
        File Storage (local/S3 via Multer) · PDF Generator · Scheduler (Cron)
```

### 1.3 Principes directeurs

- **Modularité stricte** : chaque domaine métier NestJS = un module autonome (controller,
  service, repository, mapper, DTOs).
- **Isolation multi-tenant systématique** : aucune requête Prisma métier n'est exécutée sans
  filtre `organizationId`.
- **Sécurité par défaut** : RBAC + guards NestJS sur chaque endpoint, jamais d'accès implicite.
- **API-first** : contrat OpenAPI (Swagger) généré automatiquement, consommé par Angular via
  services typés.
- **UI réactive** : état applicatif Angular géré via Signals (stores légers par feature), pas de
  NgRx pour garder l'application simple à maintenir.
- **Soft delete généralisé** : aucune donnée métier n'est supprimée physiquement (`deletedAt`).
- **Auditabilité** : toute action sensible (paiement, résiliation, changement de rôle,
  suppression) est journalisée dans `AuditLog`.

---

## 2. Architecture multi-tenant

### 2.1 Stratégie retenue : **Shared Database, Shared Schema, discriminant `organizationId`**

Choix pragmatique pour un SaaS de taille PME/ETI (coût d'infra maîtrisé, migrations Prisma
simples). Une évolution vers **PostgreSQL Row-Level Security (RLS)** est prévue en V2 pour
renforcer l'isolation au niveau base (voir §14).

### 2.2 Résolution du tenant

1. L'utilisateur s'authentifie → le JWT contient `sub` (userId), `organizationId`, `role`.
2. Un `TenantInterceptor` (NestJS, request-scoped) extrait `organizationId` du JWT et l'injecte
   dans un `TenantContextService` (AsyncLocalStorage) disponible dans toute la durée de vie de
   la requête.
3. Un `PrismaService` custom étend le client Prisma avec un **middleware `$use`** qui :
   - injecte automatiquement `where: { organizationId }` sur les lectures,
   - injecte automatiquement `data.organizationId` sur les créations,
   - rejette toute requête cross-tenant (vérification `organizationId` sur update/delete).
4. Exception : `SUPER_ADMIN` opère hors tenant (accès à `Organization` en global) via un
   contexte dédié `AdminContext`, jamais mélangé avec le contexte métier tenant.

### 2.3 Entité racine

```prisma
model Organization {
  id                String   @id @default(uuid())
  name              String
  code              String   @unique
  address           String?
  phone             String?
  email             String?
  subscriptionPlan  SubscriptionPlan @default(FREE)
  isActive          Boolean  @default(true)
  createdAt         DateTime @default(now())
  updatedAt         DateTime @updatedAt
  deletedAt         DateTime?

  users             User[]
  properties        Property[]
  owners            Owner[]
  tenants           Tenant[]
  leases            Lease[]
  // ...
}
```

Toute entité métier porte `organizationId String` + relation `@relation` + `@@index([organizationId])`.

---

## 3. Structure des dossiers — Backend NestJS

```
backend/
├── src/
│   ├── main.ts                       # bootstrap, Helmet, CORS, ValidationPipe, Swagger
│   ├── app.module.ts
│   │
│   ├── common/
│   │   ├── decorators/                # @CurrentUser, @Roles, @Permissions, @TenantId
│   │   ├── guards/                    # JwtAuthGuard, RolesGuard, PermissionsGuard
│   │   ├── interceptors/              # TenantInterceptor, LoggingInterceptor, AuditInterceptor
│   │   ├── filters/                   # AllExceptionsFilter, PrismaExceptionFilter
│   │   ├── pipes/                     # ParseUuidPipe, TrimPipe
│   │   ├── dto/                       # PaginationQueryDto, PaginatedResponseDto
│   │   ├── interfaces/
│   │   └── utils/                     # pdf-generator, file-storage, date-helpers
│   │
│   ├── config/
│   │   ├── configuration.ts           # env loader typé
│   │   ├── validation.schema.ts       # Joi/zod validation des env vars
│   │   └── cors.config.ts
│   │
│   ├── prisma/
│   │   ├── prisma.module.ts
│   │   ├── prisma.service.ts          # extends PrismaClient + middleware tenant
│   │   └── tenant-context.service.ts  # AsyncLocalStorage
│   │
│   ├── modules/
│   │   ├── auth/
│   │   │   ├── auth.module.ts
│   │   │   ├── auth.controller.ts
│   │   │   ├── auth.service.ts
│   │   │   ├── strategies/            # jwt.strategy.ts, jwt-refresh.strategy.ts, local.strategy.ts
│   │   │   ├── guards/
│   │   │   └── dto/
│   │   │
│   │   ├── organizations/
│   │   │   ├── organizations.module.ts
│   │   │   ├── organizations.controller.ts
│   │   │   ├── organizations.service.ts
│   │   │   ├── organizations.repository.ts
│   │   │   ├── organizations.mapper.ts
│   │   │   └── dto/
│   │   │
│   │   ├── users/                     # même pattern controller/service/repository/mapper/dto
│   │   ├── roles/
│   │   ├── permissions/
│   │   ├── properties/
│   │   │   └── property-images/       # sous-module upload photos
│   │   ├── owners/
│   │   ├── tenants/
│   │   ├── leases/
│   │   │   └── lease-documents/
│   │   ├── payments/
│   │   ├── expenses/
│   │   ├── maintenance/
│   │   │   └── maintenance-attachments/
│   │   ├── notifications/
│   │   │   ├── channels/              # email.channel.ts, sms.channel.ts, inapp.channel.ts
│   │   │   └── notifications.scheduler.ts   # Cron (rappels loyers, échéances)
│   │   ├── dashboard/
│   │   └── audit-log/
│   │
│   └── health/                        # /health (liveness/readiness)
│
├── prisma/
│   ├── schema.prisma
│   ├── migrations/
│   └── seed.ts
│
├── test/                              # e2e (Jest + Supertest)
├── uploads/                           # stockage local dev (Multer) — S3 en prod
├── docker-compose.yml
├── Dockerfile
├── .env.example
└── package.json
```

**Convention par module** (ex. `properties`) :

| Fichier | Responsabilité |
|---|---|
| `properties.controller.ts` | Routes HTTP, Swagger, guards, validation des DTO entrants |
| `properties.service.ts` | Logique métier, orchestration, règles de gestion |
| `properties.repository.ts` | Accès Prisma exclusivement (aucune logique métier) |
| `properties.mapper.ts` | Entity Prisma → Response DTO (jamais d'exposition directe du modèle Prisma) |
| `dto/create-property.dto.ts` | class-validator |
| `dto/update-property.dto.ts` | `PartialType(CreatePropertyDto)` |
| `dto/query-property.dto.ts` | filtres + pagination |
| `dto/property-response.dto.ts` | forme exposée à l'API |

---

## 4. Structure des dossiers — Frontend Angular

```
frontend/
├── src/
│   ├── main.ts
│   ├── styles/                        # thème clair/sombre (Angular Material M3 + CSS variables)
│   │
│   ├── app/
│   │   ├── app.config.ts              # providers standalone, interceptors, routes
│   │   ├── app.routes.ts              # routes racine + lazy loading par feature
│   │   │
│   │   ├── core/
│   │   │   ├── interceptors/
│   │   │   │   ├── jwt.interceptor.ts          # ajoute Authorization: Bearer
│   │   │   │   ├── refresh.interceptor.ts      # gère 401 → refresh silencieux
│   │   │   │   └── error.interceptor.ts        # toast erreurs globales
│   │   │   ├── guards/
│   │   │   │   ├── auth.guard.ts
│   │   │   │   ├── role.guard.ts
│   │   │   │   └── permission.guard.ts
│   │   │   ├── services/
│   │   │   │   ├── auth.service.ts             # signals: currentUser, isAuthenticated
│   │   │   │   ├── token-storage.service.ts
│   │   │   │   ├── notification.service.ts     # toasts + websocket/polling in-app
│   │   │   │   └── theme.service.ts             # signal 'light' | 'dark'
│   │   │   └── models/                # interfaces partagées (User, Organization, PaginatedResult)
│   │   │
│   │   ├── shared/
│   │   │   ├── components/
│   │   │   │   ├── data-table/                 # table paginée générique
│   │   │   │   ├── stat-card/
│   │   │   │   ├── confirm-dialog/
│   │   │   │   ├── file-upload/
│   │   │   │   ├── page-header/
│   │   │   │   └── empty-state/
│   │   │   ├── pipes/                 # currency-xof.pipe, status-label.pipe
│   │   │   └── directives/            # has-permission.directive.ts
│   │   │
│   │   ├── layout/
│   │   │   ├── shell/                          # sidebar collapsable + toolbar
│   │   │   ├── sidebar/
│   │   │   └── topbar/
│   │   │
│   │   └── features/
│   │       ├── auth/
│   │       │   ├── pages/ (login, forgot-password, reset-password)
│   │       │   ├── services/auth-api.service.ts
│   │       │   └── models/
│   │       │
│   │       ├── dashboard/
│   │       │   ├── pages/ (admin-dashboard, manager-dashboard, tenant-dashboard)
│   │       │   ├── components/ (occupancy-chart, revenue-chart, upcoming-expirations)
│   │       │   ├── services/dashboard-api.service.ts
│   │       │   └── store/dashboard.store.ts     # signals + computed
│   │       │
│   │       ├── properties/
│   │       │   ├── pages/ (property-list, property-detail, property-form)
│   │       │   ├── dialogs/ (property-photo-dialog)
│   │       │   ├── components/ (property-card, property-filters, property-map)
│   │       │   ├── services/properties-api.service.ts
│   │       │   ├── models/property.model.ts
│   │       │   └── store/properties.store.ts
│   │       │
│   │       ├── owners/            # même pattern
│   │       ├── tenants/           # même pattern
│   │       ├── leases/            # + lease-wizard (formulaire multi-étapes)
│   │       ├── payments/          # + payment-recording-dialog
│   │       ├── maintenance/       # + kanban board par statut
│   │       ├── notifications/     # centre de notifications
│   │       └── settings/
│   │           ├── organization-settings/
│   │           ├── users-management/
│   │           └── roles-permissions/
│   │
│   └── assets/
│
├── angular.json
├── tsconfig.json
└── package.json
```

**Convention `store` (Signals)** — exemple `properties.store.ts` :

```ts
@Injectable({ providedIn: 'root' })
export class PropertiesStore {
  private readonly api = inject(PropertiesApiService);

  private readonly _properties = signal<Property[]>([]);
  private readonly _loading = signal(false);
  private readonly _filters = signal<PropertyFilters>({});

  readonly properties = this._properties.asReadonly();
  readonly loading = this._loading.asReadonly();
  readonly availableCount = computed(
    () => this._properties().filter(p => p.status === 'AVAILABLE').length
  );

  load(query: PropertyQuery) {
    this._loading.set(true);
    this.api.list(query).subscribe({
      next: (res) => { this._properties.set(res.data); this._loading.set(false); },
      error: () => this._loading.set(false),
    });
  }
}
```

---

## 5. Modèle de données Prisma complet

```prisma
// ============================================================
// schema.prisma
// ============================================================
generator client {
  provider = "prisma-client-js"
}

datasource db {
  provider = "postgresql"
  url      = env("DATABASE_URL")
}

// -------------------- ENUMS --------------------

enum SubscriptionPlan {
  FREE
  STARTER
  PROFESSIONAL
  ENTERPRISE
}

enum RoleName {
  SUPER_ADMIN
  ADMIN_AGENCE
  GESTIONNAIRE
  AGENT_IMMOBILIER
  LOCATAIRE
}

enum PropertyType {
  MAISON
  APPARTEMENT
  STUDIO
  BUREAU
  TERRAIN
  BOUTIQUE
}

enum PropertyStatus {
  DISPONIBLE
  OCCUPE
  RESERVE
  MAINTENANCE
}

enum LeaseStatus {
  ACTIF
  EXPIRE
  RESILIE
}

enum PaymentFrequency {
  MENSUEL
  TRIMESTRIEL
  SEMESTRIEL
  ANNUEL
}

enum PaymentStatus {
  EN_ATTENTE
  PARTIEL
  PAYE
  EN_RETARD
  ANNULE
}

enum PaymentMethod {
  ESPECES
  VIREMENT
  MOBILE_MONEY
  CHEQUE
  CARTE
}

enum ExpenseCategory {
  EAU
  ELECTRICITE
  SECURITE
  ENTRETIEN
  SYNDIC
  AUTRE
}

enum MaintenancePriority {
  BASSE
  NORMALE
  HAUTE
  URGENTE
}

enum MaintenanceStatus {
  NOUVELLE
  VALIDEE
  ASSIGNEE
  EN_COURS
  TERMINEE
  CLOTUREE
}

enum NotificationType {
  RAPPEL_LOYER
  RETARD_PAIEMENT
  CONFIRMATION_PAIEMENT
  EXPIRATION_CONTRAT
  MAINTENANCE
  ALERTE_ADMIN
}

enum NotificationChannel {
  IN_APP
  EMAIL
  SMS
}

enum AuditAction {
  CREATE
  UPDATE
  DELETE
  LOGIN
  LOGOUT
  PAYMENT_RECORDED
  LEASE_TERMINATED
  ROLE_CHANGED
}

// -------------------- CORE --------------------

model Organization {
  id               String            @id @default(uuid())
  name             String
  code             String            @unique
  address          String?
  phone            String?
  email            String?
  subscriptionPlan SubscriptionPlan  @default(FREE)
  isActive         Boolean           @default(true)
  createdAt        DateTime          @default(now())
  updatedAt        DateTime          @updatedAt
  deletedAt        DateTime?

  users            User[]
  roles            Role[]
  properties       Property[]
  owners           Owner[]
  tenants          Tenant[]
  leases           Lease[]
  payments         Payment[]
  expenses         Expense[]
  maintenances     MaintenanceRequest[]
  notifications    Notification[]
  auditLogs        AuditLog[]

  @@index([isActive])
}

model User {
  id                String    @id @default(uuid())
  organizationId    String
  organization      Organization @relation(fields: [organizationId], references: [id])

  email             String
  passwordHash      String
  firstName         String
  lastName          String
  phone             String?
  avatarUrl         String?

  roleId            String
  role              Role      @relation(fields: [roleId], references: [id])

  isActive          Boolean   @default(true)
  isEmailVerified   Boolean   @default(false)
  failedLoginCount  Int       @default(0)
  lockedUntil       DateTime?
  lastLoginAt       DateTime?

  createdAt         DateTime  @default(now())
  updatedAt         DateTime  @updatedAt
  deletedAt         DateTime?

  refreshTokens     RefreshToken[]
  auditLogs         AuditLog[]
  maintenanceAssigned MaintenanceRequest[] @relation("AssignedTechnician")
  tenantProfile     Tenant?               @relation("UserTenantProfile")

  @@unique([organizationId, email])
  @@index([organizationId])
  @@index([roleId])
}

model Role {
  id             String   @id @default(uuid())
  organizationId String?  // null = rôle système global (SUPER_ADMIN)
  organization   Organization? @relation(fields: [organizationId], references: [id])

  name           RoleName
  label          String
  isSystem       Boolean  @default(false)

  permissions    RolePermission[]
  users          User[]

  createdAt      DateTime @default(now())
  updatedAt      DateTime @updatedAt

  @@unique([organizationId, name])
  @@index([organizationId])
}

model Permission {
  id          String   @id @default(uuid())
  code        String   @unique   // ex: "properties:create", "payments:read"
  description String?
  module      String             // ex: "properties", "payments"

  roles       RolePermission[]

  @@index([module])
}

model RolePermission {
  roleId       String
  permissionId String
  role         Role       @relation(fields: [roleId], references: [id], onDelete: Cascade)
  permission   Permission @relation(fields: [permissionId], references: [id], onDelete: Cascade)

  @@id([roleId, permissionId])
}

model RefreshToken {
  id             String   @id @default(uuid())
  userId         String
  user           User     @relation(fields: [userId], references: [id], onDelete: Cascade)
  tokenHash      String
  userAgent      String?
  ipAddress      String?
  expiresAt      DateTime
  revokedAt      DateTime?
  createdAt      DateTime @default(now())

  @@index([userId])
  @@index([expiresAt])
}

// -------------------- BIENS --------------------

model Property {
  id             String         @id @default(uuid())
  organizationId String
  organization   Organization   @relation(fields: [organizationId], references: [id])

  reference      String                    // référence unique lisible (ex: PROP-2026-0001)
  title          String
  description    String?
  type           PropertyType
  status         PropertyStatus @default(DISPONIBLE)

  addressLine    String
  city           String
  district       String?
  latitude       Float?
  longitude      Float?

  rooms          Int?
  surfaceM2      Float?
  monthlyRent    Decimal        @db.Decimal(12, 2)
  monthlyCharges Decimal?       @db.Decimal(12, 2)

  ownerId        String
  owner          Owner          @relation(fields: [ownerId], references: [id])

  images         PropertyImage[]
  leases         Lease[]
  maintenances   MaintenanceRequest[]
  history        PropertyHistory[]

  createdAt      DateTime       @default(now())
  updatedAt      DateTime       @updatedAt
  deletedAt      DateTime?

  @@unique([organizationId, reference])
  @@index([organizationId, status])
  @@index([organizationId, city])
}

model PropertyImage {
  id         String   @id @default(uuid())
  propertyId String
  property   Property @relation(fields: [propertyId], references: [id], onDelete: Cascade)
  url        String
  isCover    Boolean  @default(false)
  order      Int      @default(0)
  createdAt  DateTime @default(now())

  @@index([propertyId])
}

model PropertyHistory {
  id         String   @id @default(uuid())
  propertyId String
  property   Property @relation(fields: [propertyId], references: [id], onDelete: Cascade)
  changedById String
  field      String
  oldValue   String?
  newValue   String?
  createdAt  DateTime @default(now())

  @@index([propertyId])
}

// -------------------- PROPRIÉTAIRES & LOCATAIRES --------------------

model Owner {
  id             String       @id @default(uuid())
  organizationId String
  organization   Organization @relation(fields: [organizationId], references: [id])

  fullName       String
  phone          String
  email          String?
  address        String?
  idDocumentUrl  String?
  bankName       String?
  bankAccountIban String?

  properties     Property[]

  createdAt      DateTime     @default(now())
  updatedAt      DateTime     @updatedAt
  deletedAt      DateTime?

  @@index([organizationId])
}

model Tenant {
  id             String       @id @default(uuid())
  organizationId String
  organization   Organization @relation(fields: [organizationId], references: [id])

  userId         String?      @unique   // lien optionnel vers un compte User (portail locataire)
  user           User?        @relation("UserTenantProfile", fields: [userId], references: [id])

  fullName       String
  phone          String
  email          String?
  profession     String?
  employer       String?
  monthlyIncome  Decimal?     @db.Decimal(12, 2)

  documents      TenantDocument[]
  leases         Lease[]
  maintenanceRequests MaintenanceRequest[]

  createdAt      DateTime     @default(now())
  updatedAt      DateTime     @updatedAt
  deletedAt      DateTime?

  @@index([organizationId])
}

model TenantDocument {
  id        String   @id @default(uuid())
  tenantId  String
  tenant    Tenant   @relation(fields: [tenantId], references: [id], onDelete: Cascade)
  type      String   // CNI, CONTRAT_TRAVAIL, CAUTION, AUTRE
  url       String
  createdAt DateTime @default(now())

  @@index([tenantId])
}

// -------------------- CONTRATS --------------------

model Lease {
  id             String       @id @default(uuid())
  organizationId String
  organization   Organization @relation(fields: [organizationId], references: [id])

  propertyId     String
  property       Property     @relation(fields: [propertyId], references: [id])
  ownerId        String
  tenantId       String
  tenant         Tenant       @relation(fields: [tenantId], references: [id])

  startDate      DateTime
  endDate        DateTime?
  rentAmount     Decimal      @db.Decimal(12, 2)
  depositAmount  Decimal      @db.Decimal(12, 2)
  paymentFrequency PaymentFrequency @default(MENSUEL)
  indexationRate Float?       // % de révision annuelle éventuelle
  status         LeaseStatus  @default(ACTIF)

  documents      LeaseDocument[]
  amendments     LeaseAmendment[]
  payments       Payment[]

  createdAt      DateTime     @default(now())
  updatedAt      DateTime     @updatedAt
  deletedAt      DateTime?

  @@index([organizationId, status])
  @@index([propertyId])
  @@index([tenantId])
  @@index([endDate])
}

model LeaseDocument {
  id        String   @id @default(uuid())
  leaseId   String
  lease     Lease    @relation(fields: [leaseId], references: [id], onDelete: Cascade)
  type      String   // CONTRAT_PDF, ETAT_LIEUX, AVENANT
  url       String
  createdAt DateTime @default(now())

  @@index([leaseId])
}

model LeaseAmendment {
  id          String   @id @default(uuid())
  leaseId     String
  lease       Lease    @relation(fields: [leaseId], references: [id], onDelete: Cascade)
  description String
  effectiveDate DateTime
  createdAt   DateTime @default(now())

  @@index([leaseId])
}

// -------------------- FINANCES --------------------

model Payment {
  id             String        @id @default(uuid())
  organizationId String
  organization   Organization  @relation(fields: [organizationId], references: [id])

  leaseId        String
  lease          Lease         @relation(fields: [leaseId], references: [id])

  amountDue      Decimal       @db.Decimal(12, 2)
  amountPaid     Decimal       @db.Decimal(12, 2) @default(0)
  dueDate        DateTime
  paidAt         DateTime?
  lateFee        Decimal?      @db.Decimal(12, 2)
  method         PaymentMethod?
  transactionRef String?
  status         PaymentStatus @default(EN_ATTENTE)
  receiptUrl     String?       // quittance PDF générée

  recordedById   String?

  createdAt      DateTime      @default(now())
  updatedAt      DateTime      @updatedAt
  deletedAt      DateTime?

  @@index([organizationId, status])
  @@index([leaseId])
  @@index([dueDate])
}

model Expense {
  id             String          @id @default(uuid())
  organizationId String
  organization   Organization    @relation(fields: [organizationId], references: [id])

  propertyId     String
  category       ExpenseCategory
  amount         Decimal         @db.Decimal(12, 2)
  description    String?
  expenseDate    DateTime
  attachmentUrl  String?

  createdAt      DateTime        @default(now())
  updatedAt      DateTime        @updatedAt
  deletedAt      DateTime?

  @@index([organizationId, category])
  @@index([propertyId])
}

// -------------------- MAINTENANCE --------------------

model MaintenanceRequest {
  id             String              @id @default(uuid())
  organizationId String
  organization   Organization        @relation(fields: [organizationId], references: [id])

  propertyId     String
  property       Property            @relation(fields: [propertyId], references: [id])
  tenantId       String?
  tenant         Tenant?             @relation(fields: [tenantId], references: [id])

  category       String
  description    String
  priority       MaintenancePriority @default(NORMALE)
  status         MaintenanceStatus   @default(NOUVELLE)

  assignedToId   String?
  assignedTo     User?               @relation("AssignedTechnician", fields: [assignedToId], references: [id])

  estimatedCost  Decimal?            @db.Decimal(12, 2)
  actualCost     Decimal?            @db.Decimal(12, 2)

  scheduledAt    DateTime?
  startedAt      DateTime?
  completedAt    DateTime?

  attachments    MaintenanceAttachment[]

  createdAt      DateTime            @default(now())
  updatedAt      DateTime            @updatedAt
  deletedAt      DateTime?

  @@index([organizationId, status])
  @@index([propertyId])
  @@index([assignedToId])
}

model MaintenanceAttachment {
  id          String   @id @default(uuid())
  requestId   String
  request     MaintenanceRequest @relation(fields: [requestId], references: [id], onDelete: Cascade)
  url         String
  phase       String   // AVANT | APRES
  createdAt   DateTime @default(now())

  @@index([requestId])
}

// -------------------- NOTIFICATIONS & AUDIT --------------------

model Notification {
  id             String              @id @default(uuid())
  organizationId String
  organization   Organization        @relation(fields: [organizationId], references: [id])

  userId         String              // destinataire
  type           NotificationType
  channel        NotificationChannel @default(IN_APP)
  title          String
  message        String
  isRead         Boolean             @default(false)
  metadata       Json?

  createdAt      DateTime            @default(now())

  @@index([organizationId, userId, isRead])
}

model AuditLog {
  id             String       @id @default(uuid())
  organizationId String?
  organization   Organization? @relation(fields: [organizationId], references: [id])

  userId         String?
  user           User?        @relation(fields: [userId], references: [id])

  action         AuditAction
  entity         String
  entityId       String?
  ipAddress      String?
  metadata       Json?

  createdAt      DateTime     @default(now())

  @@index([organizationId, createdAt])
  @@index([entity, entityId])
}
```

---

## 6. DTOs principaux

### 6.1 Auth

```ts
// login.dto.ts
export class LoginDto {
  @IsEmail() email: string;
  @IsString() @MinLength(8) password: string;
}

// register.dto.ts
export class RegisterDto {
  @IsString() organizationName: string;
  @IsEmail() email: string;
  @IsString() @MinLength(8) password: string;
  @IsString() firstName: string;
  @IsString() lastName: string;
}

// reset-password.dto.ts
export class ResetPasswordDto {
  @IsString() token: string;
  @IsString() @MinLength(8) newPassword: string;
}
```

### 6.2 Properties

```ts
export class CreatePropertyDto {
  @IsString() title: string;
  @IsOptional() @IsString() description?: string;
  @IsEnum(PropertyType) type: PropertyType;
  @IsString() addressLine: string;
  @IsString() city: string;
  @IsOptional() @IsString() district?: string;
  @IsOptional() @IsNumber() latitude?: number;
  @IsOptional() @IsNumber() longitude?: number;
  @IsOptional() @IsInt() @Min(0) rooms?: number;
  @IsOptional() @IsNumber() @Min(0) surfaceM2?: number;
  @IsNumber() @Min(0) monthlyRent: number;
  @IsOptional() @IsNumber() @Min(0) monthlyCharges?: number;
  @IsUUID() ownerId: string;
}

export class UpdatePropertyDto extends PartialType(CreatePropertyDto) {
  @IsOptional() @IsEnum(PropertyStatus) status?: PropertyStatus;
}

export class QueryPropertyDto extends PaginationQueryDto {
  @IsOptional() @IsEnum(PropertyType) type?: PropertyType;
  @IsOptional() @IsEnum(PropertyStatus) status?: PropertyStatus;
  @IsOptional() @IsString() city?: string;
  @IsOptional() @IsNumber() minRent?: number;
  @IsOptional() @IsNumber() maxRent?: number;
  @IsOptional() @IsString() search?: string;      // titre, référence, adresse
}
```

### 6.3 Leases

```ts
export class CreateLeaseDto {
  @IsUUID() propertyId: string;
  @IsUUID() tenantId: string;
  @IsDateString() startDate: string;
  @IsOptional() @IsDateString() endDate?: string;
  @IsNumber() @Min(0) rentAmount: number;
  @IsNumber() @Min(0) depositAmount: number;
  @IsEnum(PaymentFrequency) paymentFrequency: PaymentFrequency;
  @IsOptional() @IsNumber() indexationRate?: number;
}

export class TerminateLeaseDto {
  @IsDateString() terminationDate: string;
  @IsOptional() @IsString() reason?: string;
}
```

### 6.4 Payments

```ts
export class RecordPaymentDto {
  @IsUUID() leaseId: string;
  @IsNumber() @Min(0) amountPaid: number;
  @IsEnum(PaymentMethod) method: PaymentMethod;
  @IsOptional() @IsString() transactionRef?: string;
  @IsDateString() paidAt: string;
}

export class QueryPaymentDto extends PaginationQueryDto {
  @IsOptional() @IsEnum(PaymentStatus) status?: PaymentStatus;
  @IsOptional() @IsUUID() propertyId?: string;
  @IsOptional() @IsDateString() fromDate?: string;
  @IsOptional() @IsDateString() toDate?: string;
}
```

### 6.5 Maintenance

```ts
export class CreateMaintenanceRequestDto {
  @IsUUID() propertyId: string;
  @IsOptional() @IsUUID() tenantId?: string;
  @IsString() category: string;
  @IsString() description: string;
  @IsOptional() @IsEnum(MaintenancePriority) priority?: MaintenancePriority;
}

export class AssignMaintenanceDto {
  @IsUUID() assignedToId: string;
  @IsOptional() @IsDateString() scheduledAt?: string;
  @IsOptional() @IsNumber() estimatedCost?: number;
}

export class UpdateMaintenanceStatusDto {
  @IsEnum(MaintenanceStatus) status: MaintenanceStatus;
  @IsOptional() @IsNumber() actualCost?: number;
}
```

### 6.6 Pagination générique (partagé, `common/dto`)

```ts
export class PaginationQueryDto {
  @IsOptional() @Type(() => Number) @IsInt() @Min(1) page: number = 1;
  @IsOptional() @Type(() => Number) @IsInt() @Min(1) @Max(100) limit: number = 20;
  @IsOptional() @IsString() sortBy?: string;
  @IsOptional() @IsIn(['asc', 'desc']) sortOrder?: 'asc' | 'desc' = 'desc';
}

export class PaginatedResponseDto<T> {
  data: T[];
  meta: { total: number; page: number; limit: number; totalPages: number };
}
```

---

## 7. Endpoints REST

Convention : toutes les routes (hors `/auth/*` publiques et `/health`) sont protégées par
`JwtAuthGuard` + `PermissionsGuard`, scoping automatique par `organizationId` (sauf module
`SUPER_ADMIN`).

### 7.1 Auth

| Méthode | Route | Description | Accès |
|---|---|---|---|
| POST | `/auth/login` | Connexion, retourne access token + cookie refresh | Public |
| POST | `/auth/register` | Création d'une organisation + premier admin | Public |
| POST | `/auth/refresh` | Rafraîchit l'access token via cookie HttpOnly | Public (cookie requis) |
| POST | `/auth/logout` | Révoque le refresh token courant | Authentifié |
| POST | `/auth/forgot-password` | Envoie un email de réinitialisation | Public |
| POST | `/auth/reset-password` | Réinitialise le mot de passe via token | Public |
| POST | `/auth/verify-email` | Vérifie l'adresse email | Public |
| POST | `/auth/change-password` | Change le mot de passe (connecté) | Authentifié |
| GET | `/auth/me` | Profil courant | Authentifié |

### 7.2 Organizations

| Méthode | Route | Description | Accès |
|---|---|---|---|
| GET | `/organizations` | Liste toutes les organisations | SUPER_ADMIN |
| GET | `/organizations/:id` | Détail d'une organisation | SUPER_ADMIN |
| POST | `/organizations` | Créer une organisation | SUPER_ADMIN |
| PATCH | `/organizations/:id` | Modifier | SUPER_ADMIN |
| PATCH | `/organizations/:id/subscription` | Changer le plan d'abonnement | SUPER_ADMIN |
| PATCH | `/organizations/:id/toggle-active` | Activer / désactiver | SUPER_ADMIN |
| GET | `/organizations/me` | Détail de l'organisation courante | ADMIN_AGENCE |
| PATCH | `/organizations/me` | Modifier l'organisation courante | ADMIN_AGENCE |

### 7.3 Users

| Méthode | Route | Description | Accès |
|---|---|---|---|
| GET | `/users` | Liste paginée (filtres: rôle, statut, recherche) | ADMIN_AGENCE |
| GET | `/users/:id` | Détail | ADMIN_AGENCE |
| POST | `/users` | Créer un utilisateur (invitation email) | ADMIN_AGENCE |
| PATCH | `/users/:id` | Modifier | ADMIN_AGENCE |
| PATCH | `/users/:id/role` | Changer de rôle | ADMIN_AGENCE |
| PATCH | `/users/:id/toggle-active` | Activer / désactiver | ADMIN_AGENCE |
| POST | `/users/:id/avatar` | Upload avatar (Multer) | Soi-même / ADMIN_AGENCE |
| DELETE | `/users/:id` | Soft delete | ADMIN_AGENCE |

### 7.4 Roles & Permissions

| Méthode | Route | Description | Accès |
|---|---|---|---|
| GET | `/roles` | Liste des rôles de l'organisation | ADMIN_AGENCE |
| POST | `/roles` | Créer un rôle personnalisé | ADMIN_AGENCE |
| PATCH | `/roles/:id/permissions` | Modifier les permissions d'un rôle | ADMIN_AGENCE |
| GET | `/permissions` | Liste de toutes les permissions disponibles | ADMIN_AGENCE |

### 7.5 Properties

| Méthode | Route | Description | Accès |
|---|---|---|---|
| GET | `/properties` | Liste paginée + filtres (type, statut, ville, prix, recherche) | Tous rôles internes |
| GET | `/properties/:id` | Détail | Tous rôles internes |
| POST | `/properties` | Créer | ADMIN_AGENCE, GESTIONNAIRE |
| PATCH | `/properties/:id` | Modifier | ADMIN_AGENCE, GESTIONNAIRE |
| DELETE | `/properties/:id` | Soft delete | ADMIN_AGENCE |
| POST | `/properties/:id/images` | Upload photos (Multer, multi-fichiers) | ADMIN_AGENCE, GESTIONNAIRE |
| DELETE | `/properties/:id/images/:imageId` | Supprimer une photo | ADMIN_AGENCE, GESTIONNAIRE |
| GET | `/properties/:id/history` | Historique des modifications | ADMIN_AGENCE, GESTIONNAIRE |
| GET | `/properties/nearby?lat&lng&radius` | Recherche géolocalisée | Tous rôles internes |

### 7.6 Owners

| Méthode | Route | Description | Accès |
|---|---|---|---|
| GET | `/owners` | Liste paginée | ADMIN_AGENCE, GESTIONNAIRE |
| GET | `/owners/:id` | Détail + biens + revenus générés | ADMIN_AGENCE, GESTIONNAIRE |
| POST | `/owners` | Créer | ADMIN_AGENCE, GESTIONNAIRE |
| PATCH | `/owners/:id` | Modifier | ADMIN_AGENCE, GESTIONNAIRE |
| DELETE | `/owners/:id` | Soft delete | ADMIN_AGENCE |

### 7.7 Tenants

| Méthode | Route | Description | Accès |
|---|---|---|---|
| GET | `/tenants` | Liste paginée | ADMIN_AGENCE, GESTIONNAIRE, AGENT_IMMOBILIER |
| GET | `/tenants/:id` | Détail + historique locatif | ADMIN_AGENCE, GESTIONNAIRE |
| POST | `/tenants` | Créer | ADMIN_AGENCE, GESTIONNAIRE, AGENT_IMMOBILIER |
| PATCH | `/tenants/:id` | Modifier | ADMIN_AGENCE, GESTIONNAIRE |
| POST | `/tenants/:id/documents` | Upload documents (CNI, contrat travail, caution) | ADMIN_AGENCE, GESTIONNAIRE |
| DELETE | `/tenants/:id` | Soft delete | ADMIN_AGENCE |

### 7.8 Leases

| Méthode | Route | Description | Accès |
|---|---|---|---|
| GET | `/leases` | Liste paginée (filtres: statut, bien, locataire, expiration proche) | ADMIN_AGENCE, GESTIONNAIRE |
| GET | `/leases/:id` | Détail | ADMIN_AGENCE, GESTIONNAIRE, LOCATAIRE (le sien) |
| POST | `/leases` | Créer un contrat | ADMIN_AGENCE, GESTIONNAIRE |
| PATCH | `/leases/:id` | Modifier | ADMIN_AGENCE, GESTIONNAIRE |
| POST | `/leases/:id/renew` | Renouveler | ADMIN_AGENCE, GESTIONNAIRE |
| POST | `/leases/:id/terminate` | Résilier | ADMIN_AGENCE, GESTIONNAIRE |
| POST | `/leases/:id/amendments` | Ajouter un avenant | ADMIN_AGENCE, GESTIONNAIRE |
| GET | `/leases/:id/contract.pdf` | Générer/télécharger le contrat PDF | ADMIN_AGENCE, GESTIONNAIRE, LOCATAIRE (le sien) |
| GET | `/leases/expiring-soon?days=30` | Contrats arrivant à échéance | ADMIN_AGENCE, GESTIONNAIRE |

### 7.9 Payments

| Méthode | Route | Description | Accès |
|---|---|---|---|
| GET | `/payments` | Liste paginée (filtres: statut, bien, période) | ADMIN_AGENCE, GESTIONNAIRE |
| GET | `/payments/:id` | Détail | ADMIN_AGENCE, GESTIONNAIRE, LOCATAIRE (le sien) |
| POST | `/payments` | Générer une échéance (job auto également) | GESTIONNAIRE |
| POST | `/payments/:id/record` | Enregistrer un paiement (partiel ou total) | GESTIONNAIRE |
| GET | `/payments/:id/receipt.pdf` | Télécharger quittance | ADMIN_AGENCE, GESTIONNAIRE, LOCATAIRE (le sien) |
| GET | `/payments/overdue` | Loyers en retard | ADMIN_AGENCE, GESTIONNAIRE |
| GET | `/payments/me` | Mes paiements | LOCATAIRE |

### 7.10 Expenses

| Méthode | Route | Description | Accès |
|---|---|---|---|
| GET | `/expenses` | Liste paginée (filtres: bien, catégorie, période) | ADMIN_AGENCE, GESTIONNAIRE |
| POST | `/expenses` | Créer une charge | ADMIN_AGENCE, GESTIONNAIRE |
| PATCH | `/expenses/:id` | Modifier | ADMIN_AGENCE, GESTIONNAIRE |
| DELETE | `/expenses/:id` | Soft delete | ADMIN_AGENCE |
| GET | `/expenses/reports?groupBy=property\|category\|month` | Rapport agrégé | ADMIN_AGENCE |

### 7.11 Maintenance

| Méthode | Route | Description | Accès |
|---|---|---|---|
| GET | `/maintenance` | Liste paginée (filtres: statut, priorité, bien) | ADMIN_AGENCE, GESTIONNAIRE |
| GET | `/maintenance/:id` | Détail | Tous rôles internes concernés |
| POST | `/maintenance` | Créer une demande | LOCATAIRE, GESTIONNAIRE, AGENT_IMMOBILIER |
| PATCH | `/maintenance/:id/validate` | Valider la demande | GESTIONNAIRE |
| PATCH | `/maintenance/:id/assign` | Assigner un technicien | GESTIONNAIRE |
| PATCH | `/maintenance/:id/status` | Changer de statut (workflow) | GESTIONNAIRE |
| POST | `/maintenance/:id/attachments` | Upload photos avant/après | GESTIONNAIRE |
| GET | `/maintenance/me` | Mes demandes (locataire) | LOCATAIRE |

### 7.12 Notifications

| Méthode | Route | Description | Accès |
|---|---|---|---|
| GET | `/notifications` | Liste paginée (mes notifications) | Authentifié |
| PATCH | `/notifications/:id/read` | Marquer comme lue | Authentifié |
| PATCH | `/notifications/read-all` | Tout marquer comme lu | Authentifié |
| GET | `/notifications/unread-count` | Compteur non lues | Authentifié |

### 7.13 Dashboard

| Méthode | Route | Description | Accès |
|---|---|---|---|
| GET | `/dashboard/admin` | KPIs globaux organisation | ADMIN_AGENCE |
| GET | `/dashboard/manager` | KPIs opérationnels | GESTIONNAIRE |
| GET | `/dashboard/tenant` | KPIs personnels | LOCATAIRE |
| GET | `/dashboard/super-admin` | Statistiques globales toutes organisations | SUPER_ADMIN |

---

## 8. Flux métier détaillés

### 8.1 Onboarding d'une nouvelle organisation

1. `POST /auth/register` avec `organizationName`, email, mot de passe, nom/prénom.
2. Le backend, en transaction Prisma :
   - crée `Organization` (`subscriptionPlan: FREE`, `isActive: true`),
   - crée les rôles système par défaut pour cette organisation (`ADMIN_AGENCE`,
     `GESTIONNAIRE`, `AGENT_IMMOBILIER`, `LOCATAIRE`) via seed de permissions,
   - crée le `User` avec `role = ADMIN_AGENCE`, `isEmailVerified: false`.
3. Envoi d'un email de vérification (`Mailer`).
4. Utilisateur redirigé vers `/auth/verify-email?token=...` côté Angular.

### 8.2 Cycle de vie d'un contrat de location

```
Bien DISPONIBLE
   │  POST /leases (propertyId, tenantId, dates, loyer, dépôt)
   ▼
Lease créé (status=ACTIF) ── transaction Prisma ──▶ Property.status = OCCUPE
   │
   ├─ génération automatique du contrat PDF (LeaseDocument type=CONTRAT_PDF)
   ├─ génération des échéances Payment futures selon paymentFrequency
   │      (job planifié ou génération à la volée mensuelle)
   │
   ├─ Renouvellement : POST /leases/:id/renew → nouvelle endDate, avenant optionnel
   │
   └─ Résiliation : POST /leases/:id/terminate
          → Lease.status = RESILIE
          → Property.status = DISPONIBLE
          → notification au propriétaire + locataire
```

### 8.3 Cycle de paiement de loyer

1. **Génération de l'échéance** : un job Cron mensuel (`@nestjs/schedule`) crée les
   `Payment` (`status=EN_ATTENTE`, `dueDate`) pour chaque bail actif selon sa fréquence.
2. **Rappel avant échéance** : 5 jours avant `dueDate`, notification `RAPPEL_LOYER`
   (in-app + email) au locataire.
3. **Enregistrement du paiement** : `POST /payments/:id/record` par le GESTIONNAIRE
   - met à jour `amountPaid`, `status` (`PARTIEL` si `amountPaid < amountDue`, sinon `PAYE`),
   - génère la quittance PDF (`receiptUrl`),
   - déclenche notification `CONFIRMATION_PAIEMENT` au locataire,
   - écrit une entrée `AuditLog` (`action=PAYMENT_RECORDED`).
4. **Détection de retard** : job Cron quotidien marque `EN_RETARD` les paiements dont
   `dueDate < now` et `status = EN_ATTENTE`, calcule `lateFee` si configuré, notifie
   locataire + gestionnaire.

### 8.4 Workflow de maintenance

```
NOUVELLE  →  VALIDEE  →  ASSIGNEE  →  EN_COURS  →  TERMINEE  →  CLOTUREE
   │             │            │            │            │            │
créée par    validée par  technicien   travaux      coût réel   clôturée
locataire/   gestionnaire  assigné +   démarrés     saisi +      après
agent        (filtrage    date        (startedAt)  photos       validation
             doublons)    planifiée                "après"      finale
```

- Chaque transition émet une notification aux parties concernées (locataire, propriétaire
  si coût élevé, technicien assigné).
- `PATCH /maintenance/:id/status` valide les transitions autorisées uniquement (machine à
  états stricte côté service, transitions arrière interdites sauf `ADMIN_AGENCE`).

### 8.5 Notifications automatiques (planificateur)

| Job (Cron) | Fréquence | Action |
|---|---|---|
| `rentReminderJob` | Quotidien 08:00 | Rappels loyers à J-5 |
| `overduePaymentJob` | Quotidien 09:00 | Marque `EN_RETARD`, notifie |
| `leaseExpirationJob` | Quotidien 08:30 | Alerte contrats expirant sous 30j |
| `generateMonthlyPaymentsJob` | 1er du mois 00:30 | Génère les échéances du mois |
| `staleMaintenanceJob` | Quotidien 10:00 | Alerte admin sur demandes non traitées > 48h |

### 8.6 Recherche avancée de biens

`GET /properties?type=&status=&city=&minRent=&maxRent=&search=&page=&limit=&sortBy=`
→ Prisma `findMany` avec `where` combiné (AND des filtres actifs), `OR` sur `search`
(titre, référence, adresse), toujours contraint par `organizationId` injecté par le
middleware tenant.

---

## 9. Navigation Angular & guards

```
/ (redirect → /dashboard si connecté, sinon /auth/login)

/auth
  /login
  /forgot-password
  /reset-password/:token
  /verify-email/:token

/app (shell layout, canActivate: authGuard)
  /dashboard                         (redirige selon rôle)
  /properties                        canActivate: permissionGuard('properties:read')
  /properties/:id
  /properties/new                    permissionGuard('properties:create')
  /properties/:id/edit                permissionGuard('properties:update')

  /owners                            permissionGuard('owners:read')
  /owners/:id
  /owners/new

  /tenants                           permissionGuard('tenants:read')
  /tenants/:id
  /tenants/new

  /leases                            permissionGuard('leases:read')
  /leases/:id
  /leases/new                        (wizard multi-étapes)

  /payments                          permissionGuard('payments:read')
  /payments/overdue

  /maintenance                       permissionGuard('maintenance:read')
  /maintenance/:id
  /maintenance/board                 (kanban par statut)

  /notifications

  /settings
    /organization                    roleGuard(['ADMIN_AGENCE'])
    /users                           roleGuard(['ADMIN_AGENCE'])
    /roles-permissions               roleGuard(['ADMIN_AGENCE'])

/super-admin (shell distinct)        roleGuard(['SUPER_ADMIN'])
  /organizations
  /organizations/:id
  /statistics
```

- **Lazy loading** par feature (`loadChildren`), un fichier `<feature>.routes.ts` par module.
- **`authGuard`** : vérifie `AuthService.isAuthenticated()` (signal), redirige vers
  `/auth/login` avec `returnUrl`.
- **`permissionGuard(code)`** / **`roleGuard(roles[])`** : `CanActivateFn` consultant les
  permissions/role du signal `currentUser`.
- **`refresh.interceptor.ts`** : intercepte les 401, tente un `POST /auth/refresh` (cookie
  HttpOnly), rejoue la requête originale, sinon déconnecte.

---

## 10. Matrice de permissions par rôle

Légende : ✅ accès complet · 🟡 accès limité (lecture seule / périmètre restreint) · ❌ aucun accès

| Ressource | SUPER_ADMIN | ADMIN_AGENCE | GESTIONNAIRE | AGENT_IMMOBILIER | LOCATAIRE |
|---|:---:|:---:|:---:|:---:|:---:|
| Organisations (toutes) | ✅ | ❌ | ❌ | ❌ | ❌ |
| Organisation (la sienne) | ✅ | ✅ | 🟡 lecture | 🟡 lecture | ❌ |
| Utilisateurs | ✅ (global) | ✅ | ❌ | ❌ | ❌ |
| Rôles & permissions | ✅ | ✅ | ❌ | ❌ | ❌ |
| Biens (properties) | ✅ | ✅ | ✅ | 🟡 lecture + création demandes | 🟡 lecture (son bien loué) |
| Propriétaires (owners) | ✅ | ✅ | ✅ | 🟡 lecture | ❌ |
| Locataires (tenants) | ✅ | ✅ | ✅ | 🟡 création | 🟡 son propre profil |
| Contrats (leases) | ✅ | ✅ | ✅ | 🟡 lecture | 🟡 son propre contrat |
| Paiements | ✅ | ✅ lecture rapports | ✅ | ❌ | 🟡 ses paiements |
| Charges (expenses) | ✅ | ✅ | 🟡 création | ❌ | ❌ |
| Maintenance | ✅ | ✅ | ✅ | 🟡 suivi visites | 🟡 création + suivi des siennes |
| Notifications | ✅ | ✅ | ✅ | ✅ (les siennes) | ✅ (les siennes) |
| Dashboard financier | ✅ global | ✅ organisation | 🟡 opérationnel | ❌ | 🟡 personnel |
| Audit logs | ✅ | ✅ (son organisation) | ❌ | ❌ | ❌ |
| Abonnement SaaS | ✅ | 🟡 lecture | ❌ | ❌ | ❌ |

Implémentation technique : chaque `Role` référence un ensemble de `Permission` (`code` type
`"<module>:<action>"`). Le `PermissionsGuard` NestJS lit les métadonnées `@Permissions(...)`
posées sur chaque handler et les compare aux permissions effectives du rôle de l'utilisateur
(résolu via `RolePermission`). Côté Angular, `HasPermissionDirective` (`*appHasPermission="'properties:create'"`)
masque les actions non autorisées dans l'UI (défense en profondeur — le backend reste
l'autorité finale).

---

## 11. Exemple de dashboard

### 11.1 Dashboard ADMIN_AGENCE — maquette fonctionnelle

```
┌─────────────────────────────────────────────────────────────────────┐
│  Tableau de bord — Agence Horizon Immo              [Aujourd'hui ▾] │
├───────────────┬───────────────┬───────────────┬───────────────────┤
│ 🏠 Biens gérés │ 📈 Taux occup. │ 💰 Revenus mois │ ⚠️ Impayés         │
│     128        │     84 %       │  12 450 000 F   │   6  (1.2M F)     │
├───────────────┴───────────────┴───────────────┴───────────────────┤
│  Revenus locatifs — 12 derniers mois          │  Répartition biens  │
│  [graphique en barres]                        │  [donut par statut] │
├────────────────────────────────────────────────────────────────────┤
│  Contrats expirant sous 30 jours         │  Maintenances ouvertes  │
│  ─────────────────────────────────────    │  ─────────────────────  │
│  • Villa Almadies — expire le 28/08       │  • Fuite robinet — URGENTE │
│  • Appt Ngor — expire le 02/09            │  • Climatisation — NORMALE │
│  • Studio Plateau — expire le 10/09       │  • Portail — BASSE        │
└────────────────────────────────────────────────────────────────────┘
```

### 11.2 Contrat de données `GET /dashboard/admin`

```json
{
  "kpis": {
    "totalProperties": 128,
    "occupancyRate": 0.84,
    "monthlyRevenue": 12450000,
    "overduePaymentsCount": 6,
    "overduePaymentsAmount": 1200000,
    "openMaintenanceCount": 9,
    "expiringLeasesCount": 3
  },
  "revenueByMonth": [
    { "month": "2025-09", "amount": 10250000 },
    { "month": "2025-10", "amount": 10890000 }
  ],
  "propertiesByStatus": [
    { "status": "OCCUPE", "count": 108 },
    { "status": "DISPONIBLE", "count": 15 },
    { "status": "MAINTENANCE", "count": 5 }
  ],
  "expiringLeases": [
    { "leaseId": "...", "propertyTitle": "Villa Almadies", "endDate": "2026-08-28" }
  ],
  "openMaintenance": [
    { "id": "...", "propertyTitle": "Appt Ngor", "priority": "URGENTE", "status": "ASSIGNEE" }
  ]
}
```

Rendu Angular : `dashboard.store.ts` charge ce payload une fois, expose des `computed()`
dérivés par carte (`StatCardComponent`), graphiques via une librairie légère (ex. ng2-charts /
Chart.js) consommant directement les signals convertis en valeurs via `toSignal`/`effect`.

### 11.3 Dashboard LOCATAIRE (aperçu)

- Carte « Prochain loyer » : montant, date d'échéance, bouton « Voir ma quittance ».
- Liste des 5 derniers paiements avec statut coloré.
- Résumé du contrat actif (bien, dates, loyer).
- Bouton « Signaler un problème » → ouvre le formulaire de demande de maintenance.

---

## 12. Plan de développement (MVP → V2 → V3)

### Phase 0 — Fondations (1–2 semaines)
- Setup monorepo, CI, Docker Compose dev, schéma Prisma initial + migrations, seed.
- Auth (login, refresh, guards), structure multi-tenant (TenantInterceptor, middleware Prisma).
- Layout Angular (shell, sidebar, thème clair/sombre), interceptors JWT.

### MVP (6–8 semaines)
- Modules : Organizations (self-service), Users, Roles/Permissions (rôles système),
  Properties (CRUD + photos), Owners, Tenants, Leases (CRUD + PDF contrat basique),
  Payments (échéances manuelles + enregistrement + quittance PDF), Dashboard admin/gestionnaire
  basique, Notifications in-app uniquement.
- Sécurité de base : Helmet, CORS, rate limiting, validation stricte, audit log sur actions
  critiques (paiement, résiliation, changement rôle).
- Déploiement Docker Compose (staging).

### V2 (6–8 semaines)
- Notifications email automatiques (rappels, retards, expirations) + planificateur Cron.
- Recherche avancée + géolocalisation biens (carte interactive).
- Module Maintenance complet (workflow, kanban, pièces jointes avant/après).
- Rapports financiers avancés (export PDF/Excel, revenus par bien/propriétaire, trésorerie).
- Dashboard locataire complet + portail self-service.
- Renforcement isolation tenant : passage à PostgreSQL RLS.
- Tests e2e critiques (auth, paiements, contrats), couverture CI.

### V3 (continue)
- Notifications SMS (intégration passerelle configurable).
- Abonnements SaaS payants (facturation, limites par plan, `SUPER_ADMIN` billing dashboard).
- Signatures électroniques des contrats.
- Application mobile (locataires) ou PWA.
- Multi-langue (i18n Angular), multi-devise.
- Audit avancé + export conformité, 2FA, SSO (SAML/OIDC) pour grandes agences.

---

## 13. Déploiement Docker + PostgreSQL

### 13.1 `docker-compose.yml` (exemple)

```yaml
version: "3.9"
services:
  postgres:
    image: postgres:16-alpine
    restart: unless-stopped
    environment:
      POSTGRES_USER: immo
      POSTGRES_PASSWORD: ${POSTGRES_PASSWORD}
      POSTGRES_DB: immo_db
    volumes:
      - pgdata:/var/lib/postgresql/data
    ports:
      - "5432:5432"

  api:
    build: ./backend
    restart: unless-stopped
    depends_on:
      - postgres
    environment:
      DATABASE_URL: postgresql://immo:${POSTGRES_PASSWORD}@postgres:5432/immo_db
      JWT_ACCESS_SECRET: ${JWT_ACCESS_SECRET}
      JWT_REFRESH_SECRET: ${JWT_REFRESH_SECRET}
      NODE_ENV: production
    ports:
      - "3000:3000"
    volumes:
      - uploads:/app/uploads

  frontend:
    build: ./frontend
    restart: unless-stopped
    depends_on:
      - api
    ports:
      - "80:80"

volumes:
  pgdata:
  uploads:
```

### 13.2 Recommandations

- **Migrations** : `prisma migrate deploy` exécuté au démarrage du conteneur `api`
  (entrypoint dédié), jamais `migrate dev` en production.
- **Stockage fichiers** : local (`uploads/` volume) en MVP, migration vers S3/MinIO en V2
  pour scalabilité horizontale de l'API.
- **Secrets** : jamais en dur, via variables d'environnement / secret manager (Docker
  secrets, Vault, ou secrets du provider cloud).
- **Reverse proxy** : Nginx ou Traefik devant `frontend` + `api`, terminaison TLS (Let's
  Encrypt), redirection HTTP→HTTPS.
- **Scalabilité** : `api` stateless (sessions via JWT) → réplicable horizontalement ;
  PostgreSQL en managé (RDS/Cloud SQL) en production plutôt qu'en conteneur.
- **Sauvegardes** : `pg_dump` planifié + rétention, tests de restauration réguliers.
- **Observabilité** : logs structurés (JSON) via un logger NestJS (Pino), healthchecks
  `/health` pour orchestrateur, métriques Prometheus optionnelles.

---

## 14. Bonnes pratiques sécurité & performance

### 14.1 Sécurité

- **JWT** : access token courte durée (15 min), refresh token longue durée (7–30 j) stocké
  en cookie `HttpOnly`, `Secure`, `SameSite=Strict`, rotation à chaque refresh (`RefreshToken`
  révoqué et remplacé), détection de réutilisation (token theft detection).
- **Mots de passe** : hash `bcrypt` (cost ≥ 12), politique de complexité minimale, verrouillage
  de compte après N tentatives échouées (`failedLoginCount`, `lockedUntil`).
- **RBAC** : vérification systématique côté backend (guards), jamais de confiance dans l'UI.
- **Isolation multi-tenant** : middleware Prisma + tests automatisés dédiés vérifiant qu'aucune
  requête ne peut retourner de données d'une autre organisation ; évolution recommandée vers
  PostgreSQL Row-Level Security (`CREATE POLICY ... USING (organization_id = current_setting(...))`)
  pour une isolation défendue au niveau base, indépendante d'un bug applicatif.
- **Validation** : `ValidationPipe({ whitelist: true, forbidNonWhitelisted: true, transform: true })`
  global, DTOs stricts, `class-validator` sur toutes les entrées.
- **Headers & transport** : `helmet()`, CORS restreint aux origines connues, TLS obligatoire
  en production.
- **Rate limiting** : `@nestjs/throttler` global + règles renforcées sur `/auth/login`,
  `/auth/forgot-password` (anti brute-force).
- **Upload de fichiers** : Multer avec whitelist de types MIME, limite de taille, scan
  antivirus optionnel (V2), noms de fichiers générés (jamais le nom original tel quel).
- **Audit** : `AuditLog` sur toute action sensible, horodatée, avec `ipAddress` et
  `userId`, non modifiable (pas d'update/delete exposés sur ce modèle).
- **Secrets & configuration** : validation stricte des variables d'environnement au boot
  (fail-fast si secret manquant), rotation régulière des secrets JWT.

### 14.2 Performance

- **Pagination systématique** sur toutes les listes (`PaginationQueryDto`), jamais de
  `findMany` non borné.
- **Indexation Prisma** ciblée sur les colonnes de filtrage fréquent (`organizationId`,
  `status`, `dueDate`, clés étrangères) — déjà reflétée dans le schéma §5.
- **Sélection de champs** (`select`/`include` Prisma) minimale par endpoint, mappers dédiés
  pour éviter la sur-fetch.
- **Cache** : cache HTTP court sur les endpoints de référence peu volatils (ex. liste des
  `Permission`), Redis en V2 pour sessions/cache applicatif si montée en charge.
- **Requêtes agrégées** pour les rapports financiers (`groupBy` Prisma) plutôt que calculs
  applicatifs sur de larges volumes.
- **Frontend** : lazy loading par feature, `OnPush`/Signals pour limiter les cycles de
  détection de changement, virtualisation (`cdk-virtual-scroll`) sur les longues listes,
  compression des images uploadées (redimensionnement côté client avant upload).
- **Jobs planifiés** : traitement par lots (batch) pour la génération mensuelle des
  échéances de paiement afin d'éviter les pics de charge sur de grandes bases de contrats.

---

*Fin du cahier des charges — document vivant, à faire évoluer au fil des sprints.*
