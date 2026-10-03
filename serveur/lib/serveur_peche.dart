/// Serveur central de « Pêche Conforme ».
///
/// Reçoit les déclarations et contrôles envoyés par l'application
/// (`POST /v1/sync/{declarations|controles}/{id}`), les vérifie et les
/// enregistre dans PostgreSQL.
library;

export 'src/api.dart';
export 'src/authentification.dart';
export 'src/stockage.dart';
export 'src/stockage_postgres.dart';
export 'src/validation.dart';
