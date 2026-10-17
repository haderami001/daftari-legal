/// Contenu du QR code d'une licence de pêche.
///
/// Format volontairement simple et lisible, sans réseau :
///
///     PECHE-CONFORME:LICENCE:<numéro>:<navire>
///
/// Le QR ne prouve rien à lui seul : l'agent vérifie toujours la licence
/// dans sa base locale (dates, navire, engins). Il évite seulement de
/// chercher le navire dans une liste et de recopier un numéro.
library;

const _prefixe = 'PECHE-CONFORME:LICENCE:';

/// Texte à encoder dans le QR code de la licence [numero] du navire
/// [navireId].
String contenuQrLicence(String numero, String navireId) =>
    '$_prefixe${Uri.encodeComponent(numero)}:${Uri.encodeComponent(navireId)}';

/// Lit un QR code de licence. Renvoie `null` si ce n'est pas un QR
/// Pêche Conforme.
({String numero, String navireId})? lireQrLicence(String contenu) {
  final texte = contenu.trim();
  if (!texte.startsWith(_prefixe)) return null;
  final parties = texte.substring(_prefixe.length).split(':');
  if (parties.length != 2 || parties.any((p) => p.isEmpty)) return null;
  try {
    return (
      numero: Uri.decodeComponent(parties[0]),
      navireId: Uri.decodeComponent(parties[1]),
    );
  } catch (_) {
    // Encodage % invalide.
    return null;
  }
}
