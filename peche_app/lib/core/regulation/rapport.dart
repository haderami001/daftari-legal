import '../format.dart';
import '../models/declaration.dart';
import 'calcul_reglementaire.dart';

/// Génère le texte du rapport d'inspection automatique : affiché à l'agent
/// avant signature et stocké avec le contrôle. La version PDF signée est
/// produite par `genererRapportPdf` (rapport_pdf.dart).
String genererRapportControle(Controle c, ResultatVerification r) {
  final b = StringBuffer()
    ..writeln('RAPPORT D\'INSPECTION EN MER')
    ..writeln('Date      : ${c.date.toIso8601String().substring(0, 16)}')
    ..writeln('Agent     : ${c.agent}')
    ..writeln('Position  : ${c.position}')
    ..writeln('Navire    : ${c.navire.nom} (${c.navire.immatriculation})')
    ..writeln('Pavillon  : ${c.navire.pavillon} — ${c.navire.type.libelle}')
    ..writeln('Engin     : ${c.engin.libelle}')
    ..writeln('Mesures maillage (mm) : '
        '${c.maillagesMm.isEmpty ? '—' : c.maillagesMm.join(', ')}')
    ..writeln('Échantillons mesurés  : ${c.echantillons.length}')
    ..writeln();
  if (r.conforme) {
    b.writeln('RÉSULTAT : CONFORME — aucune infraction constatée.');
  } else {
    b.writeln('RÉSULTAT : ${r.infractions.length} INFRACTION(S)');
    for (final i in r.infractions) {
      b.writeln(' • $i');
    }
    b
      ..writeln()
      ..writeln('Amende indicative : ${formaterMontant(r.amendeMin)} à '
          '${formaterMontant(r.amendeMax)} MRU')
      ..writeln('(montant définitif fixé par l\'autorité compétente)');
  }
  if (c.observations.isNotEmpty) {
    b
      ..writeln()
      ..writeln('Observations : ${c.observations}');
  }
  return b.toString();
}
