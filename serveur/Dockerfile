# Image du serveur central « Pêche Conforme ».
# Construction : docker build -t peche-serveur serveur/
FROM dart:3.5 AS construction
WORKDIR /app
COPY pubspec.yaml pubspec.lock ./
RUN dart pub get
COPY . .
RUN dart compile exe bin/serveur.dart -o /app/serveur

# Image finale minimale : le programme compilé seul (pas de SDK Dart).
FROM scratch
COPY --from=construction /runtime/ /
COPY --from=construction /app/serveur /app/serveur
EXPOSE 8080
USER 65534
ENTRYPOINT ["/app/serveur"]
