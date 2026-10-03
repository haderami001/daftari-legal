-- =====================================================================
-- Schéma de la base CENTRALE (serveur) — PostgreSQL 16 + PostGIS
-- Application « Pêche Conforme »
--
-- Le mobile garde une copie partielle de ces tables dans SQLite (Drift)
-- pour fonctionner hors ligne ; chaque ligne porte un UUID généré sur
-- l'appareil + des colonnes de synchronisation (sync_*).
-- =====================================================================

CREATE EXTENSION IF NOT EXISTS postgis;
CREATE EXTENSION IF NOT EXISTS pgcrypto;  -- gen_random_uuid()

-- ---------------------------------------------------------------------
-- Types énumérés
-- ---------------------------------------------------------------------
CREATE TYPE type_peche   AS ENUM ('artisanale', 'cotiere', 'hauturiere');
CREATE TYPE type_navire  AS ENUM ('pirogue', 'chalutier', 'senneur', 'dragueur');
CREATE TYPE type_engin   AS ENUM ('ligne', 'filet_maillant', 'casier',
                                  'chalut_demersal', 'chalut_pelagique',
                                  'senne_tournante', 'drague');
CREATE TYPE gravite      AS ENUM ('mineure', 'grave', 'tres_grave');
CREATE TYPE role_util    AS ENUM ('capitaine', 'armateur', 'agent_gc',
                                  'superviseur', 'admin');
CREATE TYPE statut_decl  AS ENUM ('brouillon', 'signee', 'validee', 'rejetee');

-- ---------------------------------------------------------------------
-- Référentiel réglementaire (versionné : on ne modifie jamais une règle,
-- on publie une nouvelle version → traçabilité juridique des contrôles)
-- ---------------------------------------------------------------------
CREATE TABLE referentiel_versions (
    id              TEXT PRIMARY KEY,               -- ex. '2026.10'
    date_effet      DATE NOT NULL,
    texte_source    TEXT NOT NULL,                  -- décret / arrêté / reco ICCAT
    publie_le       TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE especes (
    code_fao        CHAR(3) PRIMARY KEY,            -- ASFIS : OCC, SAA, YFT...
    nom_commun      TEXT NOT NULL,
    nom_scientifique TEXT NOT NULL
);

CREATE TABLE regles_especes (
    referentiel_id  TEXT REFERENCES referentiel_versions(id),
    code_fao        CHAR(3) REFERENCES especes(code_fao),
    unite           TEXT NOT NULL CHECK (unite IN ('cm', 'g')),
    minimum         NUMERIC(8,2) NOT NULL,
    organisme       TEXT NOT NULL,                  -- 'MRT', 'ICCAT', 'UE'...
    PRIMARY KEY (referentiel_id, code_fao)
);

CREATE TABLE regles_engins (
    referentiel_id  TEXT REFERENCES referentiel_versions(id),
    engin           type_engin,
    maillage_min_mm NUMERIC(6,1) NOT NULL DEFAULT 0,
    prises_acc_max_pct NUMERIC(5,2) NOT NULL,
    PRIMARY KEY (referentiel_id, engin)
);

CREATE TABLE baremes_sanctions (
    referentiel_id  TEXT REFERENCES referentiel_versions(id),
    gravite         gravite,
    amende_min_mru  NUMERIC(14,2) NOT NULL,
    amende_max_mru  NUMERIC(14,2) NOT NULL,
    PRIMARY KEY (referentiel_id, gravite)
);

-- Zones (ZEE, zones interdites, aires protégées comme le PNBA...)
CREATE TABLE zones (
    id              SERIAL PRIMARY KEY,
    nom             TEXT NOT NULL,
    interdite_pour  type_engin[] NOT NULL DEFAULT '{}',
    geom            GEOMETRY(MultiPolygon, 4326) NOT NULL
);
CREATE INDEX zones_geom_idx ON zones USING GIST (geom);

-- ---------------------------------------------------------------------
-- Utilisateurs
-- ---------------------------------------------------------------------
CREATE TABLE utilisateurs (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nom             TEXT NOT NULL,
    telephone       TEXT UNIQUE,
    matricule       TEXT UNIQUE,                    -- agents garde-côtes
    role            role_util NOT NULL,
    actif           BOOLEAN NOT NULL DEFAULT TRUE
);

-- ---------------------------------------------------------------------
-- Navires
-- ---------------------------------------------------------------------
CREATE TABLE navires (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nom             TEXT NOT NULL,
    immatriculation TEXT NOT NULL UNIQUE,
    numero_imo      CHAR(7) UNIQUE,                 -- NULL pour les pirogues
    pavillon        CHAR(3) NOT NULL,               -- ISO 3166 alpha-3
    type            type_navire NOT NULL,
    longueur_m      NUMERIC(6,2) NOT NULL,
    jauge_tjb       NUMERIC(10,2),
    puissance_kw    NUMERIC(8,1),
    armateur_id     UUID REFERENCES utilisateurs(id),
    balise_vms      TEXT,
    cree_le         TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE certificats (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    navire_id       UUID NOT NULL REFERENCES navires(id) ON DELETE CASCADE,
    type            TEXT NOT NULL,                  -- navigabilite, jaugeage, sanitaire, radio
    numero          TEXT NOT NULL,
    date_expiration DATE NOT NULL,
    fichier_url     TEXT                            -- scan PDF (stockage objet)
);
CREATE INDEX certificats_navire_idx ON certificats (navire_id);

-- ---------------------------------------------------------------------
-- Licences
-- ---------------------------------------------------------------------
CREATE TABLE licences (
    numero          TEXT PRIMARY KEY,
    navire_id       UUID NOT NULL REFERENCES navires(id),
    segment         type_peche NOT NULL,
    cadre_juridique TEXT NOT NULL,                  -- 'national', 'UE-MRT', 'affretement'...
    engins_autorises type_engin[] NOT NULL,
    especes_cibles  CHAR(3)[] NOT NULL,
    date_debut      DATE NOT NULL,
    date_fin        DATE NOT NULL,
    zone_id         INT REFERENCES zones(id),
    CHECK (date_fin >= date_debut)
);
CREATE INDEX licences_navire_idx ON licences (navire_id, date_fin);

CREATE TABLE quotas (
    licence_numero  TEXT REFERENCES licences(numero) ON DELETE CASCADE,
    code_fao        CHAR(3) REFERENCES especes(code_fao),
    quota_kg        NUMERIC(14,2) NOT NULL,
    PRIMARY KEY (licence_numero, code_fao)
);

-- ---------------------------------------------------------------------
-- Déclarations du capitaine (marées) et captures
-- ---------------------------------------------------------------------
CREATE TABLE declarations (
    id              UUID PRIMARY KEY,               -- généré sur le mobile
    navire_id       UUID NOT NULL REFERENCES navires(id),
    licence_numero  TEXT NOT NULL REFERENCES licences(numero),
    capitaine_id    UUID NOT NULL REFERENCES utilisateurs(id),
    engin           type_engin NOT NULL,
    date_depart     TIMESTAMPTZ NOT NULL,
    date_retour     TIMESTAMPTZ,
    port_debarquement TEXT,
    statut          statut_decl NOT NULL DEFAULT 'brouillon',
    signature       TEXT,                           -- signature numérique (hash signé)
    referentiel_id  TEXT REFERENCES referentiel_versions(id),
    sync_cree_le    TIMESTAMPTZ NOT NULL,           -- horodatage appareil
    sync_recu_le    TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE equipage (
    id              UUID PRIMARY KEY,
    declaration_id  UUID NOT NULL REFERENCES declarations(id) ON DELETE CASCADE,
    nom             TEXT NOT NULL,
    fonction        TEXT NOT NULL,
    nationalite     CHAR(3) NOT NULL,
    piece_identite  TEXT
);

CREATE TABLE captures (
    id              UUID PRIMARY KEY,
    declaration_id  UUID NOT NULL REFERENCES declarations(id) ON DELETE CASCADE,
    code_fao        CHAR(3) NOT NULL REFERENCES especes(code_fao),
    poids_kg        NUMERIC(12,2) NOT NULL CHECK (poids_kg > 0),
    est_accessoire  BOOLEAN NOT NULL,               -- calculé à l'enregistrement
    position        GEOGRAPHY(Point, 4326),
    capture_le      TIMESTAMPTZ NOT NULL
);
CREATE INDEX captures_decl_idx ON captures (declaration_id);
CREATE INDEX captures_espece_idx ON captures (code_fao, capture_le);

-- Positions GPS (déclarées par l'app + reçues du VMS)
CREATE TABLE positions (
    id              BIGSERIAL PRIMARY KEY,
    navire_id       UUID NOT NULL REFERENCES navires(id),
    source          TEXT NOT NULL CHECK (source IN ('app', 'vms', 'ais')),
    position        GEOGRAPHY(Point, 4326) NOT NULL,
    vitesse_noeuds  NUMERIC(5,2),
    horodatage      TIMESTAMPTZ NOT NULL
);
CREATE INDEX positions_navire_temps_idx ON positions (navire_id, horodatage DESC);
CREATE INDEX positions_geo_idx ON positions USING GIST (position);

-- ---------------------------------------------------------------------
-- Contrôles (inspections garde-côtes)
-- ---------------------------------------------------------------------
CREATE TABLE controles (
    id              UUID PRIMARY KEY,               -- généré sur le mobile
    navire_id       UUID NOT NULL REFERENCES navires(id),
    agent_id        UUID NOT NULL REFERENCES utilisateurs(id),
    declaration_id  UUID REFERENCES declarations(id),
    lieu            TEXT NOT NULL CHECK (lieu IN ('mer', 'port', 'debarquement')),
    position        GEOGRAPHY(Point, 4326) NOT NULL,
    date_controle   TIMESTAMPTZ NOT NULL,
    engin           type_engin NOT NULL,
    pavillon_conforme      BOOLEAN NOT NULL,
    marquage_conforme      BOOLEAN NOT NULL,
    stockage_conforme      BOOLEAN NOT NULL,
    observations    TEXT,
    referentiel_id  TEXT NOT NULL REFERENCES referentiel_versions(id),
    amende_min_mru  NUMERIC(14,2) NOT NULL DEFAULT 0,
    amende_max_mru  NUMERIC(14,2) NOT NULL DEFAULT 0,
    rapport_pdf_url TEXT,
    signature_agent TEXT,
    sync_cree_le    TIMESTAMPTZ NOT NULL,
    sync_recu_le    TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE INDEX controles_navire_idx ON controles (navire_id, date_controle DESC);

CREATE TABLE controle_maillages (
    id              BIGSERIAL PRIMARY KEY,
    controle_id     UUID NOT NULL REFERENCES controles(id) ON DELETE CASCADE,
    mesure_mm       NUMERIC(6,1) NOT NULL CHECK (mesure_mm > 0)
);

CREATE TABLE controle_echantillons (
    id              BIGSERIAL PRIMARY KEY,
    controle_id     UUID NOT NULL REFERENCES controles(id) ON DELETE CASCADE,
    code_fao        CHAR(3) NOT NULL REFERENCES especes(code_fao),
    valeur          NUMERIC(8,2) NOT NULL,          -- cm ou g selon regles_especes
    photo_url       TEXT
);

CREATE TABLE infractions (
    id              BIGSERIAL PRIMARY KEY,
    controle_id     UUID REFERENCES controles(id) ON DELETE CASCADE,
    declaration_id  UUID REFERENCES declarations(id) ON DELETE CASCADE,
    code            TEXT NOT NULL,                  -- QUOTA_DEPASSE, MAILLAGE...
    gravite         gravite NOT NULL,
    message         TEXT NOT NULL,
    CHECK (controle_id IS NOT NULL OR declaration_id IS NOT NULL)
);

-- Journal d'audit (qui a modifié quoi : exigence de valeur probante)
CREATE TABLE audit_log (
    id              BIGSERIAL PRIMARY KEY,
    utilisateur_id  UUID REFERENCES utilisateurs(id),
    table_cible     TEXT NOT NULL,
    ligne_id        TEXT NOT NULL,
    action          TEXT NOT NULL,
    avant           JSONB,
    apres           JSONB,
    horodatage      TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- ---------------------------------------------------------------------
-- Exemple de requête : cumul des captures par licence vs quota
-- ---------------------------------------------------------------------
-- SELECT q.licence_numero, q.code_fao, q.quota_kg,
--        COALESCE(SUM(c.poids_kg), 0) AS cumul_kg,
--        q.quota_kg - COALESCE(SUM(c.poids_kg), 0) AS reste_kg
-- FROM quotas q
-- LEFT JOIN declarations d ON d.licence_numero = q.licence_numero
--                         AND d.statut IN ('signee', 'validee')
-- LEFT JOIN captures c ON c.declaration_id = d.id AND c.code_fao = q.code_fao
-- GROUP BY q.licence_numero, q.code_fao, q.quota_kg;
