// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $DecksTable extends Decks with TableInfo<$DecksTable, Deck> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DecksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, createdAt, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'decks';
  @override
  VerificationContext validateIntegrity(
    Insertable<Deck> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Deck map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Deck(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $DecksTable createAlias(String alias) {
    return $DecksTable(attachedDatabase, alias);
  }
}

class Deck extends DataClass implements Insertable<Deck> {
  final int id;
  final String name;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Deck({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  DecksCompanion toCompanion(bool nullToAbsent) {
    return DecksCompanion(
      id: Value(id),
      name: Value(name),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Deck.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Deck(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Deck copyWith({
    int? id,
    String? name,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Deck(
    id: id ?? this.id,
    name: name ?? this.name,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Deck copyWithCompanion(DecksCompanion data) {
    return Deck(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Deck(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Deck &&
          other.id == this.id &&
          other.name == this.name &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class DecksCompanion extends UpdateCompanion<Deck> {
  final Value<int> id;
  final Value<String> name;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const DecksCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  DecksCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : name = Value(name),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Deck> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  DecksCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return DecksCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DecksCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $CardDefinitionsTable extends CardDefinitions
    with TableInfo<$CardDefinitionsTable, CardDefinition> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CardDefinitionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _setCodeMeta = const VerificationMeta(
    'setCode',
  );
  @override
  late final GeneratedColumn<String> setCode = GeneratedColumn<String>(
    'set_code',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _collectorNumberMeta = const VerificationMeta(
    'collectorNumber',
  );
  @override
  late final GeneratedColumn<String> collectorNumber = GeneratedColumn<String>(
    'collector_number',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _scryfallIdMeta = const VerificationMeta(
    'scryfallId',
  );
  @override
  late final GeneratedColumn<String> scryfallId = GeneratedColumn<String>(
    'scryfall_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _manaCostMeta = const VerificationMeta(
    'manaCost',
  );
  @override
  late final GeneratedColumn<String> manaCost = GeneratedColumn<String>(
    'mana_cost',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _cmcMeta = const VerificationMeta('cmc');
  @override
  late final GeneratedColumn<double> cmc = GeneratedColumn<double>(
    'cmc',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _typeLineMeta = const VerificationMeta(
    'typeLine',
  );
  @override
  late final GeneratedColumn<String> typeLine = GeneratedColumn<String>(
    'type_line',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _oracleTextMeta = const VerificationMeta(
    'oracleText',
  );
  @override
  late final GeneratedColumn<String> oracleText = GeneratedColumn<String>(
    'oracle_text',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _colorsMeta = const VerificationMeta('colors');
  @override
  late final GeneratedColumn<String> colors = GeneratedColumn<String>(
    'colors',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _powerMeta = const VerificationMeta('power');
  @override
  late final GeneratedColumn<String> power = GeneratedColumn<String>(
    'power',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _toughnessMeta = const VerificationMeta(
    'toughness',
  );
  @override
  late final GeneratedColumn<String> toughness = GeneratedColumn<String>(
    'toughness',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _imageUriMeta = const VerificationMeta(
    'imageUri',
  );
  @override
  late final GeneratedColumn<String> imageUri = GeneratedColumn<String>(
    'image_uri',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    setCode,
    collectorNumber,
    scryfallId,
    manaCost,
    cmc,
    typeLine,
    oracleText,
    colors,
    power,
    toughness,
    imageUri,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'card_definitions';
  @override
  VerificationContext validateIntegrity(
    Insertable<CardDefinition> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('set_code')) {
      context.handle(
        _setCodeMeta,
        setCode.isAcceptableOrUnknown(data['set_code']!, _setCodeMeta),
      );
    }
    if (data.containsKey('collector_number')) {
      context.handle(
        _collectorNumberMeta,
        collectorNumber.isAcceptableOrUnknown(
          data['collector_number']!,
          _collectorNumberMeta,
        ),
      );
    }
    if (data.containsKey('scryfall_id')) {
      context.handle(
        _scryfallIdMeta,
        scryfallId.isAcceptableOrUnknown(data['scryfall_id']!, _scryfallIdMeta),
      );
    }
    if (data.containsKey('mana_cost')) {
      context.handle(
        _manaCostMeta,
        manaCost.isAcceptableOrUnknown(data['mana_cost']!, _manaCostMeta),
      );
    }
    if (data.containsKey('cmc')) {
      context.handle(
        _cmcMeta,
        cmc.isAcceptableOrUnknown(data['cmc']!, _cmcMeta),
      );
    }
    if (data.containsKey('type_line')) {
      context.handle(
        _typeLineMeta,
        typeLine.isAcceptableOrUnknown(data['type_line']!, _typeLineMeta),
      );
    }
    if (data.containsKey('oracle_text')) {
      context.handle(
        _oracleTextMeta,
        oracleText.isAcceptableOrUnknown(data['oracle_text']!, _oracleTextMeta),
      );
    }
    if (data.containsKey('colors')) {
      context.handle(
        _colorsMeta,
        colors.isAcceptableOrUnknown(data['colors']!, _colorsMeta),
      );
    }
    if (data.containsKey('power')) {
      context.handle(
        _powerMeta,
        power.isAcceptableOrUnknown(data['power']!, _powerMeta),
      );
    }
    if (data.containsKey('toughness')) {
      context.handle(
        _toughnessMeta,
        toughness.isAcceptableOrUnknown(data['toughness']!, _toughnessMeta),
      );
    }
    if (data.containsKey('image_uri')) {
      context.handle(
        _imageUriMeta,
        imageUri.isAcceptableOrUnknown(data['image_uri']!, _imageUriMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CardDefinition map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CardDefinition(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      setCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}set_code'],
      ),
      collectorNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}collector_number'],
      ),
      scryfallId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}scryfall_id'],
      ),
      manaCost: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mana_cost'],
      ),
      cmc: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}cmc'],
      ),
      typeLine: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type_line'],
      ),
      oracleText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}oracle_text'],
      ),
      colors: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}colors'],
      ),
      power: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}power'],
      ),
      toughness: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}toughness'],
      ),
      imageUri: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_uri'],
      ),
    );
  }

  @override
  $CardDefinitionsTable createAlias(String alias) {
    return $CardDefinitionsTable(attachedDatabase, alias);
  }
}

class CardDefinition extends DataClass implements Insertable<CardDefinition> {
  final int id;
  final String name;
  final String? setCode;
  final String? collectorNumber;
  final String? scryfallId;
  final String? manaCost;
  final double? cmc;
  final String? typeLine;
  final String? oracleText;
  final String? colors;
  final String? power;
  final String? toughness;
  final String? imageUri;
  const CardDefinition({
    required this.id,
    required this.name,
    this.setCode,
    this.collectorNumber,
    this.scryfallId,
    this.manaCost,
    this.cmc,
    this.typeLine,
    this.oracleText,
    this.colors,
    this.power,
    this.toughness,
    this.imageUri,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || setCode != null) {
      map['set_code'] = Variable<String>(setCode);
    }
    if (!nullToAbsent || collectorNumber != null) {
      map['collector_number'] = Variable<String>(collectorNumber);
    }
    if (!nullToAbsent || scryfallId != null) {
      map['scryfall_id'] = Variable<String>(scryfallId);
    }
    if (!nullToAbsent || manaCost != null) {
      map['mana_cost'] = Variable<String>(manaCost);
    }
    if (!nullToAbsent || cmc != null) {
      map['cmc'] = Variable<double>(cmc);
    }
    if (!nullToAbsent || typeLine != null) {
      map['type_line'] = Variable<String>(typeLine);
    }
    if (!nullToAbsent || oracleText != null) {
      map['oracle_text'] = Variable<String>(oracleText);
    }
    if (!nullToAbsent || colors != null) {
      map['colors'] = Variable<String>(colors);
    }
    if (!nullToAbsent || power != null) {
      map['power'] = Variable<String>(power);
    }
    if (!nullToAbsent || toughness != null) {
      map['toughness'] = Variable<String>(toughness);
    }
    if (!nullToAbsent || imageUri != null) {
      map['image_uri'] = Variable<String>(imageUri);
    }
    return map;
  }

  CardDefinitionsCompanion toCompanion(bool nullToAbsent) {
    return CardDefinitionsCompanion(
      id: Value(id),
      name: Value(name),
      setCode: setCode == null && nullToAbsent
          ? const Value.absent()
          : Value(setCode),
      collectorNumber: collectorNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(collectorNumber),
      scryfallId: scryfallId == null && nullToAbsent
          ? const Value.absent()
          : Value(scryfallId),
      manaCost: manaCost == null && nullToAbsent
          ? const Value.absent()
          : Value(manaCost),
      cmc: cmc == null && nullToAbsent ? const Value.absent() : Value(cmc),
      typeLine: typeLine == null && nullToAbsent
          ? const Value.absent()
          : Value(typeLine),
      oracleText: oracleText == null && nullToAbsent
          ? const Value.absent()
          : Value(oracleText),
      colors: colors == null && nullToAbsent
          ? const Value.absent()
          : Value(colors),
      power: power == null && nullToAbsent
          ? const Value.absent()
          : Value(power),
      toughness: toughness == null && nullToAbsent
          ? const Value.absent()
          : Value(toughness),
      imageUri: imageUri == null && nullToAbsent
          ? const Value.absent()
          : Value(imageUri),
    );
  }

  factory CardDefinition.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CardDefinition(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      setCode: serializer.fromJson<String?>(json['setCode']),
      collectorNumber: serializer.fromJson<String?>(json['collectorNumber']),
      scryfallId: serializer.fromJson<String?>(json['scryfallId']),
      manaCost: serializer.fromJson<String?>(json['manaCost']),
      cmc: serializer.fromJson<double?>(json['cmc']),
      typeLine: serializer.fromJson<String?>(json['typeLine']),
      oracleText: serializer.fromJson<String?>(json['oracleText']),
      colors: serializer.fromJson<String?>(json['colors']),
      power: serializer.fromJson<String?>(json['power']),
      toughness: serializer.fromJson<String?>(json['toughness']),
      imageUri: serializer.fromJson<String?>(json['imageUri']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'setCode': serializer.toJson<String?>(setCode),
      'collectorNumber': serializer.toJson<String?>(collectorNumber),
      'scryfallId': serializer.toJson<String?>(scryfallId),
      'manaCost': serializer.toJson<String?>(manaCost),
      'cmc': serializer.toJson<double?>(cmc),
      'typeLine': serializer.toJson<String?>(typeLine),
      'oracleText': serializer.toJson<String?>(oracleText),
      'colors': serializer.toJson<String?>(colors),
      'power': serializer.toJson<String?>(power),
      'toughness': serializer.toJson<String?>(toughness),
      'imageUri': serializer.toJson<String?>(imageUri),
    };
  }

  CardDefinition copyWith({
    int? id,
    String? name,
    Value<String?> setCode = const Value.absent(),
    Value<String?> collectorNumber = const Value.absent(),
    Value<String?> scryfallId = const Value.absent(),
    Value<String?> manaCost = const Value.absent(),
    Value<double?> cmc = const Value.absent(),
    Value<String?> typeLine = const Value.absent(),
    Value<String?> oracleText = const Value.absent(),
    Value<String?> colors = const Value.absent(),
    Value<String?> power = const Value.absent(),
    Value<String?> toughness = const Value.absent(),
    Value<String?> imageUri = const Value.absent(),
  }) => CardDefinition(
    id: id ?? this.id,
    name: name ?? this.name,
    setCode: setCode.present ? setCode.value : this.setCode,
    collectorNumber: collectorNumber.present
        ? collectorNumber.value
        : this.collectorNumber,
    scryfallId: scryfallId.present ? scryfallId.value : this.scryfallId,
    manaCost: manaCost.present ? manaCost.value : this.manaCost,
    cmc: cmc.present ? cmc.value : this.cmc,
    typeLine: typeLine.present ? typeLine.value : this.typeLine,
    oracleText: oracleText.present ? oracleText.value : this.oracleText,
    colors: colors.present ? colors.value : this.colors,
    power: power.present ? power.value : this.power,
    toughness: toughness.present ? toughness.value : this.toughness,
    imageUri: imageUri.present ? imageUri.value : this.imageUri,
  );
  CardDefinition copyWithCompanion(CardDefinitionsCompanion data) {
    return CardDefinition(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      setCode: data.setCode.present ? data.setCode.value : this.setCode,
      collectorNumber: data.collectorNumber.present
          ? data.collectorNumber.value
          : this.collectorNumber,
      scryfallId: data.scryfallId.present
          ? data.scryfallId.value
          : this.scryfallId,
      manaCost: data.manaCost.present ? data.manaCost.value : this.manaCost,
      cmc: data.cmc.present ? data.cmc.value : this.cmc,
      typeLine: data.typeLine.present ? data.typeLine.value : this.typeLine,
      oracleText: data.oracleText.present
          ? data.oracleText.value
          : this.oracleText,
      colors: data.colors.present ? data.colors.value : this.colors,
      power: data.power.present ? data.power.value : this.power,
      toughness: data.toughness.present ? data.toughness.value : this.toughness,
      imageUri: data.imageUri.present ? data.imageUri.value : this.imageUri,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CardDefinition(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('setCode: $setCode, ')
          ..write('collectorNumber: $collectorNumber, ')
          ..write('scryfallId: $scryfallId, ')
          ..write('manaCost: $manaCost, ')
          ..write('cmc: $cmc, ')
          ..write('typeLine: $typeLine, ')
          ..write('oracleText: $oracleText, ')
          ..write('colors: $colors, ')
          ..write('power: $power, ')
          ..write('toughness: $toughness, ')
          ..write('imageUri: $imageUri')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    setCode,
    collectorNumber,
    scryfallId,
    manaCost,
    cmc,
    typeLine,
    oracleText,
    colors,
    power,
    toughness,
    imageUri,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CardDefinition &&
          other.id == this.id &&
          other.name == this.name &&
          other.setCode == this.setCode &&
          other.collectorNumber == this.collectorNumber &&
          other.scryfallId == this.scryfallId &&
          other.manaCost == this.manaCost &&
          other.cmc == this.cmc &&
          other.typeLine == this.typeLine &&
          other.oracleText == this.oracleText &&
          other.colors == this.colors &&
          other.power == this.power &&
          other.toughness == this.toughness &&
          other.imageUri == this.imageUri);
}

class CardDefinitionsCompanion extends UpdateCompanion<CardDefinition> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> setCode;
  final Value<String?> collectorNumber;
  final Value<String?> scryfallId;
  final Value<String?> manaCost;
  final Value<double?> cmc;
  final Value<String?> typeLine;
  final Value<String?> oracleText;
  final Value<String?> colors;
  final Value<String?> power;
  final Value<String?> toughness;
  final Value<String?> imageUri;
  const CardDefinitionsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.setCode = const Value.absent(),
    this.collectorNumber = const Value.absent(),
    this.scryfallId = const Value.absent(),
    this.manaCost = const Value.absent(),
    this.cmc = const Value.absent(),
    this.typeLine = const Value.absent(),
    this.oracleText = const Value.absent(),
    this.colors = const Value.absent(),
    this.power = const Value.absent(),
    this.toughness = const Value.absent(),
    this.imageUri = const Value.absent(),
  });
  CardDefinitionsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.setCode = const Value.absent(),
    this.collectorNumber = const Value.absent(),
    this.scryfallId = const Value.absent(),
    this.manaCost = const Value.absent(),
    this.cmc = const Value.absent(),
    this.typeLine = const Value.absent(),
    this.oracleText = const Value.absent(),
    this.colors = const Value.absent(),
    this.power = const Value.absent(),
    this.toughness = const Value.absent(),
    this.imageUri = const Value.absent(),
  }) : name = Value(name);
  static Insertable<CardDefinition> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? setCode,
    Expression<String>? collectorNumber,
    Expression<String>? scryfallId,
    Expression<String>? manaCost,
    Expression<double>? cmc,
    Expression<String>? typeLine,
    Expression<String>? oracleText,
    Expression<String>? colors,
    Expression<String>? power,
    Expression<String>? toughness,
    Expression<String>? imageUri,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (setCode != null) 'set_code': setCode,
      if (collectorNumber != null) 'collector_number': collectorNumber,
      if (scryfallId != null) 'scryfall_id': scryfallId,
      if (manaCost != null) 'mana_cost': manaCost,
      if (cmc != null) 'cmc': cmc,
      if (typeLine != null) 'type_line': typeLine,
      if (oracleText != null) 'oracle_text': oracleText,
      if (colors != null) 'colors': colors,
      if (power != null) 'power': power,
      if (toughness != null) 'toughness': toughness,
      if (imageUri != null) 'image_uri': imageUri,
    });
  }

  CardDefinitionsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String?>? setCode,
    Value<String?>? collectorNumber,
    Value<String?>? scryfallId,
    Value<String?>? manaCost,
    Value<double?>? cmc,
    Value<String?>? typeLine,
    Value<String?>? oracleText,
    Value<String?>? colors,
    Value<String?>? power,
    Value<String?>? toughness,
    Value<String?>? imageUri,
  }) {
    return CardDefinitionsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      setCode: setCode ?? this.setCode,
      collectorNumber: collectorNumber ?? this.collectorNumber,
      scryfallId: scryfallId ?? this.scryfallId,
      manaCost: manaCost ?? this.manaCost,
      cmc: cmc ?? this.cmc,
      typeLine: typeLine ?? this.typeLine,
      oracleText: oracleText ?? this.oracleText,
      colors: colors ?? this.colors,
      power: power ?? this.power,
      toughness: toughness ?? this.toughness,
      imageUri: imageUri ?? this.imageUri,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (setCode.present) {
      map['set_code'] = Variable<String>(setCode.value);
    }
    if (collectorNumber.present) {
      map['collector_number'] = Variable<String>(collectorNumber.value);
    }
    if (scryfallId.present) {
      map['scryfall_id'] = Variable<String>(scryfallId.value);
    }
    if (manaCost.present) {
      map['mana_cost'] = Variable<String>(manaCost.value);
    }
    if (cmc.present) {
      map['cmc'] = Variable<double>(cmc.value);
    }
    if (typeLine.present) {
      map['type_line'] = Variable<String>(typeLine.value);
    }
    if (oracleText.present) {
      map['oracle_text'] = Variable<String>(oracleText.value);
    }
    if (colors.present) {
      map['colors'] = Variable<String>(colors.value);
    }
    if (power.present) {
      map['power'] = Variable<String>(power.value);
    }
    if (toughness.present) {
      map['toughness'] = Variable<String>(toughness.value);
    }
    if (imageUri.present) {
      map['image_uri'] = Variable<String>(imageUri.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CardDefinitionsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('setCode: $setCode, ')
          ..write('collectorNumber: $collectorNumber, ')
          ..write('scryfallId: $scryfallId, ')
          ..write('manaCost: $manaCost, ')
          ..write('cmc: $cmc, ')
          ..write('typeLine: $typeLine, ')
          ..write('oracleText: $oracleText, ')
          ..write('colors: $colors, ')
          ..write('power: $power, ')
          ..write('toughness: $toughness, ')
          ..write('imageUri: $imageUri')
          ..write(')'))
        .toString();
  }
}

class $DeckCardsTable extends DeckCards
    with TableInfo<$DeckCardsTable, DeckCard> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DeckCardsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _deckIdMeta = const VerificationMeta('deckId');
  @override
  late final GeneratedColumn<int> deckId = GeneratedColumn<int>(
    'deck_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cardDefinitionIdMeta = const VerificationMeta(
    'cardDefinitionId',
  );
  @override
  late final GeneratedColumn<int> cardDefinitionId = GeneratedColumn<int>(
    'card_definition_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _boardMeta = const VerificationMeta('board');
  @override
  late final GeneratedColumn<String> board = GeneratedColumn<String>(
    'board',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('main'),
  );
  static const VerificationMeta _inPlayMeta = const VerificationMeta('inPlay');
  @override
  late final GeneratedColumn<bool> inPlay = GeneratedColumn<bool>(
    'in_play',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("in_play" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    deckId,
    cardDefinitionId,
    board,
    inPlay,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'deck_cards';
  @override
  VerificationContext validateIntegrity(
    Insertable<DeckCard> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('deck_id')) {
      context.handle(
        _deckIdMeta,
        deckId.isAcceptableOrUnknown(data['deck_id']!, _deckIdMeta),
      );
    } else if (isInserting) {
      context.missing(_deckIdMeta);
    }
    if (data.containsKey('card_definition_id')) {
      context.handle(
        _cardDefinitionIdMeta,
        cardDefinitionId.isAcceptableOrUnknown(
          data['card_definition_id']!,
          _cardDefinitionIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_cardDefinitionIdMeta);
    }
    if (data.containsKey('board')) {
      context.handle(
        _boardMeta,
        board.isAcceptableOrUnknown(data['board']!, _boardMeta),
      );
    }
    if (data.containsKey('in_play')) {
      context.handle(
        _inPlayMeta,
        inPlay.isAcceptableOrUnknown(data['in_play']!, _inPlayMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DeckCard map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DeckCard(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      deckId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}deck_id'],
      )!,
      cardDefinitionId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}card_definition_id'],
      )!,
      board: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}board'],
      )!,
      inPlay: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}in_play'],
      )!,
    );
  }

  @override
  $DeckCardsTable createAlias(String alias) {
    return $DeckCardsTable(attachedDatabase, alias);
  }
}

class DeckCard extends DataClass implements Insertable<DeckCard> {
  final int id;
  final int deckId;
  final int cardDefinitionId;
  final String board;
  final bool inPlay;
  const DeckCard({
    required this.id,
    required this.deckId,
    required this.cardDefinitionId,
    required this.board,
    required this.inPlay,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['deck_id'] = Variable<int>(deckId);
    map['card_definition_id'] = Variable<int>(cardDefinitionId);
    map['board'] = Variable<String>(board);
    map['in_play'] = Variable<bool>(inPlay);
    return map;
  }

  DeckCardsCompanion toCompanion(bool nullToAbsent) {
    return DeckCardsCompanion(
      id: Value(id),
      deckId: Value(deckId),
      cardDefinitionId: Value(cardDefinitionId),
      board: Value(board),
      inPlay: Value(inPlay),
    );
  }

  factory DeckCard.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DeckCard(
      id: serializer.fromJson<int>(json['id']),
      deckId: serializer.fromJson<int>(json['deckId']),
      cardDefinitionId: serializer.fromJson<int>(json['cardDefinitionId']),
      board: serializer.fromJson<String>(json['board']),
      inPlay: serializer.fromJson<bool>(json['inPlay']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'deckId': serializer.toJson<int>(deckId),
      'cardDefinitionId': serializer.toJson<int>(cardDefinitionId),
      'board': serializer.toJson<String>(board),
      'inPlay': serializer.toJson<bool>(inPlay),
    };
  }

  DeckCard copyWith({
    int? id,
    int? deckId,
    int? cardDefinitionId,
    String? board,
    bool? inPlay,
  }) => DeckCard(
    id: id ?? this.id,
    deckId: deckId ?? this.deckId,
    cardDefinitionId: cardDefinitionId ?? this.cardDefinitionId,
    board: board ?? this.board,
    inPlay: inPlay ?? this.inPlay,
  );
  DeckCard copyWithCompanion(DeckCardsCompanion data) {
    return DeckCard(
      id: data.id.present ? data.id.value : this.id,
      deckId: data.deckId.present ? data.deckId.value : this.deckId,
      cardDefinitionId: data.cardDefinitionId.present
          ? data.cardDefinitionId.value
          : this.cardDefinitionId,
      board: data.board.present ? data.board.value : this.board,
      inPlay: data.inPlay.present ? data.inPlay.value : this.inPlay,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DeckCard(')
          ..write('id: $id, ')
          ..write('deckId: $deckId, ')
          ..write('cardDefinitionId: $cardDefinitionId, ')
          ..write('board: $board, ')
          ..write('inPlay: $inPlay')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, deckId, cardDefinitionId, board, inPlay);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DeckCard &&
          other.id == this.id &&
          other.deckId == this.deckId &&
          other.cardDefinitionId == this.cardDefinitionId &&
          other.board == this.board &&
          other.inPlay == this.inPlay);
}

class DeckCardsCompanion extends UpdateCompanion<DeckCard> {
  final Value<int> id;
  final Value<int> deckId;
  final Value<int> cardDefinitionId;
  final Value<String> board;
  final Value<bool> inPlay;
  const DeckCardsCompanion({
    this.id = const Value.absent(),
    this.deckId = const Value.absent(),
    this.cardDefinitionId = const Value.absent(),
    this.board = const Value.absent(),
    this.inPlay = const Value.absent(),
  });
  DeckCardsCompanion.insert({
    this.id = const Value.absent(),
    required int deckId,
    required int cardDefinitionId,
    this.board = const Value.absent(),
    this.inPlay = const Value.absent(),
  }) : deckId = Value(deckId),
       cardDefinitionId = Value(cardDefinitionId);
  static Insertable<DeckCard> custom({
    Expression<int>? id,
    Expression<int>? deckId,
    Expression<int>? cardDefinitionId,
    Expression<String>? board,
    Expression<bool>? inPlay,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (deckId != null) 'deck_id': deckId,
      if (cardDefinitionId != null) 'card_definition_id': cardDefinitionId,
      if (board != null) 'board': board,
      if (inPlay != null) 'in_play': inPlay,
    });
  }

  DeckCardsCompanion copyWith({
    Value<int>? id,
    Value<int>? deckId,
    Value<int>? cardDefinitionId,
    Value<String>? board,
    Value<bool>? inPlay,
  }) {
    return DeckCardsCompanion(
      id: id ?? this.id,
      deckId: deckId ?? this.deckId,
      cardDefinitionId: cardDefinitionId ?? this.cardDefinitionId,
      board: board ?? this.board,
      inPlay: inPlay ?? this.inPlay,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (deckId.present) {
      map['deck_id'] = Variable<int>(deckId.value);
    }
    if (cardDefinitionId.present) {
      map['card_definition_id'] = Variable<int>(cardDefinitionId.value);
    }
    if (board.present) {
      map['board'] = Variable<String>(board.value);
    }
    if (inPlay.present) {
      map['in_play'] = Variable<bool>(inPlay.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DeckCardsCompanion(')
          ..write('id: $id, ')
          ..write('deckId: $deckId, ')
          ..write('cardDefinitionId: $cardDefinitionId, ')
          ..write('board: $board, ')
          ..write('inPlay: $inPlay')
          ..write(')'))
        .toString();
  }
}

class $CardEffectsTable extends CardEffects
    with TableInfo<$CardEffectsTable, CardEffect> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CardEffectsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _cardDefinitionIdMeta = const VerificationMeta(
    'cardDefinitionId',
  );
  @override
  late final GeneratedColumn<int> cardDefinitionId = GeneratedColumn<int>(
    'card_definition_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _triggerMeta = const VerificationMeta(
    'trigger',
  );
  @override
  late final GeneratedColumn<String> trigger = GeneratedColumn<String>(
    'trigger',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _spellCategoryMeta = const VerificationMeta(
    'spellCategory',
  );
  @override
  late final GeneratedColumn<String> spellCategory = GeneratedColumn<String>(
    'spell_category',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _shortLabelMeta = const VerificationMeta(
    'shortLabel',
  );
  @override
  late final GeneratedColumn<String> shortLabel = GeneratedColumn<String>(
    'short_label',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _triggersEffectIdMeta = const VerificationMeta(
    'triggersEffectId',
  );
  @override
  late final GeneratedColumn<int> triggersEffectId = GeneratedColumn<int>(
    'triggers_effect_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    cardDefinitionId,
    trigger,
    spellCategory,
    shortLabel,
    description,
    triggersEffectId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'card_effects';
  @override
  VerificationContext validateIntegrity(
    Insertable<CardEffect> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('card_definition_id')) {
      context.handle(
        _cardDefinitionIdMeta,
        cardDefinitionId.isAcceptableOrUnknown(
          data['card_definition_id']!,
          _cardDefinitionIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_cardDefinitionIdMeta);
    }
    if (data.containsKey('trigger')) {
      context.handle(
        _triggerMeta,
        trigger.isAcceptableOrUnknown(data['trigger']!, _triggerMeta),
      );
    } else if (isInserting) {
      context.missing(_triggerMeta);
    }
    if (data.containsKey('spell_category')) {
      context.handle(
        _spellCategoryMeta,
        spellCategory.isAcceptableOrUnknown(
          data['spell_category']!,
          _spellCategoryMeta,
        ),
      );
    }
    if (data.containsKey('short_label')) {
      context.handle(
        _shortLabelMeta,
        shortLabel.isAcceptableOrUnknown(data['short_label']!, _shortLabelMeta),
      );
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('triggers_effect_id')) {
      context.handle(
        _triggersEffectIdMeta,
        triggersEffectId.isAcceptableOrUnknown(
          data['triggers_effect_id']!,
          _triggersEffectIdMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CardEffect map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CardEffect(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      cardDefinitionId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}card_definition_id'],
      )!,
      trigger: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}trigger'],
      )!,
      spellCategory: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}spell_category'],
      ),
      shortLabel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}short_label'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      triggersEffectId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}triggers_effect_id'],
      ),
    );
  }

  @override
  $CardEffectsTable createAlias(String alias) {
    return $CardEffectsTable(attachedDatabase, alias);
  }
}

class CardEffect extends DataClass implements Insertable<CardEffect> {
  final int id;
  final int cardDefinitionId;
  final String trigger;
  final String? spellCategory;
  final String shortLabel;
  final String description;
  final int? triggersEffectId;
  const CardEffect({
    required this.id,
    required this.cardDefinitionId,
    required this.trigger,
    this.spellCategory,
    required this.shortLabel,
    required this.description,
    this.triggersEffectId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['card_definition_id'] = Variable<int>(cardDefinitionId);
    map['trigger'] = Variable<String>(trigger);
    if (!nullToAbsent || spellCategory != null) {
      map['spell_category'] = Variable<String>(spellCategory);
    }
    map['short_label'] = Variable<String>(shortLabel);
    map['description'] = Variable<String>(description);
    if (!nullToAbsent || triggersEffectId != null) {
      map['triggers_effect_id'] = Variable<int>(triggersEffectId);
    }
    return map;
  }

  CardEffectsCompanion toCompanion(bool nullToAbsent) {
    return CardEffectsCompanion(
      id: Value(id),
      cardDefinitionId: Value(cardDefinitionId),
      trigger: Value(trigger),
      spellCategory: spellCategory == null && nullToAbsent
          ? const Value.absent()
          : Value(spellCategory),
      shortLabel: Value(shortLabel),
      description: Value(description),
      triggersEffectId: triggersEffectId == null && nullToAbsent
          ? const Value.absent()
          : Value(triggersEffectId),
    );
  }

  factory CardEffect.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CardEffect(
      id: serializer.fromJson<int>(json['id']),
      cardDefinitionId: serializer.fromJson<int>(json['cardDefinitionId']),
      trigger: serializer.fromJson<String>(json['trigger']),
      spellCategory: serializer.fromJson<String?>(json['spellCategory']),
      shortLabel: serializer.fromJson<String>(json['shortLabel']),
      description: serializer.fromJson<String>(json['description']),
      triggersEffectId: serializer.fromJson<int?>(json['triggersEffectId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'cardDefinitionId': serializer.toJson<int>(cardDefinitionId),
      'trigger': serializer.toJson<String>(trigger),
      'spellCategory': serializer.toJson<String?>(spellCategory),
      'shortLabel': serializer.toJson<String>(shortLabel),
      'description': serializer.toJson<String>(description),
      'triggersEffectId': serializer.toJson<int?>(triggersEffectId),
    };
  }

  CardEffect copyWith({
    int? id,
    int? cardDefinitionId,
    String? trigger,
    Value<String?> spellCategory = const Value.absent(),
    String? shortLabel,
    String? description,
    Value<int?> triggersEffectId = const Value.absent(),
  }) => CardEffect(
    id: id ?? this.id,
    cardDefinitionId: cardDefinitionId ?? this.cardDefinitionId,
    trigger: trigger ?? this.trigger,
    spellCategory: spellCategory.present
        ? spellCategory.value
        : this.spellCategory,
    shortLabel: shortLabel ?? this.shortLabel,
    description: description ?? this.description,
    triggersEffectId: triggersEffectId.present
        ? triggersEffectId.value
        : this.triggersEffectId,
  );
  CardEffect copyWithCompanion(CardEffectsCompanion data) {
    return CardEffect(
      id: data.id.present ? data.id.value : this.id,
      cardDefinitionId: data.cardDefinitionId.present
          ? data.cardDefinitionId.value
          : this.cardDefinitionId,
      trigger: data.trigger.present ? data.trigger.value : this.trigger,
      spellCategory: data.spellCategory.present
          ? data.spellCategory.value
          : this.spellCategory,
      shortLabel: data.shortLabel.present
          ? data.shortLabel.value
          : this.shortLabel,
      description: data.description.present
          ? data.description.value
          : this.description,
      triggersEffectId: data.triggersEffectId.present
          ? data.triggersEffectId.value
          : this.triggersEffectId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CardEffect(')
          ..write('id: $id, ')
          ..write('cardDefinitionId: $cardDefinitionId, ')
          ..write('trigger: $trigger, ')
          ..write('spellCategory: $spellCategory, ')
          ..write('shortLabel: $shortLabel, ')
          ..write('description: $description, ')
          ..write('triggersEffectId: $triggersEffectId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    cardDefinitionId,
    trigger,
    spellCategory,
    shortLabel,
    description,
    triggersEffectId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CardEffect &&
          other.id == this.id &&
          other.cardDefinitionId == this.cardDefinitionId &&
          other.trigger == this.trigger &&
          other.spellCategory == this.spellCategory &&
          other.shortLabel == this.shortLabel &&
          other.description == this.description &&
          other.triggersEffectId == this.triggersEffectId);
}

class CardEffectsCompanion extends UpdateCompanion<CardEffect> {
  final Value<int> id;
  final Value<int> cardDefinitionId;
  final Value<String> trigger;
  final Value<String?> spellCategory;
  final Value<String> shortLabel;
  final Value<String> description;
  final Value<int?> triggersEffectId;
  const CardEffectsCompanion({
    this.id = const Value.absent(),
    this.cardDefinitionId = const Value.absent(),
    this.trigger = const Value.absent(),
    this.spellCategory = const Value.absent(),
    this.shortLabel = const Value.absent(),
    this.description = const Value.absent(),
    this.triggersEffectId = const Value.absent(),
  });
  CardEffectsCompanion.insert({
    this.id = const Value.absent(),
    required int cardDefinitionId,
    required String trigger,
    this.spellCategory = const Value.absent(),
    this.shortLabel = const Value.absent(),
    required String description,
    this.triggersEffectId = const Value.absent(),
  }) : cardDefinitionId = Value(cardDefinitionId),
       trigger = Value(trigger),
       description = Value(description);
  static Insertable<CardEffect> custom({
    Expression<int>? id,
    Expression<int>? cardDefinitionId,
    Expression<String>? trigger,
    Expression<String>? spellCategory,
    Expression<String>? shortLabel,
    Expression<String>? description,
    Expression<int>? triggersEffectId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (cardDefinitionId != null) 'card_definition_id': cardDefinitionId,
      if (trigger != null) 'trigger': trigger,
      if (spellCategory != null) 'spell_category': spellCategory,
      if (shortLabel != null) 'short_label': shortLabel,
      if (description != null) 'description': description,
      if (triggersEffectId != null) 'triggers_effect_id': triggersEffectId,
    });
  }

  CardEffectsCompanion copyWith({
    Value<int>? id,
    Value<int>? cardDefinitionId,
    Value<String>? trigger,
    Value<String?>? spellCategory,
    Value<String>? shortLabel,
    Value<String>? description,
    Value<int?>? triggersEffectId,
  }) {
    return CardEffectsCompanion(
      id: id ?? this.id,
      cardDefinitionId: cardDefinitionId ?? this.cardDefinitionId,
      trigger: trigger ?? this.trigger,
      spellCategory: spellCategory ?? this.spellCategory,
      shortLabel: shortLabel ?? this.shortLabel,
      description: description ?? this.description,
      triggersEffectId: triggersEffectId ?? this.triggersEffectId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (cardDefinitionId.present) {
      map['card_definition_id'] = Variable<int>(cardDefinitionId.value);
    }
    if (trigger.present) {
      map['trigger'] = Variable<String>(trigger.value);
    }
    if (spellCategory.present) {
      map['spell_category'] = Variable<String>(spellCategory.value);
    }
    if (shortLabel.present) {
      map['short_label'] = Variable<String>(shortLabel.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (triggersEffectId.present) {
      map['triggers_effect_id'] = Variable<int>(triggersEffectId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CardEffectsCompanion(')
          ..write('id: $id, ')
          ..write('cardDefinitionId: $cardDefinitionId, ')
          ..write('trigger: $trigger, ')
          ..write('spellCategory: $spellCategory, ')
          ..write('shortLabel: $shortLabel, ')
          ..write('description: $description, ')
          ..write('triggersEffectId: $triggersEffectId')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $DecksTable decks = $DecksTable(this);
  late final $CardDefinitionsTable cardDefinitions = $CardDefinitionsTable(
    this,
  );
  late final $DeckCardsTable deckCards = $DeckCardsTable(this);
  late final $CardEffectsTable cardEffects = $CardEffectsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    decks,
    cardDefinitions,
    deckCards,
    cardEffects,
  ];
}

typedef $$DecksTableCreateCompanionBuilder =
    DecksCompanion Function({
      Value<int> id,
      required String name,
      required DateTime createdAt,
      required DateTime updatedAt,
    });
typedef $$DecksTableUpdateCompanionBuilder =
    DecksCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

class $$DecksTableFilterComposer extends Composer<_$AppDatabase, $DecksTable> {
  $$DecksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DecksTableOrderingComposer
    extends Composer<_$AppDatabase, $DecksTable> {
  $$DecksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DecksTableAnnotationComposer
    extends Composer<_$AppDatabase, $DecksTable> {
  $$DecksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$DecksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DecksTable,
          Deck,
          $$DecksTableFilterComposer,
          $$DecksTableOrderingComposer,
          $$DecksTableAnnotationComposer,
          $$DecksTableCreateCompanionBuilder,
          $$DecksTableUpdateCompanionBuilder,
          (Deck, BaseReferences<_$AppDatabase, $DecksTable, Deck>),
          Deck,
          PrefetchHooks Function()
        > {
  $$DecksTableTableManager(_$AppDatabase db, $DecksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DecksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DecksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DecksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => DecksCompanion(
                id: id,
                name: name,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required DateTime createdAt,
                required DateTime updatedAt,
              }) => DecksCompanion.insert(
                id: id,
                name: name,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DecksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DecksTable,
      Deck,
      $$DecksTableFilterComposer,
      $$DecksTableOrderingComposer,
      $$DecksTableAnnotationComposer,
      $$DecksTableCreateCompanionBuilder,
      $$DecksTableUpdateCompanionBuilder,
      (Deck, BaseReferences<_$AppDatabase, $DecksTable, Deck>),
      Deck,
      PrefetchHooks Function()
    >;
typedef $$CardDefinitionsTableCreateCompanionBuilder =
    CardDefinitionsCompanion Function({
      Value<int> id,
      required String name,
      Value<String?> setCode,
      Value<String?> collectorNumber,
      Value<String?> scryfallId,
      Value<String?> manaCost,
      Value<double?> cmc,
      Value<String?> typeLine,
      Value<String?> oracleText,
      Value<String?> colors,
      Value<String?> power,
      Value<String?> toughness,
      Value<String?> imageUri,
    });
typedef $$CardDefinitionsTableUpdateCompanionBuilder =
    CardDefinitionsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String?> setCode,
      Value<String?> collectorNumber,
      Value<String?> scryfallId,
      Value<String?> manaCost,
      Value<double?> cmc,
      Value<String?> typeLine,
      Value<String?> oracleText,
      Value<String?> colors,
      Value<String?> power,
      Value<String?> toughness,
      Value<String?> imageUri,
    });

class $$CardDefinitionsTableFilterComposer
    extends Composer<_$AppDatabase, $CardDefinitionsTable> {
  $$CardDefinitionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get setCode => $composableBuilder(
    column: $table.setCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get collectorNumber => $composableBuilder(
    column: $table.collectorNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get scryfallId => $composableBuilder(
    column: $table.scryfallId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get manaCost => $composableBuilder(
    column: $table.manaCost,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get cmc => $composableBuilder(
    column: $table.cmc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get typeLine => $composableBuilder(
    column: $table.typeLine,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get oracleText => $composableBuilder(
    column: $table.oracleText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get colors => $composableBuilder(
    column: $table.colors,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get power => $composableBuilder(
    column: $table.power,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get toughness => $composableBuilder(
    column: $table.toughness,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imageUri => $composableBuilder(
    column: $table.imageUri,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CardDefinitionsTableOrderingComposer
    extends Composer<_$AppDatabase, $CardDefinitionsTable> {
  $$CardDefinitionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get setCode => $composableBuilder(
    column: $table.setCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get collectorNumber => $composableBuilder(
    column: $table.collectorNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get scryfallId => $composableBuilder(
    column: $table.scryfallId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get manaCost => $composableBuilder(
    column: $table.manaCost,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get cmc => $composableBuilder(
    column: $table.cmc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get typeLine => $composableBuilder(
    column: $table.typeLine,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get oracleText => $composableBuilder(
    column: $table.oracleText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get colors => $composableBuilder(
    column: $table.colors,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get power => $composableBuilder(
    column: $table.power,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get toughness => $composableBuilder(
    column: $table.toughness,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imageUri => $composableBuilder(
    column: $table.imageUri,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CardDefinitionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CardDefinitionsTable> {
  $$CardDefinitionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get setCode =>
      $composableBuilder(column: $table.setCode, builder: (column) => column);

  GeneratedColumn<String> get collectorNumber => $composableBuilder(
    column: $table.collectorNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get scryfallId => $composableBuilder(
    column: $table.scryfallId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get manaCost =>
      $composableBuilder(column: $table.manaCost, builder: (column) => column);

  GeneratedColumn<double> get cmc =>
      $composableBuilder(column: $table.cmc, builder: (column) => column);

  GeneratedColumn<String> get typeLine =>
      $composableBuilder(column: $table.typeLine, builder: (column) => column);

  GeneratedColumn<String> get oracleText => $composableBuilder(
    column: $table.oracleText,
    builder: (column) => column,
  );

  GeneratedColumn<String> get colors =>
      $composableBuilder(column: $table.colors, builder: (column) => column);

  GeneratedColumn<String> get power =>
      $composableBuilder(column: $table.power, builder: (column) => column);

  GeneratedColumn<String> get toughness =>
      $composableBuilder(column: $table.toughness, builder: (column) => column);

  GeneratedColumn<String> get imageUri =>
      $composableBuilder(column: $table.imageUri, builder: (column) => column);
}

class $$CardDefinitionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CardDefinitionsTable,
          CardDefinition,
          $$CardDefinitionsTableFilterComposer,
          $$CardDefinitionsTableOrderingComposer,
          $$CardDefinitionsTableAnnotationComposer,
          $$CardDefinitionsTableCreateCompanionBuilder,
          $$CardDefinitionsTableUpdateCompanionBuilder,
          (
            CardDefinition,
            BaseReferences<
              _$AppDatabase,
              $CardDefinitionsTable,
              CardDefinition
            >,
          ),
          CardDefinition,
          PrefetchHooks Function()
        > {
  $$CardDefinitionsTableTableManager(
    _$AppDatabase db,
    $CardDefinitionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CardDefinitionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CardDefinitionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CardDefinitionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> setCode = const Value.absent(),
                Value<String?> collectorNumber = const Value.absent(),
                Value<String?> scryfallId = const Value.absent(),
                Value<String?> manaCost = const Value.absent(),
                Value<double?> cmc = const Value.absent(),
                Value<String?> typeLine = const Value.absent(),
                Value<String?> oracleText = const Value.absent(),
                Value<String?> colors = const Value.absent(),
                Value<String?> power = const Value.absent(),
                Value<String?> toughness = const Value.absent(),
                Value<String?> imageUri = const Value.absent(),
              }) => CardDefinitionsCompanion(
                id: id,
                name: name,
                setCode: setCode,
                collectorNumber: collectorNumber,
                scryfallId: scryfallId,
                manaCost: manaCost,
                cmc: cmc,
                typeLine: typeLine,
                oracleText: oracleText,
                colors: colors,
                power: power,
                toughness: toughness,
                imageUri: imageUri,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<String?> setCode = const Value.absent(),
                Value<String?> collectorNumber = const Value.absent(),
                Value<String?> scryfallId = const Value.absent(),
                Value<String?> manaCost = const Value.absent(),
                Value<double?> cmc = const Value.absent(),
                Value<String?> typeLine = const Value.absent(),
                Value<String?> oracleText = const Value.absent(),
                Value<String?> colors = const Value.absent(),
                Value<String?> power = const Value.absent(),
                Value<String?> toughness = const Value.absent(),
                Value<String?> imageUri = const Value.absent(),
              }) => CardDefinitionsCompanion.insert(
                id: id,
                name: name,
                setCode: setCode,
                collectorNumber: collectorNumber,
                scryfallId: scryfallId,
                manaCost: manaCost,
                cmc: cmc,
                typeLine: typeLine,
                oracleText: oracleText,
                colors: colors,
                power: power,
                toughness: toughness,
                imageUri: imageUri,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CardDefinitionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CardDefinitionsTable,
      CardDefinition,
      $$CardDefinitionsTableFilterComposer,
      $$CardDefinitionsTableOrderingComposer,
      $$CardDefinitionsTableAnnotationComposer,
      $$CardDefinitionsTableCreateCompanionBuilder,
      $$CardDefinitionsTableUpdateCompanionBuilder,
      (
        CardDefinition,
        BaseReferences<_$AppDatabase, $CardDefinitionsTable, CardDefinition>,
      ),
      CardDefinition,
      PrefetchHooks Function()
    >;
typedef $$DeckCardsTableCreateCompanionBuilder =
    DeckCardsCompanion Function({
      Value<int> id,
      required int deckId,
      required int cardDefinitionId,
      Value<String> board,
      Value<bool> inPlay,
    });
typedef $$DeckCardsTableUpdateCompanionBuilder =
    DeckCardsCompanion Function({
      Value<int> id,
      Value<int> deckId,
      Value<int> cardDefinitionId,
      Value<String> board,
      Value<bool> inPlay,
    });

class $$DeckCardsTableFilterComposer
    extends Composer<_$AppDatabase, $DeckCardsTable> {
  $$DeckCardsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get deckId => $composableBuilder(
    column: $table.deckId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get cardDefinitionId => $composableBuilder(
    column: $table.cardDefinitionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get board => $composableBuilder(
    column: $table.board,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get inPlay => $composableBuilder(
    column: $table.inPlay,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DeckCardsTableOrderingComposer
    extends Composer<_$AppDatabase, $DeckCardsTable> {
  $$DeckCardsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get deckId => $composableBuilder(
    column: $table.deckId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get cardDefinitionId => $composableBuilder(
    column: $table.cardDefinitionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get board => $composableBuilder(
    column: $table.board,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get inPlay => $composableBuilder(
    column: $table.inPlay,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DeckCardsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DeckCardsTable> {
  $$DeckCardsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get deckId =>
      $composableBuilder(column: $table.deckId, builder: (column) => column);

  GeneratedColumn<int> get cardDefinitionId => $composableBuilder(
    column: $table.cardDefinitionId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get board =>
      $composableBuilder(column: $table.board, builder: (column) => column);

  GeneratedColumn<bool> get inPlay =>
      $composableBuilder(column: $table.inPlay, builder: (column) => column);
}

class $$DeckCardsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DeckCardsTable,
          DeckCard,
          $$DeckCardsTableFilterComposer,
          $$DeckCardsTableOrderingComposer,
          $$DeckCardsTableAnnotationComposer,
          $$DeckCardsTableCreateCompanionBuilder,
          $$DeckCardsTableUpdateCompanionBuilder,
          (DeckCard, BaseReferences<_$AppDatabase, $DeckCardsTable, DeckCard>),
          DeckCard,
          PrefetchHooks Function()
        > {
  $$DeckCardsTableTableManager(_$AppDatabase db, $DeckCardsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DeckCardsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DeckCardsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DeckCardsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> deckId = const Value.absent(),
                Value<int> cardDefinitionId = const Value.absent(),
                Value<String> board = const Value.absent(),
                Value<bool> inPlay = const Value.absent(),
              }) => DeckCardsCompanion(
                id: id,
                deckId: deckId,
                cardDefinitionId: cardDefinitionId,
                board: board,
                inPlay: inPlay,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int deckId,
                required int cardDefinitionId,
                Value<String> board = const Value.absent(),
                Value<bool> inPlay = const Value.absent(),
              }) => DeckCardsCompanion.insert(
                id: id,
                deckId: deckId,
                cardDefinitionId: cardDefinitionId,
                board: board,
                inPlay: inPlay,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DeckCardsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DeckCardsTable,
      DeckCard,
      $$DeckCardsTableFilterComposer,
      $$DeckCardsTableOrderingComposer,
      $$DeckCardsTableAnnotationComposer,
      $$DeckCardsTableCreateCompanionBuilder,
      $$DeckCardsTableUpdateCompanionBuilder,
      (DeckCard, BaseReferences<_$AppDatabase, $DeckCardsTable, DeckCard>),
      DeckCard,
      PrefetchHooks Function()
    >;
typedef $$CardEffectsTableCreateCompanionBuilder =
    CardEffectsCompanion Function({
      Value<int> id,
      required int cardDefinitionId,
      required String trigger,
      Value<String?> spellCategory,
      Value<String> shortLabel,
      required String description,
      Value<int?> triggersEffectId,
    });
typedef $$CardEffectsTableUpdateCompanionBuilder =
    CardEffectsCompanion Function({
      Value<int> id,
      Value<int> cardDefinitionId,
      Value<String> trigger,
      Value<String?> spellCategory,
      Value<String> shortLabel,
      Value<String> description,
      Value<int?> triggersEffectId,
    });

class $$CardEffectsTableFilterComposer
    extends Composer<_$AppDatabase, $CardEffectsTable> {
  $$CardEffectsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get cardDefinitionId => $composableBuilder(
    column: $table.cardDefinitionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get trigger => $composableBuilder(
    column: $table.trigger,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get spellCategory => $composableBuilder(
    column: $table.spellCategory,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get shortLabel => $composableBuilder(
    column: $table.shortLabel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get triggersEffectId => $composableBuilder(
    column: $table.triggersEffectId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CardEffectsTableOrderingComposer
    extends Composer<_$AppDatabase, $CardEffectsTable> {
  $$CardEffectsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get cardDefinitionId => $composableBuilder(
    column: $table.cardDefinitionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get trigger => $composableBuilder(
    column: $table.trigger,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get spellCategory => $composableBuilder(
    column: $table.spellCategory,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get shortLabel => $composableBuilder(
    column: $table.shortLabel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get triggersEffectId => $composableBuilder(
    column: $table.triggersEffectId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CardEffectsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CardEffectsTable> {
  $$CardEffectsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get cardDefinitionId => $composableBuilder(
    column: $table.cardDefinitionId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get trigger =>
      $composableBuilder(column: $table.trigger, builder: (column) => column);

  GeneratedColumn<String> get spellCategory => $composableBuilder(
    column: $table.spellCategory,
    builder: (column) => column,
  );

  GeneratedColumn<String> get shortLabel => $composableBuilder(
    column: $table.shortLabel,
    builder: (column) => column,
  );

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<int> get triggersEffectId => $composableBuilder(
    column: $table.triggersEffectId,
    builder: (column) => column,
  );
}

class $$CardEffectsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CardEffectsTable,
          CardEffect,
          $$CardEffectsTableFilterComposer,
          $$CardEffectsTableOrderingComposer,
          $$CardEffectsTableAnnotationComposer,
          $$CardEffectsTableCreateCompanionBuilder,
          $$CardEffectsTableUpdateCompanionBuilder,
          (
            CardEffect,
            BaseReferences<_$AppDatabase, $CardEffectsTable, CardEffect>,
          ),
          CardEffect,
          PrefetchHooks Function()
        > {
  $$CardEffectsTableTableManager(_$AppDatabase db, $CardEffectsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CardEffectsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CardEffectsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CardEffectsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> cardDefinitionId = const Value.absent(),
                Value<String> trigger = const Value.absent(),
                Value<String?> spellCategory = const Value.absent(),
                Value<String> shortLabel = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<int?> triggersEffectId = const Value.absent(),
              }) => CardEffectsCompanion(
                id: id,
                cardDefinitionId: cardDefinitionId,
                trigger: trigger,
                spellCategory: spellCategory,
                shortLabel: shortLabel,
                description: description,
                triggersEffectId: triggersEffectId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int cardDefinitionId,
                required String trigger,
                Value<String?> spellCategory = const Value.absent(),
                Value<String> shortLabel = const Value.absent(),
                required String description,
                Value<int?> triggersEffectId = const Value.absent(),
              }) => CardEffectsCompanion.insert(
                id: id,
                cardDefinitionId: cardDefinitionId,
                trigger: trigger,
                spellCategory: spellCategory,
                shortLabel: shortLabel,
                description: description,
                triggersEffectId: triggersEffectId,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CardEffectsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CardEffectsTable,
      CardEffect,
      $$CardEffectsTableFilterComposer,
      $$CardEffectsTableOrderingComposer,
      $$CardEffectsTableAnnotationComposer,
      $$CardEffectsTableCreateCompanionBuilder,
      $$CardEffectsTableUpdateCompanionBuilder,
      (
        CardEffect,
        BaseReferences<_$AppDatabase, $CardEffectsTable, CardEffect>,
      ),
      CardEffect,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$DecksTableTableManager get decks =>
      $$DecksTableTableManager(_db, _db.decks);
  $$CardDefinitionsTableTableManager get cardDefinitions =>
      $$CardDefinitionsTableTableManager(_db, _db.cardDefinitions);
  $$DeckCardsTableTableManager get deckCards =>
      $$DeckCardsTableTableManager(_db, _db.deckCards);
  $$CardEffectsTableTableManager get cardEffects =>
      $$CardEffectsTableTableManager(_db, _db.cardEffects);
}
