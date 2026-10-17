/// Ports et points de débarquement de Mauritanie, par code.
///
/// ⚠️ Liste d'exemple : à remplacer par la liste officielle (ministère des
/// Pêches). Le code est stocké dans la base et envoyé au serveur ; le nom
/// affiché vient des traductions (`l10n.nomPort(code)`), le nom français
/// ci-dessous sert au rapport officiel.
const portsDebarquement = <String, String>{
  'NDB': 'Nouadhibou',
  'NKC': 'Nouakchott',
  'TAN': 'Tanit',
  'NDG': "N'Diago",
  'MHJ': 'Mhaijratt',
  'IWK': 'Iwik',
};

/// Nom français d'un port (rapport officiel), ou le code s'il est inconnu.
String nomPort(String code) => portsDebarquement[code] ?? code;
