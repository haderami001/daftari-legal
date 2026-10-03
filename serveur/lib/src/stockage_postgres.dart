import 'dart:convert';
import 'dart:typed_data';

import 'package:postgres/postgres.dart';

import 'authentification.dart';
import 'referentiel.dart';
import 'stockage.dart';
import 'validation.dart';

/// Migrations du schéma, appliquées dans l'ordre au démarrage. On n'en
/// modifie jamais une déjà publiée : on en ajoute une nouvelle.
const migrations = <String>[
  // 1 — tables de réception des saisies.
  '''
  CREATE TABLE declarations (
      id              UUID PRIMARY KEY,
      navire_id       TEXT NOT NULL,
      licence_numero  TEXT NOT NULL,
      engin           TEXT NOT NULL,
      latitude        DOUBLE PRECISION NOT NULL,
      longitude       DOUBLE PRECISION NOT NULL,
      horodatage      TIMESTAMPTZ NOT NULL,
      nb_infractions  INTEGER NOT NULL,
      poids_total_kg  NUMERIC(14,2) NOT NULL,
      equipage        JSONB NOT NULL,
      captures        JSONB NOT NULL,
      empreinte       TEXT NOT NULL,
      recu_le         TIMESTAMPTZ NOT NULL DEFAULT now()
  );
  CREATE INDEX declarations_navire_idx ON declarations (navire_id, horodatage DESC);

  CREATE TABLE controles (
      id                 UUID PRIMARY KEY,
      navire_id          TEXT NOT NULL,
      agent              TEXT NOT NULL,
      date_controle      TIMESTAMPTZ NOT NULL,
      latitude           DOUBLE PRECISION NOT NULL,
      longitude          DOUBLE PRECISION NOT NULL,
      engin              TEXT NOT NULL,
      pavillon_conforme  BOOLEAN NOT NULL,
      marquage_conforme  BOOLEAN NOT NULL,
      stockage_conforme  BOOLEAN NOT NULL,
      observations       TEXT NOT NULL,
      nb_infractions     INTEGER NOT NULL,
      amende_min_mru     NUMERIC(14,2) NOT NULL,
      amende_max_mru     NUMERIC(14,2) NOT NULL,
      maillages_mm       JSONB NOT NULL,
      echantillons       JSONB NOT NULL,
      rapport            TEXT NOT NULL,
      rapport_pdf        BYTEA,
      empreinte          TEXT NOT NULL,
      recu_le            TIMESTAMPTZ NOT NULL DEFAULT now()
  );
  CREATE INDEX controles_navire_idx ON controles (navire_id, date_controle DESC);
  ''',
  // 2 — compte Keycloak qui a envoyé la saisie (traçabilité).
  '''
  ALTER TABLE declarations ADD COLUMN envoye_par TEXT;
  ALTER TABLE declarations ADD COLUMN envoye_par_nom TEXT;
  ALTER TABLE controles ADD COLUMN envoye_par TEXT;
  ALTER TABLE controles ADD COLUMN envoye_par_nom TEXT;
  ''',
  // 3 — référentiel (navires, licences). Chaque modification prend un
  // numéro de version croissant : le téléphone compare avec le sien.
  '''
  CREATE SEQUENCE referentiel_version_seq;
  CREATE TABLE navires (
      id               TEXT PRIMARY KEY,
      immatriculation  TEXT NOT NULL UNIQUE,
      donnees          JSONB NOT NULL,
      version          BIGINT NOT NULL,
      modifie_le       TIMESTAMPTZ NOT NULL DEFAULT now(),
      modifie_par      TEXT
  );
  CREATE TABLE licences (
      numero       TEXT PRIMARY KEY,
      navire_id    TEXT NOT NULL REFERENCES navires (id),
      donnees      JSONB NOT NULL,
      version      BIGINT NOT NULL,
      modifie_le   TIMESTAMPTZ NOT NULL DEFAULT now(),
      modifie_par  TEXT
  );
  CREATE INDEX licences_navire_idx ON licences (navire_id);
  ''',
];

/// Stockage PostgreSQL (production).
class StockagePostgres implements Stockage {
  StockagePostgres._(this._pool);

  final Pool<void> _pool;

  /// Se connecte, applique les migrations manquantes et renvoie le stockage.
  ///
  /// [url] : `postgres://utilisateur:motdepasse@hote:5432/base?sslmode=require`
  static Future<StockagePostgres> ouvrir(Uri url) async {
    final infos = url.userInfo.split(':');
    final pool = Pool<void>.withEndpoints(
      [
        Endpoint(
          host: url.host,
          port: url.hasPort ? url.port : 5432,
          database:
              url.pathSegments.isEmpty ? 'postgres' : url.pathSegments.first,
          username: infos.isEmpty || infos.first.isEmpty
              ? null
              : Uri.decodeComponent(infos.first),
          password: infos.length > 1
              ? Uri.decodeComponent(infos.sublist(1).join(':'))
              : null,
        ),
      ],
      settings: PoolSettings(
        maxConnectionCount: 8,
        sslMode: switch (url.queryParameters['sslmode']) {
          'require' => SslMode.require,
          'verify-full' => SslMode.verifyFull,
          _ => SslMode.disable,
        },
      ),
    );
    final stockage = StockagePostgres._(pool);
    await stockage._migrer();
    return stockage;
  }

  Future<void> _migrer() => _pool.runTx((tx) async {
        await tx.execute('CREATE TABLE IF NOT EXISTS schema_version ('
            'version INTEGER PRIMARY KEY, '
            'applique_le TIMESTAMPTZ NOT NULL DEFAULT now())');
        // Un seul serveur à la fois applique les migrations.
        await tx.execute('LOCK TABLE schema_version IN EXCLUSIVE MODE');
        final r = await tx
            .execute('SELECT coalesce(max(version), 0) FROM schema_version');
        final actuelle = r.first.first! as int;
        for (var v = actuelle + 1; v <= migrations.length; v++) {
          for (final instruction in migrations[v - 1].split(';')) {
            if (instruction.trim().isNotEmpty) await tx.execute(instruction);
          }
          await tx.execute(
              Sql.named('INSERT INTO schema_version (version) VALUES (@v)'),
              parameters: {'v': v});
        }
      });

  @override
  Future<Enregistrement> enregistrer(
      TypeSaisie type, String id, Map<String, Object?> d,
      {Utilisateur? par}) async {
    final e = empreinte(d);
    final position = d['position']! as Map;
    final commun = <String, Object?>{
      'id': id,
      'navire': d['navire_id'],
      'engin': d['engin'],
      'lat': (position['lat'] as num).toDouble(),
      'lon': (position['lon'] as num).toDouble(),
      'nb': d['nb_infractions'],
      'empreinte': e,
      'par': par?.id,
      'par_nom': par?.nom,
    };
    final Result r;
    switch (type) {
      case TypeSaisie.declaration:
        final captures = d['captures']! as List;
        final poidsTotal = captures.fold<num>(
            0, (s, c) => s + ((c as Map)['poids_kg'] as num));
        r = await _pool.execute(
          Sql.named('''
            INSERT INTO declarations (id, navire_id, licence_numero, engin,
                latitude, longitude, horodatage, nb_infractions,
                poids_total_kg, equipage, captures, empreinte, envoye_par,
                envoye_par_nom)
            VALUES (@id:uuid, @navire, @licence, @engin, @lat, @lon,
                @horodatage:timestamptz, @nb, @poids, @equipage:jsonb,
                @captures:jsonb, @empreinte, @par:text, @par_nom:text)
            ON CONFLICT (id) DO NOTHING
            RETURNING id'''),
          parameters: {
            ...commun,
            'licence': d['licence_numero'],
            'horodatage': DateTime.parse(d['horodatage']! as String),
            'poids': poidsTotal.toString(),
            'equipage': d['equipage'],
            'captures': captures,
          },
        );
      case TypeSaisie.controle:
        final pdf = d['rapport_pdf_base64'] as String?;
        r = await _pool.execute(
          Sql.named('''
            INSERT INTO controles (id, navire_id, agent, date_controle,
                latitude, longitude, engin, pavillon_conforme,
                marquage_conforme, stockage_conforme, observations,
                nb_infractions, amende_min_mru, amende_max_mru, maillages_mm,
                echantillons, rapport, rapport_pdf, empreinte, envoye_par,
                envoye_par_nom)
            VALUES (@id:uuid, @navire, @agent, @date:timestamptz, @lat, @lon,
                @engin, @pavillon, @marquage, @stockage, @observations, @nb,
                @amende_min, @amende_max, @maillages:jsonb,
                @echantillons:jsonb, @rapport, @pdf:bytea, @empreinte,
                @par:text, @par_nom:text)
            ON CONFLICT (id) DO NOTHING
            RETURNING id'''),
          parameters: {
            ...commun,
            'agent': d['agent'],
            'date': DateTime.parse(d['date']! as String),
            'pavillon': d['pavillon_conforme'],
            'marquage': d['marquage_conforme'],
            'stockage': d['stockage_conforme'],
            'observations': d['observations'],
            'amende_min': (d['amende_min_mru']! as num).toString(),
            'amende_max': (d['amende_max_mru']! as num).toString(),
            'maillages': d['maillages_mm'],
            'echantillons': d['echantillons'],
            'rapport': d['rapport'],
            'pdf': pdf == null ? null : base64Decode(pdf),
          },
        );
    }
    if (r.isNotEmpty) return Enregistrement.cree;

    // Déjà présent : même contenu (renvoi) ou contenu différent (conflit) ?
    final existant = await _pool.execute(
      Sql.named('SELECT empreinte FROM ${type.segment} WHERE id = @id:uuid'),
      parameters: {'id': id},
    );
    return existant.first.first == e
        ? Enregistrement.dejaRecu
        : Enregistrement.conflit;
  }

  @override
  Future<List<ResumeSaisie>> lister(TypeSaisie type, {int limite = 50}) async {
    final colonneDate = switch (type) {
      TypeSaisie.declaration => 'horodatage',
      TypeSaisie.controle => 'date_controle',
    };
    final r = await _pool.execute(
      Sql.named('SELECT id::text, navire_id, $colonneDate, nb_infractions, '
          'recu_le, envoye_par_nom FROM ${type.segment} '
          'ORDER BY recu_le DESC LIMIT @limite'),
      parameters: {'limite': limite},
    );
    return [
      for (final l in r)
        ResumeSaisie(
          id: l[0]! as String,
          navireId: l[1]! as String,
          date: l[2]! as DateTime,
          nbInfractions: l[3]! as int,
          recuLe: l[4]! as DateTime,
          envoyePar: l[5] as String?,
        ),
    ];
  }

  @override
  Future<Uint8List?> rapportPdf(String controleId) async {
    final r = await _pool.execute(
      Sql.named('SELECT rapport_pdf FROM controles WHERE id = @id:uuid'),
      parameters: {'id': controleId},
    );
    if (r.isEmpty || r.first.first == null) return null;
    return Uint8List.fromList(r.first.first! as List<int>);
  }

  @override
  Future<Map<String, int>> compter() async {
    final r = await _pool.execute('SELECT '
        '(SELECT count(*) FROM declarations), (SELECT count(*) FROM controles)');
    return {
      TypeSaisie.declaration.segment: r.first[0]! as int,
      TypeSaisie.controle.segment: r.first[1]! as int,
    };
  }

  @override
  Future<Map<String, Object?>> referentiel() => _pool.runTx((tx) async {
        // Instantané cohérent : version et données lues ensemble.
        final v = await _version(tx);
        final n = await tx.execute('SELECT donnees FROM navires ORDER BY id');
        final l =
            await tx.execute('SELECT donnees FROM licences ORDER BY numero');
        return {
          'version': v,
          'navires': [for (final r in n) r.first],
          'licences': [for (final r in l) r.first],
        };
      },
          settings: TransactionSettings(
              isolationLevel: IsolationLevel.repeatableRead,
              accessMode: AccessMode.readOnly));

  @override
  Future<int> versionReferentiel() => _version(_pool);

  Future<int> _version(Session s) async {
    final r = await s.execute('SELECT greatest('
        '(SELECT coalesce(max(version), 0) FROM navires), '
        '(SELECT coalesce(max(version), 0) FROM licences))::int');
    return r.first.first! as int;
  }

  @override
  Future<EcritureReferentiel> enregistrerNavire(Map<String, Object?> navire,
          {Utilisateur? par}) =>
      _ecrire('''
          INSERT INTO navires (id, immatriculation, donnees, version,
              modifie_par)
          VALUES (@id, @cle, @d:jsonb, nextval('referentiel_version_seq'),
              @par:text)
          ON CONFLICT (id) DO UPDATE SET
              immatriculation = EXCLUDED.immatriculation,
              donnees = EXCLUDED.donnees, version = EXCLUDED.version,
              modifie_le = now(), modifie_par = EXCLUDED.modifie_par
          RETURNING (xmax = 0)''', {
        'id': navire['id'],
        'cle': navire['immatriculation'],
        'd': navire,
        'par': par?.id,
      });

  @override
  Future<EcritureReferentiel> enregistrerLicence(Map<String, Object?> licence,
          {Utilisateur? par}) =>
      _ecrire('''
          INSERT INTO licences (numero, navire_id, donnees, version,
              modifie_par)
          VALUES (@id, @cle, @d:jsonb, nextval('referentiel_version_seq'),
              @par:text)
          ON CONFLICT (numero) DO UPDATE SET
              navire_id = EXCLUDED.navire_id,
              donnees = EXCLUDED.donnees, version = EXCLUDED.version,
              modifie_le = now(), modifie_par = EXCLUDED.modifie_par
          RETURNING (xmax = 0)''', {
        'id': licence['numero'],
        'cle': licence['navire_id'],
        'd': licence,
        'par': par?.id,
      });

  /// `RETURNING (xmax = 0)` : vrai pour une insertion, faux pour une mise
  /// à jour.
  Future<EcritureReferentiel> _ecrire(
      String sql, Map<String, Object?> parametres) async {
    try {
      final r = await _pool.execute(Sql.named(sql), parameters: parametres);
      return r.first.first == true
          ? EcritureReferentiel.cree
          : EcritureReferentiel.modifie;
    } on ServerException catch (e) {
      if (e.code == '23505') {
        return EcritureReferentiel.immatriculationEnDouble; // unique
      }
      if (e.code == '23503') return EcritureReferentiel.navireInconnu;
      rethrow;
    }
  }

  @override
  Future<void> fermer() => _pool.close();
}
