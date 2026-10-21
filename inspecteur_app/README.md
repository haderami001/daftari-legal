# Inspecteur des pêches (prototype Flutter)

Assistant de l'inspecteur des pêches en Mauritanie : une référence de
poche pour les **textes juridiques**, les **règles de calcul** et les
**nouveautés réglementaires** publiées par le ministère des Pêches.

Application séparée de [Pêche Conforme](../peche_app/README.md), mais avec
**le même moteur de calcul** : les règles (modèles, référentiel des seuils,
calcul des infractions et des amendes) sont dans le paquet partagé
[`../peche_regles`](../peche_regles). Une règle changée là l'est dans les
deux applications.

> ⚠️ Les seuils du référentiel (`demo-2026.10`) sont **fictifs** : ils
> doivent être remplacés par les valeurs officielles validées.

## Ce que fait l'application

| Module | État |
|---|---|
| **Calculateurs** : maillage (moyenne, tolérance) et tailles minimales, avec gravité, amende indicative et texte source | ✅ |
| **Bibliothèque juridique** : Code des pêches, décrets, arrêtés, recherche, hors ligne | à venir |
| **Nouveautés réglementaires** : décrets et circulaires du mois, validés avant publication | à venir |

Interface en **français** et en **arabe** (menu 文A sur l'accueil).

## Lancer le projet

```bash
cd inspecteur_app
flutter pub get
flutter run                 # téléphone ou émulateur
flutter run -d chrome       # navigateur
flutter analyze && flutter test
```

Dans VS Code : *Exécuter et déboguer* → « Inspecteur des pêches ».

À chaque modification, GitHub Actions construit l'**APK Android** et la
**version web** : onglet *Actions* → dernière exécution « inspecteur_app »
→ section *Artifacts* (`inspecteur-apk`, `inspecteur-web`).

## Organisation du code

```
lib/
  main.dart                 application, langues, thème
  accueil_screen.dart       accueil et modules
  calculateurs_screen.dart  calculateurs (moteur de peche_regles)
  theme.dart                même identité visuelle que Pêche Conforme
  l10n/                     traductions (app_fr.arb, app_ar.arb)
```
