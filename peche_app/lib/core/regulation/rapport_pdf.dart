import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../format.dart';
import '../models/declaration.dart';
import '../models/navire.dart';
import 'calcul_reglementaire.dart';
import 'referentiel.dart';

/// Génère le rapport d'inspection au format PDF (A4).
///
/// Le package `pdf` est en Dart pur : la génération fonctionne sans réseau,
/// sur téléphone comme dans les tests. Le document produit au moment de la
/// signature est stocké tel quel dans la base locale (valeur probante).
///
/// Les polices standard du PDF (Helvetica) couvrent les accents français
/// mais pas les tirets longs (— –) : [_texte] les remplace. Pour l'arabe il
/// faudra embarquer une police (ex. Noto Naskh Arabic).
Future<Uint8List> genererRapportPdf(
  Controle c,
  ResultatVerification r, {
  Licence? licence,
  String? identifiant,
  Referentiel ref = referentielDemo,
}) {
  final doc = pw.Document(
    title: 'Rapport d\'inspection - ${c.navire.nom}',
    author: c.agent,
    creator: 'Pêche Conforme',
  );
  const bleu = PdfColor.fromInt(0xFF0B5E8A);
  final date = _date(c.date);
  final regleEngin = ref.engin(c.engin);

  doc.addPage(pw.MultiPage(
    pageFormat: PdfPageFormat.a4,
    margin: const pw.EdgeInsets.all(32),
    header: (ctx) => pw.Container(
      padding: const pw.EdgeInsets.only(bottom: 8),
      decoration: const pw.BoxDecoration(
          border: pw.Border(bottom: pw.BorderSide(color: bleu, width: 2))),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text('RAPPORT D\'INSPECTION EN MER',
              style: pw.TextStyle(
                  fontSize: 16, fontWeight: pw.FontWeight.bold, color: bleu)),
          pw.Text(date, style: const pw.TextStyle(fontSize: 10)),
        ],
      ),
    ),
    footer: (ctx) => pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(
          'Référentiel ${ref.version}'
          '${identifiant == null ? '' : ' · n° $identifiant'}',
          style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey700),
        ),
        pw.Text('Page ${ctx.pageNumber}/${ctx.pagesCount}',
            style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey700)),
      ],
    ),
    build: (ctx) => [
      _titre('1. Identification', bleu),
      _tableauCleValeur({
        'Navire': '${c.navire.nom} (${c.navire.type.libelle})',
        'Immatriculation': c.navire.immatriculation,
        if (c.navire.numeroImo != null) 'N° IMO': c.navire.numeroImo!,
        'Pavillon': c.navire.pavillon,
        'Dimensions': '${c.navire.longueurM} m · ${c.navire.puissanceKw} kW',
        if (licence != null)
          'Licence': '${licence.numero} (${licence.segment.libelle})',
        'Position': c.position.toString(),
        'Agent': c.agent,
      }),
      _titre('2. Constatations', bleu),
      _tableauCleValeur({
        'Pavillon / documents': _ouiNon(c.pavillonConforme),
        'Marquage extérieur': _ouiNon(c.marquageConforme),
        'Plan de stockage': _ouiNon(c.planStockageConforme),
        for (final cert in c.navire.certificats)
          cert.type.libelle: '${cert.numero}, expire le '
              '${_date(cert.dateExpiration).substring(0, 10)}'
              '${cert.estValideLe(c.date) ? '' : ' (EXPIRÉ)'}',
      }),
      _titre('3. Engin et maillage', bleu),
      _tableauCleValeur({
        'Engin': c.engin.libelle,
        if (regleEngin != null && regleEngin.maillageMinMm > 0)
          'Maillage minimal':
              '${regleEngin.maillageMinMm.toStringAsFixed(0)} mm '
                  '(tolérance ${ref.toleranceMaillagePct.toStringAsFixed(0)} %)',
        'Mesures (mm)': c.maillagesMm.isEmpty
            ? 'aucune'
            : c.maillagesMm.map((m) => m.toStringAsFixed(1)).join(' · '),
      }),
      if (c.echantillons.isNotEmpty) ...[
        _titre('4. Échantillons', bleu),
        pw.TableHelper.fromTextArray(
          headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
          headerDecoration: const pw.BoxDecoration(color: PdfColors.grey200),
          cellStyle: const pw.TextStyle(fontSize: 10),
          headers: ['Espèce', 'Mesure', 'Minimum', 'Conforme'],
          data: [
            for (final e in c.echantillons)
              if (ref.espece(e.especeCode) case final regle?)
                [
                  '${regle.nomCommun} (${regle.code})',
                  '${e.valeur.toStringAsFixed(1)} ${regle.unite.symbole}',
                  '${regle.minimum.toStringAsFixed(0)} ${regle.unite.symbole}',
                  e.valeur >= regle.minimum ? 'oui' : 'NON',
                ]
              else
                [e.especeCode, e.valeur.toStringAsFixed(1), '-', '-'],
          ],
        ),
      ],
      _titre('Résultat', bleu),
      if (r.conforme)
        pw.Text('CONFORME : aucune infraction constatée.',
            style: pw.TextStyle(
                fontWeight: pw.FontWeight.bold, color: PdfColors.green800))
      else ...[
        pw.TableHelper.fromTextArray(
          headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
          headerDecoration: const pw.BoxDecoration(color: PdfColors.grey200),
          cellStyle: const pw.TextStyle(fontSize: 10),
          columnWidths: {
            0: const pw.FixedColumnWidth(70),
            1: const pw.FlexColumnWidth(),
          },
          headers: ['Gravité', 'Infraction'],
          data: [
            for (final i in r.infractions)
              [i.gravite.libelle, _texte(i.message)],
          ],
        ),
        pw.SizedBox(height: 8),
        pw.Text(
          'Amende indicative : ${formaterMontant(r.amendeMin)} à ${formaterMontant(r.amendeMax)} MRU',
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
        ),
        pw.Text('Montant définitif fixé par l\'autorité compétente.',
            style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey700)),
      ],
      if (c.observations.isNotEmpty) ...[
        _titre('Observations', bleu),
        pw.Text(_texte(c.observations)),
      ],
      pw.SizedBox(height: 16),
      pw.Row(children: [
        pw.Expanded(child: _signature('Signature de l\'agent', c.agent)),
        pw.SizedBox(width: 16),
        pw.Expanded(child: _signature('Signature du capitaine', '')),
      ]),
    ],
  ));
  return doc.save();
}

pw.Widget _titre(String texte, PdfColor couleur) => pw.Padding(
      padding: const pw.EdgeInsets.only(top: 10, bottom: 4),
      child: pw.Text(texte,
          style: pw.TextStyle(
              fontSize: 12, fontWeight: pw.FontWeight.bold, color: couleur)),
    );

pw.Widget _tableauCleValeur(Map<String, String> lignes) => pw.Table(
      columnWidths: {
        0: const pw.FixedColumnWidth(140),
        1: const pw.FlexColumnWidth(),
      },
      children: [
        for (final MapEntry(:key, :value) in lignes.entries)
          pw.TableRow(children: [
            pw.Padding(
              padding: const pw.EdgeInsets.symmetric(vertical: 2),
              child: pw.Text(key,
                  style: pw.TextStyle(
                      fontSize: 10, fontWeight: pw.FontWeight.bold)),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.symmetric(vertical: 2),
              child: pw.Text(value, style: const pw.TextStyle(fontSize: 10)),
            ),
          ]),
      ],
    );

pw.Widget _signature(String titre, String nom) => pw.Container(
      height: 56,
      padding: const pw.EdgeInsets.all(6),
      decoration: pw.BoxDecoration(border: pw.Border.all(width: 0.5)),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(titre, style: const pw.TextStyle(fontSize: 9)),
          pw.Text(nom, style: const pw.TextStyle(fontSize: 9)),
        ],
      ),
    );

/// Remplace les caractères absents des polices standard du PDF.
String _texte(String s) => s.replaceAll(RegExp('[–—]'), '-');

String _ouiNon(bool conforme) => conforme ? 'Conforme' : 'NON CONFORME';

String _date(DateTime d) =>
    d.toIso8601String().substring(0, 16).replaceFirst('T', ' ');
