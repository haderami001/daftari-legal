import 'dart:convert';

import 'package:drift/drift.dart';

import '../../models/enums.dart';

/// Tables SQLite de la base locale (hors ligne).
///
/// Avec Drift, chaque classe qui hérite de `Table` décrit une table SQL :
/// chaque getter est une colonne. Le code SQL et les classes de lignes
/// (ex. `NavireLigne`) sont générés dans `base_de_donnees.g.dart` par :
///
///     dart run build_runner build --delete-conflicting-outputs
///
/// Les enums sont stockés par leur nom (`textEnum`) : ne pas renommer une
/// valeur d'enum sans prévoir une migration.

// ---------------------------------------------------------------------------
// Référentiel téléchargé (navires, certificats, licences, quotas)
// ---------------------------------------------------------------------------

@DataClassName('NavireLigne')
class Navires extends Table {
  TextColumn get id => text()();
  TextColumn get nom => text()();
  TextColumn get immatriculation => text().unique()();
  TextColumn get pavillon => text().withLength(min: 3, max: 3)();
  TextColumn get type => textEnum<TypeNavire>()();
  RealColumn get longueurM => real()();
  RealColumn get puissanceKw => real()();
  TextColumn get numeroImo => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('CertificatLigne')
class Certificats extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get navireId =>
      text().references(Navires, #id, onDelete: KeyAction.cascade)();
  TextColumn get type => textEnum<TypeCertificat>()();
  TextColumn get numero => text()();
  DateTimeColumn get dateExpiration => dateTime()();
}

@DataClassName('LicenceLigne')
class Licences extends Table {
  TextColumn get numero => text()();
  TextColumn get navireId => text().references(Navires, #id)();
  TextColumn get segment => textEnum<TypePeche>()();
  TextColumn get enginsAutorises => text().map(const EnginsConverter())();
  TextColumn get especesCibles => text().map(const CodesConverter())();
  DateTimeColumn get dateDebut => dateTime()();
  DateTimeColumn get dateFin => dateTime()();

  @override
  Set<Column> get primaryKey => {numero};
}

@DataClassName('QuotaLigne')
class Quotas extends Table {
  TextColumn get licenceNumero =>
      text().references(Licences, #numero, onDelete: KeyAction.cascade)();
  TextColumn get especeCode => text().withLength(min: 3, max: 3)();
  RealColumn get quotaKg => real()();

  @override
  Set<Column> get primaryKey => {licenceNumero, especeCode};
}

// ---------------------------------------------------------------------------
// Saisies faites sur le téléphone (déclarations, contrôles)
// ---------------------------------------------------------------------------

/// Les identifiants sont des UUID créés sur le téléphone : la même
/// saisie renvoyée deux fois au serveur ne crée pas de doublon.
@DataClassName('DeclarationLigne')
class Declarations extends Table {
  TextColumn get id => text()();
  TextColumn get navireId => text().references(Navires, #id)();
  TextColumn get licenceNumero => text().references(Licences, #numero)();
  TextColumn get engin => textEnum<TypeEngin>()();
  RealColumn get latitude => real()();
  RealColumn get longitude => real()();
  DateTimeColumn get horodatage => dateTime()();
  IntColumn get nbInfractions => integer().withDefault(const Constant(0))();
  DateTimeColumn get creeLe => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('MembreEquipageLigne')
class Equipages extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get declarationId =>
      text().references(Declarations, #id, onDelete: KeyAction.cascade)();
  TextColumn get nom => text()();
  TextColumn get fonction => text()();
  TextColumn get nationalite => text()();
}

@DataClassName('CaptureLigne')
class Captures extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get declarationId =>
      text().references(Declarations, #id, onDelete: KeyAction.cascade)();
  TextColumn get especeCode => text().withLength(min: 3, max: 3)();
  RealColumn get poidsKg => real()();
}

@DataClassName('ControleLigne')
class Controles extends Table {
  TextColumn get id => text()();
  TextColumn get navireId => text().references(Navires, #id)();
  TextColumn get agent => text()();
  DateTimeColumn get date => dateTime()();
  RealColumn get latitude => real()();
  RealColumn get longitude => real()();
  TextColumn get engin => textEnum<TypeEngin>()();
  BoolColumn get pavillonConforme => boolean()();
  BoolColumn get marquageConforme => boolean()();
  BoolColumn get planStockageConforme => boolean()();
  TextColumn get observations => text().withDefault(const Constant(''))();
  IntColumn get nbInfractions => integer()();
  RealColumn get amendeMin => real()();
  RealColumn get amendeMax => real()();

  /// Texte du rapport tel que signé par l'agent (valeur probante).
  TextColumn get rapport => text()();
  DateTimeColumn get creeLe => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('MaillageLigne')
class ControleMaillages extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get controleId =>
      text().references(Controles, #id, onDelete: KeyAction.cascade)();
  RealColumn get mesureMm => real()();
}

@DataClassName('EchantillonLigne')
class ControleEchantillons extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get controleId =>
      text().references(Controles, #id, onDelete: KeyAction.cascade)();
  TextColumn get especeCode => text().withLength(min: 3, max: 3)();
  RealColumn get valeur => real()();
}

// ---------------------------------------------------------------------------
// File d'envoi (« outbox ») : ce qui reste à transmettre au serveur
// ---------------------------------------------------------------------------

enum TypeEnvoi { declaration, controle }

@DataClassName('EnvoiLigne')
class FileEnvois extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get type => textEnum<TypeEnvoi>()();
  TextColumn get entiteId => text()();

  /// Résumé lisible affiché dans l'écran « Envois en attente ».
  TextColumn get resume => text()();
  DateTimeColumn get creeLe => dateTime().withDefault(currentDateAndTime)();
  IntColumn get tentatives => integer().withDefault(const Constant(0))();
  TextColumn get derniereErreur => text().nullable()();

  /// NULL tant que le serveur n'a pas confirmé la réception.
  DateTimeColumn get envoyeLe => dateTime().nullable()();
}

// ---------------------------------------------------------------------------
// Convertisseurs : un ensemble de valeurs stocké en JSON dans une colonne
// ---------------------------------------------------------------------------

class EnginsConverter extends TypeConverter<Set<TypeEngin>, String> {
  const EnginsConverter();

  @override
  Set<TypeEngin> fromSql(String fromDb) => {
        for (final nom in jsonDecode(fromDb) as List)
          TypeEngin.values.byName(nom as String),
      };

  @override
  String toSql(Set<TypeEngin> value) =>
      jsonEncode([for (final e in value) e.name]);
}

class CodesConverter extends TypeConverter<Set<String>, String> {
  const CodesConverter();

  @override
  Set<String> fromSql(String fromDb) =>
      (jsonDecode(fromDb) as List).cast<String>().toSet();

  @override
  String toSql(Set<String> value) => jsonEncode(value.toList());
}
