# Règles de la pêche

Code **Dart pur** (sans Flutter) utilisé par [Pêche Conforme](../peche_app/README.md) :
modèles, référentiel des seuils et moteur de calcul. Séparé de l'application
pour pouvoir être testé seul et réutilisé (serveur, autres applications).

L'application **Inspecteur des pêches** (dépôt `inspecteur`) en contient une
**copie** : une règle modifiée ici doit y être recopiée.

Contenu :

| Fichier | Rôle |
|---|---|
| `enums.dart`, `navire.dart`, `declaration.dart`, `ports.dart` | modèles (navires, licences, déclarations, contrôles) |
| `referentiel.dart` | seuils réglementaires (tailles, maillages, quotas, barème) |
| `calcul_reglementaire.dart` | moteur de calcul : infractions, gravité, amendes |
| `format.dart` | affichage des montants et des textes gauche-droite |

Pêche Conforme l'utilise avec :

```yaml
dependencies:
  peche_regles:
    path: ../peche_regles
```

Les tests du moteur sont dans `peche_app/test/calcul_reglementaire_test.dart`
(ils utilisent la flotte de démonstration de Pêche Conforme).
