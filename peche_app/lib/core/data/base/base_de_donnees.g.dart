// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'base_de_donnees.dart';

// ignore_for_file: type=lint
class $NaviresTable extends Navires with TableInfo<$NaviresTable, NavireLigne> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NaviresTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nomMeta = const VerificationMeta('nom');
  @override
  late final GeneratedColumn<String> nom = GeneratedColumn<String>(
      'nom', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _immatriculationMeta =
      const VerificationMeta('immatriculation');
  @override
  late final GeneratedColumn<String> immatriculation = GeneratedColumn<String>(
      'immatriculation', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _pavillonMeta =
      const VerificationMeta('pavillon');
  @override
  late final GeneratedColumn<String> pavillon = GeneratedColumn<String>(
      'pavillon', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 3, maxTextLength: 3),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumnWithTypeConverter<TypeNavire, String> type =
      GeneratedColumn<String>('type', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<TypeNavire>($NaviresTable.$convertertype);
  static const VerificationMeta _longueurMMeta =
      const VerificationMeta('longueurM');
  @override
  late final GeneratedColumn<double> longueurM = GeneratedColumn<double>(
      'longueur_m', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _puissanceKwMeta =
      const VerificationMeta('puissanceKw');
  @override
  late final GeneratedColumn<double> puissanceKw = GeneratedColumn<double>(
      'puissance_kw', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _numeroImoMeta =
      const VerificationMeta('numeroImo');
  @override
  late final GeneratedColumn<String> numeroImo = GeneratedColumn<String>(
      'numero_imo', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        nom,
        immatriculation,
        pavillon,
        type,
        longueurM,
        puissanceKw,
        numeroImo
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'navires';
  @override
  VerificationContext validateIntegrity(Insertable<NavireLigne> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('nom')) {
      context.handle(
          _nomMeta, nom.isAcceptableOrUnknown(data['nom']!, _nomMeta));
    } else if (isInserting) {
      context.missing(_nomMeta);
    }
    if (data.containsKey('immatriculation')) {
      context.handle(
          _immatriculationMeta,
          immatriculation.isAcceptableOrUnknown(
              data['immatriculation']!, _immatriculationMeta));
    } else if (isInserting) {
      context.missing(_immatriculationMeta);
    }
    if (data.containsKey('pavillon')) {
      context.handle(_pavillonMeta,
          pavillon.isAcceptableOrUnknown(data['pavillon']!, _pavillonMeta));
    } else if (isInserting) {
      context.missing(_pavillonMeta);
    }
    context.handle(_typeMeta, const VerificationResult.success());
    if (data.containsKey('longueur_m')) {
      context.handle(_longueurMMeta,
          longueurM.isAcceptableOrUnknown(data['longueur_m']!, _longueurMMeta));
    } else if (isInserting) {
      context.missing(_longueurMMeta);
    }
    if (data.containsKey('puissance_kw')) {
      context.handle(
          _puissanceKwMeta,
          puissanceKw.isAcceptableOrUnknown(
              data['puissance_kw']!, _puissanceKwMeta));
    } else if (isInserting) {
      context.missing(_puissanceKwMeta);
    }
    if (data.containsKey('numero_imo')) {
      context.handle(_numeroImoMeta,
          numeroImo.isAcceptableOrUnknown(data['numero_imo']!, _numeroImoMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  NavireLigne map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return NavireLigne(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      nom: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}nom'])!,
      immatriculation: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}immatriculation'])!,
      pavillon: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}pavillon'])!,
      type: $NaviresTable.$convertertype.fromSql(attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!),
      longueurM: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}longueur_m'])!,
      puissanceKw: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}puissance_kw'])!,
      numeroImo: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}numero_imo']),
    );
  }

  @override
  $NaviresTable createAlias(String alias) {
    return $NaviresTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<TypeNavire, String, String> $convertertype =
      const EnumNameConverter<TypeNavire>(TypeNavire.values);
}

class NavireLigne extends DataClass implements Insertable<NavireLigne> {
  final String id;
  final String nom;
  final String immatriculation;
  final String pavillon;
  final TypeNavire type;
  final double longueurM;
  final double puissanceKw;
  final String? numeroImo;
  const NavireLigne(
      {required this.id,
      required this.nom,
      required this.immatriculation,
      required this.pavillon,
      required this.type,
      required this.longueurM,
      required this.puissanceKw,
      this.numeroImo});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['nom'] = Variable<String>(nom);
    map['immatriculation'] = Variable<String>(immatriculation);
    map['pavillon'] = Variable<String>(pavillon);
    {
      map['type'] = Variable<String>($NaviresTable.$convertertype.toSql(type));
    }
    map['longueur_m'] = Variable<double>(longueurM);
    map['puissance_kw'] = Variable<double>(puissanceKw);
    if (!nullToAbsent || numeroImo != null) {
      map['numero_imo'] = Variable<String>(numeroImo);
    }
    return map;
  }

  NaviresCompanion toCompanion(bool nullToAbsent) {
    return NaviresCompanion(
      id: Value(id),
      nom: Value(nom),
      immatriculation: Value(immatriculation),
      pavillon: Value(pavillon),
      type: Value(type),
      longueurM: Value(longueurM),
      puissanceKw: Value(puissanceKw),
      numeroImo: numeroImo == null && nullToAbsent
          ? const Value.absent()
          : Value(numeroImo),
    );
  }

  factory NavireLigne.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return NavireLigne(
      id: serializer.fromJson<String>(json['id']),
      nom: serializer.fromJson<String>(json['nom']),
      immatriculation: serializer.fromJson<String>(json['immatriculation']),
      pavillon: serializer.fromJson<String>(json['pavillon']),
      type: $NaviresTable.$convertertype
          .fromJson(serializer.fromJson<String>(json['type'])),
      longueurM: serializer.fromJson<double>(json['longueurM']),
      puissanceKw: serializer.fromJson<double>(json['puissanceKw']),
      numeroImo: serializer.fromJson<String?>(json['numeroImo']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'nom': serializer.toJson<String>(nom),
      'immatriculation': serializer.toJson<String>(immatriculation),
      'pavillon': serializer.toJson<String>(pavillon),
      'type':
          serializer.toJson<String>($NaviresTable.$convertertype.toJson(type)),
      'longueurM': serializer.toJson<double>(longueurM),
      'puissanceKw': serializer.toJson<double>(puissanceKw),
      'numeroImo': serializer.toJson<String?>(numeroImo),
    };
  }

  NavireLigne copyWith(
          {String? id,
          String? nom,
          String? immatriculation,
          String? pavillon,
          TypeNavire? type,
          double? longueurM,
          double? puissanceKw,
          Value<String?> numeroImo = const Value.absent()}) =>
      NavireLigne(
        id: id ?? this.id,
        nom: nom ?? this.nom,
        immatriculation: immatriculation ?? this.immatriculation,
        pavillon: pavillon ?? this.pavillon,
        type: type ?? this.type,
        longueurM: longueurM ?? this.longueurM,
        puissanceKw: puissanceKw ?? this.puissanceKw,
        numeroImo: numeroImo.present ? numeroImo.value : this.numeroImo,
      );
  NavireLigne copyWithCompanion(NaviresCompanion data) {
    return NavireLigne(
      id: data.id.present ? data.id.value : this.id,
      nom: data.nom.present ? data.nom.value : this.nom,
      immatriculation: data.immatriculation.present
          ? data.immatriculation.value
          : this.immatriculation,
      pavillon: data.pavillon.present ? data.pavillon.value : this.pavillon,
      type: data.type.present ? data.type.value : this.type,
      longueurM: data.longueurM.present ? data.longueurM.value : this.longueurM,
      puissanceKw:
          data.puissanceKw.present ? data.puissanceKw.value : this.puissanceKw,
      numeroImo: data.numeroImo.present ? data.numeroImo.value : this.numeroImo,
    );
  }

  @override
  String toString() {
    return (StringBuffer('NavireLigne(')
          ..write('id: $id, ')
          ..write('nom: $nom, ')
          ..write('immatriculation: $immatriculation, ')
          ..write('pavillon: $pavillon, ')
          ..write('type: $type, ')
          ..write('longueurM: $longueurM, ')
          ..write('puissanceKw: $puissanceKw, ')
          ..write('numeroImo: $numeroImo')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, nom, immatriculation, pavillon, type,
      longueurM, puissanceKw, numeroImo);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NavireLigne &&
          other.id == this.id &&
          other.nom == this.nom &&
          other.immatriculation == this.immatriculation &&
          other.pavillon == this.pavillon &&
          other.type == this.type &&
          other.longueurM == this.longueurM &&
          other.puissanceKw == this.puissanceKw &&
          other.numeroImo == this.numeroImo);
}

class NaviresCompanion extends UpdateCompanion<NavireLigne> {
  final Value<String> id;
  final Value<String> nom;
  final Value<String> immatriculation;
  final Value<String> pavillon;
  final Value<TypeNavire> type;
  final Value<double> longueurM;
  final Value<double> puissanceKw;
  final Value<String?> numeroImo;
  final Value<int> rowid;
  const NaviresCompanion({
    this.id = const Value.absent(),
    this.nom = const Value.absent(),
    this.immatriculation = const Value.absent(),
    this.pavillon = const Value.absent(),
    this.type = const Value.absent(),
    this.longueurM = const Value.absent(),
    this.puissanceKw = const Value.absent(),
    this.numeroImo = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  NaviresCompanion.insert({
    required String id,
    required String nom,
    required String immatriculation,
    required String pavillon,
    required TypeNavire type,
    required double longueurM,
    required double puissanceKw,
    this.numeroImo = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        nom = Value(nom),
        immatriculation = Value(immatriculation),
        pavillon = Value(pavillon),
        type = Value(type),
        longueurM = Value(longueurM),
        puissanceKw = Value(puissanceKw);
  static Insertable<NavireLigne> custom({
    Expression<String>? id,
    Expression<String>? nom,
    Expression<String>? immatriculation,
    Expression<String>? pavillon,
    Expression<String>? type,
    Expression<double>? longueurM,
    Expression<double>? puissanceKw,
    Expression<String>? numeroImo,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nom != null) 'nom': nom,
      if (immatriculation != null) 'immatriculation': immatriculation,
      if (pavillon != null) 'pavillon': pavillon,
      if (type != null) 'type': type,
      if (longueurM != null) 'longueur_m': longueurM,
      if (puissanceKw != null) 'puissance_kw': puissanceKw,
      if (numeroImo != null) 'numero_imo': numeroImo,
      if (rowid != null) 'rowid': rowid,
    });
  }

  NaviresCompanion copyWith(
      {Value<String>? id,
      Value<String>? nom,
      Value<String>? immatriculation,
      Value<String>? pavillon,
      Value<TypeNavire>? type,
      Value<double>? longueurM,
      Value<double>? puissanceKw,
      Value<String?>? numeroImo,
      Value<int>? rowid}) {
    return NaviresCompanion(
      id: id ?? this.id,
      nom: nom ?? this.nom,
      immatriculation: immatriculation ?? this.immatriculation,
      pavillon: pavillon ?? this.pavillon,
      type: type ?? this.type,
      longueurM: longueurM ?? this.longueurM,
      puissanceKw: puissanceKw ?? this.puissanceKw,
      numeroImo: numeroImo ?? this.numeroImo,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (nom.present) {
      map['nom'] = Variable<String>(nom.value);
    }
    if (immatriculation.present) {
      map['immatriculation'] = Variable<String>(immatriculation.value);
    }
    if (pavillon.present) {
      map['pavillon'] = Variable<String>(pavillon.value);
    }
    if (type.present) {
      map['type'] =
          Variable<String>($NaviresTable.$convertertype.toSql(type.value));
    }
    if (longueurM.present) {
      map['longueur_m'] = Variable<double>(longueurM.value);
    }
    if (puissanceKw.present) {
      map['puissance_kw'] = Variable<double>(puissanceKw.value);
    }
    if (numeroImo.present) {
      map['numero_imo'] = Variable<String>(numeroImo.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NaviresCompanion(')
          ..write('id: $id, ')
          ..write('nom: $nom, ')
          ..write('immatriculation: $immatriculation, ')
          ..write('pavillon: $pavillon, ')
          ..write('type: $type, ')
          ..write('longueurM: $longueurM, ')
          ..write('puissanceKw: $puissanceKw, ')
          ..write('numeroImo: $numeroImo, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CertificatsTable extends Certificats
    with TableInfo<$CertificatsTable, CertificatLigne> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CertificatsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _navireIdMeta =
      const VerificationMeta('navireId');
  @override
  late final GeneratedColumn<String> navireId = GeneratedColumn<String>(
      'navire_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES navires (id) ON DELETE CASCADE'));
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumnWithTypeConverter<TypeCertificat, String> type =
      GeneratedColumn<String>('type', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<TypeCertificat>($CertificatsTable.$convertertype);
  static const VerificationMeta _numeroMeta = const VerificationMeta('numero');
  @override
  late final GeneratedColumn<String> numero = GeneratedColumn<String>(
      'numero', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _dateExpirationMeta =
      const VerificationMeta('dateExpiration');
  @override
  late final GeneratedColumn<DateTime> dateExpiration =
      GeneratedColumn<DateTime>('date_expiration', aliasedName, false,
          type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, navireId, type, numero, dateExpiration];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'certificats';
  @override
  VerificationContext validateIntegrity(Insertable<CertificatLigne> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('navire_id')) {
      context.handle(_navireIdMeta,
          navireId.isAcceptableOrUnknown(data['navire_id']!, _navireIdMeta));
    } else if (isInserting) {
      context.missing(_navireIdMeta);
    }
    context.handle(_typeMeta, const VerificationResult.success());
    if (data.containsKey('numero')) {
      context.handle(_numeroMeta,
          numero.isAcceptableOrUnknown(data['numero']!, _numeroMeta));
    } else if (isInserting) {
      context.missing(_numeroMeta);
    }
    if (data.containsKey('date_expiration')) {
      context.handle(
          _dateExpirationMeta,
          dateExpiration.isAcceptableOrUnknown(
              data['date_expiration']!, _dateExpirationMeta));
    } else if (isInserting) {
      context.missing(_dateExpirationMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CertificatLigne map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CertificatLigne(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      navireId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}navire_id'])!,
      type: $CertificatsTable.$convertertype.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!),
      numero: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}numero'])!,
      dateExpiration: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}date_expiration'])!,
    );
  }

  @override
  $CertificatsTable createAlias(String alias) {
    return $CertificatsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<TypeCertificat, String, String> $convertertype =
      const EnumNameConverter<TypeCertificat>(TypeCertificat.values);
}

class CertificatLigne extends DataClass implements Insertable<CertificatLigne> {
  final int id;
  final String navireId;
  final TypeCertificat type;
  final String numero;
  final DateTime dateExpiration;
  const CertificatLigne(
      {required this.id,
      required this.navireId,
      required this.type,
      required this.numero,
      required this.dateExpiration});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['navire_id'] = Variable<String>(navireId);
    {
      map['type'] =
          Variable<String>($CertificatsTable.$convertertype.toSql(type));
    }
    map['numero'] = Variable<String>(numero);
    map['date_expiration'] = Variable<DateTime>(dateExpiration);
    return map;
  }

  CertificatsCompanion toCompanion(bool nullToAbsent) {
    return CertificatsCompanion(
      id: Value(id),
      navireId: Value(navireId),
      type: Value(type),
      numero: Value(numero),
      dateExpiration: Value(dateExpiration),
    );
  }

  factory CertificatLigne.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CertificatLigne(
      id: serializer.fromJson<int>(json['id']),
      navireId: serializer.fromJson<String>(json['navireId']),
      type: $CertificatsTable.$convertertype
          .fromJson(serializer.fromJson<String>(json['type'])),
      numero: serializer.fromJson<String>(json['numero']),
      dateExpiration: serializer.fromJson<DateTime>(json['dateExpiration']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'navireId': serializer.toJson<String>(navireId),
      'type': serializer
          .toJson<String>($CertificatsTable.$convertertype.toJson(type)),
      'numero': serializer.toJson<String>(numero),
      'dateExpiration': serializer.toJson<DateTime>(dateExpiration),
    };
  }

  CertificatLigne copyWith(
          {int? id,
          String? navireId,
          TypeCertificat? type,
          String? numero,
          DateTime? dateExpiration}) =>
      CertificatLigne(
        id: id ?? this.id,
        navireId: navireId ?? this.navireId,
        type: type ?? this.type,
        numero: numero ?? this.numero,
        dateExpiration: dateExpiration ?? this.dateExpiration,
      );
  CertificatLigne copyWithCompanion(CertificatsCompanion data) {
    return CertificatLigne(
      id: data.id.present ? data.id.value : this.id,
      navireId: data.navireId.present ? data.navireId.value : this.navireId,
      type: data.type.present ? data.type.value : this.type,
      numero: data.numero.present ? data.numero.value : this.numero,
      dateExpiration: data.dateExpiration.present
          ? data.dateExpiration.value
          : this.dateExpiration,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CertificatLigne(')
          ..write('id: $id, ')
          ..write('navireId: $navireId, ')
          ..write('type: $type, ')
          ..write('numero: $numero, ')
          ..write('dateExpiration: $dateExpiration')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, navireId, type, numero, dateExpiration);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CertificatLigne &&
          other.id == this.id &&
          other.navireId == this.navireId &&
          other.type == this.type &&
          other.numero == this.numero &&
          other.dateExpiration == this.dateExpiration);
}

class CertificatsCompanion extends UpdateCompanion<CertificatLigne> {
  final Value<int> id;
  final Value<String> navireId;
  final Value<TypeCertificat> type;
  final Value<String> numero;
  final Value<DateTime> dateExpiration;
  const CertificatsCompanion({
    this.id = const Value.absent(),
    this.navireId = const Value.absent(),
    this.type = const Value.absent(),
    this.numero = const Value.absent(),
    this.dateExpiration = const Value.absent(),
  });
  CertificatsCompanion.insert({
    this.id = const Value.absent(),
    required String navireId,
    required TypeCertificat type,
    required String numero,
    required DateTime dateExpiration,
  })  : navireId = Value(navireId),
        type = Value(type),
        numero = Value(numero),
        dateExpiration = Value(dateExpiration);
  static Insertable<CertificatLigne> custom({
    Expression<int>? id,
    Expression<String>? navireId,
    Expression<String>? type,
    Expression<String>? numero,
    Expression<DateTime>? dateExpiration,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (navireId != null) 'navire_id': navireId,
      if (type != null) 'type': type,
      if (numero != null) 'numero': numero,
      if (dateExpiration != null) 'date_expiration': dateExpiration,
    });
  }

  CertificatsCompanion copyWith(
      {Value<int>? id,
      Value<String>? navireId,
      Value<TypeCertificat>? type,
      Value<String>? numero,
      Value<DateTime>? dateExpiration}) {
    return CertificatsCompanion(
      id: id ?? this.id,
      navireId: navireId ?? this.navireId,
      type: type ?? this.type,
      numero: numero ?? this.numero,
      dateExpiration: dateExpiration ?? this.dateExpiration,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (navireId.present) {
      map['navire_id'] = Variable<String>(navireId.value);
    }
    if (type.present) {
      map['type'] =
          Variable<String>($CertificatsTable.$convertertype.toSql(type.value));
    }
    if (numero.present) {
      map['numero'] = Variable<String>(numero.value);
    }
    if (dateExpiration.present) {
      map['date_expiration'] = Variable<DateTime>(dateExpiration.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CertificatsCompanion(')
          ..write('id: $id, ')
          ..write('navireId: $navireId, ')
          ..write('type: $type, ')
          ..write('numero: $numero, ')
          ..write('dateExpiration: $dateExpiration')
          ..write(')'))
        .toString();
  }
}

class $LicencesTable extends Licences
    with TableInfo<$LicencesTable, LicenceLigne> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LicencesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _numeroMeta = const VerificationMeta('numero');
  @override
  late final GeneratedColumn<String> numero = GeneratedColumn<String>(
      'numero', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _navireIdMeta =
      const VerificationMeta('navireId');
  @override
  late final GeneratedColumn<String> navireId = GeneratedColumn<String>(
      'navire_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES navires (id)'));
  static const VerificationMeta _segmentMeta =
      const VerificationMeta('segment');
  @override
  late final GeneratedColumnWithTypeConverter<TypePeche, String> segment =
      GeneratedColumn<String>('segment', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<TypePeche>($LicencesTable.$convertersegment);
  static const VerificationMeta _enginsAutorisesMeta =
      const VerificationMeta('enginsAutorises');
  @override
  late final GeneratedColumnWithTypeConverter<Set<TypeEngin>, String>
      enginsAutorises = GeneratedColumn<String>(
              'engins_autorises', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<Set<TypeEngin>>(
              $LicencesTable.$converterenginsAutorises);
  static const VerificationMeta _especesCiblesMeta =
      const VerificationMeta('especesCibles');
  @override
  late final GeneratedColumnWithTypeConverter<Set<String>, String>
      especesCibles = GeneratedColumn<String>(
              'especes_cibles', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<Set<String>>($LicencesTable.$converterespecesCibles);
  static const VerificationMeta _dateDebutMeta =
      const VerificationMeta('dateDebut');
  @override
  late final GeneratedColumn<DateTime> dateDebut = GeneratedColumn<DateTime>(
      'date_debut', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _dateFinMeta =
      const VerificationMeta('dateFin');
  @override
  late final GeneratedColumn<DateTime> dateFin = GeneratedColumn<DateTime>(
      'date_fin', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        numero,
        navireId,
        segment,
        enginsAutorises,
        especesCibles,
        dateDebut,
        dateFin
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'licences';
  @override
  VerificationContext validateIntegrity(Insertable<LicenceLigne> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('numero')) {
      context.handle(_numeroMeta,
          numero.isAcceptableOrUnknown(data['numero']!, _numeroMeta));
    } else if (isInserting) {
      context.missing(_numeroMeta);
    }
    if (data.containsKey('navire_id')) {
      context.handle(_navireIdMeta,
          navireId.isAcceptableOrUnknown(data['navire_id']!, _navireIdMeta));
    } else if (isInserting) {
      context.missing(_navireIdMeta);
    }
    context.handle(_segmentMeta, const VerificationResult.success());
    context.handle(_enginsAutorisesMeta, const VerificationResult.success());
    context.handle(_especesCiblesMeta, const VerificationResult.success());
    if (data.containsKey('date_debut')) {
      context.handle(_dateDebutMeta,
          dateDebut.isAcceptableOrUnknown(data['date_debut']!, _dateDebutMeta));
    } else if (isInserting) {
      context.missing(_dateDebutMeta);
    }
    if (data.containsKey('date_fin')) {
      context.handle(_dateFinMeta,
          dateFin.isAcceptableOrUnknown(data['date_fin']!, _dateFinMeta));
    } else if (isInserting) {
      context.missing(_dateFinMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {numero};
  @override
  LicenceLigne map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LicenceLigne(
      numero: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}numero'])!,
      navireId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}navire_id'])!,
      segment: $LicencesTable.$convertersegment.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}segment'])!),
      enginsAutorises: $LicencesTable.$converterenginsAutorises.fromSql(
          attachedDatabase.typeMapping.read(DriftSqlType.string,
              data['${effectivePrefix}engins_autorises'])!),
      especesCibles: $LicencesTable.$converterespecesCibles.fromSql(
          attachedDatabase.typeMapping.read(
              DriftSqlType.string, data['${effectivePrefix}especes_cibles'])!),
      dateDebut: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date_debut'])!,
      dateFin: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date_fin'])!,
    );
  }

  @override
  $LicencesTable createAlias(String alias) {
    return $LicencesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<TypePeche, String, String> $convertersegment =
      const EnumNameConverter<TypePeche>(TypePeche.values);
  static TypeConverter<Set<TypeEngin>, String> $converterenginsAutorises =
      const EnginsConverter();
  static TypeConverter<Set<String>, String> $converterespecesCibles =
      const CodesConverter();
}

class LicenceLigne extends DataClass implements Insertable<LicenceLigne> {
  final String numero;
  final String navireId;
  final TypePeche segment;
  final Set<TypeEngin> enginsAutorises;
  final Set<String> especesCibles;
  final DateTime dateDebut;
  final DateTime dateFin;
  const LicenceLigne(
      {required this.numero,
      required this.navireId,
      required this.segment,
      required this.enginsAutorises,
      required this.especesCibles,
      required this.dateDebut,
      required this.dateFin});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['numero'] = Variable<String>(numero);
    map['navire_id'] = Variable<String>(navireId);
    {
      map['segment'] =
          Variable<String>($LicencesTable.$convertersegment.toSql(segment));
    }
    {
      map['engins_autorises'] = Variable<String>(
          $LicencesTable.$converterenginsAutorises.toSql(enginsAutorises));
    }
    {
      map['especes_cibles'] = Variable<String>(
          $LicencesTable.$converterespecesCibles.toSql(especesCibles));
    }
    map['date_debut'] = Variable<DateTime>(dateDebut);
    map['date_fin'] = Variable<DateTime>(dateFin);
    return map;
  }

  LicencesCompanion toCompanion(bool nullToAbsent) {
    return LicencesCompanion(
      numero: Value(numero),
      navireId: Value(navireId),
      segment: Value(segment),
      enginsAutorises: Value(enginsAutorises),
      especesCibles: Value(especesCibles),
      dateDebut: Value(dateDebut),
      dateFin: Value(dateFin),
    );
  }

  factory LicenceLigne.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LicenceLigne(
      numero: serializer.fromJson<String>(json['numero']),
      navireId: serializer.fromJson<String>(json['navireId']),
      segment: $LicencesTable.$convertersegment
          .fromJson(serializer.fromJson<String>(json['segment'])),
      enginsAutorises:
          serializer.fromJson<Set<TypeEngin>>(json['enginsAutorises']),
      especesCibles: serializer.fromJson<Set<String>>(json['especesCibles']),
      dateDebut: serializer.fromJson<DateTime>(json['dateDebut']),
      dateFin: serializer.fromJson<DateTime>(json['dateFin']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'numero': serializer.toJson<String>(numero),
      'navireId': serializer.toJson<String>(navireId),
      'segment': serializer
          .toJson<String>($LicencesTable.$convertersegment.toJson(segment)),
      'enginsAutorises': serializer.toJson<Set<TypeEngin>>(enginsAutorises),
      'especesCibles': serializer.toJson<Set<String>>(especesCibles),
      'dateDebut': serializer.toJson<DateTime>(dateDebut),
      'dateFin': serializer.toJson<DateTime>(dateFin),
    };
  }

  LicenceLigne copyWith(
          {String? numero,
          String? navireId,
          TypePeche? segment,
          Set<TypeEngin>? enginsAutorises,
          Set<String>? especesCibles,
          DateTime? dateDebut,
          DateTime? dateFin}) =>
      LicenceLigne(
        numero: numero ?? this.numero,
        navireId: navireId ?? this.navireId,
        segment: segment ?? this.segment,
        enginsAutorises: enginsAutorises ?? this.enginsAutorises,
        especesCibles: especesCibles ?? this.especesCibles,
        dateDebut: dateDebut ?? this.dateDebut,
        dateFin: dateFin ?? this.dateFin,
      );
  LicenceLigne copyWithCompanion(LicencesCompanion data) {
    return LicenceLigne(
      numero: data.numero.present ? data.numero.value : this.numero,
      navireId: data.navireId.present ? data.navireId.value : this.navireId,
      segment: data.segment.present ? data.segment.value : this.segment,
      enginsAutorises: data.enginsAutorises.present
          ? data.enginsAutorises.value
          : this.enginsAutorises,
      especesCibles: data.especesCibles.present
          ? data.especesCibles.value
          : this.especesCibles,
      dateDebut: data.dateDebut.present ? data.dateDebut.value : this.dateDebut,
      dateFin: data.dateFin.present ? data.dateFin.value : this.dateFin,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LicenceLigne(')
          ..write('numero: $numero, ')
          ..write('navireId: $navireId, ')
          ..write('segment: $segment, ')
          ..write('enginsAutorises: $enginsAutorises, ')
          ..write('especesCibles: $especesCibles, ')
          ..write('dateDebut: $dateDebut, ')
          ..write('dateFin: $dateFin')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(numero, navireId, segment, enginsAutorises,
      especesCibles, dateDebut, dateFin);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LicenceLigne &&
          other.numero == this.numero &&
          other.navireId == this.navireId &&
          other.segment == this.segment &&
          other.enginsAutorises == this.enginsAutorises &&
          other.especesCibles == this.especesCibles &&
          other.dateDebut == this.dateDebut &&
          other.dateFin == this.dateFin);
}

class LicencesCompanion extends UpdateCompanion<LicenceLigne> {
  final Value<String> numero;
  final Value<String> navireId;
  final Value<TypePeche> segment;
  final Value<Set<TypeEngin>> enginsAutorises;
  final Value<Set<String>> especesCibles;
  final Value<DateTime> dateDebut;
  final Value<DateTime> dateFin;
  final Value<int> rowid;
  const LicencesCompanion({
    this.numero = const Value.absent(),
    this.navireId = const Value.absent(),
    this.segment = const Value.absent(),
    this.enginsAutorises = const Value.absent(),
    this.especesCibles = const Value.absent(),
    this.dateDebut = const Value.absent(),
    this.dateFin = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LicencesCompanion.insert({
    required String numero,
    required String navireId,
    required TypePeche segment,
    required Set<TypeEngin> enginsAutorises,
    required Set<String> especesCibles,
    required DateTime dateDebut,
    required DateTime dateFin,
    this.rowid = const Value.absent(),
  })  : numero = Value(numero),
        navireId = Value(navireId),
        segment = Value(segment),
        enginsAutorises = Value(enginsAutorises),
        especesCibles = Value(especesCibles),
        dateDebut = Value(dateDebut),
        dateFin = Value(dateFin);
  static Insertable<LicenceLigne> custom({
    Expression<String>? numero,
    Expression<String>? navireId,
    Expression<String>? segment,
    Expression<String>? enginsAutorises,
    Expression<String>? especesCibles,
    Expression<DateTime>? dateDebut,
    Expression<DateTime>? dateFin,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (numero != null) 'numero': numero,
      if (navireId != null) 'navire_id': navireId,
      if (segment != null) 'segment': segment,
      if (enginsAutorises != null) 'engins_autorises': enginsAutorises,
      if (especesCibles != null) 'especes_cibles': especesCibles,
      if (dateDebut != null) 'date_debut': dateDebut,
      if (dateFin != null) 'date_fin': dateFin,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LicencesCompanion copyWith(
      {Value<String>? numero,
      Value<String>? navireId,
      Value<TypePeche>? segment,
      Value<Set<TypeEngin>>? enginsAutorises,
      Value<Set<String>>? especesCibles,
      Value<DateTime>? dateDebut,
      Value<DateTime>? dateFin,
      Value<int>? rowid}) {
    return LicencesCompanion(
      numero: numero ?? this.numero,
      navireId: navireId ?? this.navireId,
      segment: segment ?? this.segment,
      enginsAutorises: enginsAutorises ?? this.enginsAutorises,
      especesCibles: especesCibles ?? this.especesCibles,
      dateDebut: dateDebut ?? this.dateDebut,
      dateFin: dateFin ?? this.dateFin,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (numero.present) {
      map['numero'] = Variable<String>(numero.value);
    }
    if (navireId.present) {
      map['navire_id'] = Variable<String>(navireId.value);
    }
    if (segment.present) {
      map['segment'] = Variable<String>(
          $LicencesTable.$convertersegment.toSql(segment.value));
    }
    if (enginsAutorises.present) {
      map['engins_autorises'] = Variable<String>($LicencesTable
          .$converterenginsAutorises
          .toSql(enginsAutorises.value));
    }
    if (especesCibles.present) {
      map['especes_cibles'] = Variable<String>(
          $LicencesTable.$converterespecesCibles.toSql(especesCibles.value));
    }
    if (dateDebut.present) {
      map['date_debut'] = Variable<DateTime>(dateDebut.value);
    }
    if (dateFin.present) {
      map['date_fin'] = Variable<DateTime>(dateFin.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LicencesCompanion(')
          ..write('numero: $numero, ')
          ..write('navireId: $navireId, ')
          ..write('segment: $segment, ')
          ..write('enginsAutorises: $enginsAutorises, ')
          ..write('especesCibles: $especesCibles, ')
          ..write('dateDebut: $dateDebut, ')
          ..write('dateFin: $dateFin, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $QuotasTable extends Quotas with TableInfo<$QuotasTable, QuotaLigne> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $QuotasTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _licenceNumeroMeta =
      const VerificationMeta('licenceNumero');
  @override
  late final GeneratedColumn<String> licenceNumero = GeneratedColumn<String>(
      'licence_numero', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES licences (numero) ON DELETE CASCADE'));
  static const VerificationMeta _especeCodeMeta =
      const VerificationMeta('especeCode');
  @override
  late final GeneratedColumn<String> especeCode = GeneratedColumn<String>(
      'espece_code', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 3, maxTextLength: 3),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _quotaKgMeta =
      const VerificationMeta('quotaKg');
  @override
  late final GeneratedColumn<double> quotaKg = GeneratedColumn<double>(
      'quota_kg', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [licenceNumero, especeCode, quotaKg];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'quotas';
  @override
  VerificationContext validateIntegrity(Insertable<QuotaLigne> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('licence_numero')) {
      context.handle(
          _licenceNumeroMeta,
          licenceNumero.isAcceptableOrUnknown(
              data['licence_numero']!, _licenceNumeroMeta));
    } else if (isInserting) {
      context.missing(_licenceNumeroMeta);
    }
    if (data.containsKey('espece_code')) {
      context.handle(
          _especeCodeMeta,
          especeCode.isAcceptableOrUnknown(
              data['espece_code']!, _especeCodeMeta));
    } else if (isInserting) {
      context.missing(_especeCodeMeta);
    }
    if (data.containsKey('quota_kg')) {
      context.handle(_quotaKgMeta,
          quotaKg.isAcceptableOrUnknown(data['quota_kg']!, _quotaKgMeta));
    } else if (isInserting) {
      context.missing(_quotaKgMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {licenceNumero, especeCode};
  @override
  QuotaLigne map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return QuotaLigne(
      licenceNumero: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}licence_numero'])!,
      especeCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}espece_code'])!,
      quotaKg: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}quota_kg'])!,
    );
  }

  @override
  $QuotasTable createAlias(String alias) {
    return $QuotasTable(attachedDatabase, alias);
  }
}

class QuotaLigne extends DataClass implements Insertable<QuotaLigne> {
  final String licenceNumero;
  final String especeCode;
  final double quotaKg;
  const QuotaLigne(
      {required this.licenceNumero,
      required this.especeCode,
      required this.quotaKg});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['licence_numero'] = Variable<String>(licenceNumero);
    map['espece_code'] = Variable<String>(especeCode);
    map['quota_kg'] = Variable<double>(quotaKg);
    return map;
  }

  QuotasCompanion toCompanion(bool nullToAbsent) {
    return QuotasCompanion(
      licenceNumero: Value(licenceNumero),
      especeCode: Value(especeCode),
      quotaKg: Value(quotaKg),
    );
  }

  factory QuotaLigne.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return QuotaLigne(
      licenceNumero: serializer.fromJson<String>(json['licenceNumero']),
      especeCode: serializer.fromJson<String>(json['especeCode']),
      quotaKg: serializer.fromJson<double>(json['quotaKg']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'licenceNumero': serializer.toJson<String>(licenceNumero),
      'especeCode': serializer.toJson<String>(especeCode),
      'quotaKg': serializer.toJson<double>(quotaKg),
    };
  }

  QuotaLigne copyWith(
          {String? licenceNumero, String? especeCode, double? quotaKg}) =>
      QuotaLigne(
        licenceNumero: licenceNumero ?? this.licenceNumero,
        especeCode: especeCode ?? this.especeCode,
        quotaKg: quotaKg ?? this.quotaKg,
      );
  QuotaLigne copyWithCompanion(QuotasCompanion data) {
    return QuotaLigne(
      licenceNumero: data.licenceNumero.present
          ? data.licenceNumero.value
          : this.licenceNumero,
      especeCode:
          data.especeCode.present ? data.especeCode.value : this.especeCode,
      quotaKg: data.quotaKg.present ? data.quotaKg.value : this.quotaKg,
    );
  }

  @override
  String toString() {
    return (StringBuffer('QuotaLigne(')
          ..write('licenceNumero: $licenceNumero, ')
          ..write('especeCode: $especeCode, ')
          ..write('quotaKg: $quotaKg')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(licenceNumero, especeCode, quotaKg);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is QuotaLigne &&
          other.licenceNumero == this.licenceNumero &&
          other.especeCode == this.especeCode &&
          other.quotaKg == this.quotaKg);
}

class QuotasCompanion extends UpdateCompanion<QuotaLigne> {
  final Value<String> licenceNumero;
  final Value<String> especeCode;
  final Value<double> quotaKg;
  final Value<int> rowid;
  const QuotasCompanion({
    this.licenceNumero = const Value.absent(),
    this.especeCode = const Value.absent(),
    this.quotaKg = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  QuotasCompanion.insert({
    required String licenceNumero,
    required String especeCode,
    required double quotaKg,
    this.rowid = const Value.absent(),
  })  : licenceNumero = Value(licenceNumero),
        especeCode = Value(especeCode),
        quotaKg = Value(quotaKg);
  static Insertable<QuotaLigne> custom({
    Expression<String>? licenceNumero,
    Expression<String>? especeCode,
    Expression<double>? quotaKg,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (licenceNumero != null) 'licence_numero': licenceNumero,
      if (especeCode != null) 'espece_code': especeCode,
      if (quotaKg != null) 'quota_kg': quotaKg,
      if (rowid != null) 'rowid': rowid,
    });
  }

  QuotasCompanion copyWith(
      {Value<String>? licenceNumero,
      Value<String>? especeCode,
      Value<double>? quotaKg,
      Value<int>? rowid}) {
    return QuotasCompanion(
      licenceNumero: licenceNumero ?? this.licenceNumero,
      especeCode: especeCode ?? this.especeCode,
      quotaKg: quotaKg ?? this.quotaKg,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (licenceNumero.present) {
      map['licence_numero'] = Variable<String>(licenceNumero.value);
    }
    if (especeCode.present) {
      map['espece_code'] = Variable<String>(especeCode.value);
    }
    if (quotaKg.present) {
      map['quota_kg'] = Variable<double>(quotaKg.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('QuotasCompanion(')
          ..write('licenceNumero: $licenceNumero, ')
          ..write('especeCode: $especeCode, ')
          ..write('quotaKg: $quotaKg, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DeclarationsTable extends Declarations
    with TableInfo<$DeclarationsTable, DeclarationLigne> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DeclarationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _navireIdMeta =
      const VerificationMeta('navireId');
  @override
  late final GeneratedColumn<String> navireId = GeneratedColumn<String>(
      'navire_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES navires (id)'));
  static const VerificationMeta _licenceNumeroMeta =
      const VerificationMeta('licenceNumero');
  @override
  late final GeneratedColumn<String> licenceNumero = GeneratedColumn<String>(
      'licence_numero', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES licences (numero)'));
  static const VerificationMeta _enginMeta = const VerificationMeta('engin');
  @override
  late final GeneratedColumnWithTypeConverter<TypeEngin, String> engin =
      GeneratedColumn<String>('engin', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<TypeEngin>($DeclarationsTable.$converterengin);
  static const VerificationMeta _latitudeMeta =
      const VerificationMeta('latitude');
  @override
  late final GeneratedColumn<double> latitude = GeneratedColumn<double>(
      'latitude', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _longitudeMeta =
      const VerificationMeta('longitude');
  @override
  late final GeneratedColumn<double> longitude = GeneratedColumn<double>(
      'longitude', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _horodatageMeta =
      const VerificationMeta('horodatage');
  @override
  late final GeneratedColumn<DateTime> horodatage = GeneratedColumn<DateTime>(
      'horodatage', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _nbInfractionsMeta =
      const VerificationMeta('nbInfractions');
  @override
  late final GeneratedColumn<int> nbInfractions = GeneratedColumn<int>(
      'nb_infractions', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _creeLeMeta = const VerificationMeta('creeLe');
  @override
  late final GeneratedColumn<DateTime> creeLe = GeneratedColumn<DateTime>(
      'cree_le', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        navireId,
        licenceNumero,
        engin,
        latitude,
        longitude,
        horodatage,
        nbInfractions,
        creeLe
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'declarations';
  @override
  VerificationContext validateIntegrity(Insertable<DeclarationLigne> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('navire_id')) {
      context.handle(_navireIdMeta,
          navireId.isAcceptableOrUnknown(data['navire_id']!, _navireIdMeta));
    } else if (isInserting) {
      context.missing(_navireIdMeta);
    }
    if (data.containsKey('licence_numero')) {
      context.handle(
          _licenceNumeroMeta,
          licenceNumero.isAcceptableOrUnknown(
              data['licence_numero']!, _licenceNumeroMeta));
    } else if (isInserting) {
      context.missing(_licenceNumeroMeta);
    }
    context.handle(_enginMeta, const VerificationResult.success());
    if (data.containsKey('latitude')) {
      context.handle(_latitudeMeta,
          latitude.isAcceptableOrUnknown(data['latitude']!, _latitudeMeta));
    } else if (isInserting) {
      context.missing(_latitudeMeta);
    }
    if (data.containsKey('longitude')) {
      context.handle(_longitudeMeta,
          longitude.isAcceptableOrUnknown(data['longitude']!, _longitudeMeta));
    } else if (isInserting) {
      context.missing(_longitudeMeta);
    }
    if (data.containsKey('horodatage')) {
      context.handle(
          _horodatageMeta,
          horodatage.isAcceptableOrUnknown(
              data['horodatage']!, _horodatageMeta));
    } else if (isInserting) {
      context.missing(_horodatageMeta);
    }
    if (data.containsKey('nb_infractions')) {
      context.handle(
          _nbInfractionsMeta,
          nbInfractions.isAcceptableOrUnknown(
              data['nb_infractions']!, _nbInfractionsMeta));
    }
    if (data.containsKey('cree_le')) {
      context.handle(_creeLeMeta,
          creeLe.isAcceptableOrUnknown(data['cree_le']!, _creeLeMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DeclarationLigne map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DeclarationLigne(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      navireId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}navire_id'])!,
      licenceNumero: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}licence_numero'])!,
      engin: $DeclarationsTable.$converterengin.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}engin'])!),
      latitude: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}latitude'])!,
      longitude: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}longitude'])!,
      horodatage: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}horodatage'])!,
      nbInfractions: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}nb_infractions'])!,
      creeLe: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}cree_le'])!,
    );
  }

  @override
  $DeclarationsTable createAlias(String alias) {
    return $DeclarationsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<TypeEngin, String, String> $converterengin =
      const EnumNameConverter<TypeEngin>(TypeEngin.values);
}

class DeclarationLigne extends DataClass
    implements Insertable<DeclarationLigne> {
  final String id;
  final String navireId;
  final String licenceNumero;
  final TypeEngin engin;
  final double latitude;
  final double longitude;
  final DateTime horodatage;
  final int nbInfractions;
  final DateTime creeLe;
  const DeclarationLigne(
      {required this.id,
      required this.navireId,
      required this.licenceNumero,
      required this.engin,
      required this.latitude,
      required this.longitude,
      required this.horodatage,
      required this.nbInfractions,
      required this.creeLe});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['navire_id'] = Variable<String>(navireId);
    map['licence_numero'] = Variable<String>(licenceNumero);
    {
      map['engin'] =
          Variable<String>($DeclarationsTable.$converterengin.toSql(engin));
    }
    map['latitude'] = Variable<double>(latitude);
    map['longitude'] = Variable<double>(longitude);
    map['horodatage'] = Variable<DateTime>(horodatage);
    map['nb_infractions'] = Variable<int>(nbInfractions);
    map['cree_le'] = Variable<DateTime>(creeLe);
    return map;
  }

  DeclarationsCompanion toCompanion(bool nullToAbsent) {
    return DeclarationsCompanion(
      id: Value(id),
      navireId: Value(navireId),
      licenceNumero: Value(licenceNumero),
      engin: Value(engin),
      latitude: Value(latitude),
      longitude: Value(longitude),
      horodatage: Value(horodatage),
      nbInfractions: Value(nbInfractions),
      creeLe: Value(creeLe),
    );
  }

  factory DeclarationLigne.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DeclarationLigne(
      id: serializer.fromJson<String>(json['id']),
      navireId: serializer.fromJson<String>(json['navireId']),
      licenceNumero: serializer.fromJson<String>(json['licenceNumero']),
      engin: $DeclarationsTable.$converterengin
          .fromJson(serializer.fromJson<String>(json['engin'])),
      latitude: serializer.fromJson<double>(json['latitude']),
      longitude: serializer.fromJson<double>(json['longitude']),
      horodatage: serializer.fromJson<DateTime>(json['horodatage']),
      nbInfractions: serializer.fromJson<int>(json['nbInfractions']),
      creeLe: serializer.fromJson<DateTime>(json['creeLe']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'navireId': serializer.toJson<String>(navireId),
      'licenceNumero': serializer.toJson<String>(licenceNumero),
      'engin': serializer
          .toJson<String>($DeclarationsTable.$converterengin.toJson(engin)),
      'latitude': serializer.toJson<double>(latitude),
      'longitude': serializer.toJson<double>(longitude),
      'horodatage': serializer.toJson<DateTime>(horodatage),
      'nbInfractions': serializer.toJson<int>(nbInfractions),
      'creeLe': serializer.toJson<DateTime>(creeLe),
    };
  }

  DeclarationLigne copyWith(
          {String? id,
          String? navireId,
          String? licenceNumero,
          TypeEngin? engin,
          double? latitude,
          double? longitude,
          DateTime? horodatage,
          int? nbInfractions,
          DateTime? creeLe}) =>
      DeclarationLigne(
        id: id ?? this.id,
        navireId: navireId ?? this.navireId,
        licenceNumero: licenceNumero ?? this.licenceNumero,
        engin: engin ?? this.engin,
        latitude: latitude ?? this.latitude,
        longitude: longitude ?? this.longitude,
        horodatage: horodatage ?? this.horodatage,
        nbInfractions: nbInfractions ?? this.nbInfractions,
        creeLe: creeLe ?? this.creeLe,
      );
  DeclarationLigne copyWithCompanion(DeclarationsCompanion data) {
    return DeclarationLigne(
      id: data.id.present ? data.id.value : this.id,
      navireId: data.navireId.present ? data.navireId.value : this.navireId,
      licenceNumero: data.licenceNumero.present
          ? data.licenceNumero.value
          : this.licenceNumero,
      engin: data.engin.present ? data.engin.value : this.engin,
      latitude: data.latitude.present ? data.latitude.value : this.latitude,
      longitude: data.longitude.present ? data.longitude.value : this.longitude,
      horodatage:
          data.horodatage.present ? data.horodatage.value : this.horodatage,
      nbInfractions: data.nbInfractions.present
          ? data.nbInfractions.value
          : this.nbInfractions,
      creeLe: data.creeLe.present ? data.creeLe.value : this.creeLe,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DeclarationLigne(')
          ..write('id: $id, ')
          ..write('navireId: $navireId, ')
          ..write('licenceNumero: $licenceNumero, ')
          ..write('engin: $engin, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('horodatage: $horodatage, ')
          ..write('nbInfractions: $nbInfractions, ')
          ..write('creeLe: $creeLe')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, navireId, licenceNumero, engin, latitude,
      longitude, horodatage, nbInfractions, creeLe);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DeclarationLigne &&
          other.id == this.id &&
          other.navireId == this.navireId &&
          other.licenceNumero == this.licenceNumero &&
          other.engin == this.engin &&
          other.latitude == this.latitude &&
          other.longitude == this.longitude &&
          other.horodatage == this.horodatage &&
          other.nbInfractions == this.nbInfractions &&
          other.creeLe == this.creeLe);
}

class DeclarationsCompanion extends UpdateCompanion<DeclarationLigne> {
  final Value<String> id;
  final Value<String> navireId;
  final Value<String> licenceNumero;
  final Value<TypeEngin> engin;
  final Value<double> latitude;
  final Value<double> longitude;
  final Value<DateTime> horodatage;
  final Value<int> nbInfractions;
  final Value<DateTime> creeLe;
  final Value<int> rowid;
  const DeclarationsCompanion({
    this.id = const Value.absent(),
    this.navireId = const Value.absent(),
    this.licenceNumero = const Value.absent(),
    this.engin = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.horodatage = const Value.absent(),
    this.nbInfractions = const Value.absent(),
    this.creeLe = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DeclarationsCompanion.insert({
    required String id,
    required String navireId,
    required String licenceNumero,
    required TypeEngin engin,
    required double latitude,
    required double longitude,
    required DateTime horodatage,
    this.nbInfractions = const Value.absent(),
    this.creeLe = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        navireId = Value(navireId),
        licenceNumero = Value(licenceNumero),
        engin = Value(engin),
        latitude = Value(latitude),
        longitude = Value(longitude),
        horodatage = Value(horodatage);
  static Insertable<DeclarationLigne> custom({
    Expression<String>? id,
    Expression<String>? navireId,
    Expression<String>? licenceNumero,
    Expression<String>? engin,
    Expression<double>? latitude,
    Expression<double>? longitude,
    Expression<DateTime>? horodatage,
    Expression<int>? nbInfractions,
    Expression<DateTime>? creeLe,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (navireId != null) 'navire_id': navireId,
      if (licenceNumero != null) 'licence_numero': licenceNumero,
      if (engin != null) 'engin': engin,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (horodatage != null) 'horodatage': horodatage,
      if (nbInfractions != null) 'nb_infractions': nbInfractions,
      if (creeLe != null) 'cree_le': creeLe,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DeclarationsCompanion copyWith(
      {Value<String>? id,
      Value<String>? navireId,
      Value<String>? licenceNumero,
      Value<TypeEngin>? engin,
      Value<double>? latitude,
      Value<double>? longitude,
      Value<DateTime>? horodatage,
      Value<int>? nbInfractions,
      Value<DateTime>? creeLe,
      Value<int>? rowid}) {
    return DeclarationsCompanion(
      id: id ?? this.id,
      navireId: navireId ?? this.navireId,
      licenceNumero: licenceNumero ?? this.licenceNumero,
      engin: engin ?? this.engin,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      horodatage: horodatage ?? this.horodatage,
      nbInfractions: nbInfractions ?? this.nbInfractions,
      creeLe: creeLe ?? this.creeLe,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (navireId.present) {
      map['navire_id'] = Variable<String>(navireId.value);
    }
    if (licenceNumero.present) {
      map['licence_numero'] = Variable<String>(licenceNumero.value);
    }
    if (engin.present) {
      map['engin'] = Variable<String>(
          $DeclarationsTable.$converterengin.toSql(engin.value));
    }
    if (latitude.present) {
      map['latitude'] = Variable<double>(latitude.value);
    }
    if (longitude.present) {
      map['longitude'] = Variable<double>(longitude.value);
    }
    if (horodatage.present) {
      map['horodatage'] = Variable<DateTime>(horodatage.value);
    }
    if (nbInfractions.present) {
      map['nb_infractions'] = Variable<int>(nbInfractions.value);
    }
    if (creeLe.present) {
      map['cree_le'] = Variable<DateTime>(creeLe.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DeclarationsCompanion(')
          ..write('id: $id, ')
          ..write('navireId: $navireId, ')
          ..write('licenceNumero: $licenceNumero, ')
          ..write('engin: $engin, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('horodatage: $horodatage, ')
          ..write('nbInfractions: $nbInfractions, ')
          ..write('creeLe: $creeLe, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $EquipagesTable extends Equipages
    with TableInfo<$EquipagesTable, MembreEquipageLigne> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EquipagesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _declarationIdMeta =
      const VerificationMeta('declarationId');
  @override
  late final GeneratedColumn<String> declarationId = GeneratedColumn<String>(
      'declaration_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES declarations (id) ON DELETE CASCADE'));
  static const VerificationMeta _nomMeta = const VerificationMeta('nom');
  @override
  late final GeneratedColumn<String> nom = GeneratedColumn<String>(
      'nom', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _fonctionMeta =
      const VerificationMeta('fonction');
  @override
  late final GeneratedColumn<String> fonction = GeneratedColumn<String>(
      'fonction', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nationaliteMeta =
      const VerificationMeta('nationalite');
  @override
  late final GeneratedColumn<String> nationalite = GeneratedColumn<String>(
      'nationalite', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, declarationId, nom, fonction, nationalite];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'equipages';
  @override
  VerificationContext validateIntegrity(
      Insertable<MembreEquipageLigne> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('declaration_id')) {
      context.handle(
          _declarationIdMeta,
          declarationId.isAcceptableOrUnknown(
              data['declaration_id']!, _declarationIdMeta));
    } else if (isInserting) {
      context.missing(_declarationIdMeta);
    }
    if (data.containsKey('nom')) {
      context.handle(
          _nomMeta, nom.isAcceptableOrUnknown(data['nom']!, _nomMeta));
    } else if (isInserting) {
      context.missing(_nomMeta);
    }
    if (data.containsKey('fonction')) {
      context.handle(_fonctionMeta,
          fonction.isAcceptableOrUnknown(data['fonction']!, _fonctionMeta));
    } else if (isInserting) {
      context.missing(_fonctionMeta);
    }
    if (data.containsKey('nationalite')) {
      context.handle(
          _nationaliteMeta,
          nationalite.isAcceptableOrUnknown(
              data['nationalite']!, _nationaliteMeta));
    } else if (isInserting) {
      context.missing(_nationaliteMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MembreEquipageLigne map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MembreEquipageLigne(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      declarationId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}declaration_id'])!,
      nom: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}nom'])!,
      fonction: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}fonction'])!,
      nationalite: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}nationalite'])!,
    );
  }

  @override
  $EquipagesTable createAlias(String alias) {
    return $EquipagesTable(attachedDatabase, alias);
  }
}

class MembreEquipageLigne extends DataClass
    implements Insertable<MembreEquipageLigne> {
  final int id;
  final String declarationId;
  final String nom;
  final String fonction;
  final String nationalite;
  const MembreEquipageLigne(
      {required this.id,
      required this.declarationId,
      required this.nom,
      required this.fonction,
      required this.nationalite});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['declaration_id'] = Variable<String>(declarationId);
    map['nom'] = Variable<String>(nom);
    map['fonction'] = Variable<String>(fonction);
    map['nationalite'] = Variable<String>(nationalite);
    return map;
  }

  EquipagesCompanion toCompanion(bool nullToAbsent) {
    return EquipagesCompanion(
      id: Value(id),
      declarationId: Value(declarationId),
      nom: Value(nom),
      fonction: Value(fonction),
      nationalite: Value(nationalite),
    );
  }

  factory MembreEquipageLigne.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MembreEquipageLigne(
      id: serializer.fromJson<int>(json['id']),
      declarationId: serializer.fromJson<String>(json['declarationId']),
      nom: serializer.fromJson<String>(json['nom']),
      fonction: serializer.fromJson<String>(json['fonction']),
      nationalite: serializer.fromJson<String>(json['nationalite']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'declarationId': serializer.toJson<String>(declarationId),
      'nom': serializer.toJson<String>(nom),
      'fonction': serializer.toJson<String>(fonction),
      'nationalite': serializer.toJson<String>(nationalite),
    };
  }

  MembreEquipageLigne copyWith(
          {int? id,
          String? declarationId,
          String? nom,
          String? fonction,
          String? nationalite}) =>
      MembreEquipageLigne(
        id: id ?? this.id,
        declarationId: declarationId ?? this.declarationId,
        nom: nom ?? this.nom,
        fonction: fonction ?? this.fonction,
        nationalite: nationalite ?? this.nationalite,
      );
  MembreEquipageLigne copyWithCompanion(EquipagesCompanion data) {
    return MembreEquipageLigne(
      id: data.id.present ? data.id.value : this.id,
      declarationId: data.declarationId.present
          ? data.declarationId.value
          : this.declarationId,
      nom: data.nom.present ? data.nom.value : this.nom,
      fonction: data.fonction.present ? data.fonction.value : this.fonction,
      nationalite:
          data.nationalite.present ? data.nationalite.value : this.nationalite,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MembreEquipageLigne(')
          ..write('id: $id, ')
          ..write('declarationId: $declarationId, ')
          ..write('nom: $nom, ')
          ..write('fonction: $fonction, ')
          ..write('nationalite: $nationalite')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, declarationId, nom, fonction, nationalite);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MembreEquipageLigne &&
          other.id == this.id &&
          other.declarationId == this.declarationId &&
          other.nom == this.nom &&
          other.fonction == this.fonction &&
          other.nationalite == this.nationalite);
}

class EquipagesCompanion extends UpdateCompanion<MembreEquipageLigne> {
  final Value<int> id;
  final Value<String> declarationId;
  final Value<String> nom;
  final Value<String> fonction;
  final Value<String> nationalite;
  const EquipagesCompanion({
    this.id = const Value.absent(),
    this.declarationId = const Value.absent(),
    this.nom = const Value.absent(),
    this.fonction = const Value.absent(),
    this.nationalite = const Value.absent(),
  });
  EquipagesCompanion.insert({
    this.id = const Value.absent(),
    required String declarationId,
    required String nom,
    required String fonction,
    required String nationalite,
  })  : declarationId = Value(declarationId),
        nom = Value(nom),
        fonction = Value(fonction),
        nationalite = Value(nationalite);
  static Insertable<MembreEquipageLigne> custom({
    Expression<int>? id,
    Expression<String>? declarationId,
    Expression<String>? nom,
    Expression<String>? fonction,
    Expression<String>? nationalite,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (declarationId != null) 'declaration_id': declarationId,
      if (nom != null) 'nom': nom,
      if (fonction != null) 'fonction': fonction,
      if (nationalite != null) 'nationalite': nationalite,
    });
  }

  EquipagesCompanion copyWith(
      {Value<int>? id,
      Value<String>? declarationId,
      Value<String>? nom,
      Value<String>? fonction,
      Value<String>? nationalite}) {
    return EquipagesCompanion(
      id: id ?? this.id,
      declarationId: declarationId ?? this.declarationId,
      nom: nom ?? this.nom,
      fonction: fonction ?? this.fonction,
      nationalite: nationalite ?? this.nationalite,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (declarationId.present) {
      map['declaration_id'] = Variable<String>(declarationId.value);
    }
    if (nom.present) {
      map['nom'] = Variable<String>(nom.value);
    }
    if (fonction.present) {
      map['fonction'] = Variable<String>(fonction.value);
    }
    if (nationalite.present) {
      map['nationalite'] = Variable<String>(nationalite.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EquipagesCompanion(')
          ..write('id: $id, ')
          ..write('declarationId: $declarationId, ')
          ..write('nom: $nom, ')
          ..write('fonction: $fonction, ')
          ..write('nationalite: $nationalite')
          ..write(')'))
        .toString();
  }
}

class $CapturesTable extends Captures
    with TableInfo<$CapturesTable, CaptureLigne> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CapturesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _declarationIdMeta =
      const VerificationMeta('declarationId');
  @override
  late final GeneratedColumn<String> declarationId = GeneratedColumn<String>(
      'declaration_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES declarations (id) ON DELETE CASCADE'));
  static const VerificationMeta _especeCodeMeta =
      const VerificationMeta('especeCode');
  @override
  late final GeneratedColumn<String> especeCode = GeneratedColumn<String>(
      'espece_code', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 3, maxTextLength: 3),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _poidsKgMeta =
      const VerificationMeta('poidsKg');
  @override
  late final GeneratedColumn<double> poidsKg = GeneratedColumn<double>(
      'poids_kg', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, declarationId, especeCode, poidsKg];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'captures';
  @override
  VerificationContext validateIntegrity(Insertable<CaptureLigne> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('declaration_id')) {
      context.handle(
          _declarationIdMeta,
          declarationId.isAcceptableOrUnknown(
              data['declaration_id']!, _declarationIdMeta));
    } else if (isInserting) {
      context.missing(_declarationIdMeta);
    }
    if (data.containsKey('espece_code')) {
      context.handle(
          _especeCodeMeta,
          especeCode.isAcceptableOrUnknown(
              data['espece_code']!, _especeCodeMeta));
    } else if (isInserting) {
      context.missing(_especeCodeMeta);
    }
    if (data.containsKey('poids_kg')) {
      context.handle(_poidsKgMeta,
          poidsKg.isAcceptableOrUnknown(data['poids_kg']!, _poidsKgMeta));
    } else if (isInserting) {
      context.missing(_poidsKgMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CaptureLigne map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CaptureLigne(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      declarationId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}declaration_id'])!,
      especeCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}espece_code'])!,
      poidsKg: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}poids_kg'])!,
    );
  }

  @override
  $CapturesTable createAlias(String alias) {
    return $CapturesTable(attachedDatabase, alias);
  }
}

class CaptureLigne extends DataClass implements Insertable<CaptureLigne> {
  final int id;
  final String declarationId;
  final String especeCode;
  final double poidsKg;
  const CaptureLigne(
      {required this.id,
      required this.declarationId,
      required this.especeCode,
      required this.poidsKg});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['declaration_id'] = Variable<String>(declarationId);
    map['espece_code'] = Variable<String>(especeCode);
    map['poids_kg'] = Variable<double>(poidsKg);
    return map;
  }

  CapturesCompanion toCompanion(bool nullToAbsent) {
    return CapturesCompanion(
      id: Value(id),
      declarationId: Value(declarationId),
      especeCode: Value(especeCode),
      poidsKg: Value(poidsKg),
    );
  }

  factory CaptureLigne.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CaptureLigne(
      id: serializer.fromJson<int>(json['id']),
      declarationId: serializer.fromJson<String>(json['declarationId']),
      especeCode: serializer.fromJson<String>(json['especeCode']),
      poidsKg: serializer.fromJson<double>(json['poidsKg']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'declarationId': serializer.toJson<String>(declarationId),
      'especeCode': serializer.toJson<String>(especeCode),
      'poidsKg': serializer.toJson<double>(poidsKg),
    };
  }

  CaptureLigne copyWith(
          {int? id,
          String? declarationId,
          String? especeCode,
          double? poidsKg}) =>
      CaptureLigne(
        id: id ?? this.id,
        declarationId: declarationId ?? this.declarationId,
        especeCode: especeCode ?? this.especeCode,
        poidsKg: poidsKg ?? this.poidsKg,
      );
  CaptureLigne copyWithCompanion(CapturesCompanion data) {
    return CaptureLigne(
      id: data.id.present ? data.id.value : this.id,
      declarationId: data.declarationId.present
          ? data.declarationId.value
          : this.declarationId,
      especeCode:
          data.especeCode.present ? data.especeCode.value : this.especeCode,
      poidsKg: data.poidsKg.present ? data.poidsKg.value : this.poidsKg,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CaptureLigne(')
          ..write('id: $id, ')
          ..write('declarationId: $declarationId, ')
          ..write('especeCode: $especeCode, ')
          ..write('poidsKg: $poidsKg')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, declarationId, especeCode, poidsKg);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CaptureLigne &&
          other.id == this.id &&
          other.declarationId == this.declarationId &&
          other.especeCode == this.especeCode &&
          other.poidsKg == this.poidsKg);
}

class CapturesCompanion extends UpdateCompanion<CaptureLigne> {
  final Value<int> id;
  final Value<String> declarationId;
  final Value<String> especeCode;
  final Value<double> poidsKg;
  const CapturesCompanion({
    this.id = const Value.absent(),
    this.declarationId = const Value.absent(),
    this.especeCode = const Value.absent(),
    this.poidsKg = const Value.absent(),
  });
  CapturesCompanion.insert({
    this.id = const Value.absent(),
    required String declarationId,
    required String especeCode,
    required double poidsKg,
  })  : declarationId = Value(declarationId),
        especeCode = Value(especeCode),
        poidsKg = Value(poidsKg);
  static Insertable<CaptureLigne> custom({
    Expression<int>? id,
    Expression<String>? declarationId,
    Expression<String>? especeCode,
    Expression<double>? poidsKg,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (declarationId != null) 'declaration_id': declarationId,
      if (especeCode != null) 'espece_code': especeCode,
      if (poidsKg != null) 'poids_kg': poidsKg,
    });
  }

  CapturesCompanion copyWith(
      {Value<int>? id,
      Value<String>? declarationId,
      Value<String>? especeCode,
      Value<double>? poidsKg}) {
    return CapturesCompanion(
      id: id ?? this.id,
      declarationId: declarationId ?? this.declarationId,
      especeCode: especeCode ?? this.especeCode,
      poidsKg: poidsKg ?? this.poidsKg,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (declarationId.present) {
      map['declaration_id'] = Variable<String>(declarationId.value);
    }
    if (especeCode.present) {
      map['espece_code'] = Variable<String>(especeCode.value);
    }
    if (poidsKg.present) {
      map['poids_kg'] = Variable<double>(poidsKg.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CapturesCompanion(')
          ..write('id: $id, ')
          ..write('declarationId: $declarationId, ')
          ..write('especeCode: $especeCode, ')
          ..write('poidsKg: $poidsKg')
          ..write(')'))
        .toString();
  }
}

class $ControlesTable extends Controles
    with TableInfo<$ControlesTable, ControleLigne> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ControlesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _navireIdMeta =
      const VerificationMeta('navireId');
  @override
  late final GeneratedColumn<String> navireId = GeneratedColumn<String>(
      'navire_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES navires (id)'));
  static const VerificationMeta _agentMeta = const VerificationMeta('agent');
  @override
  late final GeneratedColumn<String> agent = GeneratedColumn<String>(
      'agent', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _latitudeMeta =
      const VerificationMeta('latitude');
  @override
  late final GeneratedColumn<double> latitude = GeneratedColumn<double>(
      'latitude', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _longitudeMeta =
      const VerificationMeta('longitude');
  @override
  late final GeneratedColumn<double> longitude = GeneratedColumn<double>(
      'longitude', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _enginMeta = const VerificationMeta('engin');
  @override
  late final GeneratedColumnWithTypeConverter<TypeEngin, String> engin =
      GeneratedColumn<String>('engin', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<TypeEngin>($ControlesTable.$converterengin);
  static const VerificationMeta _pavillonConformeMeta =
      const VerificationMeta('pavillonConforme');
  @override
  late final GeneratedColumn<bool> pavillonConforme = GeneratedColumn<bool>(
      'pavillon_conforme', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("pavillon_conforme" IN (0, 1))'));
  static const VerificationMeta _marquageConformeMeta =
      const VerificationMeta('marquageConforme');
  @override
  late final GeneratedColumn<bool> marquageConforme = GeneratedColumn<bool>(
      'marquage_conforme', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("marquage_conforme" IN (0, 1))'));
  static const VerificationMeta _planStockageConformeMeta =
      const VerificationMeta('planStockageConforme');
  @override
  late final GeneratedColumn<bool> planStockageConforme = GeneratedColumn<bool>(
      'plan_stockage_conforme', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("plan_stockage_conforme" IN (0, 1))'));
  static const VerificationMeta _observationsMeta =
      const VerificationMeta('observations');
  @override
  late final GeneratedColumn<String> observations = GeneratedColumn<String>(
      'observations', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _nbInfractionsMeta =
      const VerificationMeta('nbInfractions');
  @override
  late final GeneratedColumn<int> nbInfractions = GeneratedColumn<int>(
      'nb_infractions', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _amendeMinMeta =
      const VerificationMeta('amendeMin');
  @override
  late final GeneratedColumn<double> amendeMin = GeneratedColumn<double>(
      'amende_min', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _amendeMaxMeta =
      const VerificationMeta('amendeMax');
  @override
  late final GeneratedColumn<double> amendeMax = GeneratedColumn<double>(
      'amende_max', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _rapportMeta =
      const VerificationMeta('rapport');
  @override
  late final GeneratedColumn<String> rapport = GeneratedColumn<String>(
      'rapport', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _rapportPdfMeta =
      const VerificationMeta('rapportPdf');
  @override
  late final GeneratedColumn<Uint8List> rapportPdf = GeneratedColumn<Uint8List>(
      'rapport_pdf', aliasedName, true,
      type: DriftSqlType.blob, requiredDuringInsert: false);
  static const VerificationMeta _creeLeMeta = const VerificationMeta('creeLe');
  @override
  late final GeneratedColumn<DateTime> creeLe = GeneratedColumn<DateTime>(
      'cree_le', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        navireId,
        agent,
        date,
        latitude,
        longitude,
        engin,
        pavillonConforme,
        marquageConforme,
        planStockageConforme,
        observations,
        nbInfractions,
        amendeMin,
        amendeMax,
        rapport,
        rapportPdf,
        creeLe
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'controles';
  @override
  VerificationContext validateIntegrity(Insertable<ControleLigne> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('navire_id')) {
      context.handle(_navireIdMeta,
          navireId.isAcceptableOrUnknown(data['navire_id']!, _navireIdMeta));
    } else if (isInserting) {
      context.missing(_navireIdMeta);
    }
    if (data.containsKey('agent')) {
      context.handle(
          _agentMeta, agent.isAcceptableOrUnknown(data['agent']!, _agentMeta));
    } else if (isInserting) {
      context.missing(_agentMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('latitude')) {
      context.handle(_latitudeMeta,
          latitude.isAcceptableOrUnknown(data['latitude']!, _latitudeMeta));
    } else if (isInserting) {
      context.missing(_latitudeMeta);
    }
    if (data.containsKey('longitude')) {
      context.handle(_longitudeMeta,
          longitude.isAcceptableOrUnknown(data['longitude']!, _longitudeMeta));
    } else if (isInserting) {
      context.missing(_longitudeMeta);
    }
    context.handle(_enginMeta, const VerificationResult.success());
    if (data.containsKey('pavillon_conforme')) {
      context.handle(
          _pavillonConformeMeta,
          pavillonConforme.isAcceptableOrUnknown(
              data['pavillon_conforme']!, _pavillonConformeMeta));
    } else if (isInserting) {
      context.missing(_pavillonConformeMeta);
    }
    if (data.containsKey('marquage_conforme')) {
      context.handle(
          _marquageConformeMeta,
          marquageConforme.isAcceptableOrUnknown(
              data['marquage_conforme']!, _marquageConformeMeta));
    } else if (isInserting) {
      context.missing(_marquageConformeMeta);
    }
    if (data.containsKey('plan_stockage_conforme')) {
      context.handle(
          _planStockageConformeMeta,
          planStockageConforme.isAcceptableOrUnknown(
              data['plan_stockage_conforme']!, _planStockageConformeMeta));
    } else if (isInserting) {
      context.missing(_planStockageConformeMeta);
    }
    if (data.containsKey('observations')) {
      context.handle(
          _observationsMeta,
          observations.isAcceptableOrUnknown(
              data['observations']!, _observationsMeta));
    }
    if (data.containsKey('nb_infractions')) {
      context.handle(
          _nbInfractionsMeta,
          nbInfractions.isAcceptableOrUnknown(
              data['nb_infractions']!, _nbInfractionsMeta));
    } else if (isInserting) {
      context.missing(_nbInfractionsMeta);
    }
    if (data.containsKey('amende_min')) {
      context.handle(_amendeMinMeta,
          amendeMin.isAcceptableOrUnknown(data['amende_min']!, _amendeMinMeta));
    } else if (isInserting) {
      context.missing(_amendeMinMeta);
    }
    if (data.containsKey('amende_max')) {
      context.handle(_amendeMaxMeta,
          amendeMax.isAcceptableOrUnknown(data['amende_max']!, _amendeMaxMeta));
    } else if (isInserting) {
      context.missing(_amendeMaxMeta);
    }
    if (data.containsKey('rapport')) {
      context.handle(_rapportMeta,
          rapport.isAcceptableOrUnknown(data['rapport']!, _rapportMeta));
    } else if (isInserting) {
      context.missing(_rapportMeta);
    }
    if (data.containsKey('rapport_pdf')) {
      context.handle(
          _rapportPdfMeta,
          rapportPdf.isAcceptableOrUnknown(
              data['rapport_pdf']!, _rapportPdfMeta));
    }
    if (data.containsKey('cree_le')) {
      context.handle(_creeLeMeta,
          creeLe.isAcceptableOrUnknown(data['cree_le']!, _creeLeMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ControleLigne map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ControleLigne(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      navireId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}navire_id'])!,
      agent: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}agent'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
      latitude: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}latitude'])!,
      longitude: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}longitude'])!,
      engin: $ControlesTable.$converterengin.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}engin'])!),
      pavillonConforme: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}pavillon_conforme'])!,
      marquageConforme: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}marquage_conforme'])!,
      planStockageConforme: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}plan_stockage_conforme'])!,
      observations: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}observations'])!,
      nbInfractions: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}nb_infractions'])!,
      amendeMin: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}amende_min'])!,
      amendeMax: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}amende_max'])!,
      rapport: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}rapport'])!,
      rapportPdf: attachedDatabase.typeMapping
          .read(DriftSqlType.blob, data['${effectivePrefix}rapport_pdf']),
      creeLe: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}cree_le'])!,
    );
  }

  @override
  $ControlesTable createAlias(String alias) {
    return $ControlesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<TypeEngin, String, String> $converterengin =
      const EnumNameConverter<TypeEngin>(TypeEngin.values);
}

class ControleLigne extends DataClass implements Insertable<ControleLigne> {
  final String id;
  final String navireId;
  final String agent;
  final DateTime date;
  final double latitude;
  final double longitude;
  final TypeEngin engin;
  final bool pavillonConforme;
  final bool marquageConforme;
  final bool planStockageConforme;
  final String observations;
  final int nbInfractions;
  final double amendeMin;
  final double amendeMax;

  /// Texte du rapport tel que signé par l'agent (valeur probante).
  final String rapport;

  /// Rapport PDF tel que signé (ajouté dans la version 2 du schéma).
  final Uint8List? rapportPdf;
  final DateTime creeLe;
  const ControleLigne(
      {required this.id,
      required this.navireId,
      required this.agent,
      required this.date,
      required this.latitude,
      required this.longitude,
      required this.engin,
      required this.pavillonConforme,
      required this.marquageConforme,
      required this.planStockageConforme,
      required this.observations,
      required this.nbInfractions,
      required this.amendeMin,
      required this.amendeMax,
      required this.rapport,
      this.rapportPdf,
      required this.creeLe});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['navire_id'] = Variable<String>(navireId);
    map['agent'] = Variable<String>(agent);
    map['date'] = Variable<DateTime>(date);
    map['latitude'] = Variable<double>(latitude);
    map['longitude'] = Variable<double>(longitude);
    {
      map['engin'] =
          Variable<String>($ControlesTable.$converterengin.toSql(engin));
    }
    map['pavillon_conforme'] = Variable<bool>(pavillonConforme);
    map['marquage_conforme'] = Variable<bool>(marquageConforme);
    map['plan_stockage_conforme'] = Variable<bool>(planStockageConforme);
    map['observations'] = Variable<String>(observations);
    map['nb_infractions'] = Variable<int>(nbInfractions);
    map['amende_min'] = Variable<double>(amendeMin);
    map['amende_max'] = Variable<double>(amendeMax);
    map['rapport'] = Variable<String>(rapport);
    if (!nullToAbsent || rapportPdf != null) {
      map['rapport_pdf'] = Variable<Uint8List>(rapportPdf);
    }
    map['cree_le'] = Variable<DateTime>(creeLe);
    return map;
  }

  ControlesCompanion toCompanion(bool nullToAbsent) {
    return ControlesCompanion(
      id: Value(id),
      navireId: Value(navireId),
      agent: Value(agent),
      date: Value(date),
      latitude: Value(latitude),
      longitude: Value(longitude),
      engin: Value(engin),
      pavillonConforme: Value(pavillonConforme),
      marquageConforme: Value(marquageConforme),
      planStockageConforme: Value(planStockageConforme),
      observations: Value(observations),
      nbInfractions: Value(nbInfractions),
      amendeMin: Value(amendeMin),
      amendeMax: Value(amendeMax),
      rapport: Value(rapport),
      rapportPdf: rapportPdf == null && nullToAbsent
          ? const Value.absent()
          : Value(rapportPdf),
      creeLe: Value(creeLe),
    );
  }

  factory ControleLigne.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ControleLigne(
      id: serializer.fromJson<String>(json['id']),
      navireId: serializer.fromJson<String>(json['navireId']),
      agent: serializer.fromJson<String>(json['agent']),
      date: serializer.fromJson<DateTime>(json['date']),
      latitude: serializer.fromJson<double>(json['latitude']),
      longitude: serializer.fromJson<double>(json['longitude']),
      engin: $ControlesTable.$converterengin
          .fromJson(serializer.fromJson<String>(json['engin'])),
      pavillonConforme: serializer.fromJson<bool>(json['pavillonConforme']),
      marquageConforme: serializer.fromJson<bool>(json['marquageConforme']),
      planStockageConforme:
          serializer.fromJson<bool>(json['planStockageConforme']),
      observations: serializer.fromJson<String>(json['observations']),
      nbInfractions: serializer.fromJson<int>(json['nbInfractions']),
      amendeMin: serializer.fromJson<double>(json['amendeMin']),
      amendeMax: serializer.fromJson<double>(json['amendeMax']),
      rapport: serializer.fromJson<String>(json['rapport']),
      rapportPdf: serializer.fromJson<Uint8List?>(json['rapportPdf']),
      creeLe: serializer.fromJson<DateTime>(json['creeLe']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'navireId': serializer.toJson<String>(navireId),
      'agent': serializer.toJson<String>(agent),
      'date': serializer.toJson<DateTime>(date),
      'latitude': serializer.toJson<double>(latitude),
      'longitude': serializer.toJson<double>(longitude),
      'engin': serializer
          .toJson<String>($ControlesTable.$converterengin.toJson(engin)),
      'pavillonConforme': serializer.toJson<bool>(pavillonConforme),
      'marquageConforme': serializer.toJson<bool>(marquageConforme),
      'planStockageConforme': serializer.toJson<bool>(planStockageConforme),
      'observations': serializer.toJson<String>(observations),
      'nbInfractions': serializer.toJson<int>(nbInfractions),
      'amendeMin': serializer.toJson<double>(amendeMin),
      'amendeMax': serializer.toJson<double>(amendeMax),
      'rapport': serializer.toJson<String>(rapport),
      'rapportPdf': serializer.toJson<Uint8List?>(rapportPdf),
      'creeLe': serializer.toJson<DateTime>(creeLe),
    };
  }

  ControleLigne copyWith(
          {String? id,
          String? navireId,
          String? agent,
          DateTime? date,
          double? latitude,
          double? longitude,
          TypeEngin? engin,
          bool? pavillonConforme,
          bool? marquageConforme,
          bool? planStockageConforme,
          String? observations,
          int? nbInfractions,
          double? amendeMin,
          double? amendeMax,
          String? rapport,
          Value<Uint8List?> rapportPdf = const Value.absent(),
          DateTime? creeLe}) =>
      ControleLigne(
        id: id ?? this.id,
        navireId: navireId ?? this.navireId,
        agent: agent ?? this.agent,
        date: date ?? this.date,
        latitude: latitude ?? this.latitude,
        longitude: longitude ?? this.longitude,
        engin: engin ?? this.engin,
        pavillonConforme: pavillonConforme ?? this.pavillonConforme,
        marquageConforme: marquageConforme ?? this.marquageConforme,
        planStockageConforme: planStockageConforme ?? this.planStockageConforme,
        observations: observations ?? this.observations,
        nbInfractions: nbInfractions ?? this.nbInfractions,
        amendeMin: amendeMin ?? this.amendeMin,
        amendeMax: amendeMax ?? this.amendeMax,
        rapport: rapport ?? this.rapport,
        rapportPdf: rapportPdf.present ? rapportPdf.value : this.rapportPdf,
        creeLe: creeLe ?? this.creeLe,
      );
  ControleLigne copyWithCompanion(ControlesCompanion data) {
    return ControleLigne(
      id: data.id.present ? data.id.value : this.id,
      navireId: data.navireId.present ? data.navireId.value : this.navireId,
      agent: data.agent.present ? data.agent.value : this.agent,
      date: data.date.present ? data.date.value : this.date,
      latitude: data.latitude.present ? data.latitude.value : this.latitude,
      longitude: data.longitude.present ? data.longitude.value : this.longitude,
      engin: data.engin.present ? data.engin.value : this.engin,
      pavillonConforme: data.pavillonConforme.present
          ? data.pavillonConforme.value
          : this.pavillonConforme,
      marquageConforme: data.marquageConforme.present
          ? data.marquageConforme.value
          : this.marquageConforme,
      planStockageConforme: data.planStockageConforme.present
          ? data.planStockageConforme.value
          : this.planStockageConforme,
      observations: data.observations.present
          ? data.observations.value
          : this.observations,
      nbInfractions: data.nbInfractions.present
          ? data.nbInfractions.value
          : this.nbInfractions,
      amendeMin: data.amendeMin.present ? data.amendeMin.value : this.amendeMin,
      amendeMax: data.amendeMax.present ? data.amendeMax.value : this.amendeMax,
      rapport: data.rapport.present ? data.rapport.value : this.rapport,
      rapportPdf:
          data.rapportPdf.present ? data.rapportPdf.value : this.rapportPdf,
      creeLe: data.creeLe.present ? data.creeLe.value : this.creeLe,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ControleLigne(')
          ..write('id: $id, ')
          ..write('navireId: $navireId, ')
          ..write('agent: $agent, ')
          ..write('date: $date, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('engin: $engin, ')
          ..write('pavillonConforme: $pavillonConforme, ')
          ..write('marquageConforme: $marquageConforme, ')
          ..write('planStockageConforme: $planStockageConforme, ')
          ..write('observations: $observations, ')
          ..write('nbInfractions: $nbInfractions, ')
          ..write('amendeMin: $amendeMin, ')
          ..write('amendeMax: $amendeMax, ')
          ..write('rapport: $rapport, ')
          ..write('rapportPdf: $rapportPdf, ')
          ..write('creeLe: $creeLe')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      navireId,
      agent,
      date,
      latitude,
      longitude,
      engin,
      pavillonConforme,
      marquageConforme,
      planStockageConforme,
      observations,
      nbInfractions,
      amendeMin,
      amendeMax,
      rapport,
      $driftBlobEquality.hash(rapportPdf),
      creeLe);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ControleLigne &&
          other.id == this.id &&
          other.navireId == this.navireId &&
          other.agent == this.agent &&
          other.date == this.date &&
          other.latitude == this.latitude &&
          other.longitude == this.longitude &&
          other.engin == this.engin &&
          other.pavillonConforme == this.pavillonConforme &&
          other.marquageConforme == this.marquageConforme &&
          other.planStockageConforme == this.planStockageConforme &&
          other.observations == this.observations &&
          other.nbInfractions == this.nbInfractions &&
          other.amendeMin == this.amendeMin &&
          other.amendeMax == this.amendeMax &&
          other.rapport == this.rapport &&
          $driftBlobEquality.equals(other.rapportPdf, this.rapportPdf) &&
          other.creeLe == this.creeLe);
}

class ControlesCompanion extends UpdateCompanion<ControleLigne> {
  final Value<String> id;
  final Value<String> navireId;
  final Value<String> agent;
  final Value<DateTime> date;
  final Value<double> latitude;
  final Value<double> longitude;
  final Value<TypeEngin> engin;
  final Value<bool> pavillonConforme;
  final Value<bool> marquageConforme;
  final Value<bool> planStockageConforme;
  final Value<String> observations;
  final Value<int> nbInfractions;
  final Value<double> amendeMin;
  final Value<double> amendeMax;
  final Value<String> rapport;
  final Value<Uint8List?> rapportPdf;
  final Value<DateTime> creeLe;
  final Value<int> rowid;
  const ControlesCompanion({
    this.id = const Value.absent(),
    this.navireId = const Value.absent(),
    this.agent = const Value.absent(),
    this.date = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.engin = const Value.absent(),
    this.pavillonConforme = const Value.absent(),
    this.marquageConforme = const Value.absent(),
    this.planStockageConforme = const Value.absent(),
    this.observations = const Value.absent(),
    this.nbInfractions = const Value.absent(),
    this.amendeMin = const Value.absent(),
    this.amendeMax = const Value.absent(),
    this.rapport = const Value.absent(),
    this.rapportPdf = const Value.absent(),
    this.creeLe = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ControlesCompanion.insert({
    required String id,
    required String navireId,
    required String agent,
    required DateTime date,
    required double latitude,
    required double longitude,
    required TypeEngin engin,
    required bool pavillonConforme,
    required bool marquageConforme,
    required bool planStockageConforme,
    this.observations = const Value.absent(),
    required int nbInfractions,
    required double amendeMin,
    required double amendeMax,
    required String rapport,
    this.rapportPdf = const Value.absent(),
    this.creeLe = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        navireId = Value(navireId),
        agent = Value(agent),
        date = Value(date),
        latitude = Value(latitude),
        longitude = Value(longitude),
        engin = Value(engin),
        pavillonConforme = Value(pavillonConforme),
        marquageConforme = Value(marquageConforme),
        planStockageConforme = Value(planStockageConforme),
        nbInfractions = Value(nbInfractions),
        amendeMin = Value(amendeMin),
        amendeMax = Value(amendeMax),
        rapport = Value(rapport);
  static Insertable<ControleLigne> custom({
    Expression<String>? id,
    Expression<String>? navireId,
    Expression<String>? agent,
    Expression<DateTime>? date,
    Expression<double>? latitude,
    Expression<double>? longitude,
    Expression<String>? engin,
    Expression<bool>? pavillonConforme,
    Expression<bool>? marquageConforme,
    Expression<bool>? planStockageConforme,
    Expression<String>? observations,
    Expression<int>? nbInfractions,
    Expression<double>? amendeMin,
    Expression<double>? amendeMax,
    Expression<String>? rapport,
    Expression<Uint8List>? rapportPdf,
    Expression<DateTime>? creeLe,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (navireId != null) 'navire_id': navireId,
      if (agent != null) 'agent': agent,
      if (date != null) 'date': date,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (engin != null) 'engin': engin,
      if (pavillonConforme != null) 'pavillon_conforme': pavillonConforme,
      if (marquageConforme != null) 'marquage_conforme': marquageConforme,
      if (planStockageConforme != null)
        'plan_stockage_conforme': planStockageConforme,
      if (observations != null) 'observations': observations,
      if (nbInfractions != null) 'nb_infractions': nbInfractions,
      if (amendeMin != null) 'amende_min': amendeMin,
      if (amendeMax != null) 'amende_max': amendeMax,
      if (rapport != null) 'rapport': rapport,
      if (rapportPdf != null) 'rapport_pdf': rapportPdf,
      if (creeLe != null) 'cree_le': creeLe,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ControlesCompanion copyWith(
      {Value<String>? id,
      Value<String>? navireId,
      Value<String>? agent,
      Value<DateTime>? date,
      Value<double>? latitude,
      Value<double>? longitude,
      Value<TypeEngin>? engin,
      Value<bool>? pavillonConforme,
      Value<bool>? marquageConforme,
      Value<bool>? planStockageConforme,
      Value<String>? observations,
      Value<int>? nbInfractions,
      Value<double>? amendeMin,
      Value<double>? amendeMax,
      Value<String>? rapport,
      Value<Uint8List?>? rapportPdf,
      Value<DateTime>? creeLe,
      Value<int>? rowid}) {
    return ControlesCompanion(
      id: id ?? this.id,
      navireId: navireId ?? this.navireId,
      agent: agent ?? this.agent,
      date: date ?? this.date,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      engin: engin ?? this.engin,
      pavillonConforme: pavillonConforme ?? this.pavillonConforme,
      marquageConforme: marquageConforme ?? this.marquageConforme,
      planStockageConforme: planStockageConforme ?? this.planStockageConforme,
      observations: observations ?? this.observations,
      nbInfractions: nbInfractions ?? this.nbInfractions,
      amendeMin: amendeMin ?? this.amendeMin,
      amendeMax: amendeMax ?? this.amendeMax,
      rapport: rapport ?? this.rapport,
      rapportPdf: rapportPdf ?? this.rapportPdf,
      creeLe: creeLe ?? this.creeLe,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (navireId.present) {
      map['navire_id'] = Variable<String>(navireId.value);
    }
    if (agent.present) {
      map['agent'] = Variable<String>(agent.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (latitude.present) {
      map['latitude'] = Variable<double>(latitude.value);
    }
    if (longitude.present) {
      map['longitude'] = Variable<double>(longitude.value);
    }
    if (engin.present) {
      map['engin'] =
          Variable<String>($ControlesTable.$converterengin.toSql(engin.value));
    }
    if (pavillonConforme.present) {
      map['pavillon_conforme'] = Variable<bool>(pavillonConforme.value);
    }
    if (marquageConforme.present) {
      map['marquage_conforme'] = Variable<bool>(marquageConforme.value);
    }
    if (planStockageConforme.present) {
      map['plan_stockage_conforme'] =
          Variable<bool>(planStockageConforme.value);
    }
    if (observations.present) {
      map['observations'] = Variable<String>(observations.value);
    }
    if (nbInfractions.present) {
      map['nb_infractions'] = Variable<int>(nbInfractions.value);
    }
    if (amendeMin.present) {
      map['amende_min'] = Variable<double>(amendeMin.value);
    }
    if (amendeMax.present) {
      map['amende_max'] = Variable<double>(amendeMax.value);
    }
    if (rapport.present) {
      map['rapport'] = Variable<String>(rapport.value);
    }
    if (rapportPdf.present) {
      map['rapport_pdf'] = Variable<Uint8List>(rapportPdf.value);
    }
    if (creeLe.present) {
      map['cree_le'] = Variable<DateTime>(creeLe.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ControlesCompanion(')
          ..write('id: $id, ')
          ..write('navireId: $navireId, ')
          ..write('agent: $agent, ')
          ..write('date: $date, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('engin: $engin, ')
          ..write('pavillonConforme: $pavillonConforme, ')
          ..write('marquageConforme: $marquageConforme, ')
          ..write('planStockageConforme: $planStockageConforme, ')
          ..write('observations: $observations, ')
          ..write('nbInfractions: $nbInfractions, ')
          ..write('amendeMin: $amendeMin, ')
          ..write('amendeMax: $amendeMax, ')
          ..write('rapport: $rapport, ')
          ..write('rapportPdf: $rapportPdf, ')
          ..write('creeLe: $creeLe, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ControleMaillagesTable extends ControleMaillages
    with TableInfo<$ControleMaillagesTable, MaillageLigne> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ControleMaillagesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _controleIdMeta =
      const VerificationMeta('controleId');
  @override
  late final GeneratedColumn<String> controleId = GeneratedColumn<String>(
      'controle_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES controles (id) ON DELETE CASCADE'));
  static const VerificationMeta _mesureMmMeta =
      const VerificationMeta('mesureMm');
  @override
  late final GeneratedColumn<double> mesureMm = GeneratedColumn<double>(
      'mesure_mm', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, controleId, mesureMm];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'controle_maillages';
  @override
  VerificationContext validateIntegrity(Insertable<MaillageLigne> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('controle_id')) {
      context.handle(
          _controleIdMeta,
          controleId.isAcceptableOrUnknown(
              data['controle_id']!, _controleIdMeta));
    } else if (isInserting) {
      context.missing(_controleIdMeta);
    }
    if (data.containsKey('mesure_mm')) {
      context.handle(_mesureMmMeta,
          mesureMm.isAcceptableOrUnknown(data['mesure_mm']!, _mesureMmMeta));
    } else if (isInserting) {
      context.missing(_mesureMmMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MaillageLigne map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MaillageLigne(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      controleId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}controle_id'])!,
      mesureMm: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}mesure_mm'])!,
    );
  }

  @override
  $ControleMaillagesTable createAlias(String alias) {
    return $ControleMaillagesTable(attachedDatabase, alias);
  }
}

class MaillageLigne extends DataClass implements Insertable<MaillageLigne> {
  final int id;
  final String controleId;
  final double mesureMm;
  const MaillageLigne(
      {required this.id, required this.controleId, required this.mesureMm});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['controle_id'] = Variable<String>(controleId);
    map['mesure_mm'] = Variable<double>(mesureMm);
    return map;
  }

  ControleMaillagesCompanion toCompanion(bool nullToAbsent) {
    return ControleMaillagesCompanion(
      id: Value(id),
      controleId: Value(controleId),
      mesureMm: Value(mesureMm),
    );
  }

  factory MaillageLigne.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MaillageLigne(
      id: serializer.fromJson<int>(json['id']),
      controleId: serializer.fromJson<String>(json['controleId']),
      mesureMm: serializer.fromJson<double>(json['mesureMm']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'controleId': serializer.toJson<String>(controleId),
      'mesureMm': serializer.toJson<double>(mesureMm),
    };
  }

  MaillageLigne copyWith({int? id, String? controleId, double? mesureMm}) =>
      MaillageLigne(
        id: id ?? this.id,
        controleId: controleId ?? this.controleId,
        mesureMm: mesureMm ?? this.mesureMm,
      );
  MaillageLigne copyWithCompanion(ControleMaillagesCompanion data) {
    return MaillageLigne(
      id: data.id.present ? data.id.value : this.id,
      controleId:
          data.controleId.present ? data.controleId.value : this.controleId,
      mesureMm: data.mesureMm.present ? data.mesureMm.value : this.mesureMm,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MaillageLigne(')
          ..write('id: $id, ')
          ..write('controleId: $controleId, ')
          ..write('mesureMm: $mesureMm')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, controleId, mesureMm);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MaillageLigne &&
          other.id == this.id &&
          other.controleId == this.controleId &&
          other.mesureMm == this.mesureMm);
}

class ControleMaillagesCompanion extends UpdateCompanion<MaillageLigne> {
  final Value<int> id;
  final Value<String> controleId;
  final Value<double> mesureMm;
  const ControleMaillagesCompanion({
    this.id = const Value.absent(),
    this.controleId = const Value.absent(),
    this.mesureMm = const Value.absent(),
  });
  ControleMaillagesCompanion.insert({
    this.id = const Value.absent(),
    required String controleId,
    required double mesureMm,
  })  : controleId = Value(controleId),
        mesureMm = Value(mesureMm);
  static Insertable<MaillageLigne> custom({
    Expression<int>? id,
    Expression<String>? controleId,
    Expression<double>? mesureMm,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (controleId != null) 'controle_id': controleId,
      if (mesureMm != null) 'mesure_mm': mesureMm,
    });
  }

  ControleMaillagesCompanion copyWith(
      {Value<int>? id, Value<String>? controleId, Value<double>? mesureMm}) {
    return ControleMaillagesCompanion(
      id: id ?? this.id,
      controleId: controleId ?? this.controleId,
      mesureMm: mesureMm ?? this.mesureMm,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (controleId.present) {
      map['controle_id'] = Variable<String>(controleId.value);
    }
    if (mesureMm.present) {
      map['mesure_mm'] = Variable<double>(mesureMm.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ControleMaillagesCompanion(')
          ..write('id: $id, ')
          ..write('controleId: $controleId, ')
          ..write('mesureMm: $mesureMm')
          ..write(')'))
        .toString();
  }
}

class $ControleEchantillonsTable extends ControleEchantillons
    with TableInfo<$ControleEchantillonsTable, EchantillonLigne> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ControleEchantillonsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _controleIdMeta =
      const VerificationMeta('controleId');
  @override
  late final GeneratedColumn<String> controleId = GeneratedColumn<String>(
      'controle_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES controles (id) ON DELETE CASCADE'));
  static const VerificationMeta _especeCodeMeta =
      const VerificationMeta('especeCode');
  @override
  late final GeneratedColumn<String> especeCode = GeneratedColumn<String>(
      'espece_code', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 3, maxTextLength: 3),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _valeurMeta = const VerificationMeta('valeur');
  @override
  late final GeneratedColumn<double> valeur = GeneratedColumn<double>(
      'valeur', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, controleId, especeCode, valeur];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'controle_echantillons';
  @override
  VerificationContext validateIntegrity(Insertable<EchantillonLigne> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('controle_id')) {
      context.handle(
          _controleIdMeta,
          controleId.isAcceptableOrUnknown(
              data['controle_id']!, _controleIdMeta));
    } else if (isInserting) {
      context.missing(_controleIdMeta);
    }
    if (data.containsKey('espece_code')) {
      context.handle(
          _especeCodeMeta,
          especeCode.isAcceptableOrUnknown(
              data['espece_code']!, _especeCodeMeta));
    } else if (isInserting) {
      context.missing(_especeCodeMeta);
    }
    if (data.containsKey('valeur')) {
      context.handle(_valeurMeta,
          valeur.isAcceptableOrUnknown(data['valeur']!, _valeurMeta));
    } else if (isInserting) {
      context.missing(_valeurMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EchantillonLigne map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EchantillonLigne(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      controleId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}controle_id'])!,
      especeCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}espece_code'])!,
      valeur: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}valeur'])!,
    );
  }

  @override
  $ControleEchantillonsTable createAlias(String alias) {
    return $ControleEchantillonsTable(attachedDatabase, alias);
  }
}

class EchantillonLigne extends DataClass
    implements Insertable<EchantillonLigne> {
  final int id;
  final String controleId;
  final String especeCode;
  final double valeur;
  const EchantillonLigne(
      {required this.id,
      required this.controleId,
      required this.especeCode,
      required this.valeur});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['controle_id'] = Variable<String>(controleId);
    map['espece_code'] = Variable<String>(especeCode);
    map['valeur'] = Variable<double>(valeur);
    return map;
  }

  ControleEchantillonsCompanion toCompanion(bool nullToAbsent) {
    return ControleEchantillonsCompanion(
      id: Value(id),
      controleId: Value(controleId),
      especeCode: Value(especeCode),
      valeur: Value(valeur),
    );
  }

  factory EchantillonLigne.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EchantillonLigne(
      id: serializer.fromJson<int>(json['id']),
      controleId: serializer.fromJson<String>(json['controleId']),
      especeCode: serializer.fromJson<String>(json['especeCode']),
      valeur: serializer.fromJson<double>(json['valeur']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'controleId': serializer.toJson<String>(controleId),
      'especeCode': serializer.toJson<String>(especeCode),
      'valeur': serializer.toJson<double>(valeur),
    };
  }

  EchantillonLigne copyWith(
          {int? id, String? controleId, String? especeCode, double? valeur}) =>
      EchantillonLigne(
        id: id ?? this.id,
        controleId: controleId ?? this.controleId,
        especeCode: especeCode ?? this.especeCode,
        valeur: valeur ?? this.valeur,
      );
  EchantillonLigne copyWithCompanion(ControleEchantillonsCompanion data) {
    return EchantillonLigne(
      id: data.id.present ? data.id.value : this.id,
      controleId:
          data.controleId.present ? data.controleId.value : this.controleId,
      especeCode:
          data.especeCode.present ? data.especeCode.value : this.especeCode,
      valeur: data.valeur.present ? data.valeur.value : this.valeur,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EchantillonLigne(')
          ..write('id: $id, ')
          ..write('controleId: $controleId, ')
          ..write('especeCode: $especeCode, ')
          ..write('valeur: $valeur')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, controleId, especeCode, valeur);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EchantillonLigne &&
          other.id == this.id &&
          other.controleId == this.controleId &&
          other.especeCode == this.especeCode &&
          other.valeur == this.valeur);
}

class ControleEchantillonsCompanion extends UpdateCompanion<EchantillonLigne> {
  final Value<int> id;
  final Value<String> controleId;
  final Value<String> especeCode;
  final Value<double> valeur;
  const ControleEchantillonsCompanion({
    this.id = const Value.absent(),
    this.controleId = const Value.absent(),
    this.especeCode = const Value.absent(),
    this.valeur = const Value.absent(),
  });
  ControleEchantillonsCompanion.insert({
    this.id = const Value.absent(),
    required String controleId,
    required String especeCode,
    required double valeur,
  })  : controleId = Value(controleId),
        especeCode = Value(especeCode),
        valeur = Value(valeur);
  static Insertable<EchantillonLigne> custom({
    Expression<int>? id,
    Expression<String>? controleId,
    Expression<String>? especeCode,
    Expression<double>? valeur,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (controleId != null) 'controle_id': controleId,
      if (especeCode != null) 'espece_code': especeCode,
      if (valeur != null) 'valeur': valeur,
    });
  }

  ControleEchantillonsCompanion copyWith(
      {Value<int>? id,
      Value<String>? controleId,
      Value<String>? especeCode,
      Value<double>? valeur}) {
    return ControleEchantillonsCompanion(
      id: id ?? this.id,
      controleId: controleId ?? this.controleId,
      especeCode: especeCode ?? this.especeCode,
      valeur: valeur ?? this.valeur,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (controleId.present) {
      map['controle_id'] = Variable<String>(controleId.value);
    }
    if (especeCode.present) {
      map['espece_code'] = Variable<String>(especeCode.value);
    }
    if (valeur.present) {
      map['valeur'] = Variable<double>(valeur.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ControleEchantillonsCompanion(')
          ..write('id: $id, ')
          ..write('controleId: $controleId, ')
          ..write('especeCode: $especeCode, ')
          ..write('valeur: $valeur')
          ..write(')'))
        .toString();
  }
}

class $FileEnvoisTable extends FileEnvois
    with TableInfo<$FileEnvoisTable, EnvoiLigne> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FileEnvoisTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumnWithTypeConverter<TypeEnvoi, String> type =
      GeneratedColumn<String>('type', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<TypeEnvoi>($FileEnvoisTable.$convertertype);
  static const VerificationMeta _entiteIdMeta =
      const VerificationMeta('entiteId');
  @override
  late final GeneratedColumn<String> entiteId = GeneratedColumn<String>(
      'entite_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _resumeMeta = const VerificationMeta('resume');
  @override
  late final GeneratedColumn<String> resume = GeneratedColumn<String>(
      'resume', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _creeLeMeta = const VerificationMeta('creeLe');
  @override
  late final GeneratedColumn<DateTime> creeLe = GeneratedColumn<DateTime>(
      'cree_le', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _tentativesMeta =
      const VerificationMeta('tentatives');
  @override
  late final GeneratedColumn<int> tentatives = GeneratedColumn<int>(
      'tentatives', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _derniereErreurMeta =
      const VerificationMeta('derniereErreur');
  @override
  late final GeneratedColumn<String> derniereErreur = GeneratedColumn<String>(
      'derniere_erreur', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _envoyeLeMeta =
      const VerificationMeta('envoyeLe');
  @override
  late final GeneratedColumn<DateTime> envoyeLe = GeneratedColumn<DateTime>(
      'envoye_le', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        type,
        entiteId,
        resume,
        creeLe,
        tentatives,
        derniereErreur,
        envoyeLe
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'file_envois';
  @override
  VerificationContext validateIntegrity(Insertable<EnvoiLigne> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    context.handle(_typeMeta, const VerificationResult.success());
    if (data.containsKey('entite_id')) {
      context.handle(_entiteIdMeta,
          entiteId.isAcceptableOrUnknown(data['entite_id']!, _entiteIdMeta));
    } else if (isInserting) {
      context.missing(_entiteIdMeta);
    }
    if (data.containsKey('resume')) {
      context.handle(_resumeMeta,
          resume.isAcceptableOrUnknown(data['resume']!, _resumeMeta));
    } else if (isInserting) {
      context.missing(_resumeMeta);
    }
    if (data.containsKey('cree_le')) {
      context.handle(_creeLeMeta,
          creeLe.isAcceptableOrUnknown(data['cree_le']!, _creeLeMeta));
    }
    if (data.containsKey('tentatives')) {
      context.handle(
          _tentativesMeta,
          tentatives.isAcceptableOrUnknown(
              data['tentatives']!, _tentativesMeta));
    }
    if (data.containsKey('derniere_erreur')) {
      context.handle(
          _derniereErreurMeta,
          derniereErreur.isAcceptableOrUnknown(
              data['derniere_erreur']!, _derniereErreurMeta));
    }
    if (data.containsKey('envoye_le')) {
      context.handle(_envoyeLeMeta,
          envoyeLe.isAcceptableOrUnknown(data['envoye_le']!, _envoyeLeMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EnvoiLigne map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EnvoiLigne(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      type: $FileEnvoisTable.$convertertype.fromSql(attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!),
      entiteId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}entite_id'])!,
      resume: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}resume'])!,
      creeLe: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}cree_le'])!,
      tentatives: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}tentatives'])!,
      derniereErreur: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}derniere_erreur']),
      envoyeLe: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}envoye_le']),
    );
  }

  @override
  $FileEnvoisTable createAlias(String alias) {
    return $FileEnvoisTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<TypeEnvoi, String, String> $convertertype =
      const EnumNameConverter<TypeEnvoi>(TypeEnvoi.values);
}

class EnvoiLigne extends DataClass implements Insertable<EnvoiLigne> {
  final int id;
  final TypeEnvoi type;
  final String entiteId;

  /// Résumé lisible affiché dans l'écran « Envois en attente ».
  final String resume;
  final DateTime creeLe;
  final int tentatives;
  final String? derniereErreur;

  /// NULL tant que le serveur n'a pas confirmé la réception.
  final DateTime? envoyeLe;
  const EnvoiLigne(
      {required this.id,
      required this.type,
      required this.entiteId,
      required this.resume,
      required this.creeLe,
      required this.tentatives,
      this.derniereErreur,
      this.envoyeLe});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    {
      map['type'] =
          Variable<String>($FileEnvoisTable.$convertertype.toSql(type));
    }
    map['entite_id'] = Variable<String>(entiteId);
    map['resume'] = Variable<String>(resume);
    map['cree_le'] = Variable<DateTime>(creeLe);
    map['tentatives'] = Variable<int>(tentatives);
    if (!nullToAbsent || derniereErreur != null) {
      map['derniere_erreur'] = Variable<String>(derniereErreur);
    }
    if (!nullToAbsent || envoyeLe != null) {
      map['envoye_le'] = Variable<DateTime>(envoyeLe);
    }
    return map;
  }

  FileEnvoisCompanion toCompanion(bool nullToAbsent) {
    return FileEnvoisCompanion(
      id: Value(id),
      type: Value(type),
      entiteId: Value(entiteId),
      resume: Value(resume),
      creeLe: Value(creeLe),
      tentatives: Value(tentatives),
      derniereErreur: derniereErreur == null && nullToAbsent
          ? const Value.absent()
          : Value(derniereErreur),
      envoyeLe: envoyeLe == null && nullToAbsent
          ? const Value.absent()
          : Value(envoyeLe),
    );
  }

  factory EnvoiLigne.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EnvoiLigne(
      id: serializer.fromJson<int>(json['id']),
      type: $FileEnvoisTable.$convertertype
          .fromJson(serializer.fromJson<String>(json['type'])),
      entiteId: serializer.fromJson<String>(json['entiteId']),
      resume: serializer.fromJson<String>(json['resume']),
      creeLe: serializer.fromJson<DateTime>(json['creeLe']),
      tentatives: serializer.fromJson<int>(json['tentatives']),
      derniereErreur: serializer.fromJson<String?>(json['derniereErreur']),
      envoyeLe: serializer.fromJson<DateTime?>(json['envoyeLe']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'type': serializer
          .toJson<String>($FileEnvoisTable.$convertertype.toJson(type)),
      'entiteId': serializer.toJson<String>(entiteId),
      'resume': serializer.toJson<String>(resume),
      'creeLe': serializer.toJson<DateTime>(creeLe),
      'tentatives': serializer.toJson<int>(tentatives),
      'derniereErreur': serializer.toJson<String?>(derniereErreur),
      'envoyeLe': serializer.toJson<DateTime?>(envoyeLe),
    };
  }

  EnvoiLigne copyWith(
          {int? id,
          TypeEnvoi? type,
          String? entiteId,
          String? resume,
          DateTime? creeLe,
          int? tentatives,
          Value<String?> derniereErreur = const Value.absent(),
          Value<DateTime?> envoyeLe = const Value.absent()}) =>
      EnvoiLigne(
        id: id ?? this.id,
        type: type ?? this.type,
        entiteId: entiteId ?? this.entiteId,
        resume: resume ?? this.resume,
        creeLe: creeLe ?? this.creeLe,
        tentatives: tentatives ?? this.tentatives,
        derniereErreur:
            derniereErreur.present ? derniereErreur.value : this.derniereErreur,
        envoyeLe: envoyeLe.present ? envoyeLe.value : this.envoyeLe,
      );
  EnvoiLigne copyWithCompanion(FileEnvoisCompanion data) {
    return EnvoiLigne(
      id: data.id.present ? data.id.value : this.id,
      type: data.type.present ? data.type.value : this.type,
      entiteId: data.entiteId.present ? data.entiteId.value : this.entiteId,
      resume: data.resume.present ? data.resume.value : this.resume,
      creeLe: data.creeLe.present ? data.creeLe.value : this.creeLe,
      tentatives:
          data.tentatives.present ? data.tentatives.value : this.tentatives,
      derniereErreur: data.derniereErreur.present
          ? data.derniereErreur.value
          : this.derniereErreur,
      envoyeLe: data.envoyeLe.present ? data.envoyeLe.value : this.envoyeLe,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EnvoiLigne(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('entiteId: $entiteId, ')
          ..write('resume: $resume, ')
          ..write('creeLe: $creeLe, ')
          ..write('tentatives: $tentatives, ')
          ..write('derniereErreur: $derniereErreur, ')
          ..write('envoyeLe: $envoyeLe')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, type, entiteId, resume, creeLe, tentatives, derniereErreur, envoyeLe);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EnvoiLigne &&
          other.id == this.id &&
          other.type == this.type &&
          other.entiteId == this.entiteId &&
          other.resume == this.resume &&
          other.creeLe == this.creeLe &&
          other.tentatives == this.tentatives &&
          other.derniereErreur == this.derniereErreur &&
          other.envoyeLe == this.envoyeLe);
}

class FileEnvoisCompanion extends UpdateCompanion<EnvoiLigne> {
  final Value<int> id;
  final Value<TypeEnvoi> type;
  final Value<String> entiteId;
  final Value<String> resume;
  final Value<DateTime> creeLe;
  final Value<int> tentatives;
  final Value<String?> derniereErreur;
  final Value<DateTime?> envoyeLe;
  const FileEnvoisCompanion({
    this.id = const Value.absent(),
    this.type = const Value.absent(),
    this.entiteId = const Value.absent(),
    this.resume = const Value.absent(),
    this.creeLe = const Value.absent(),
    this.tentatives = const Value.absent(),
    this.derniereErreur = const Value.absent(),
    this.envoyeLe = const Value.absent(),
  });
  FileEnvoisCompanion.insert({
    this.id = const Value.absent(),
    required TypeEnvoi type,
    required String entiteId,
    required String resume,
    this.creeLe = const Value.absent(),
    this.tentatives = const Value.absent(),
    this.derniereErreur = const Value.absent(),
    this.envoyeLe = const Value.absent(),
  })  : type = Value(type),
        entiteId = Value(entiteId),
        resume = Value(resume);
  static Insertable<EnvoiLigne> custom({
    Expression<int>? id,
    Expression<String>? type,
    Expression<String>? entiteId,
    Expression<String>? resume,
    Expression<DateTime>? creeLe,
    Expression<int>? tentatives,
    Expression<String>? derniereErreur,
    Expression<DateTime>? envoyeLe,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (type != null) 'type': type,
      if (entiteId != null) 'entite_id': entiteId,
      if (resume != null) 'resume': resume,
      if (creeLe != null) 'cree_le': creeLe,
      if (tentatives != null) 'tentatives': tentatives,
      if (derniereErreur != null) 'derniere_erreur': derniereErreur,
      if (envoyeLe != null) 'envoye_le': envoyeLe,
    });
  }

  FileEnvoisCompanion copyWith(
      {Value<int>? id,
      Value<TypeEnvoi>? type,
      Value<String>? entiteId,
      Value<String>? resume,
      Value<DateTime>? creeLe,
      Value<int>? tentatives,
      Value<String?>? derniereErreur,
      Value<DateTime?>? envoyeLe}) {
    return FileEnvoisCompanion(
      id: id ?? this.id,
      type: type ?? this.type,
      entiteId: entiteId ?? this.entiteId,
      resume: resume ?? this.resume,
      creeLe: creeLe ?? this.creeLe,
      tentatives: tentatives ?? this.tentatives,
      derniereErreur: derniereErreur ?? this.derniereErreur,
      envoyeLe: envoyeLe ?? this.envoyeLe,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (type.present) {
      map['type'] =
          Variable<String>($FileEnvoisTable.$convertertype.toSql(type.value));
    }
    if (entiteId.present) {
      map['entite_id'] = Variable<String>(entiteId.value);
    }
    if (resume.present) {
      map['resume'] = Variable<String>(resume.value);
    }
    if (creeLe.present) {
      map['cree_le'] = Variable<DateTime>(creeLe.value);
    }
    if (tentatives.present) {
      map['tentatives'] = Variable<int>(tentatives.value);
    }
    if (derniereErreur.present) {
      map['derniere_erreur'] = Variable<String>(derniereErreur.value);
    }
    if (envoyeLe.present) {
      map['envoye_le'] = Variable<DateTime>(envoyeLe.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FileEnvoisCompanion(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('entiteId: $entiteId, ')
          ..write('resume: $resume, ')
          ..write('creeLe: $creeLe, ')
          ..write('tentatives: $tentatives, ')
          ..write('derniereErreur: $derniereErreur, ')
          ..write('envoyeLe: $envoyeLe')
          ..write(')'))
        .toString();
  }
}

class $ReglagesTable extends Reglages
    with TableInfo<$ReglagesTable, ReglageLigne> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReglagesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _cleMeta = const VerificationMeta('cle');
  @override
  late final GeneratedColumn<String> cle = GeneratedColumn<String>(
      'cle', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _valeurMeta = const VerificationMeta('valeur');
  @override
  late final GeneratedColumn<String> valeur = GeneratedColumn<String>(
      'valeur', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [cle, valeur];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'reglages';
  @override
  VerificationContext validateIntegrity(Insertable<ReglageLigne> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('cle')) {
      context.handle(
          _cleMeta, cle.isAcceptableOrUnknown(data['cle']!, _cleMeta));
    } else if (isInserting) {
      context.missing(_cleMeta);
    }
    if (data.containsKey('valeur')) {
      context.handle(_valeurMeta,
          valeur.isAcceptableOrUnknown(data['valeur']!, _valeurMeta));
    } else if (isInserting) {
      context.missing(_valeurMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {cle};
  @override
  ReglageLigne map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReglageLigne(
      cle: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}cle'])!,
      valeur: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}valeur'])!,
    );
  }

  @override
  $ReglagesTable createAlias(String alias) {
    return $ReglagesTable(attachedDatabase, alias);
  }
}

class ReglageLigne extends DataClass implements Insertable<ReglageLigne> {
  final String cle;
  final String valeur;
  const ReglageLigne({required this.cle, required this.valeur});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['cle'] = Variable<String>(cle);
    map['valeur'] = Variable<String>(valeur);
    return map;
  }

  ReglagesCompanion toCompanion(bool nullToAbsent) {
    return ReglagesCompanion(
      cle: Value(cle),
      valeur: Value(valeur),
    );
  }

  factory ReglageLigne.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReglageLigne(
      cle: serializer.fromJson<String>(json['cle']),
      valeur: serializer.fromJson<String>(json['valeur']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'cle': serializer.toJson<String>(cle),
      'valeur': serializer.toJson<String>(valeur),
    };
  }

  ReglageLigne copyWith({String? cle, String? valeur}) => ReglageLigne(
        cle: cle ?? this.cle,
        valeur: valeur ?? this.valeur,
      );
  ReglageLigne copyWithCompanion(ReglagesCompanion data) {
    return ReglageLigne(
      cle: data.cle.present ? data.cle.value : this.cle,
      valeur: data.valeur.present ? data.valeur.value : this.valeur,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReglageLigne(')
          ..write('cle: $cle, ')
          ..write('valeur: $valeur')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(cle, valeur);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReglageLigne &&
          other.cle == this.cle &&
          other.valeur == this.valeur);
}

class ReglagesCompanion extends UpdateCompanion<ReglageLigne> {
  final Value<String> cle;
  final Value<String> valeur;
  final Value<int> rowid;
  const ReglagesCompanion({
    this.cle = const Value.absent(),
    this.valeur = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ReglagesCompanion.insert({
    required String cle,
    required String valeur,
    this.rowid = const Value.absent(),
  })  : cle = Value(cle),
        valeur = Value(valeur);
  static Insertable<ReglageLigne> custom({
    Expression<String>? cle,
    Expression<String>? valeur,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (cle != null) 'cle': cle,
      if (valeur != null) 'valeur': valeur,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ReglagesCompanion copyWith(
      {Value<String>? cle, Value<String>? valeur, Value<int>? rowid}) {
    return ReglagesCompanion(
      cle: cle ?? this.cle,
      valeur: valeur ?? this.valeur,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (cle.present) {
      map['cle'] = Variable<String>(cle.value);
    }
    if (valeur.present) {
      map['valeur'] = Variable<String>(valeur.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReglagesCompanion(')
          ..write('cle: $cle, ')
          ..write('valeur: $valeur, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$BaseDeDonnees extends GeneratedDatabase {
  _$BaseDeDonnees(QueryExecutor e) : super(e);
  $BaseDeDonneesManager get managers => $BaseDeDonneesManager(this);
  late final $NaviresTable navires = $NaviresTable(this);
  late final $CertificatsTable certificats = $CertificatsTable(this);
  late final $LicencesTable licences = $LicencesTable(this);
  late final $QuotasTable quotas = $QuotasTable(this);
  late final $DeclarationsTable declarations = $DeclarationsTable(this);
  late final $EquipagesTable equipages = $EquipagesTable(this);
  late final $CapturesTable captures = $CapturesTable(this);
  late final $ControlesTable controles = $ControlesTable(this);
  late final $ControleMaillagesTable controleMaillages =
      $ControleMaillagesTable(this);
  late final $ControleEchantillonsTable controleEchantillons =
      $ControleEchantillonsTable(this);
  late final $FileEnvoisTable fileEnvois = $FileEnvoisTable(this);
  late final $ReglagesTable reglages = $ReglagesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        navires,
        certificats,
        licences,
        quotas,
        declarations,
        equipages,
        captures,
        controles,
        controleMaillages,
        controleEchantillons,
        fileEnvois,
        reglages
      ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules(
        [
          WritePropagation(
            on: TableUpdateQuery.onTableName('navires',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('certificats', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('licences',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('quotas', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('declarations',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('equipages', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('declarations',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('captures', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('controles',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('controle_maillages', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('controles',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('controle_echantillons', kind: UpdateKind.delete),
            ],
          ),
        ],
      );
}

typedef $$NaviresTableCreateCompanionBuilder = NaviresCompanion Function({
  required String id,
  required String nom,
  required String immatriculation,
  required String pavillon,
  required TypeNavire type,
  required double longueurM,
  required double puissanceKw,
  Value<String?> numeroImo,
  Value<int> rowid,
});
typedef $$NaviresTableUpdateCompanionBuilder = NaviresCompanion Function({
  Value<String> id,
  Value<String> nom,
  Value<String> immatriculation,
  Value<String> pavillon,
  Value<TypeNavire> type,
  Value<double> longueurM,
  Value<double> puissanceKw,
  Value<String?> numeroImo,
  Value<int> rowid,
});

final class $$NaviresTableReferences
    extends BaseReferences<_$BaseDeDonnees, $NaviresTable, NavireLigne> {
  $$NaviresTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$CertificatsTable, List<CertificatLigne>>
      _certificatsRefsTable(_$BaseDeDonnees db) =>
          MultiTypedResultKey.fromTable(db.certificats,
              aliasName:
                  $_aliasNameGenerator(db.navires.id, db.certificats.navireId));

  $$CertificatsTableProcessedTableManager get certificatsRefs {
    final manager = $$CertificatsTableTableManager($_db, $_db.certificats)
        .filter((f) => f.navireId.id($_item.id));

    final cache = $_typedResult.readTableOrNull(_certificatsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$LicencesTable, List<LicenceLigne>>
      _licencesRefsTable(_$BaseDeDonnees db) => MultiTypedResultKey.fromTable(
          db.licences,
          aliasName: $_aliasNameGenerator(db.navires.id, db.licences.navireId));

  $$LicencesTableProcessedTableManager get licencesRefs {
    final manager = $$LicencesTableTableManager($_db, $_db.licences)
        .filter((f) => f.navireId.id($_item.id));

    final cache = $_typedResult.readTableOrNull(_licencesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$DeclarationsTable, List<DeclarationLigne>>
      _declarationsRefsTable(_$BaseDeDonnees db) =>
          MultiTypedResultKey.fromTable(db.declarations,
              aliasName: $_aliasNameGenerator(
                  db.navires.id, db.declarations.navireId));

  $$DeclarationsTableProcessedTableManager get declarationsRefs {
    final manager = $$DeclarationsTableTableManager($_db, $_db.declarations)
        .filter((f) => f.navireId.id($_item.id));

    final cache = $_typedResult.readTableOrNull(_declarationsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$ControlesTable, List<ControleLigne>>
      _controlesRefsTable(_$BaseDeDonnees db) =>
          MultiTypedResultKey.fromTable(db.controles,
              aliasName:
                  $_aliasNameGenerator(db.navires.id, db.controles.navireId));

  $$ControlesTableProcessedTableManager get controlesRefs {
    final manager = $$ControlesTableTableManager($_db, $_db.controles)
        .filter((f) => f.navireId.id($_item.id));

    final cache = $_typedResult.readTableOrNull(_controlesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$NaviresTableFilterComposer
    extends Composer<_$BaseDeDonnees, $NaviresTable> {
  $$NaviresTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nom => $composableBuilder(
      column: $table.nom, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get immatriculation => $composableBuilder(
      column: $table.immatriculation,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get pavillon => $composableBuilder(
      column: $table.pavillon, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<TypeNavire, TypeNavire, String> get type =>
      $composableBuilder(
          column: $table.type,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<double> get longueurM => $composableBuilder(
      column: $table.longueurM, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get puissanceKw => $composableBuilder(
      column: $table.puissanceKw, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get numeroImo => $composableBuilder(
      column: $table.numeroImo, builder: (column) => ColumnFilters(column));

  Expression<bool> certificatsRefs(
      Expression<bool> Function($$CertificatsTableFilterComposer f) f) {
    final $$CertificatsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.certificats,
        getReferencedColumn: (t) => t.navireId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CertificatsTableFilterComposer(
              $db: $db,
              $table: $db.certificats,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> licencesRefs(
      Expression<bool> Function($$LicencesTableFilterComposer f) f) {
    final $$LicencesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.licences,
        getReferencedColumn: (t) => t.navireId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$LicencesTableFilterComposer(
              $db: $db,
              $table: $db.licences,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> declarationsRefs(
      Expression<bool> Function($$DeclarationsTableFilterComposer f) f) {
    final $$DeclarationsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.declarations,
        getReferencedColumn: (t) => t.navireId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DeclarationsTableFilterComposer(
              $db: $db,
              $table: $db.declarations,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> controlesRefs(
      Expression<bool> Function($$ControlesTableFilterComposer f) f) {
    final $$ControlesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.controles,
        getReferencedColumn: (t) => t.navireId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ControlesTableFilterComposer(
              $db: $db,
              $table: $db.controles,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$NaviresTableOrderingComposer
    extends Composer<_$BaseDeDonnees, $NaviresTable> {
  $$NaviresTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nom => $composableBuilder(
      column: $table.nom, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get immatriculation => $composableBuilder(
      column: $table.immatriculation,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get pavillon => $composableBuilder(
      column: $table.pavillon, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get longueurM => $composableBuilder(
      column: $table.longueurM, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get puissanceKw => $composableBuilder(
      column: $table.puissanceKw, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get numeroImo => $composableBuilder(
      column: $table.numeroImo, builder: (column) => ColumnOrderings(column));
}

class $$NaviresTableAnnotationComposer
    extends Composer<_$BaseDeDonnees, $NaviresTable> {
  $$NaviresTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nom =>
      $composableBuilder(column: $table.nom, builder: (column) => column);

  GeneratedColumn<String> get immatriculation => $composableBuilder(
      column: $table.immatriculation, builder: (column) => column);

  GeneratedColumn<String> get pavillon =>
      $composableBuilder(column: $table.pavillon, builder: (column) => column);

  GeneratedColumnWithTypeConverter<TypeNavire, String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<double> get longueurM =>
      $composableBuilder(column: $table.longueurM, builder: (column) => column);

  GeneratedColumn<double> get puissanceKw => $composableBuilder(
      column: $table.puissanceKw, builder: (column) => column);

  GeneratedColumn<String> get numeroImo =>
      $composableBuilder(column: $table.numeroImo, builder: (column) => column);

  Expression<T> certificatsRefs<T extends Object>(
      Expression<T> Function($$CertificatsTableAnnotationComposer a) f) {
    final $$CertificatsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.certificats,
        getReferencedColumn: (t) => t.navireId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CertificatsTableAnnotationComposer(
              $db: $db,
              $table: $db.certificats,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> licencesRefs<T extends Object>(
      Expression<T> Function($$LicencesTableAnnotationComposer a) f) {
    final $$LicencesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.licences,
        getReferencedColumn: (t) => t.navireId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$LicencesTableAnnotationComposer(
              $db: $db,
              $table: $db.licences,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> declarationsRefs<T extends Object>(
      Expression<T> Function($$DeclarationsTableAnnotationComposer a) f) {
    final $$DeclarationsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.declarations,
        getReferencedColumn: (t) => t.navireId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DeclarationsTableAnnotationComposer(
              $db: $db,
              $table: $db.declarations,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> controlesRefs<T extends Object>(
      Expression<T> Function($$ControlesTableAnnotationComposer a) f) {
    final $$ControlesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.controles,
        getReferencedColumn: (t) => t.navireId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ControlesTableAnnotationComposer(
              $db: $db,
              $table: $db.controles,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$NaviresTableTableManager extends RootTableManager<
    _$BaseDeDonnees,
    $NaviresTable,
    NavireLigne,
    $$NaviresTableFilterComposer,
    $$NaviresTableOrderingComposer,
    $$NaviresTableAnnotationComposer,
    $$NaviresTableCreateCompanionBuilder,
    $$NaviresTableUpdateCompanionBuilder,
    (NavireLigne, $$NaviresTableReferences),
    NavireLigne,
    PrefetchHooks Function(
        {bool certificatsRefs,
        bool licencesRefs,
        bool declarationsRefs,
        bool controlesRefs})> {
  $$NaviresTableTableManager(_$BaseDeDonnees db, $NaviresTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NaviresTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$NaviresTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$NaviresTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> nom = const Value.absent(),
            Value<String> immatriculation = const Value.absent(),
            Value<String> pavillon = const Value.absent(),
            Value<TypeNavire> type = const Value.absent(),
            Value<double> longueurM = const Value.absent(),
            Value<double> puissanceKw = const Value.absent(),
            Value<String?> numeroImo = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              NaviresCompanion(
            id: id,
            nom: nom,
            immatriculation: immatriculation,
            pavillon: pavillon,
            type: type,
            longueurM: longueurM,
            puissanceKw: puissanceKw,
            numeroImo: numeroImo,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String nom,
            required String immatriculation,
            required String pavillon,
            required TypeNavire type,
            required double longueurM,
            required double puissanceKw,
            Value<String?> numeroImo = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              NaviresCompanion.insert(
            id: id,
            nom: nom,
            immatriculation: immatriculation,
            pavillon: pavillon,
            type: type,
            longueurM: longueurM,
            puissanceKw: puissanceKw,
            numeroImo: numeroImo,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$NaviresTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: (
              {certificatsRefs = false,
              licencesRefs = false,
              declarationsRefs = false,
              controlesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (certificatsRefs) db.certificats,
                if (licencesRefs) db.licences,
                if (declarationsRefs) db.declarations,
                if (controlesRefs) db.controles
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (certificatsRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable:
                            $$NaviresTableReferences._certificatsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$NaviresTableReferences(db, table, p0)
                                .certificatsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.navireId == item.id),
                        typedResults: items),
                  if (licencesRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable:
                            $$NaviresTableReferences._licencesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$NaviresTableReferences(db, table, p0)
                                .licencesRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.navireId == item.id),
                        typedResults: items),
                  if (declarationsRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable:
                            $$NaviresTableReferences._declarationsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$NaviresTableReferences(db, table, p0)
                                .declarationsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.navireId == item.id),
                        typedResults: items),
                  if (controlesRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable:
                            $$NaviresTableReferences._controlesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$NaviresTableReferences(db, table, p0)
                                .controlesRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.navireId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$NaviresTableProcessedTableManager = ProcessedTableManager<
    _$BaseDeDonnees,
    $NaviresTable,
    NavireLigne,
    $$NaviresTableFilterComposer,
    $$NaviresTableOrderingComposer,
    $$NaviresTableAnnotationComposer,
    $$NaviresTableCreateCompanionBuilder,
    $$NaviresTableUpdateCompanionBuilder,
    (NavireLigne, $$NaviresTableReferences),
    NavireLigne,
    PrefetchHooks Function(
        {bool certificatsRefs,
        bool licencesRefs,
        bool declarationsRefs,
        bool controlesRefs})>;
typedef $$CertificatsTableCreateCompanionBuilder = CertificatsCompanion
    Function({
  Value<int> id,
  required String navireId,
  required TypeCertificat type,
  required String numero,
  required DateTime dateExpiration,
});
typedef $$CertificatsTableUpdateCompanionBuilder = CertificatsCompanion
    Function({
  Value<int> id,
  Value<String> navireId,
  Value<TypeCertificat> type,
  Value<String> numero,
  Value<DateTime> dateExpiration,
});

final class $$CertificatsTableReferences extends BaseReferences<_$BaseDeDonnees,
    $CertificatsTable, CertificatLigne> {
  $$CertificatsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $NaviresTable _navireIdTable(_$BaseDeDonnees db) =>
      db.navires.createAlias(
          $_aliasNameGenerator(db.certificats.navireId, db.navires.id));

  $$NaviresTableProcessedTableManager get navireId {
    final manager = $$NaviresTableTableManager($_db, $_db.navires)
        .filter((f) => f.id($_item.navireId));
    final item = $_typedResult.readTableOrNull(_navireIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$CertificatsTableFilterComposer
    extends Composer<_$BaseDeDonnees, $CertificatsTable> {
  $$CertificatsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<TypeCertificat, TypeCertificat, String>
      get type => $composableBuilder(
          column: $table.type,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<String> get numero => $composableBuilder(
      column: $table.numero, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get dateExpiration => $composableBuilder(
      column: $table.dateExpiration,
      builder: (column) => ColumnFilters(column));

  $$NaviresTableFilterComposer get navireId {
    final $$NaviresTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.navireId,
        referencedTable: $db.navires,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$NaviresTableFilterComposer(
              $db: $db,
              $table: $db.navires,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$CertificatsTableOrderingComposer
    extends Composer<_$BaseDeDonnees, $CertificatsTable> {
  $$CertificatsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get numero => $composableBuilder(
      column: $table.numero, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get dateExpiration => $composableBuilder(
      column: $table.dateExpiration,
      builder: (column) => ColumnOrderings(column));

  $$NaviresTableOrderingComposer get navireId {
    final $$NaviresTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.navireId,
        referencedTable: $db.navires,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$NaviresTableOrderingComposer(
              $db: $db,
              $table: $db.navires,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$CertificatsTableAnnotationComposer
    extends Composer<_$BaseDeDonnees, $CertificatsTable> {
  $$CertificatsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<TypeCertificat, String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get numero =>
      $composableBuilder(column: $table.numero, builder: (column) => column);

  GeneratedColumn<DateTime> get dateExpiration => $composableBuilder(
      column: $table.dateExpiration, builder: (column) => column);

  $$NaviresTableAnnotationComposer get navireId {
    final $$NaviresTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.navireId,
        referencedTable: $db.navires,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$NaviresTableAnnotationComposer(
              $db: $db,
              $table: $db.navires,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$CertificatsTableTableManager extends RootTableManager<
    _$BaseDeDonnees,
    $CertificatsTable,
    CertificatLigne,
    $$CertificatsTableFilterComposer,
    $$CertificatsTableOrderingComposer,
    $$CertificatsTableAnnotationComposer,
    $$CertificatsTableCreateCompanionBuilder,
    $$CertificatsTableUpdateCompanionBuilder,
    (CertificatLigne, $$CertificatsTableReferences),
    CertificatLigne,
    PrefetchHooks Function({bool navireId})> {
  $$CertificatsTableTableManager(_$BaseDeDonnees db, $CertificatsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CertificatsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CertificatsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CertificatsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> navireId = const Value.absent(),
            Value<TypeCertificat> type = const Value.absent(),
            Value<String> numero = const Value.absent(),
            Value<DateTime> dateExpiration = const Value.absent(),
          }) =>
              CertificatsCompanion(
            id: id,
            navireId: navireId,
            type: type,
            numero: numero,
            dateExpiration: dateExpiration,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String navireId,
            required TypeCertificat type,
            required String numero,
            required DateTime dateExpiration,
          }) =>
              CertificatsCompanion.insert(
            id: id,
            navireId: navireId,
            type: type,
            numero: numero,
            dateExpiration: dateExpiration,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$CertificatsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({navireId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (navireId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.navireId,
                    referencedTable:
                        $$CertificatsTableReferences._navireIdTable(db),
                    referencedColumn:
                        $$CertificatsTableReferences._navireIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$CertificatsTableProcessedTableManager = ProcessedTableManager<
    _$BaseDeDonnees,
    $CertificatsTable,
    CertificatLigne,
    $$CertificatsTableFilterComposer,
    $$CertificatsTableOrderingComposer,
    $$CertificatsTableAnnotationComposer,
    $$CertificatsTableCreateCompanionBuilder,
    $$CertificatsTableUpdateCompanionBuilder,
    (CertificatLigne, $$CertificatsTableReferences),
    CertificatLigne,
    PrefetchHooks Function({bool navireId})>;
typedef $$LicencesTableCreateCompanionBuilder = LicencesCompanion Function({
  required String numero,
  required String navireId,
  required TypePeche segment,
  required Set<TypeEngin> enginsAutorises,
  required Set<String> especesCibles,
  required DateTime dateDebut,
  required DateTime dateFin,
  Value<int> rowid,
});
typedef $$LicencesTableUpdateCompanionBuilder = LicencesCompanion Function({
  Value<String> numero,
  Value<String> navireId,
  Value<TypePeche> segment,
  Value<Set<TypeEngin>> enginsAutorises,
  Value<Set<String>> especesCibles,
  Value<DateTime> dateDebut,
  Value<DateTime> dateFin,
  Value<int> rowid,
});

final class $$LicencesTableReferences
    extends BaseReferences<_$BaseDeDonnees, $LicencesTable, LicenceLigne> {
  $$LicencesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $NaviresTable _navireIdTable(_$BaseDeDonnees db) => db.navires
      .createAlias($_aliasNameGenerator(db.licences.navireId, db.navires.id));

  $$NaviresTableProcessedTableManager get navireId {
    final manager = $$NaviresTableTableManager($_db, $_db.navires)
        .filter((f) => f.id($_item.navireId));
    final item = $_typedResult.readTableOrNull(_navireIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$QuotasTable, List<QuotaLigne>> _quotasRefsTable(
          _$BaseDeDonnees db) =>
      MultiTypedResultKey.fromTable(db.quotas,
          aliasName: $_aliasNameGenerator(
              db.licences.numero, db.quotas.licenceNumero));

  $$QuotasTableProcessedTableManager get quotasRefs {
    final manager = $$QuotasTableTableManager($_db, $_db.quotas)
        .filter((f) => f.licenceNumero.numero($_item.numero));

    final cache = $_typedResult.readTableOrNull(_quotasRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$DeclarationsTable, List<DeclarationLigne>>
      _declarationsRefsTable(_$BaseDeDonnees db) =>
          MultiTypedResultKey.fromTable(db.declarations,
              aliasName: $_aliasNameGenerator(
                  db.licences.numero, db.declarations.licenceNumero));

  $$DeclarationsTableProcessedTableManager get declarationsRefs {
    final manager = $$DeclarationsTableTableManager($_db, $_db.declarations)
        .filter((f) => f.licenceNumero.numero($_item.numero));

    final cache = $_typedResult.readTableOrNull(_declarationsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$LicencesTableFilterComposer
    extends Composer<_$BaseDeDonnees, $LicencesTable> {
  $$LicencesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get numero => $composableBuilder(
      column: $table.numero, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<TypePeche, TypePeche, String> get segment =>
      $composableBuilder(
          column: $table.segment,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnWithTypeConverterFilters<Set<TypeEngin>, Set<TypeEngin>, String>
      get enginsAutorises => $composableBuilder(
          column: $table.enginsAutorises,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnWithTypeConverterFilters<Set<String>, Set<String>, String>
      get especesCibles => $composableBuilder(
          column: $table.especesCibles,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<DateTime> get dateDebut => $composableBuilder(
      column: $table.dateDebut, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get dateFin => $composableBuilder(
      column: $table.dateFin, builder: (column) => ColumnFilters(column));

  $$NaviresTableFilterComposer get navireId {
    final $$NaviresTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.navireId,
        referencedTable: $db.navires,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$NaviresTableFilterComposer(
              $db: $db,
              $table: $db.navires,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> quotasRefs(
      Expression<bool> Function($$QuotasTableFilterComposer f) f) {
    final $$QuotasTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.numero,
        referencedTable: $db.quotas,
        getReferencedColumn: (t) => t.licenceNumero,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$QuotasTableFilterComposer(
              $db: $db,
              $table: $db.quotas,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> declarationsRefs(
      Expression<bool> Function($$DeclarationsTableFilterComposer f) f) {
    final $$DeclarationsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.numero,
        referencedTable: $db.declarations,
        getReferencedColumn: (t) => t.licenceNumero,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DeclarationsTableFilterComposer(
              $db: $db,
              $table: $db.declarations,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$LicencesTableOrderingComposer
    extends Composer<_$BaseDeDonnees, $LicencesTable> {
  $$LicencesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get numero => $composableBuilder(
      column: $table.numero, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get segment => $composableBuilder(
      column: $table.segment, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get enginsAutorises => $composableBuilder(
      column: $table.enginsAutorises,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get especesCibles => $composableBuilder(
      column: $table.especesCibles,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get dateDebut => $composableBuilder(
      column: $table.dateDebut, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get dateFin => $composableBuilder(
      column: $table.dateFin, builder: (column) => ColumnOrderings(column));

  $$NaviresTableOrderingComposer get navireId {
    final $$NaviresTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.navireId,
        referencedTable: $db.navires,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$NaviresTableOrderingComposer(
              $db: $db,
              $table: $db.navires,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$LicencesTableAnnotationComposer
    extends Composer<_$BaseDeDonnees, $LicencesTable> {
  $$LicencesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get numero =>
      $composableBuilder(column: $table.numero, builder: (column) => column);

  GeneratedColumnWithTypeConverter<TypePeche, String> get segment =>
      $composableBuilder(column: $table.segment, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Set<TypeEngin>, String>
      get enginsAutorises => $composableBuilder(
          column: $table.enginsAutorises, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Set<String>, String> get especesCibles =>
      $composableBuilder(
          column: $table.especesCibles, builder: (column) => column);

  GeneratedColumn<DateTime> get dateDebut =>
      $composableBuilder(column: $table.dateDebut, builder: (column) => column);

  GeneratedColumn<DateTime> get dateFin =>
      $composableBuilder(column: $table.dateFin, builder: (column) => column);

  $$NaviresTableAnnotationComposer get navireId {
    final $$NaviresTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.navireId,
        referencedTable: $db.navires,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$NaviresTableAnnotationComposer(
              $db: $db,
              $table: $db.navires,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> quotasRefs<T extends Object>(
      Expression<T> Function($$QuotasTableAnnotationComposer a) f) {
    final $$QuotasTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.numero,
        referencedTable: $db.quotas,
        getReferencedColumn: (t) => t.licenceNumero,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$QuotasTableAnnotationComposer(
              $db: $db,
              $table: $db.quotas,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> declarationsRefs<T extends Object>(
      Expression<T> Function($$DeclarationsTableAnnotationComposer a) f) {
    final $$DeclarationsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.numero,
        referencedTable: $db.declarations,
        getReferencedColumn: (t) => t.licenceNumero,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DeclarationsTableAnnotationComposer(
              $db: $db,
              $table: $db.declarations,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$LicencesTableTableManager extends RootTableManager<
    _$BaseDeDonnees,
    $LicencesTable,
    LicenceLigne,
    $$LicencesTableFilterComposer,
    $$LicencesTableOrderingComposer,
    $$LicencesTableAnnotationComposer,
    $$LicencesTableCreateCompanionBuilder,
    $$LicencesTableUpdateCompanionBuilder,
    (LicenceLigne, $$LicencesTableReferences),
    LicenceLigne,
    PrefetchHooks Function(
        {bool navireId, bool quotasRefs, bool declarationsRefs})> {
  $$LicencesTableTableManager(_$BaseDeDonnees db, $LicencesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LicencesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LicencesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LicencesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> numero = const Value.absent(),
            Value<String> navireId = const Value.absent(),
            Value<TypePeche> segment = const Value.absent(),
            Value<Set<TypeEngin>> enginsAutorises = const Value.absent(),
            Value<Set<String>> especesCibles = const Value.absent(),
            Value<DateTime> dateDebut = const Value.absent(),
            Value<DateTime> dateFin = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              LicencesCompanion(
            numero: numero,
            navireId: navireId,
            segment: segment,
            enginsAutorises: enginsAutorises,
            especesCibles: especesCibles,
            dateDebut: dateDebut,
            dateFin: dateFin,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String numero,
            required String navireId,
            required TypePeche segment,
            required Set<TypeEngin> enginsAutorises,
            required Set<String> especesCibles,
            required DateTime dateDebut,
            required DateTime dateFin,
            Value<int> rowid = const Value.absent(),
          }) =>
              LicencesCompanion.insert(
            numero: numero,
            navireId: navireId,
            segment: segment,
            enginsAutorises: enginsAutorises,
            especesCibles: especesCibles,
            dateDebut: dateDebut,
            dateFin: dateFin,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$LicencesTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: (
              {navireId = false,
              quotasRefs = false,
              declarationsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (quotasRefs) db.quotas,
                if (declarationsRefs) db.declarations
              ],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (navireId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.navireId,
                    referencedTable:
                        $$LicencesTableReferences._navireIdTable(db),
                    referencedColumn:
                        $$LicencesTableReferences._navireIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (quotasRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable:
                            $$LicencesTableReferences._quotasRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$LicencesTableReferences(db, table, p0).quotasRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.licenceNumero == item.numero),
                        typedResults: items),
                  if (declarationsRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable: $$LicencesTableReferences
                            ._declarationsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$LicencesTableReferences(db, table, p0)
                                .declarationsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.licenceNumero == item.numero),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$LicencesTableProcessedTableManager = ProcessedTableManager<
    _$BaseDeDonnees,
    $LicencesTable,
    LicenceLigne,
    $$LicencesTableFilterComposer,
    $$LicencesTableOrderingComposer,
    $$LicencesTableAnnotationComposer,
    $$LicencesTableCreateCompanionBuilder,
    $$LicencesTableUpdateCompanionBuilder,
    (LicenceLigne, $$LicencesTableReferences),
    LicenceLigne,
    PrefetchHooks Function(
        {bool navireId, bool quotasRefs, bool declarationsRefs})>;
typedef $$QuotasTableCreateCompanionBuilder = QuotasCompanion Function({
  required String licenceNumero,
  required String especeCode,
  required double quotaKg,
  Value<int> rowid,
});
typedef $$QuotasTableUpdateCompanionBuilder = QuotasCompanion Function({
  Value<String> licenceNumero,
  Value<String> especeCode,
  Value<double> quotaKg,
  Value<int> rowid,
});

final class $$QuotasTableReferences
    extends BaseReferences<_$BaseDeDonnees, $QuotasTable, QuotaLigne> {
  $$QuotasTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $LicencesTable _licenceNumeroTable(_$BaseDeDonnees db) =>
      db.licences.createAlias(
          $_aliasNameGenerator(db.quotas.licenceNumero, db.licences.numero));

  $$LicencesTableProcessedTableManager get licenceNumero {
    final manager = $$LicencesTableTableManager($_db, $_db.licences)
        .filter((f) => f.numero($_item.licenceNumero));
    final item = $_typedResult.readTableOrNull(_licenceNumeroTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$QuotasTableFilterComposer
    extends Composer<_$BaseDeDonnees, $QuotasTable> {
  $$QuotasTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get especeCode => $composableBuilder(
      column: $table.especeCode, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get quotaKg => $composableBuilder(
      column: $table.quotaKg, builder: (column) => ColumnFilters(column));

  $$LicencesTableFilterComposer get licenceNumero {
    final $$LicencesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.licenceNumero,
        referencedTable: $db.licences,
        getReferencedColumn: (t) => t.numero,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$LicencesTableFilterComposer(
              $db: $db,
              $table: $db.licences,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$QuotasTableOrderingComposer
    extends Composer<_$BaseDeDonnees, $QuotasTable> {
  $$QuotasTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get especeCode => $composableBuilder(
      column: $table.especeCode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get quotaKg => $composableBuilder(
      column: $table.quotaKg, builder: (column) => ColumnOrderings(column));

  $$LicencesTableOrderingComposer get licenceNumero {
    final $$LicencesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.licenceNumero,
        referencedTable: $db.licences,
        getReferencedColumn: (t) => t.numero,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$LicencesTableOrderingComposer(
              $db: $db,
              $table: $db.licences,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$QuotasTableAnnotationComposer
    extends Composer<_$BaseDeDonnees, $QuotasTable> {
  $$QuotasTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get especeCode => $composableBuilder(
      column: $table.especeCode, builder: (column) => column);

  GeneratedColumn<double> get quotaKg =>
      $composableBuilder(column: $table.quotaKg, builder: (column) => column);

  $$LicencesTableAnnotationComposer get licenceNumero {
    final $$LicencesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.licenceNumero,
        referencedTable: $db.licences,
        getReferencedColumn: (t) => t.numero,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$LicencesTableAnnotationComposer(
              $db: $db,
              $table: $db.licences,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$QuotasTableTableManager extends RootTableManager<
    _$BaseDeDonnees,
    $QuotasTable,
    QuotaLigne,
    $$QuotasTableFilterComposer,
    $$QuotasTableOrderingComposer,
    $$QuotasTableAnnotationComposer,
    $$QuotasTableCreateCompanionBuilder,
    $$QuotasTableUpdateCompanionBuilder,
    (QuotaLigne, $$QuotasTableReferences),
    QuotaLigne,
    PrefetchHooks Function({bool licenceNumero})> {
  $$QuotasTableTableManager(_$BaseDeDonnees db, $QuotasTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$QuotasTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$QuotasTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$QuotasTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> licenceNumero = const Value.absent(),
            Value<String> especeCode = const Value.absent(),
            Value<double> quotaKg = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              QuotasCompanion(
            licenceNumero: licenceNumero,
            especeCode: especeCode,
            quotaKg: quotaKg,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String licenceNumero,
            required String especeCode,
            required double quotaKg,
            Value<int> rowid = const Value.absent(),
          }) =>
              QuotasCompanion.insert(
            licenceNumero: licenceNumero,
            especeCode: especeCode,
            quotaKg: quotaKg,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$QuotasTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({licenceNumero = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (licenceNumero) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.licenceNumero,
                    referencedTable:
                        $$QuotasTableReferences._licenceNumeroTable(db),
                    referencedColumn:
                        $$QuotasTableReferences._licenceNumeroTable(db).numero,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$QuotasTableProcessedTableManager = ProcessedTableManager<
    _$BaseDeDonnees,
    $QuotasTable,
    QuotaLigne,
    $$QuotasTableFilterComposer,
    $$QuotasTableOrderingComposer,
    $$QuotasTableAnnotationComposer,
    $$QuotasTableCreateCompanionBuilder,
    $$QuotasTableUpdateCompanionBuilder,
    (QuotaLigne, $$QuotasTableReferences),
    QuotaLigne,
    PrefetchHooks Function({bool licenceNumero})>;
typedef $$DeclarationsTableCreateCompanionBuilder = DeclarationsCompanion
    Function({
  required String id,
  required String navireId,
  required String licenceNumero,
  required TypeEngin engin,
  required double latitude,
  required double longitude,
  required DateTime horodatage,
  Value<int> nbInfractions,
  Value<DateTime> creeLe,
  Value<int> rowid,
});
typedef $$DeclarationsTableUpdateCompanionBuilder = DeclarationsCompanion
    Function({
  Value<String> id,
  Value<String> navireId,
  Value<String> licenceNumero,
  Value<TypeEngin> engin,
  Value<double> latitude,
  Value<double> longitude,
  Value<DateTime> horodatage,
  Value<int> nbInfractions,
  Value<DateTime> creeLe,
  Value<int> rowid,
});

final class $$DeclarationsTableReferences extends BaseReferences<
    _$BaseDeDonnees, $DeclarationsTable, DeclarationLigne> {
  $$DeclarationsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $NaviresTable _navireIdTable(_$BaseDeDonnees db) =>
      db.navires.createAlias(
          $_aliasNameGenerator(db.declarations.navireId, db.navires.id));

  $$NaviresTableProcessedTableManager get navireId {
    final manager = $$NaviresTableTableManager($_db, $_db.navires)
        .filter((f) => f.id($_item.navireId));
    final item = $_typedResult.readTableOrNull(_navireIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $LicencesTable _licenceNumeroTable(_$BaseDeDonnees db) =>
      db.licences.createAlias($_aliasNameGenerator(
          db.declarations.licenceNumero, db.licences.numero));

  $$LicencesTableProcessedTableManager get licenceNumero {
    final manager = $$LicencesTableTableManager($_db, $_db.licences)
        .filter((f) => f.numero($_item.licenceNumero));
    final item = $_typedResult.readTableOrNull(_licenceNumeroTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$EquipagesTable, List<MembreEquipageLigne>>
      _equipagesRefsTable(_$BaseDeDonnees db) =>
          MultiTypedResultKey.fromTable(db.equipages,
              aliasName: $_aliasNameGenerator(
                  db.declarations.id, db.equipages.declarationId));

  $$EquipagesTableProcessedTableManager get equipagesRefs {
    final manager = $$EquipagesTableTableManager($_db, $_db.equipages)
        .filter((f) => f.declarationId.id($_item.id));

    final cache = $_typedResult.readTableOrNull(_equipagesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$CapturesTable, List<CaptureLigne>>
      _capturesRefsTable(_$BaseDeDonnees db) =>
          MultiTypedResultKey.fromTable(db.captures,
              aliasName: $_aliasNameGenerator(
                  db.declarations.id, db.captures.declarationId));

  $$CapturesTableProcessedTableManager get capturesRefs {
    final manager = $$CapturesTableTableManager($_db, $_db.captures)
        .filter((f) => f.declarationId.id($_item.id));

    final cache = $_typedResult.readTableOrNull(_capturesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$DeclarationsTableFilterComposer
    extends Composer<_$BaseDeDonnees, $DeclarationsTable> {
  $$DeclarationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<TypeEngin, TypeEngin, String> get engin =>
      $composableBuilder(
          column: $table.engin,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<double> get latitude => $composableBuilder(
      column: $table.latitude, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get longitude => $composableBuilder(
      column: $table.longitude, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get horodatage => $composableBuilder(
      column: $table.horodatage, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get nbInfractions => $composableBuilder(
      column: $table.nbInfractions, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get creeLe => $composableBuilder(
      column: $table.creeLe, builder: (column) => ColumnFilters(column));

  $$NaviresTableFilterComposer get navireId {
    final $$NaviresTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.navireId,
        referencedTable: $db.navires,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$NaviresTableFilterComposer(
              $db: $db,
              $table: $db.navires,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$LicencesTableFilterComposer get licenceNumero {
    final $$LicencesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.licenceNumero,
        referencedTable: $db.licences,
        getReferencedColumn: (t) => t.numero,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$LicencesTableFilterComposer(
              $db: $db,
              $table: $db.licences,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> equipagesRefs(
      Expression<bool> Function($$EquipagesTableFilterComposer f) f) {
    final $$EquipagesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.equipages,
        getReferencedColumn: (t) => t.declarationId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EquipagesTableFilterComposer(
              $db: $db,
              $table: $db.equipages,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> capturesRefs(
      Expression<bool> Function($$CapturesTableFilterComposer f) f) {
    final $$CapturesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.captures,
        getReferencedColumn: (t) => t.declarationId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CapturesTableFilterComposer(
              $db: $db,
              $table: $db.captures,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$DeclarationsTableOrderingComposer
    extends Composer<_$BaseDeDonnees, $DeclarationsTable> {
  $$DeclarationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get engin => $composableBuilder(
      column: $table.engin, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get latitude => $composableBuilder(
      column: $table.latitude, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get longitude => $composableBuilder(
      column: $table.longitude, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get horodatage => $composableBuilder(
      column: $table.horodatage, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get nbInfractions => $composableBuilder(
      column: $table.nbInfractions,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get creeLe => $composableBuilder(
      column: $table.creeLe, builder: (column) => ColumnOrderings(column));

  $$NaviresTableOrderingComposer get navireId {
    final $$NaviresTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.navireId,
        referencedTable: $db.navires,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$NaviresTableOrderingComposer(
              $db: $db,
              $table: $db.navires,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$LicencesTableOrderingComposer get licenceNumero {
    final $$LicencesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.licenceNumero,
        referencedTable: $db.licences,
        getReferencedColumn: (t) => t.numero,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$LicencesTableOrderingComposer(
              $db: $db,
              $table: $db.licences,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$DeclarationsTableAnnotationComposer
    extends Composer<_$BaseDeDonnees, $DeclarationsTable> {
  $$DeclarationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<TypeEngin, String> get engin =>
      $composableBuilder(column: $table.engin, builder: (column) => column);

  GeneratedColumn<double> get latitude =>
      $composableBuilder(column: $table.latitude, builder: (column) => column);

  GeneratedColumn<double> get longitude =>
      $composableBuilder(column: $table.longitude, builder: (column) => column);

  GeneratedColumn<DateTime> get horodatage => $composableBuilder(
      column: $table.horodatage, builder: (column) => column);

  GeneratedColumn<int> get nbInfractions => $composableBuilder(
      column: $table.nbInfractions, builder: (column) => column);

  GeneratedColumn<DateTime> get creeLe =>
      $composableBuilder(column: $table.creeLe, builder: (column) => column);

  $$NaviresTableAnnotationComposer get navireId {
    final $$NaviresTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.navireId,
        referencedTable: $db.navires,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$NaviresTableAnnotationComposer(
              $db: $db,
              $table: $db.navires,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$LicencesTableAnnotationComposer get licenceNumero {
    final $$LicencesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.licenceNumero,
        referencedTable: $db.licences,
        getReferencedColumn: (t) => t.numero,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$LicencesTableAnnotationComposer(
              $db: $db,
              $table: $db.licences,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> equipagesRefs<T extends Object>(
      Expression<T> Function($$EquipagesTableAnnotationComposer a) f) {
    final $$EquipagesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.equipages,
        getReferencedColumn: (t) => t.declarationId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EquipagesTableAnnotationComposer(
              $db: $db,
              $table: $db.equipages,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> capturesRefs<T extends Object>(
      Expression<T> Function($$CapturesTableAnnotationComposer a) f) {
    final $$CapturesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.captures,
        getReferencedColumn: (t) => t.declarationId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CapturesTableAnnotationComposer(
              $db: $db,
              $table: $db.captures,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$DeclarationsTableTableManager extends RootTableManager<
    _$BaseDeDonnees,
    $DeclarationsTable,
    DeclarationLigne,
    $$DeclarationsTableFilterComposer,
    $$DeclarationsTableOrderingComposer,
    $$DeclarationsTableAnnotationComposer,
    $$DeclarationsTableCreateCompanionBuilder,
    $$DeclarationsTableUpdateCompanionBuilder,
    (DeclarationLigne, $$DeclarationsTableReferences),
    DeclarationLigne,
    PrefetchHooks Function(
        {bool navireId,
        bool licenceNumero,
        bool equipagesRefs,
        bool capturesRefs})> {
  $$DeclarationsTableTableManager(_$BaseDeDonnees db, $DeclarationsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DeclarationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DeclarationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DeclarationsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> navireId = const Value.absent(),
            Value<String> licenceNumero = const Value.absent(),
            Value<TypeEngin> engin = const Value.absent(),
            Value<double> latitude = const Value.absent(),
            Value<double> longitude = const Value.absent(),
            Value<DateTime> horodatage = const Value.absent(),
            Value<int> nbInfractions = const Value.absent(),
            Value<DateTime> creeLe = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              DeclarationsCompanion(
            id: id,
            navireId: navireId,
            licenceNumero: licenceNumero,
            engin: engin,
            latitude: latitude,
            longitude: longitude,
            horodatage: horodatage,
            nbInfractions: nbInfractions,
            creeLe: creeLe,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String navireId,
            required String licenceNumero,
            required TypeEngin engin,
            required double latitude,
            required double longitude,
            required DateTime horodatage,
            Value<int> nbInfractions = const Value.absent(),
            Value<DateTime> creeLe = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              DeclarationsCompanion.insert(
            id: id,
            navireId: navireId,
            licenceNumero: licenceNumero,
            engin: engin,
            latitude: latitude,
            longitude: longitude,
            horodatage: horodatage,
            nbInfractions: nbInfractions,
            creeLe: creeLe,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$DeclarationsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {navireId = false,
              licenceNumero = false,
              equipagesRefs = false,
              capturesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (equipagesRefs) db.equipages,
                if (capturesRefs) db.captures
              ],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (navireId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.navireId,
                    referencedTable:
                        $$DeclarationsTableReferences._navireIdTable(db),
                    referencedColumn:
                        $$DeclarationsTableReferences._navireIdTable(db).id,
                  ) as T;
                }
                if (licenceNumero) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.licenceNumero,
                    referencedTable:
                        $$DeclarationsTableReferences._licenceNumeroTable(db),
                    referencedColumn: $$DeclarationsTableReferences
                        ._licenceNumeroTable(db)
                        .numero,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (equipagesRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable: $$DeclarationsTableReferences
                            ._equipagesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$DeclarationsTableReferences(db, table, p0)
                                .equipagesRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.declarationId == item.id),
                        typedResults: items),
                  if (capturesRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable: $$DeclarationsTableReferences
                            ._capturesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$DeclarationsTableReferences(db, table, p0)
                                .capturesRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.declarationId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$DeclarationsTableProcessedTableManager = ProcessedTableManager<
    _$BaseDeDonnees,
    $DeclarationsTable,
    DeclarationLigne,
    $$DeclarationsTableFilterComposer,
    $$DeclarationsTableOrderingComposer,
    $$DeclarationsTableAnnotationComposer,
    $$DeclarationsTableCreateCompanionBuilder,
    $$DeclarationsTableUpdateCompanionBuilder,
    (DeclarationLigne, $$DeclarationsTableReferences),
    DeclarationLigne,
    PrefetchHooks Function(
        {bool navireId,
        bool licenceNumero,
        bool equipagesRefs,
        bool capturesRefs})>;
typedef $$EquipagesTableCreateCompanionBuilder = EquipagesCompanion Function({
  Value<int> id,
  required String declarationId,
  required String nom,
  required String fonction,
  required String nationalite,
});
typedef $$EquipagesTableUpdateCompanionBuilder = EquipagesCompanion Function({
  Value<int> id,
  Value<String> declarationId,
  Value<String> nom,
  Value<String> fonction,
  Value<String> nationalite,
});

final class $$EquipagesTableReferences extends BaseReferences<_$BaseDeDonnees,
    $EquipagesTable, MembreEquipageLigne> {
  $$EquipagesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $DeclarationsTable _declarationIdTable(_$BaseDeDonnees db) =>
      db.declarations.createAlias(
          $_aliasNameGenerator(db.equipages.declarationId, db.declarations.id));

  $$DeclarationsTableProcessedTableManager get declarationId {
    final manager = $$DeclarationsTableTableManager($_db, $_db.declarations)
        .filter((f) => f.id($_item.declarationId));
    final item = $_typedResult.readTableOrNull(_declarationIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$EquipagesTableFilterComposer
    extends Composer<_$BaseDeDonnees, $EquipagesTable> {
  $$EquipagesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nom => $composableBuilder(
      column: $table.nom, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get fonction => $composableBuilder(
      column: $table.fonction, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nationalite => $composableBuilder(
      column: $table.nationalite, builder: (column) => ColumnFilters(column));

  $$DeclarationsTableFilterComposer get declarationId {
    final $$DeclarationsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.declarationId,
        referencedTable: $db.declarations,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DeclarationsTableFilterComposer(
              $db: $db,
              $table: $db.declarations,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$EquipagesTableOrderingComposer
    extends Composer<_$BaseDeDonnees, $EquipagesTable> {
  $$EquipagesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nom => $composableBuilder(
      column: $table.nom, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get fonction => $composableBuilder(
      column: $table.fonction, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nationalite => $composableBuilder(
      column: $table.nationalite, builder: (column) => ColumnOrderings(column));

  $$DeclarationsTableOrderingComposer get declarationId {
    final $$DeclarationsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.declarationId,
        referencedTable: $db.declarations,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DeclarationsTableOrderingComposer(
              $db: $db,
              $table: $db.declarations,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$EquipagesTableAnnotationComposer
    extends Composer<_$BaseDeDonnees, $EquipagesTable> {
  $$EquipagesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nom =>
      $composableBuilder(column: $table.nom, builder: (column) => column);

  GeneratedColumn<String> get fonction =>
      $composableBuilder(column: $table.fonction, builder: (column) => column);

  GeneratedColumn<String> get nationalite => $composableBuilder(
      column: $table.nationalite, builder: (column) => column);

  $$DeclarationsTableAnnotationComposer get declarationId {
    final $$DeclarationsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.declarationId,
        referencedTable: $db.declarations,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DeclarationsTableAnnotationComposer(
              $db: $db,
              $table: $db.declarations,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$EquipagesTableTableManager extends RootTableManager<
    _$BaseDeDonnees,
    $EquipagesTable,
    MembreEquipageLigne,
    $$EquipagesTableFilterComposer,
    $$EquipagesTableOrderingComposer,
    $$EquipagesTableAnnotationComposer,
    $$EquipagesTableCreateCompanionBuilder,
    $$EquipagesTableUpdateCompanionBuilder,
    (MembreEquipageLigne, $$EquipagesTableReferences),
    MembreEquipageLigne,
    PrefetchHooks Function({bool declarationId})> {
  $$EquipagesTableTableManager(_$BaseDeDonnees db, $EquipagesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EquipagesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EquipagesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EquipagesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> declarationId = const Value.absent(),
            Value<String> nom = const Value.absent(),
            Value<String> fonction = const Value.absent(),
            Value<String> nationalite = const Value.absent(),
          }) =>
              EquipagesCompanion(
            id: id,
            declarationId: declarationId,
            nom: nom,
            fonction: fonction,
            nationalite: nationalite,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String declarationId,
            required String nom,
            required String fonction,
            required String nationalite,
          }) =>
              EquipagesCompanion.insert(
            id: id,
            declarationId: declarationId,
            nom: nom,
            fonction: fonction,
            nationalite: nationalite,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$EquipagesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({declarationId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (declarationId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.declarationId,
                    referencedTable:
                        $$EquipagesTableReferences._declarationIdTable(db),
                    referencedColumn:
                        $$EquipagesTableReferences._declarationIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$EquipagesTableProcessedTableManager = ProcessedTableManager<
    _$BaseDeDonnees,
    $EquipagesTable,
    MembreEquipageLigne,
    $$EquipagesTableFilterComposer,
    $$EquipagesTableOrderingComposer,
    $$EquipagesTableAnnotationComposer,
    $$EquipagesTableCreateCompanionBuilder,
    $$EquipagesTableUpdateCompanionBuilder,
    (MembreEquipageLigne, $$EquipagesTableReferences),
    MembreEquipageLigne,
    PrefetchHooks Function({bool declarationId})>;
typedef $$CapturesTableCreateCompanionBuilder = CapturesCompanion Function({
  Value<int> id,
  required String declarationId,
  required String especeCode,
  required double poidsKg,
});
typedef $$CapturesTableUpdateCompanionBuilder = CapturesCompanion Function({
  Value<int> id,
  Value<String> declarationId,
  Value<String> especeCode,
  Value<double> poidsKg,
});

final class $$CapturesTableReferences
    extends BaseReferences<_$BaseDeDonnees, $CapturesTable, CaptureLigne> {
  $$CapturesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $DeclarationsTable _declarationIdTable(_$BaseDeDonnees db) =>
      db.declarations.createAlias(
          $_aliasNameGenerator(db.captures.declarationId, db.declarations.id));

  $$DeclarationsTableProcessedTableManager get declarationId {
    final manager = $$DeclarationsTableTableManager($_db, $_db.declarations)
        .filter((f) => f.id($_item.declarationId));
    final item = $_typedResult.readTableOrNull(_declarationIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$CapturesTableFilterComposer
    extends Composer<_$BaseDeDonnees, $CapturesTable> {
  $$CapturesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get especeCode => $composableBuilder(
      column: $table.especeCode, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get poidsKg => $composableBuilder(
      column: $table.poidsKg, builder: (column) => ColumnFilters(column));

  $$DeclarationsTableFilterComposer get declarationId {
    final $$DeclarationsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.declarationId,
        referencedTable: $db.declarations,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DeclarationsTableFilterComposer(
              $db: $db,
              $table: $db.declarations,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$CapturesTableOrderingComposer
    extends Composer<_$BaseDeDonnees, $CapturesTable> {
  $$CapturesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get especeCode => $composableBuilder(
      column: $table.especeCode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get poidsKg => $composableBuilder(
      column: $table.poidsKg, builder: (column) => ColumnOrderings(column));

  $$DeclarationsTableOrderingComposer get declarationId {
    final $$DeclarationsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.declarationId,
        referencedTable: $db.declarations,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DeclarationsTableOrderingComposer(
              $db: $db,
              $table: $db.declarations,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$CapturesTableAnnotationComposer
    extends Composer<_$BaseDeDonnees, $CapturesTable> {
  $$CapturesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get especeCode => $composableBuilder(
      column: $table.especeCode, builder: (column) => column);

  GeneratedColumn<double> get poidsKg =>
      $composableBuilder(column: $table.poidsKg, builder: (column) => column);

  $$DeclarationsTableAnnotationComposer get declarationId {
    final $$DeclarationsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.declarationId,
        referencedTable: $db.declarations,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DeclarationsTableAnnotationComposer(
              $db: $db,
              $table: $db.declarations,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$CapturesTableTableManager extends RootTableManager<
    _$BaseDeDonnees,
    $CapturesTable,
    CaptureLigne,
    $$CapturesTableFilterComposer,
    $$CapturesTableOrderingComposer,
    $$CapturesTableAnnotationComposer,
    $$CapturesTableCreateCompanionBuilder,
    $$CapturesTableUpdateCompanionBuilder,
    (CaptureLigne, $$CapturesTableReferences),
    CaptureLigne,
    PrefetchHooks Function({bool declarationId})> {
  $$CapturesTableTableManager(_$BaseDeDonnees db, $CapturesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CapturesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CapturesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CapturesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> declarationId = const Value.absent(),
            Value<String> especeCode = const Value.absent(),
            Value<double> poidsKg = const Value.absent(),
          }) =>
              CapturesCompanion(
            id: id,
            declarationId: declarationId,
            especeCode: especeCode,
            poidsKg: poidsKg,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String declarationId,
            required String especeCode,
            required double poidsKg,
          }) =>
              CapturesCompanion.insert(
            id: id,
            declarationId: declarationId,
            especeCode: especeCode,
            poidsKg: poidsKg,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$CapturesTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({declarationId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (declarationId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.declarationId,
                    referencedTable:
                        $$CapturesTableReferences._declarationIdTable(db),
                    referencedColumn:
                        $$CapturesTableReferences._declarationIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$CapturesTableProcessedTableManager = ProcessedTableManager<
    _$BaseDeDonnees,
    $CapturesTable,
    CaptureLigne,
    $$CapturesTableFilterComposer,
    $$CapturesTableOrderingComposer,
    $$CapturesTableAnnotationComposer,
    $$CapturesTableCreateCompanionBuilder,
    $$CapturesTableUpdateCompanionBuilder,
    (CaptureLigne, $$CapturesTableReferences),
    CaptureLigne,
    PrefetchHooks Function({bool declarationId})>;
typedef $$ControlesTableCreateCompanionBuilder = ControlesCompanion Function({
  required String id,
  required String navireId,
  required String agent,
  required DateTime date,
  required double latitude,
  required double longitude,
  required TypeEngin engin,
  required bool pavillonConforme,
  required bool marquageConforme,
  required bool planStockageConforme,
  Value<String> observations,
  required int nbInfractions,
  required double amendeMin,
  required double amendeMax,
  required String rapport,
  Value<Uint8List?> rapportPdf,
  Value<DateTime> creeLe,
  Value<int> rowid,
});
typedef $$ControlesTableUpdateCompanionBuilder = ControlesCompanion Function({
  Value<String> id,
  Value<String> navireId,
  Value<String> agent,
  Value<DateTime> date,
  Value<double> latitude,
  Value<double> longitude,
  Value<TypeEngin> engin,
  Value<bool> pavillonConforme,
  Value<bool> marquageConforme,
  Value<bool> planStockageConforme,
  Value<String> observations,
  Value<int> nbInfractions,
  Value<double> amendeMin,
  Value<double> amendeMax,
  Value<String> rapport,
  Value<Uint8List?> rapportPdf,
  Value<DateTime> creeLe,
  Value<int> rowid,
});

final class $$ControlesTableReferences
    extends BaseReferences<_$BaseDeDonnees, $ControlesTable, ControleLigne> {
  $$ControlesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $NaviresTable _navireIdTable(_$BaseDeDonnees db) => db.navires
      .createAlias($_aliasNameGenerator(db.controles.navireId, db.navires.id));

  $$NaviresTableProcessedTableManager get navireId {
    final manager = $$NaviresTableTableManager($_db, $_db.navires)
        .filter((f) => f.id($_item.navireId));
    final item = $_typedResult.readTableOrNull(_navireIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$ControleMaillagesTable, List<MaillageLigne>>
      _controleMaillagesRefsTable(_$BaseDeDonnees db) =>
          MultiTypedResultKey.fromTable(db.controleMaillages,
              aliasName: $_aliasNameGenerator(
                  db.controles.id, db.controleMaillages.controleId));

  $$ControleMaillagesTableProcessedTableManager get controleMaillagesRefs {
    final manager =
        $$ControleMaillagesTableTableManager($_db, $_db.controleMaillages)
            .filter((f) => f.controleId.id($_item.id));

    final cache =
        $_typedResult.readTableOrNull(_controleMaillagesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$ControleEchantillonsTable, List<EchantillonLigne>>
      _controleEchantillonsRefsTable(_$BaseDeDonnees db) =>
          MultiTypedResultKey.fromTable(db.controleEchantillons,
              aliasName: $_aliasNameGenerator(
                  db.controles.id, db.controleEchantillons.controleId));

  $$ControleEchantillonsTableProcessedTableManager
      get controleEchantillonsRefs {
    final manager =
        $$ControleEchantillonsTableTableManager($_db, $_db.controleEchantillons)
            .filter((f) => f.controleId.id($_item.id));

    final cache =
        $_typedResult.readTableOrNull(_controleEchantillonsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$ControlesTableFilterComposer
    extends Composer<_$BaseDeDonnees, $ControlesTable> {
  $$ControlesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get agent => $composableBuilder(
      column: $table.agent, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get latitude => $composableBuilder(
      column: $table.latitude, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get longitude => $composableBuilder(
      column: $table.longitude, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<TypeEngin, TypeEngin, String> get engin =>
      $composableBuilder(
          column: $table.engin,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<bool> get pavillonConforme => $composableBuilder(
      column: $table.pavillonConforme,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get marquageConforme => $composableBuilder(
      column: $table.marquageConforme,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get planStockageConforme => $composableBuilder(
      column: $table.planStockageConforme,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get observations => $composableBuilder(
      column: $table.observations, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get nbInfractions => $composableBuilder(
      column: $table.nbInfractions, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get amendeMin => $composableBuilder(
      column: $table.amendeMin, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get amendeMax => $composableBuilder(
      column: $table.amendeMax, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get rapport => $composableBuilder(
      column: $table.rapport, builder: (column) => ColumnFilters(column));

  ColumnFilters<Uint8List> get rapportPdf => $composableBuilder(
      column: $table.rapportPdf, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get creeLe => $composableBuilder(
      column: $table.creeLe, builder: (column) => ColumnFilters(column));

  $$NaviresTableFilterComposer get navireId {
    final $$NaviresTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.navireId,
        referencedTable: $db.navires,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$NaviresTableFilterComposer(
              $db: $db,
              $table: $db.navires,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> controleMaillagesRefs(
      Expression<bool> Function($$ControleMaillagesTableFilterComposer f) f) {
    final $$ControleMaillagesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.controleMaillages,
        getReferencedColumn: (t) => t.controleId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ControleMaillagesTableFilterComposer(
              $db: $db,
              $table: $db.controleMaillages,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> controleEchantillonsRefs(
      Expression<bool> Function($$ControleEchantillonsTableFilterComposer f)
          f) {
    final $$ControleEchantillonsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.controleEchantillons,
        getReferencedColumn: (t) => t.controleId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ControleEchantillonsTableFilterComposer(
              $db: $db,
              $table: $db.controleEchantillons,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ControlesTableOrderingComposer
    extends Composer<_$BaseDeDonnees, $ControlesTable> {
  $$ControlesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get agent => $composableBuilder(
      column: $table.agent, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get latitude => $composableBuilder(
      column: $table.latitude, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get longitude => $composableBuilder(
      column: $table.longitude, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get engin => $composableBuilder(
      column: $table.engin, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get pavillonConforme => $composableBuilder(
      column: $table.pavillonConforme,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get marquageConforme => $composableBuilder(
      column: $table.marquageConforme,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get planStockageConforme => $composableBuilder(
      column: $table.planStockageConforme,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get observations => $composableBuilder(
      column: $table.observations,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get nbInfractions => $composableBuilder(
      column: $table.nbInfractions,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get amendeMin => $composableBuilder(
      column: $table.amendeMin, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get amendeMax => $composableBuilder(
      column: $table.amendeMax, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get rapport => $composableBuilder(
      column: $table.rapport, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<Uint8List> get rapportPdf => $composableBuilder(
      column: $table.rapportPdf, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get creeLe => $composableBuilder(
      column: $table.creeLe, builder: (column) => ColumnOrderings(column));

  $$NaviresTableOrderingComposer get navireId {
    final $$NaviresTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.navireId,
        referencedTable: $db.navires,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$NaviresTableOrderingComposer(
              $db: $db,
              $table: $db.navires,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ControlesTableAnnotationComposer
    extends Composer<_$BaseDeDonnees, $ControlesTable> {
  $$ControlesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get agent =>
      $composableBuilder(column: $table.agent, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<double> get latitude =>
      $composableBuilder(column: $table.latitude, builder: (column) => column);

  GeneratedColumn<double> get longitude =>
      $composableBuilder(column: $table.longitude, builder: (column) => column);

  GeneratedColumnWithTypeConverter<TypeEngin, String> get engin =>
      $composableBuilder(column: $table.engin, builder: (column) => column);

  GeneratedColumn<bool> get pavillonConforme => $composableBuilder(
      column: $table.pavillonConforme, builder: (column) => column);

  GeneratedColumn<bool> get marquageConforme => $composableBuilder(
      column: $table.marquageConforme, builder: (column) => column);

  GeneratedColumn<bool> get planStockageConforme => $composableBuilder(
      column: $table.planStockageConforme, builder: (column) => column);

  GeneratedColumn<String> get observations => $composableBuilder(
      column: $table.observations, builder: (column) => column);

  GeneratedColumn<int> get nbInfractions => $composableBuilder(
      column: $table.nbInfractions, builder: (column) => column);

  GeneratedColumn<double> get amendeMin =>
      $composableBuilder(column: $table.amendeMin, builder: (column) => column);

  GeneratedColumn<double> get amendeMax =>
      $composableBuilder(column: $table.amendeMax, builder: (column) => column);

  GeneratedColumn<String> get rapport =>
      $composableBuilder(column: $table.rapport, builder: (column) => column);

  GeneratedColumn<Uint8List> get rapportPdf => $composableBuilder(
      column: $table.rapportPdf, builder: (column) => column);

  GeneratedColumn<DateTime> get creeLe =>
      $composableBuilder(column: $table.creeLe, builder: (column) => column);

  $$NaviresTableAnnotationComposer get navireId {
    final $$NaviresTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.navireId,
        referencedTable: $db.navires,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$NaviresTableAnnotationComposer(
              $db: $db,
              $table: $db.navires,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> controleMaillagesRefs<T extends Object>(
      Expression<T> Function($$ControleMaillagesTableAnnotationComposer a) f) {
    final $$ControleMaillagesTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.controleMaillages,
            getReferencedColumn: (t) => t.controleId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$ControleMaillagesTableAnnotationComposer(
                  $db: $db,
                  $table: $db.controleMaillages,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }

  Expression<T> controleEchantillonsRefs<T extends Object>(
      Expression<T> Function($$ControleEchantillonsTableAnnotationComposer a)
          f) {
    final $$ControleEchantillonsTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.controleEchantillons,
            getReferencedColumn: (t) => t.controleId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$ControleEchantillonsTableAnnotationComposer(
                  $db: $db,
                  $table: $db.controleEchantillons,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$ControlesTableTableManager extends RootTableManager<
    _$BaseDeDonnees,
    $ControlesTable,
    ControleLigne,
    $$ControlesTableFilterComposer,
    $$ControlesTableOrderingComposer,
    $$ControlesTableAnnotationComposer,
    $$ControlesTableCreateCompanionBuilder,
    $$ControlesTableUpdateCompanionBuilder,
    (ControleLigne, $$ControlesTableReferences),
    ControleLigne,
    PrefetchHooks Function(
        {bool navireId,
        bool controleMaillagesRefs,
        bool controleEchantillonsRefs})> {
  $$ControlesTableTableManager(_$BaseDeDonnees db, $ControlesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ControlesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ControlesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ControlesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> navireId = const Value.absent(),
            Value<String> agent = const Value.absent(),
            Value<DateTime> date = const Value.absent(),
            Value<double> latitude = const Value.absent(),
            Value<double> longitude = const Value.absent(),
            Value<TypeEngin> engin = const Value.absent(),
            Value<bool> pavillonConforme = const Value.absent(),
            Value<bool> marquageConforme = const Value.absent(),
            Value<bool> planStockageConforme = const Value.absent(),
            Value<String> observations = const Value.absent(),
            Value<int> nbInfractions = const Value.absent(),
            Value<double> amendeMin = const Value.absent(),
            Value<double> amendeMax = const Value.absent(),
            Value<String> rapport = const Value.absent(),
            Value<Uint8List?> rapportPdf = const Value.absent(),
            Value<DateTime> creeLe = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ControlesCompanion(
            id: id,
            navireId: navireId,
            agent: agent,
            date: date,
            latitude: latitude,
            longitude: longitude,
            engin: engin,
            pavillonConforme: pavillonConforme,
            marquageConforme: marquageConforme,
            planStockageConforme: planStockageConforme,
            observations: observations,
            nbInfractions: nbInfractions,
            amendeMin: amendeMin,
            amendeMax: amendeMax,
            rapport: rapport,
            rapportPdf: rapportPdf,
            creeLe: creeLe,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String navireId,
            required String agent,
            required DateTime date,
            required double latitude,
            required double longitude,
            required TypeEngin engin,
            required bool pavillonConforme,
            required bool marquageConforme,
            required bool planStockageConforme,
            Value<String> observations = const Value.absent(),
            required int nbInfractions,
            required double amendeMin,
            required double amendeMax,
            required String rapport,
            Value<Uint8List?> rapportPdf = const Value.absent(),
            Value<DateTime> creeLe = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ControlesCompanion.insert(
            id: id,
            navireId: navireId,
            agent: agent,
            date: date,
            latitude: latitude,
            longitude: longitude,
            engin: engin,
            pavillonConforme: pavillonConforme,
            marquageConforme: marquageConforme,
            planStockageConforme: planStockageConforme,
            observations: observations,
            nbInfractions: nbInfractions,
            amendeMin: amendeMin,
            amendeMax: amendeMax,
            rapport: rapport,
            rapportPdf: rapportPdf,
            creeLe: creeLe,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$ControlesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {navireId = false,
              controleMaillagesRefs = false,
              controleEchantillonsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (controleMaillagesRefs) db.controleMaillages,
                if (controleEchantillonsRefs) db.controleEchantillons
              ],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (navireId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.navireId,
                    referencedTable:
                        $$ControlesTableReferences._navireIdTable(db),
                    referencedColumn:
                        $$ControlesTableReferences._navireIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (controleMaillagesRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable: $$ControlesTableReferences
                            ._controleMaillagesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ControlesTableReferences(db, table, p0)
                                .controleMaillagesRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.controleId == item.id),
                        typedResults: items),
                  if (controleEchantillonsRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable: $$ControlesTableReferences
                            ._controleEchantillonsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ControlesTableReferences(db, table, p0)
                                .controleEchantillonsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.controleId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$ControlesTableProcessedTableManager = ProcessedTableManager<
    _$BaseDeDonnees,
    $ControlesTable,
    ControleLigne,
    $$ControlesTableFilterComposer,
    $$ControlesTableOrderingComposer,
    $$ControlesTableAnnotationComposer,
    $$ControlesTableCreateCompanionBuilder,
    $$ControlesTableUpdateCompanionBuilder,
    (ControleLigne, $$ControlesTableReferences),
    ControleLigne,
    PrefetchHooks Function(
        {bool navireId,
        bool controleMaillagesRefs,
        bool controleEchantillonsRefs})>;
typedef $$ControleMaillagesTableCreateCompanionBuilder
    = ControleMaillagesCompanion Function({
  Value<int> id,
  required String controleId,
  required double mesureMm,
});
typedef $$ControleMaillagesTableUpdateCompanionBuilder
    = ControleMaillagesCompanion Function({
  Value<int> id,
  Value<String> controleId,
  Value<double> mesureMm,
});

final class $$ControleMaillagesTableReferences extends BaseReferences<
    _$BaseDeDonnees, $ControleMaillagesTable, MaillageLigne> {
  $$ControleMaillagesTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $ControlesTable _controleIdTable(_$BaseDeDonnees db) =>
      db.controles.createAlias($_aliasNameGenerator(
          db.controleMaillages.controleId, db.controles.id));

  $$ControlesTableProcessedTableManager get controleId {
    final manager = $$ControlesTableTableManager($_db, $_db.controles)
        .filter((f) => f.id($_item.controleId));
    final item = $_typedResult.readTableOrNull(_controleIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$ControleMaillagesTableFilterComposer
    extends Composer<_$BaseDeDonnees, $ControleMaillagesTable> {
  $$ControleMaillagesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get mesureMm => $composableBuilder(
      column: $table.mesureMm, builder: (column) => ColumnFilters(column));

  $$ControlesTableFilterComposer get controleId {
    final $$ControlesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.controleId,
        referencedTable: $db.controles,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ControlesTableFilterComposer(
              $db: $db,
              $table: $db.controles,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ControleMaillagesTableOrderingComposer
    extends Composer<_$BaseDeDonnees, $ControleMaillagesTable> {
  $$ControleMaillagesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get mesureMm => $composableBuilder(
      column: $table.mesureMm, builder: (column) => ColumnOrderings(column));

  $$ControlesTableOrderingComposer get controleId {
    final $$ControlesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.controleId,
        referencedTable: $db.controles,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ControlesTableOrderingComposer(
              $db: $db,
              $table: $db.controles,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ControleMaillagesTableAnnotationComposer
    extends Composer<_$BaseDeDonnees, $ControleMaillagesTable> {
  $$ControleMaillagesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get mesureMm =>
      $composableBuilder(column: $table.mesureMm, builder: (column) => column);

  $$ControlesTableAnnotationComposer get controleId {
    final $$ControlesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.controleId,
        referencedTable: $db.controles,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ControlesTableAnnotationComposer(
              $db: $db,
              $table: $db.controles,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ControleMaillagesTableTableManager extends RootTableManager<
    _$BaseDeDonnees,
    $ControleMaillagesTable,
    MaillageLigne,
    $$ControleMaillagesTableFilterComposer,
    $$ControleMaillagesTableOrderingComposer,
    $$ControleMaillagesTableAnnotationComposer,
    $$ControleMaillagesTableCreateCompanionBuilder,
    $$ControleMaillagesTableUpdateCompanionBuilder,
    (MaillageLigne, $$ControleMaillagesTableReferences),
    MaillageLigne,
    PrefetchHooks Function({bool controleId})> {
  $$ControleMaillagesTableTableManager(
      _$BaseDeDonnees db, $ControleMaillagesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ControleMaillagesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ControleMaillagesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ControleMaillagesTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> controleId = const Value.absent(),
            Value<double> mesureMm = const Value.absent(),
          }) =>
              ControleMaillagesCompanion(
            id: id,
            controleId: controleId,
            mesureMm: mesureMm,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String controleId,
            required double mesureMm,
          }) =>
              ControleMaillagesCompanion.insert(
            id: id,
            controleId: controleId,
            mesureMm: mesureMm,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$ControleMaillagesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({controleId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (controleId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.controleId,
                    referencedTable:
                        $$ControleMaillagesTableReferences._controleIdTable(db),
                    referencedColumn: $$ControleMaillagesTableReferences
                        ._controleIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$ControleMaillagesTableProcessedTableManager = ProcessedTableManager<
    _$BaseDeDonnees,
    $ControleMaillagesTable,
    MaillageLigne,
    $$ControleMaillagesTableFilterComposer,
    $$ControleMaillagesTableOrderingComposer,
    $$ControleMaillagesTableAnnotationComposer,
    $$ControleMaillagesTableCreateCompanionBuilder,
    $$ControleMaillagesTableUpdateCompanionBuilder,
    (MaillageLigne, $$ControleMaillagesTableReferences),
    MaillageLigne,
    PrefetchHooks Function({bool controleId})>;
typedef $$ControleEchantillonsTableCreateCompanionBuilder
    = ControleEchantillonsCompanion Function({
  Value<int> id,
  required String controleId,
  required String especeCode,
  required double valeur,
});
typedef $$ControleEchantillonsTableUpdateCompanionBuilder
    = ControleEchantillonsCompanion Function({
  Value<int> id,
  Value<String> controleId,
  Value<String> especeCode,
  Value<double> valeur,
});

final class $$ControleEchantillonsTableReferences extends BaseReferences<
    _$BaseDeDonnees, $ControleEchantillonsTable, EchantillonLigne> {
  $$ControleEchantillonsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $ControlesTable _controleIdTable(_$BaseDeDonnees db) =>
      db.controles.createAlias($_aliasNameGenerator(
          db.controleEchantillons.controleId, db.controles.id));

  $$ControlesTableProcessedTableManager get controleId {
    final manager = $$ControlesTableTableManager($_db, $_db.controles)
        .filter((f) => f.id($_item.controleId));
    final item = $_typedResult.readTableOrNull(_controleIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$ControleEchantillonsTableFilterComposer
    extends Composer<_$BaseDeDonnees, $ControleEchantillonsTable> {
  $$ControleEchantillonsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get especeCode => $composableBuilder(
      column: $table.especeCode, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get valeur => $composableBuilder(
      column: $table.valeur, builder: (column) => ColumnFilters(column));

  $$ControlesTableFilterComposer get controleId {
    final $$ControlesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.controleId,
        referencedTable: $db.controles,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ControlesTableFilterComposer(
              $db: $db,
              $table: $db.controles,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ControleEchantillonsTableOrderingComposer
    extends Composer<_$BaseDeDonnees, $ControleEchantillonsTable> {
  $$ControleEchantillonsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get especeCode => $composableBuilder(
      column: $table.especeCode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get valeur => $composableBuilder(
      column: $table.valeur, builder: (column) => ColumnOrderings(column));

  $$ControlesTableOrderingComposer get controleId {
    final $$ControlesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.controleId,
        referencedTable: $db.controles,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ControlesTableOrderingComposer(
              $db: $db,
              $table: $db.controles,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ControleEchantillonsTableAnnotationComposer
    extends Composer<_$BaseDeDonnees, $ControleEchantillonsTable> {
  $$ControleEchantillonsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get especeCode => $composableBuilder(
      column: $table.especeCode, builder: (column) => column);

  GeneratedColumn<double> get valeur =>
      $composableBuilder(column: $table.valeur, builder: (column) => column);

  $$ControlesTableAnnotationComposer get controleId {
    final $$ControlesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.controleId,
        referencedTable: $db.controles,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ControlesTableAnnotationComposer(
              $db: $db,
              $table: $db.controles,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ControleEchantillonsTableTableManager extends RootTableManager<
    _$BaseDeDonnees,
    $ControleEchantillonsTable,
    EchantillonLigne,
    $$ControleEchantillonsTableFilterComposer,
    $$ControleEchantillonsTableOrderingComposer,
    $$ControleEchantillonsTableAnnotationComposer,
    $$ControleEchantillonsTableCreateCompanionBuilder,
    $$ControleEchantillonsTableUpdateCompanionBuilder,
    (EchantillonLigne, $$ControleEchantillonsTableReferences),
    EchantillonLigne,
    PrefetchHooks Function({bool controleId})> {
  $$ControleEchantillonsTableTableManager(
      _$BaseDeDonnees db, $ControleEchantillonsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ControleEchantillonsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ControleEchantillonsTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ControleEchantillonsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> controleId = const Value.absent(),
            Value<String> especeCode = const Value.absent(),
            Value<double> valeur = const Value.absent(),
          }) =>
              ControleEchantillonsCompanion(
            id: id,
            controleId: controleId,
            especeCode: especeCode,
            valeur: valeur,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String controleId,
            required String especeCode,
            required double valeur,
          }) =>
              ControleEchantillonsCompanion.insert(
            id: id,
            controleId: controleId,
            especeCode: especeCode,
            valeur: valeur,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$ControleEchantillonsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({controleId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (controleId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.controleId,
                    referencedTable: $$ControleEchantillonsTableReferences
                        ._controleIdTable(db),
                    referencedColumn: $$ControleEchantillonsTableReferences
                        ._controleIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$ControleEchantillonsTableProcessedTableManager
    = ProcessedTableManager<
        _$BaseDeDonnees,
        $ControleEchantillonsTable,
        EchantillonLigne,
        $$ControleEchantillonsTableFilterComposer,
        $$ControleEchantillonsTableOrderingComposer,
        $$ControleEchantillonsTableAnnotationComposer,
        $$ControleEchantillonsTableCreateCompanionBuilder,
        $$ControleEchantillonsTableUpdateCompanionBuilder,
        (EchantillonLigne, $$ControleEchantillonsTableReferences),
        EchantillonLigne,
        PrefetchHooks Function({bool controleId})>;
typedef $$FileEnvoisTableCreateCompanionBuilder = FileEnvoisCompanion Function({
  Value<int> id,
  required TypeEnvoi type,
  required String entiteId,
  required String resume,
  Value<DateTime> creeLe,
  Value<int> tentatives,
  Value<String?> derniereErreur,
  Value<DateTime?> envoyeLe,
});
typedef $$FileEnvoisTableUpdateCompanionBuilder = FileEnvoisCompanion Function({
  Value<int> id,
  Value<TypeEnvoi> type,
  Value<String> entiteId,
  Value<String> resume,
  Value<DateTime> creeLe,
  Value<int> tentatives,
  Value<String?> derniereErreur,
  Value<DateTime?> envoyeLe,
});

class $$FileEnvoisTableFilterComposer
    extends Composer<_$BaseDeDonnees, $FileEnvoisTable> {
  $$FileEnvoisTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<TypeEnvoi, TypeEnvoi, String> get type =>
      $composableBuilder(
          column: $table.type,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<String> get entiteId => $composableBuilder(
      column: $table.entiteId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get resume => $composableBuilder(
      column: $table.resume, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get creeLe => $composableBuilder(
      column: $table.creeLe, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get tentatives => $composableBuilder(
      column: $table.tentatives, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get derniereErreur => $composableBuilder(
      column: $table.derniereErreur,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get envoyeLe => $composableBuilder(
      column: $table.envoyeLe, builder: (column) => ColumnFilters(column));
}

class $$FileEnvoisTableOrderingComposer
    extends Composer<_$BaseDeDonnees, $FileEnvoisTable> {
  $$FileEnvoisTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get entiteId => $composableBuilder(
      column: $table.entiteId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get resume => $composableBuilder(
      column: $table.resume, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get creeLe => $composableBuilder(
      column: $table.creeLe, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get tentatives => $composableBuilder(
      column: $table.tentatives, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get derniereErreur => $composableBuilder(
      column: $table.derniereErreur,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get envoyeLe => $composableBuilder(
      column: $table.envoyeLe, builder: (column) => ColumnOrderings(column));
}

class $$FileEnvoisTableAnnotationComposer
    extends Composer<_$BaseDeDonnees, $FileEnvoisTable> {
  $$FileEnvoisTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<TypeEnvoi, String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get entiteId =>
      $composableBuilder(column: $table.entiteId, builder: (column) => column);

  GeneratedColumn<String> get resume =>
      $composableBuilder(column: $table.resume, builder: (column) => column);

  GeneratedColumn<DateTime> get creeLe =>
      $composableBuilder(column: $table.creeLe, builder: (column) => column);

  GeneratedColumn<int> get tentatives => $composableBuilder(
      column: $table.tentatives, builder: (column) => column);

  GeneratedColumn<String> get derniereErreur => $composableBuilder(
      column: $table.derniereErreur, builder: (column) => column);

  GeneratedColumn<DateTime> get envoyeLe =>
      $composableBuilder(column: $table.envoyeLe, builder: (column) => column);
}

class $$FileEnvoisTableTableManager extends RootTableManager<
    _$BaseDeDonnees,
    $FileEnvoisTable,
    EnvoiLigne,
    $$FileEnvoisTableFilterComposer,
    $$FileEnvoisTableOrderingComposer,
    $$FileEnvoisTableAnnotationComposer,
    $$FileEnvoisTableCreateCompanionBuilder,
    $$FileEnvoisTableUpdateCompanionBuilder,
    (EnvoiLigne, BaseReferences<_$BaseDeDonnees, $FileEnvoisTable, EnvoiLigne>),
    EnvoiLigne,
    PrefetchHooks Function()> {
  $$FileEnvoisTableTableManager(_$BaseDeDonnees db, $FileEnvoisTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FileEnvoisTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FileEnvoisTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FileEnvoisTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<TypeEnvoi> type = const Value.absent(),
            Value<String> entiteId = const Value.absent(),
            Value<String> resume = const Value.absent(),
            Value<DateTime> creeLe = const Value.absent(),
            Value<int> tentatives = const Value.absent(),
            Value<String?> derniereErreur = const Value.absent(),
            Value<DateTime?> envoyeLe = const Value.absent(),
          }) =>
              FileEnvoisCompanion(
            id: id,
            type: type,
            entiteId: entiteId,
            resume: resume,
            creeLe: creeLe,
            tentatives: tentatives,
            derniereErreur: derniereErreur,
            envoyeLe: envoyeLe,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required TypeEnvoi type,
            required String entiteId,
            required String resume,
            Value<DateTime> creeLe = const Value.absent(),
            Value<int> tentatives = const Value.absent(),
            Value<String?> derniereErreur = const Value.absent(),
            Value<DateTime?> envoyeLe = const Value.absent(),
          }) =>
              FileEnvoisCompanion.insert(
            id: id,
            type: type,
            entiteId: entiteId,
            resume: resume,
            creeLe: creeLe,
            tentatives: tentatives,
            derniereErreur: derniereErreur,
            envoyeLe: envoyeLe,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$FileEnvoisTableProcessedTableManager = ProcessedTableManager<
    _$BaseDeDonnees,
    $FileEnvoisTable,
    EnvoiLigne,
    $$FileEnvoisTableFilterComposer,
    $$FileEnvoisTableOrderingComposer,
    $$FileEnvoisTableAnnotationComposer,
    $$FileEnvoisTableCreateCompanionBuilder,
    $$FileEnvoisTableUpdateCompanionBuilder,
    (EnvoiLigne, BaseReferences<_$BaseDeDonnees, $FileEnvoisTable, EnvoiLigne>),
    EnvoiLigne,
    PrefetchHooks Function()>;
typedef $$ReglagesTableCreateCompanionBuilder = ReglagesCompanion Function({
  required String cle,
  required String valeur,
  Value<int> rowid,
});
typedef $$ReglagesTableUpdateCompanionBuilder = ReglagesCompanion Function({
  Value<String> cle,
  Value<String> valeur,
  Value<int> rowid,
});

class $$ReglagesTableFilterComposer
    extends Composer<_$BaseDeDonnees, $ReglagesTable> {
  $$ReglagesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get cle => $composableBuilder(
      column: $table.cle, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get valeur => $composableBuilder(
      column: $table.valeur, builder: (column) => ColumnFilters(column));
}

class $$ReglagesTableOrderingComposer
    extends Composer<_$BaseDeDonnees, $ReglagesTable> {
  $$ReglagesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get cle => $composableBuilder(
      column: $table.cle, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get valeur => $composableBuilder(
      column: $table.valeur, builder: (column) => ColumnOrderings(column));
}

class $$ReglagesTableAnnotationComposer
    extends Composer<_$BaseDeDonnees, $ReglagesTable> {
  $$ReglagesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get cle =>
      $composableBuilder(column: $table.cle, builder: (column) => column);

  GeneratedColumn<String> get valeur =>
      $composableBuilder(column: $table.valeur, builder: (column) => column);
}

class $$ReglagesTableTableManager extends RootTableManager<
    _$BaseDeDonnees,
    $ReglagesTable,
    ReglageLigne,
    $$ReglagesTableFilterComposer,
    $$ReglagesTableOrderingComposer,
    $$ReglagesTableAnnotationComposer,
    $$ReglagesTableCreateCompanionBuilder,
    $$ReglagesTableUpdateCompanionBuilder,
    (
      ReglageLigne,
      BaseReferences<_$BaseDeDonnees, $ReglagesTable, ReglageLigne>
    ),
    ReglageLigne,
    PrefetchHooks Function()> {
  $$ReglagesTableTableManager(_$BaseDeDonnees db, $ReglagesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReglagesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ReglagesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ReglagesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> cle = const Value.absent(),
            Value<String> valeur = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ReglagesCompanion(
            cle: cle,
            valeur: valeur,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String cle,
            required String valeur,
            Value<int> rowid = const Value.absent(),
          }) =>
              ReglagesCompanion.insert(
            cle: cle,
            valeur: valeur,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ReglagesTableProcessedTableManager = ProcessedTableManager<
    _$BaseDeDonnees,
    $ReglagesTable,
    ReglageLigne,
    $$ReglagesTableFilterComposer,
    $$ReglagesTableOrderingComposer,
    $$ReglagesTableAnnotationComposer,
    $$ReglagesTableCreateCompanionBuilder,
    $$ReglagesTableUpdateCompanionBuilder,
    (
      ReglageLigne,
      BaseReferences<_$BaseDeDonnees, $ReglagesTable, ReglageLigne>
    ),
    ReglageLigne,
    PrefetchHooks Function()>;

class $BaseDeDonneesManager {
  final _$BaseDeDonnees _db;
  $BaseDeDonneesManager(this._db);
  $$NaviresTableTableManager get navires =>
      $$NaviresTableTableManager(_db, _db.navires);
  $$CertificatsTableTableManager get certificats =>
      $$CertificatsTableTableManager(_db, _db.certificats);
  $$LicencesTableTableManager get licences =>
      $$LicencesTableTableManager(_db, _db.licences);
  $$QuotasTableTableManager get quotas =>
      $$QuotasTableTableManager(_db, _db.quotas);
  $$DeclarationsTableTableManager get declarations =>
      $$DeclarationsTableTableManager(_db, _db.declarations);
  $$EquipagesTableTableManager get equipages =>
      $$EquipagesTableTableManager(_db, _db.equipages);
  $$CapturesTableTableManager get captures =>
      $$CapturesTableTableManager(_db, _db.captures);
  $$ControlesTableTableManager get controles =>
      $$ControlesTableTableManager(_db, _db.controles);
  $$ControleMaillagesTableTableManager get controleMaillages =>
      $$ControleMaillagesTableTableManager(_db, _db.controleMaillages);
  $$ControleEchantillonsTableTableManager get controleEchantillons =>
      $$ControleEchantillonsTableTableManager(_db, _db.controleEchantillons);
  $$FileEnvoisTableTableManager get fileEnvois =>
      $$FileEnvoisTableTableManager(_db, _db.fileEnvois);
  $$ReglagesTableTableManager get reglages =>
      $$ReglagesTableTableManager(_db, _db.reglages);
}
