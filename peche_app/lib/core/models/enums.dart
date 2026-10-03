/// Énumérations métier partagées par toute l'application.
///
/// Astuce Dart : un « enhanced enum » peut porter des champs et un
/// constructeur `const`. Cela évite de disperser des `switch` partout.
library;

/// Segment de pêche.
enum TypePeche {
  artisanale('Pêche artisanale'),
  cotiere('Pêche côtière'),
  hauturiere('Pêche hauturière');

  const TypePeche(this.libelle);
  final String libelle;
}

/// Type de navire (la « plateforme »).
enum TypeNavire {
  pirogue('Pirogue', TypePeche.artisanale),
  chalutier('Chalutier', TypePeche.hauturiere),
  senneur('Senneur', TypePeche.cotiere),
  dragueur('Dragueur', TypePeche.cotiere);

  const TypeNavire(this.libelle, this.segmentParDefaut);
  final String libelle;
  final TypePeche segmentParDefaut;
}

/// Engin de pêche effectivement utilisé (ce qui est contrôlé).
enum TypeEngin {
  ligne('Ligne / palangre'),
  filetMaillant('Filet maillant'),
  casier('Casier / pot à poulpe'),
  chalutDemersal('Chalut de fond'),
  chalutPelagique('Chalut pélagique'),
  senneTournante('Senne tournante'),
  drague('Drague');

  const TypeEngin(this.libelle);
  final String libelle;
}

/// Gravité d'une infraction : détermine la fourchette de sanction.
enum Gravite {
  mineure('Mineure'),
  grave('Grave'),
  tresGrave('Très grave');

  const Gravite(this.libelle);
  final String libelle;
}

enum TypeCertificat {
  navigabilite('Certificat de navigabilité'),
  jaugeage('Certificat de jaugeage'),
  hygiene('Agrément sanitaire'),
  radio('Licence radio / VMS');

  const TypeCertificat(this.libelle);
  final String libelle;
}
