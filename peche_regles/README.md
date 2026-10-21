# Règles de la pêche (paquet partagé)

Code **Dart pur** (sans Flutter) partagé par les applications du dépôt :

- [Pêche Conforme](../peche_app/README.md) : déclarations et contrôles ;
- [Inspecteur des pêches](../inspecteur_app/README.md) : assistant de
  l'inspecteur.

Contenu :

| Fichier | Rôle |
|---|---|
| `enums.dart`, `navire.dart`, `declaration.dart`, `ports.dart` | modèles (navires, licences, déclarations, contrôles) |
| `referentiel.dart` | seuils réglementaires (tailles, maillages, quotas, barème) |
| `calcul_reglementaire.dart` | moteur de calcul : infractions, gravité, amendes |
| `format.dart` | affichage des montants et des textes gauche-droite |

Les deux applications l'utilisent avec :

```yaml
dependencies:
  peche_regles:
    path: ../peche_regles
```

Les tests du moteur sont dans `peche_app/test/calcul_reglementaire_test.dart`
(ils utilisent la flotte de démonstration de Pêche Conforme).
