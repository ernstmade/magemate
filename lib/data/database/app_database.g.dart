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
  static const VerificationMeta _printedNameMeta = const VerificationMeta(
    'printedName',
  );
  @override
  late final GeneratedColumn<String> printedName = GeneratedColumn<String>(
    'printed_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _printedTextMeta = const VerificationMeta(
    'printedText',
  );
  @override
  late final GeneratedColumn<String> printedText = GeneratedColumn<String>(
    'printed_text',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _printedTypeLineMeta = const VerificationMeta(
    'printedTypeLine',
  );
  @override
  late final GeneratedColumn<String> printedTypeLine = GeneratedColumn<String>(
    'printed_type_line',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _ratingMeta = const VerificationMeta('rating');
  @override
  late final GeneratedColumn<double> rating = GeneratedColumn<double>(
    'rating',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _keywordsMeta = const VerificationMeta(
    'keywords',
  );
  @override
  late final GeneratedColumn<String> keywords = GeneratedColumn<String>(
    'keywords',
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
    printedName,
    printedText,
    printedTypeLine,
    rating,
    keywords,
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
    if (data.containsKey('printed_name')) {
      context.handle(
        _printedNameMeta,
        printedName.isAcceptableOrUnknown(
          data['printed_name']!,
          _printedNameMeta,
        ),
      );
    }
    if (data.containsKey('printed_text')) {
      context.handle(
        _printedTextMeta,
        printedText.isAcceptableOrUnknown(
          data['printed_text']!,
          _printedTextMeta,
        ),
      );
    }
    if (data.containsKey('printed_type_line')) {
      context.handle(
        _printedTypeLineMeta,
        printedTypeLine.isAcceptableOrUnknown(
          data['printed_type_line']!,
          _printedTypeLineMeta,
        ),
      );
    }
    if (data.containsKey('rating')) {
      context.handle(
        _ratingMeta,
        rating.isAcceptableOrUnknown(data['rating']!, _ratingMeta),
      );
    }
    if (data.containsKey('keywords')) {
      context.handle(
        _keywordsMeta,
        keywords.isAcceptableOrUnknown(data['keywords']!, _keywordsMeta),
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
      printedName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}printed_name'],
      ),
      printedText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}printed_text'],
      ),
      printedTypeLine: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}printed_type_line'],
      ),
      rating: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}rating'],
      ),
      keywords: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}keywords'],
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
  final String? printedName;
  final String? printedText;
  final String? printedTypeLine;
  final double? rating;
  final String? keywords;
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
    this.printedName,
    this.printedText,
    this.printedTypeLine,
    this.rating,
    this.keywords,
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
    if (!nullToAbsent || printedName != null) {
      map['printed_name'] = Variable<String>(printedName);
    }
    if (!nullToAbsent || printedText != null) {
      map['printed_text'] = Variable<String>(printedText);
    }
    if (!nullToAbsent || printedTypeLine != null) {
      map['printed_type_line'] = Variable<String>(printedTypeLine);
    }
    if (!nullToAbsent || rating != null) {
      map['rating'] = Variable<double>(rating);
    }
    if (!nullToAbsent || keywords != null) {
      map['keywords'] = Variable<String>(keywords);
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
      printedName: printedName == null && nullToAbsent
          ? const Value.absent()
          : Value(printedName),
      printedText: printedText == null && nullToAbsent
          ? const Value.absent()
          : Value(printedText),
      printedTypeLine: printedTypeLine == null && nullToAbsent
          ? const Value.absent()
          : Value(printedTypeLine),
      rating: rating == null && nullToAbsent
          ? const Value.absent()
          : Value(rating),
      keywords: keywords == null && nullToAbsent
          ? const Value.absent()
          : Value(keywords),
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
      printedName: serializer.fromJson<String?>(json['printedName']),
      printedText: serializer.fromJson<String?>(json['printedText']),
      printedTypeLine: serializer.fromJson<String?>(json['printedTypeLine']),
      rating: serializer.fromJson<double?>(json['rating']),
      keywords: serializer.fromJson<String?>(json['keywords']),
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
      'printedName': serializer.toJson<String?>(printedName),
      'printedText': serializer.toJson<String?>(printedText),
      'printedTypeLine': serializer.toJson<String?>(printedTypeLine),
      'rating': serializer.toJson<double?>(rating),
      'keywords': serializer.toJson<String?>(keywords),
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
    Value<String?> printedName = const Value.absent(),
    Value<String?> printedText = const Value.absent(),
    Value<String?> printedTypeLine = const Value.absent(),
    Value<double?> rating = const Value.absent(),
    Value<String?> keywords = const Value.absent(),
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
    printedName: printedName.present ? printedName.value : this.printedName,
    printedText: printedText.present ? printedText.value : this.printedText,
    printedTypeLine: printedTypeLine.present
        ? printedTypeLine.value
        : this.printedTypeLine,
    rating: rating.present ? rating.value : this.rating,
    keywords: keywords.present ? keywords.value : this.keywords,
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
      printedName: data.printedName.present
          ? data.printedName.value
          : this.printedName,
      printedText: data.printedText.present
          ? data.printedText.value
          : this.printedText,
      printedTypeLine: data.printedTypeLine.present
          ? data.printedTypeLine.value
          : this.printedTypeLine,
      rating: data.rating.present ? data.rating.value : this.rating,
      keywords: data.keywords.present ? data.keywords.value : this.keywords,
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
          ..write('imageUri: $imageUri, ')
          ..write('printedName: $printedName, ')
          ..write('printedText: $printedText, ')
          ..write('printedTypeLine: $printedTypeLine, ')
          ..write('rating: $rating, ')
          ..write('keywords: $keywords')
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
    printedName,
    printedText,
    printedTypeLine,
    rating,
    keywords,
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
          other.imageUri == this.imageUri &&
          other.printedName == this.printedName &&
          other.printedText == this.printedText &&
          other.printedTypeLine == this.printedTypeLine &&
          other.rating == this.rating &&
          other.keywords == this.keywords);
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
  final Value<String?> printedName;
  final Value<String?> printedText;
  final Value<String?> printedTypeLine;
  final Value<double?> rating;
  final Value<String?> keywords;
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
    this.printedName = const Value.absent(),
    this.printedText = const Value.absent(),
    this.printedTypeLine = const Value.absent(),
    this.rating = const Value.absent(),
    this.keywords = const Value.absent(),
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
    this.printedName = const Value.absent(),
    this.printedText = const Value.absent(),
    this.printedTypeLine = const Value.absent(),
    this.rating = const Value.absent(),
    this.keywords = const Value.absent(),
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
    Expression<String>? printedName,
    Expression<String>? printedText,
    Expression<String>? printedTypeLine,
    Expression<double>? rating,
    Expression<String>? keywords,
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
      if (printedName != null) 'printed_name': printedName,
      if (printedText != null) 'printed_text': printedText,
      if (printedTypeLine != null) 'printed_type_line': printedTypeLine,
      if (rating != null) 'rating': rating,
      if (keywords != null) 'keywords': keywords,
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
    Value<String?>? printedName,
    Value<String?>? printedText,
    Value<String?>? printedTypeLine,
    Value<double?>? rating,
    Value<String?>? keywords,
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
      printedName: printedName ?? this.printedName,
      printedText: printedText ?? this.printedText,
      printedTypeLine: printedTypeLine ?? this.printedTypeLine,
      rating: rating ?? this.rating,
      keywords: keywords ?? this.keywords,
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
    if (printedName.present) {
      map['printed_name'] = Variable<String>(printedName.value);
    }
    if (printedText.present) {
      map['printed_text'] = Variable<String>(printedText.value);
    }
    if (printedTypeLine.present) {
      map['printed_type_line'] = Variable<String>(printedTypeLine.value);
    }
    if (rating.present) {
      map['rating'] = Variable<double>(rating.value);
    }
    if (keywords.present) {
      map['keywords'] = Variable<String>(keywords.value);
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
          ..write('imageUri: $imageUri, ')
          ..write('printedName: $printedName, ')
          ..write('printedText: $printedText, ')
          ..write('printedTypeLine: $printedTypeLine, ')
          ..write('rating: $rating, ')
          ..write('keywords: $keywords')
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
  static const VerificationMeta _triggerDetailMeta = const VerificationMeta(
    'triggerDetail',
  );
  @override
  late final GeneratedColumn<String> triggerDetail = GeneratedColumn<String>(
    'spell_category',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _extraConditionsMeta = const VerificationMeta(
    'extraConditions',
  );
  @override
  late final GeneratedColumn<String> extraConditions = GeneratedColumn<String>(
    'extra_conditions',
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
  static const VerificationMeta _shortLabelEnMeta = const VerificationMeta(
    'shortLabelEn',
  );
  @override
  late final GeneratedColumn<String> shortLabelEn = GeneratedColumn<String>(
    'short_label_en',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
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
  static const VerificationMeta _damageAmountMeta = const VerificationMeta(
    'damageAmount',
  );
  @override
  late final GeneratedColumn<int> damageAmount = GeneratedColumn<int>(
    'damage_amount',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _damageTargetMeta = const VerificationMeta(
    'damageTarget',
  );
  @override
  late final GeneratedColumn<String> damageTarget = GeneratedColumn<String>(
    'damage_target',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _replacementScopeMeta = const VerificationMeta(
    'replacementScope',
  );
  @override
  late final GeneratedColumn<String> replacementScope = GeneratedColumn<String>(
    'replacement_scope',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dynamicDamageMeta = const VerificationMeta(
    'dynamicDamage',
  );
  @override
  late final GeneratedColumn<bool> dynamicDamage = GeneratedColumn<bool>(
    'dynamic_damage',
    aliasedName,
    true,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("dynamic_damage" IN (0, 1))',
    ),
  );
  static const VerificationMeta _damageMultiplierMeta = const VerificationMeta(
    'damageMultiplier',
  );
  @override
  late final GeneratedColumn<int> damageMultiplier = GeneratedColumn<int>(
    'damage_multiplier',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _damageMinimumMeta = const VerificationMeta(
    'damageMinimum',
  );
  @override
  late final GeneratedColumn<int> damageMinimum = GeneratedColumn<int>(
    'damage_minimum',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _triggerConditionTextMeta =
      const VerificationMeta('triggerConditionText');
  @override
  late final GeneratedColumn<String> triggerConditionText =
      GeneratedColumn<String>(
        'trigger_condition_text',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
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
  static const VerificationMeta _effectTypeMeta = const VerificationMeta(
    'effectType',
  );
  @override
  late final GeneratedColumn<String> effectType = GeneratedColumn<String>(
    'effect_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _ceScopeMeta = const VerificationMeta(
    'ceScope',
  );
  @override
  late final GeneratedColumn<String> ceScope = GeneratedColumn<String>(
    'ce_scope',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _effectDetailMeta = const VerificationMeta(
    'effectDetail',
  );
  @override
  late final GeneratedColumn<String> effectDetail = GeneratedColumn<String>(
    'effect_detail',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _effectExtraConditionsMeta =
      const VerificationMeta('effectExtraConditions');
  @override
  late final GeneratedColumn<String> effectExtraConditions =
      GeneratedColumn<String>(
        'effect_extra_conditions',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    cardDefinitionId,
    trigger,
    triggerDetail,
    extraConditions,
    shortLabel,
    shortLabelEn,
    description,
    damageAmount,
    damageTarget,
    replacementScope,
    dynamicDamage,
    damageMultiplier,
    damageMinimum,
    triggerConditionText,
    triggersEffectId,
    effectType,
    ceScope,
    effectDetail,
    effectExtraConditions,
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
        _triggerDetailMeta,
        triggerDetail.isAcceptableOrUnknown(
          data['spell_category']!,
          _triggerDetailMeta,
        ),
      );
    }
    if (data.containsKey('extra_conditions')) {
      context.handle(
        _extraConditionsMeta,
        extraConditions.isAcceptableOrUnknown(
          data['extra_conditions']!,
          _extraConditionsMeta,
        ),
      );
    }
    if (data.containsKey('short_label')) {
      context.handle(
        _shortLabelMeta,
        shortLabel.isAcceptableOrUnknown(data['short_label']!, _shortLabelMeta),
      );
    }
    if (data.containsKey('short_label_en')) {
      context.handle(
        _shortLabelEnMeta,
        shortLabelEn.isAcceptableOrUnknown(
          data['short_label_en']!,
          _shortLabelEnMeta,
        ),
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
    if (data.containsKey('damage_amount')) {
      context.handle(
        _damageAmountMeta,
        damageAmount.isAcceptableOrUnknown(
          data['damage_amount']!,
          _damageAmountMeta,
        ),
      );
    }
    if (data.containsKey('damage_target')) {
      context.handle(
        _damageTargetMeta,
        damageTarget.isAcceptableOrUnknown(
          data['damage_target']!,
          _damageTargetMeta,
        ),
      );
    }
    if (data.containsKey('replacement_scope')) {
      context.handle(
        _replacementScopeMeta,
        replacementScope.isAcceptableOrUnknown(
          data['replacement_scope']!,
          _replacementScopeMeta,
        ),
      );
    }
    if (data.containsKey('dynamic_damage')) {
      context.handle(
        _dynamicDamageMeta,
        dynamicDamage.isAcceptableOrUnknown(
          data['dynamic_damage']!,
          _dynamicDamageMeta,
        ),
      );
    }
    if (data.containsKey('damage_multiplier')) {
      context.handle(
        _damageMultiplierMeta,
        damageMultiplier.isAcceptableOrUnknown(
          data['damage_multiplier']!,
          _damageMultiplierMeta,
        ),
      );
    }
    if (data.containsKey('damage_minimum')) {
      context.handle(
        _damageMinimumMeta,
        damageMinimum.isAcceptableOrUnknown(
          data['damage_minimum']!,
          _damageMinimumMeta,
        ),
      );
    }
    if (data.containsKey('trigger_condition_text')) {
      context.handle(
        _triggerConditionTextMeta,
        triggerConditionText.isAcceptableOrUnknown(
          data['trigger_condition_text']!,
          _triggerConditionTextMeta,
        ),
      );
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
    if (data.containsKey('effect_type')) {
      context.handle(
        _effectTypeMeta,
        effectType.isAcceptableOrUnknown(data['effect_type']!, _effectTypeMeta),
      );
    }
    if (data.containsKey('ce_scope')) {
      context.handle(
        _ceScopeMeta,
        ceScope.isAcceptableOrUnknown(data['ce_scope']!, _ceScopeMeta),
      );
    }
    if (data.containsKey('effect_detail')) {
      context.handle(
        _effectDetailMeta,
        effectDetail.isAcceptableOrUnknown(
          data['effect_detail']!,
          _effectDetailMeta,
        ),
      );
    }
    if (data.containsKey('effect_extra_conditions')) {
      context.handle(
        _effectExtraConditionsMeta,
        effectExtraConditions.isAcceptableOrUnknown(
          data['effect_extra_conditions']!,
          _effectExtraConditionsMeta,
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
      triggerDetail: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}spell_category'],
      ),
      extraConditions: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}extra_conditions'],
      ),
      shortLabel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}short_label'],
      )!,
      shortLabelEn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}short_label_en'],
      ),
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      damageAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}damage_amount'],
      ),
      damageTarget: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}damage_target'],
      ),
      replacementScope: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}replacement_scope'],
      ),
      dynamicDamage: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}dynamic_damage'],
      ),
      damageMultiplier: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}damage_multiplier'],
      ),
      damageMinimum: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}damage_minimum'],
      ),
      triggerConditionText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}trigger_condition_text'],
      ),
      triggersEffectId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}triggers_effect_id'],
      ),
      effectType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}effect_type'],
      ),
      ceScope: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ce_scope'],
      ),
      effectDetail: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}effect_detail'],
      ),
      effectExtraConditions: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}effect_extra_conditions'],
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
  final String? triggerDetail;
  final String? extraConditions;
  final String shortLabel;
  final String? shortLabelEn;
  final String description;
  final int? damageAmount;
  final String? damageTarget;
  final String? replacementScope;
  final bool? dynamicDamage;
  final int? damageMultiplier;
  final int? damageMinimum;
  final String? triggerConditionText;
  final int? triggersEffectId;
  final String? effectType;
  final String? ceScope;
  final String? effectDetail;
  final String? effectExtraConditions;
  const CardEffect({
    required this.id,
    required this.cardDefinitionId,
    required this.trigger,
    this.triggerDetail,
    this.extraConditions,
    required this.shortLabel,
    this.shortLabelEn,
    required this.description,
    this.damageAmount,
    this.damageTarget,
    this.replacementScope,
    this.dynamicDamage,
    this.damageMultiplier,
    this.damageMinimum,
    this.triggerConditionText,
    this.triggersEffectId,
    this.effectType,
    this.ceScope,
    this.effectDetail,
    this.effectExtraConditions,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['card_definition_id'] = Variable<int>(cardDefinitionId);
    map['trigger'] = Variable<String>(trigger);
    if (!nullToAbsent || triggerDetail != null) {
      map['spell_category'] = Variable<String>(triggerDetail);
    }
    if (!nullToAbsent || extraConditions != null) {
      map['extra_conditions'] = Variable<String>(extraConditions);
    }
    map['short_label'] = Variable<String>(shortLabel);
    if (!nullToAbsent || shortLabelEn != null) {
      map['short_label_en'] = Variable<String>(shortLabelEn);
    }
    map['description'] = Variable<String>(description);
    if (!nullToAbsent || damageAmount != null) {
      map['damage_amount'] = Variable<int>(damageAmount);
    }
    if (!nullToAbsent || damageTarget != null) {
      map['damage_target'] = Variable<String>(damageTarget);
    }
    if (!nullToAbsent || replacementScope != null) {
      map['replacement_scope'] = Variable<String>(replacementScope);
    }
    if (!nullToAbsent || dynamicDamage != null) {
      map['dynamic_damage'] = Variable<bool>(dynamicDamage);
    }
    if (!nullToAbsent || damageMultiplier != null) {
      map['damage_multiplier'] = Variable<int>(damageMultiplier);
    }
    if (!nullToAbsent || damageMinimum != null) {
      map['damage_minimum'] = Variable<int>(damageMinimum);
    }
    if (!nullToAbsent || triggerConditionText != null) {
      map['trigger_condition_text'] = Variable<String>(triggerConditionText);
    }
    if (!nullToAbsent || triggersEffectId != null) {
      map['triggers_effect_id'] = Variable<int>(triggersEffectId);
    }
    if (!nullToAbsent || effectType != null) {
      map['effect_type'] = Variable<String>(effectType);
    }
    if (!nullToAbsent || ceScope != null) {
      map['ce_scope'] = Variable<String>(ceScope);
    }
    if (!nullToAbsent || effectDetail != null) {
      map['effect_detail'] = Variable<String>(effectDetail);
    }
    if (!nullToAbsent || effectExtraConditions != null) {
      map['effect_extra_conditions'] = Variable<String>(effectExtraConditions);
    }
    return map;
  }

  CardEffectsCompanion toCompanion(bool nullToAbsent) {
    return CardEffectsCompanion(
      id: Value(id),
      cardDefinitionId: Value(cardDefinitionId),
      trigger: Value(trigger),
      triggerDetail: triggerDetail == null && nullToAbsent
          ? const Value.absent()
          : Value(triggerDetail),
      extraConditions: extraConditions == null && nullToAbsent
          ? const Value.absent()
          : Value(extraConditions),
      shortLabel: Value(shortLabel),
      shortLabelEn: shortLabelEn == null && nullToAbsent
          ? const Value.absent()
          : Value(shortLabelEn),
      description: Value(description),
      damageAmount: damageAmount == null && nullToAbsent
          ? const Value.absent()
          : Value(damageAmount),
      damageTarget: damageTarget == null && nullToAbsent
          ? const Value.absent()
          : Value(damageTarget),
      replacementScope: replacementScope == null && nullToAbsent
          ? const Value.absent()
          : Value(replacementScope),
      dynamicDamage: dynamicDamage == null && nullToAbsent
          ? const Value.absent()
          : Value(dynamicDamage),
      damageMultiplier: damageMultiplier == null && nullToAbsent
          ? const Value.absent()
          : Value(damageMultiplier),
      damageMinimum: damageMinimum == null && nullToAbsent
          ? const Value.absent()
          : Value(damageMinimum),
      triggerConditionText: triggerConditionText == null && nullToAbsent
          ? const Value.absent()
          : Value(triggerConditionText),
      triggersEffectId: triggersEffectId == null && nullToAbsent
          ? const Value.absent()
          : Value(triggersEffectId),
      effectType: effectType == null && nullToAbsent
          ? const Value.absent()
          : Value(effectType),
      ceScope: ceScope == null && nullToAbsent
          ? const Value.absent()
          : Value(ceScope),
      effectDetail: effectDetail == null && nullToAbsent
          ? const Value.absent()
          : Value(effectDetail),
      effectExtraConditions: effectExtraConditions == null && nullToAbsent
          ? const Value.absent()
          : Value(effectExtraConditions),
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
      triggerDetail: serializer.fromJson<String?>(json['triggerDetail']),
      extraConditions: serializer.fromJson<String?>(json['extraConditions']),
      shortLabel: serializer.fromJson<String>(json['shortLabel']),
      shortLabelEn: serializer.fromJson<String?>(json['shortLabelEn']),
      description: serializer.fromJson<String>(json['description']),
      damageAmount: serializer.fromJson<int?>(json['damageAmount']),
      damageTarget: serializer.fromJson<String?>(json['damageTarget']),
      replacementScope: serializer.fromJson<String?>(json['replacementScope']),
      dynamicDamage: serializer.fromJson<bool?>(json['dynamicDamage']),
      damageMultiplier: serializer.fromJson<int?>(json['damageMultiplier']),
      damageMinimum: serializer.fromJson<int?>(json['damageMinimum']),
      triggerConditionText: serializer.fromJson<String?>(
        json['triggerConditionText'],
      ),
      triggersEffectId: serializer.fromJson<int?>(json['triggersEffectId']),
      effectType: serializer.fromJson<String?>(json['effectType']),
      ceScope: serializer.fromJson<String?>(json['ceScope']),
      effectDetail: serializer.fromJson<String?>(json['effectDetail']),
      effectExtraConditions: serializer.fromJson<String?>(
        json['effectExtraConditions'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'cardDefinitionId': serializer.toJson<int>(cardDefinitionId),
      'trigger': serializer.toJson<String>(trigger),
      'triggerDetail': serializer.toJson<String?>(triggerDetail),
      'extraConditions': serializer.toJson<String?>(extraConditions),
      'shortLabel': serializer.toJson<String>(shortLabel),
      'shortLabelEn': serializer.toJson<String?>(shortLabelEn),
      'description': serializer.toJson<String>(description),
      'damageAmount': serializer.toJson<int?>(damageAmount),
      'damageTarget': serializer.toJson<String?>(damageTarget),
      'replacementScope': serializer.toJson<String?>(replacementScope),
      'dynamicDamage': serializer.toJson<bool?>(dynamicDamage),
      'damageMultiplier': serializer.toJson<int?>(damageMultiplier),
      'damageMinimum': serializer.toJson<int?>(damageMinimum),
      'triggerConditionText': serializer.toJson<String?>(triggerConditionText),
      'triggersEffectId': serializer.toJson<int?>(triggersEffectId),
      'effectType': serializer.toJson<String?>(effectType),
      'ceScope': serializer.toJson<String?>(ceScope),
      'effectDetail': serializer.toJson<String?>(effectDetail),
      'effectExtraConditions': serializer.toJson<String?>(
        effectExtraConditions,
      ),
    };
  }

  CardEffect copyWith({
    int? id,
    int? cardDefinitionId,
    String? trigger,
    Value<String?> triggerDetail = const Value.absent(),
    Value<String?> extraConditions = const Value.absent(),
    String? shortLabel,
    Value<String?> shortLabelEn = const Value.absent(),
    String? description,
    Value<int?> damageAmount = const Value.absent(),
    Value<String?> damageTarget = const Value.absent(),
    Value<String?> replacementScope = const Value.absent(),
    Value<bool?> dynamicDamage = const Value.absent(),
    Value<int?> damageMultiplier = const Value.absent(),
    Value<int?> damageMinimum = const Value.absent(),
    Value<String?> triggerConditionText = const Value.absent(),
    Value<int?> triggersEffectId = const Value.absent(),
    Value<String?> effectType = const Value.absent(),
    Value<String?> ceScope = const Value.absent(),
    Value<String?> effectDetail = const Value.absent(),
    Value<String?> effectExtraConditions = const Value.absent(),
  }) => CardEffect(
    id: id ?? this.id,
    cardDefinitionId: cardDefinitionId ?? this.cardDefinitionId,
    trigger: trigger ?? this.trigger,
    triggerDetail: triggerDetail.present
        ? triggerDetail.value
        : this.triggerDetail,
    extraConditions: extraConditions.present
        ? extraConditions.value
        : this.extraConditions,
    shortLabel: shortLabel ?? this.shortLabel,
    shortLabelEn: shortLabelEn.present ? shortLabelEn.value : this.shortLabelEn,
    description: description ?? this.description,
    damageAmount: damageAmount.present ? damageAmount.value : this.damageAmount,
    damageTarget: damageTarget.present ? damageTarget.value : this.damageTarget,
    replacementScope: replacementScope.present
        ? replacementScope.value
        : this.replacementScope,
    dynamicDamage: dynamicDamage.present
        ? dynamicDamage.value
        : this.dynamicDamage,
    damageMultiplier: damageMultiplier.present
        ? damageMultiplier.value
        : this.damageMultiplier,
    damageMinimum: damageMinimum.present
        ? damageMinimum.value
        : this.damageMinimum,
    triggerConditionText: triggerConditionText.present
        ? triggerConditionText.value
        : this.triggerConditionText,
    triggersEffectId: triggersEffectId.present
        ? triggersEffectId.value
        : this.triggersEffectId,
    effectType: effectType.present ? effectType.value : this.effectType,
    ceScope: ceScope.present ? ceScope.value : this.ceScope,
    effectDetail: effectDetail.present ? effectDetail.value : this.effectDetail,
    effectExtraConditions: effectExtraConditions.present
        ? effectExtraConditions.value
        : this.effectExtraConditions,
  );
  CardEffect copyWithCompanion(CardEffectsCompanion data) {
    return CardEffect(
      id: data.id.present ? data.id.value : this.id,
      cardDefinitionId: data.cardDefinitionId.present
          ? data.cardDefinitionId.value
          : this.cardDefinitionId,
      trigger: data.trigger.present ? data.trigger.value : this.trigger,
      triggerDetail: data.triggerDetail.present
          ? data.triggerDetail.value
          : this.triggerDetail,
      extraConditions: data.extraConditions.present
          ? data.extraConditions.value
          : this.extraConditions,
      shortLabel: data.shortLabel.present
          ? data.shortLabel.value
          : this.shortLabel,
      shortLabelEn: data.shortLabelEn.present
          ? data.shortLabelEn.value
          : this.shortLabelEn,
      description: data.description.present
          ? data.description.value
          : this.description,
      damageAmount: data.damageAmount.present
          ? data.damageAmount.value
          : this.damageAmount,
      damageTarget: data.damageTarget.present
          ? data.damageTarget.value
          : this.damageTarget,
      replacementScope: data.replacementScope.present
          ? data.replacementScope.value
          : this.replacementScope,
      dynamicDamage: data.dynamicDamage.present
          ? data.dynamicDamage.value
          : this.dynamicDamage,
      damageMultiplier: data.damageMultiplier.present
          ? data.damageMultiplier.value
          : this.damageMultiplier,
      damageMinimum: data.damageMinimum.present
          ? data.damageMinimum.value
          : this.damageMinimum,
      triggerConditionText: data.triggerConditionText.present
          ? data.triggerConditionText.value
          : this.triggerConditionText,
      triggersEffectId: data.triggersEffectId.present
          ? data.triggersEffectId.value
          : this.triggersEffectId,
      effectType: data.effectType.present
          ? data.effectType.value
          : this.effectType,
      ceScope: data.ceScope.present ? data.ceScope.value : this.ceScope,
      effectDetail: data.effectDetail.present
          ? data.effectDetail.value
          : this.effectDetail,
      effectExtraConditions: data.effectExtraConditions.present
          ? data.effectExtraConditions.value
          : this.effectExtraConditions,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CardEffect(')
          ..write('id: $id, ')
          ..write('cardDefinitionId: $cardDefinitionId, ')
          ..write('trigger: $trigger, ')
          ..write('triggerDetail: $triggerDetail, ')
          ..write('extraConditions: $extraConditions, ')
          ..write('shortLabel: $shortLabel, ')
          ..write('shortLabelEn: $shortLabelEn, ')
          ..write('description: $description, ')
          ..write('damageAmount: $damageAmount, ')
          ..write('damageTarget: $damageTarget, ')
          ..write('replacementScope: $replacementScope, ')
          ..write('dynamicDamage: $dynamicDamage, ')
          ..write('damageMultiplier: $damageMultiplier, ')
          ..write('damageMinimum: $damageMinimum, ')
          ..write('triggerConditionText: $triggerConditionText, ')
          ..write('triggersEffectId: $triggersEffectId, ')
          ..write('effectType: $effectType, ')
          ..write('ceScope: $ceScope, ')
          ..write('effectDetail: $effectDetail, ')
          ..write('effectExtraConditions: $effectExtraConditions')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    cardDefinitionId,
    trigger,
    triggerDetail,
    extraConditions,
    shortLabel,
    shortLabelEn,
    description,
    damageAmount,
    damageTarget,
    replacementScope,
    dynamicDamage,
    damageMultiplier,
    damageMinimum,
    triggerConditionText,
    triggersEffectId,
    effectType,
    ceScope,
    effectDetail,
    effectExtraConditions,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CardEffect &&
          other.id == this.id &&
          other.cardDefinitionId == this.cardDefinitionId &&
          other.trigger == this.trigger &&
          other.triggerDetail == this.triggerDetail &&
          other.extraConditions == this.extraConditions &&
          other.shortLabel == this.shortLabel &&
          other.shortLabelEn == this.shortLabelEn &&
          other.description == this.description &&
          other.damageAmount == this.damageAmount &&
          other.damageTarget == this.damageTarget &&
          other.replacementScope == this.replacementScope &&
          other.dynamicDamage == this.dynamicDamage &&
          other.damageMultiplier == this.damageMultiplier &&
          other.damageMinimum == this.damageMinimum &&
          other.triggerConditionText == this.triggerConditionText &&
          other.triggersEffectId == this.triggersEffectId &&
          other.effectType == this.effectType &&
          other.ceScope == this.ceScope &&
          other.effectDetail == this.effectDetail &&
          other.effectExtraConditions == this.effectExtraConditions);
}

class CardEffectsCompanion extends UpdateCompanion<CardEffect> {
  final Value<int> id;
  final Value<int> cardDefinitionId;
  final Value<String> trigger;
  final Value<String?> triggerDetail;
  final Value<String?> extraConditions;
  final Value<String> shortLabel;
  final Value<String?> shortLabelEn;
  final Value<String> description;
  final Value<int?> damageAmount;
  final Value<String?> damageTarget;
  final Value<String?> replacementScope;
  final Value<bool?> dynamicDamage;
  final Value<int?> damageMultiplier;
  final Value<int?> damageMinimum;
  final Value<String?> triggerConditionText;
  final Value<int?> triggersEffectId;
  final Value<String?> effectType;
  final Value<String?> ceScope;
  final Value<String?> effectDetail;
  final Value<String?> effectExtraConditions;
  const CardEffectsCompanion({
    this.id = const Value.absent(),
    this.cardDefinitionId = const Value.absent(),
    this.trigger = const Value.absent(),
    this.triggerDetail = const Value.absent(),
    this.extraConditions = const Value.absent(),
    this.shortLabel = const Value.absent(),
    this.shortLabelEn = const Value.absent(),
    this.description = const Value.absent(),
    this.damageAmount = const Value.absent(),
    this.damageTarget = const Value.absent(),
    this.replacementScope = const Value.absent(),
    this.dynamicDamage = const Value.absent(),
    this.damageMultiplier = const Value.absent(),
    this.damageMinimum = const Value.absent(),
    this.triggerConditionText = const Value.absent(),
    this.triggersEffectId = const Value.absent(),
    this.effectType = const Value.absent(),
    this.ceScope = const Value.absent(),
    this.effectDetail = const Value.absent(),
    this.effectExtraConditions = const Value.absent(),
  });
  CardEffectsCompanion.insert({
    this.id = const Value.absent(),
    required int cardDefinitionId,
    required String trigger,
    this.triggerDetail = const Value.absent(),
    this.extraConditions = const Value.absent(),
    this.shortLabel = const Value.absent(),
    this.shortLabelEn = const Value.absent(),
    required String description,
    this.damageAmount = const Value.absent(),
    this.damageTarget = const Value.absent(),
    this.replacementScope = const Value.absent(),
    this.dynamicDamage = const Value.absent(),
    this.damageMultiplier = const Value.absent(),
    this.damageMinimum = const Value.absent(),
    this.triggerConditionText = const Value.absent(),
    this.triggersEffectId = const Value.absent(),
    this.effectType = const Value.absent(),
    this.ceScope = const Value.absent(),
    this.effectDetail = const Value.absent(),
    this.effectExtraConditions = const Value.absent(),
  }) : cardDefinitionId = Value(cardDefinitionId),
       trigger = Value(trigger),
       description = Value(description);
  static Insertable<CardEffect> custom({
    Expression<int>? id,
    Expression<int>? cardDefinitionId,
    Expression<String>? trigger,
    Expression<String>? triggerDetail,
    Expression<String>? extraConditions,
    Expression<String>? shortLabel,
    Expression<String>? shortLabelEn,
    Expression<String>? description,
    Expression<int>? damageAmount,
    Expression<String>? damageTarget,
    Expression<String>? replacementScope,
    Expression<bool>? dynamicDamage,
    Expression<int>? damageMultiplier,
    Expression<int>? damageMinimum,
    Expression<String>? triggerConditionText,
    Expression<int>? triggersEffectId,
    Expression<String>? effectType,
    Expression<String>? ceScope,
    Expression<String>? effectDetail,
    Expression<String>? effectExtraConditions,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (cardDefinitionId != null) 'card_definition_id': cardDefinitionId,
      if (trigger != null) 'trigger': trigger,
      if (triggerDetail != null) 'spell_category': triggerDetail,
      if (extraConditions != null) 'extra_conditions': extraConditions,
      if (shortLabel != null) 'short_label': shortLabel,
      if (shortLabelEn != null) 'short_label_en': shortLabelEn,
      if (description != null) 'description': description,
      if (damageAmount != null) 'damage_amount': damageAmount,
      if (damageTarget != null) 'damage_target': damageTarget,
      if (replacementScope != null) 'replacement_scope': replacementScope,
      if (dynamicDamage != null) 'dynamic_damage': dynamicDamage,
      if (damageMultiplier != null) 'damage_multiplier': damageMultiplier,
      if (damageMinimum != null) 'damage_minimum': damageMinimum,
      if (triggerConditionText != null)
        'trigger_condition_text': triggerConditionText,
      if (triggersEffectId != null) 'triggers_effect_id': triggersEffectId,
      if (effectType != null) 'effect_type': effectType,
      if (ceScope != null) 'ce_scope': ceScope,
      if (effectDetail != null) 'effect_detail': effectDetail,
      if (effectExtraConditions != null)
        'effect_extra_conditions': effectExtraConditions,
    });
  }

  CardEffectsCompanion copyWith({
    Value<int>? id,
    Value<int>? cardDefinitionId,
    Value<String>? trigger,
    Value<String?>? triggerDetail,
    Value<String?>? extraConditions,
    Value<String>? shortLabel,
    Value<String?>? shortLabelEn,
    Value<String>? description,
    Value<int?>? damageAmount,
    Value<String?>? damageTarget,
    Value<String?>? replacementScope,
    Value<bool?>? dynamicDamage,
    Value<int?>? damageMultiplier,
    Value<int?>? damageMinimum,
    Value<String?>? triggerConditionText,
    Value<int?>? triggersEffectId,
    Value<String?>? effectType,
    Value<String?>? ceScope,
    Value<String?>? effectDetail,
    Value<String?>? effectExtraConditions,
  }) {
    return CardEffectsCompanion(
      id: id ?? this.id,
      cardDefinitionId: cardDefinitionId ?? this.cardDefinitionId,
      trigger: trigger ?? this.trigger,
      triggerDetail: triggerDetail ?? this.triggerDetail,
      extraConditions: extraConditions ?? this.extraConditions,
      shortLabel: shortLabel ?? this.shortLabel,
      shortLabelEn: shortLabelEn ?? this.shortLabelEn,
      description: description ?? this.description,
      damageAmount: damageAmount ?? this.damageAmount,
      damageTarget: damageTarget ?? this.damageTarget,
      replacementScope: replacementScope ?? this.replacementScope,
      dynamicDamage: dynamicDamage ?? this.dynamicDamage,
      damageMultiplier: damageMultiplier ?? this.damageMultiplier,
      damageMinimum: damageMinimum ?? this.damageMinimum,
      triggerConditionText: triggerConditionText ?? this.triggerConditionText,
      triggersEffectId: triggersEffectId ?? this.triggersEffectId,
      effectType: effectType ?? this.effectType,
      ceScope: ceScope ?? this.ceScope,
      effectDetail: effectDetail ?? this.effectDetail,
      effectExtraConditions:
          effectExtraConditions ?? this.effectExtraConditions,
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
    if (triggerDetail.present) {
      map['spell_category'] = Variable<String>(triggerDetail.value);
    }
    if (extraConditions.present) {
      map['extra_conditions'] = Variable<String>(extraConditions.value);
    }
    if (shortLabel.present) {
      map['short_label'] = Variable<String>(shortLabel.value);
    }
    if (shortLabelEn.present) {
      map['short_label_en'] = Variable<String>(shortLabelEn.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (damageAmount.present) {
      map['damage_amount'] = Variable<int>(damageAmount.value);
    }
    if (damageTarget.present) {
      map['damage_target'] = Variable<String>(damageTarget.value);
    }
    if (replacementScope.present) {
      map['replacement_scope'] = Variable<String>(replacementScope.value);
    }
    if (dynamicDamage.present) {
      map['dynamic_damage'] = Variable<bool>(dynamicDamage.value);
    }
    if (damageMultiplier.present) {
      map['damage_multiplier'] = Variable<int>(damageMultiplier.value);
    }
    if (damageMinimum.present) {
      map['damage_minimum'] = Variable<int>(damageMinimum.value);
    }
    if (triggerConditionText.present) {
      map['trigger_condition_text'] = Variable<String>(
        triggerConditionText.value,
      );
    }
    if (triggersEffectId.present) {
      map['triggers_effect_id'] = Variable<int>(triggersEffectId.value);
    }
    if (effectType.present) {
      map['effect_type'] = Variable<String>(effectType.value);
    }
    if (ceScope.present) {
      map['ce_scope'] = Variable<String>(ceScope.value);
    }
    if (effectDetail.present) {
      map['effect_detail'] = Variable<String>(effectDetail.value);
    }
    if (effectExtraConditions.present) {
      map['effect_extra_conditions'] = Variable<String>(
        effectExtraConditions.value,
      );
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CardEffectsCompanion(')
          ..write('id: $id, ')
          ..write('cardDefinitionId: $cardDefinitionId, ')
          ..write('trigger: $trigger, ')
          ..write('triggerDetail: $triggerDetail, ')
          ..write('extraConditions: $extraConditions, ')
          ..write('shortLabel: $shortLabel, ')
          ..write('shortLabelEn: $shortLabelEn, ')
          ..write('description: $description, ')
          ..write('damageAmount: $damageAmount, ')
          ..write('damageTarget: $damageTarget, ')
          ..write('replacementScope: $replacementScope, ')
          ..write('dynamicDamage: $dynamicDamage, ')
          ..write('damageMultiplier: $damageMultiplier, ')
          ..write('damageMinimum: $damageMinimum, ')
          ..write('triggerConditionText: $triggerConditionText, ')
          ..write('triggersEffectId: $triggersEffectId, ')
          ..write('effectType: $effectType, ')
          ..write('ceScope: $ceScope, ')
          ..write('effectDetail: $effectDetail, ')
          ..write('effectExtraConditions: $effectExtraConditions')
          ..write(')'))
        .toString();
  }
}

class $LearnedRulesTable extends LearnedRules
    with TableInfo<$LearnedRulesTable, LearnedRule> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LearnedRulesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _normalizedPatternMeta = const VerificationMeta(
    'normalizedPattern',
  );
  @override
  late final GeneratedColumn<String> normalizedPattern =
      GeneratedColumn<String>(
        'normalized_pattern',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
        $customConstraints: 'NOT NULL UNIQUE',
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
  static const VerificationMeta _triggerDetailMeta = const VerificationMeta(
    'triggerDetail',
  );
  @override
  late final GeneratedColumn<String> triggerDetail = GeneratedColumn<String>(
    'trigger_detail',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _extraConditionsMeta = const VerificationMeta(
    'extraConditions',
  );
  @override
  late final GeneratedColumn<String> extraConditions = GeneratedColumn<String>(
    'extra_conditions',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _shortLabelTemplateMeta =
      const VerificationMeta('shortLabelTemplate');
  @override
  late final GeneratedColumn<String> shortLabelTemplate =
      GeneratedColumn<String>(
        'short_label_template',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _shortLabelEnTemplateMeta =
      const VerificationMeta('shortLabelEnTemplate');
  @override
  late final GeneratedColumn<String> shortLabelEnTemplate =
      GeneratedColumn<String>(
        'short_label_en_template',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _hasDamageAmountMeta = const VerificationMeta(
    'hasDamageAmount',
  );
  @override
  late final GeneratedColumn<bool> hasDamageAmount = GeneratedColumn<bool>(
    'has_damage_amount',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("has_damage_amount" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _damageTargetMeta = const VerificationMeta(
    'damageTarget',
  );
  @override
  late final GeneratedColumn<String> damageTarget = GeneratedColumn<String>(
    'damage_target',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _damageMultiplierMeta = const VerificationMeta(
    'damageMultiplier',
  );
  @override
  late final GeneratedColumn<int> damageMultiplier = GeneratedColumn<int>(
    'damage_multiplier',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _damageMinimumMeta = const VerificationMeta(
    'damageMinimum',
  );
  @override
  late final GeneratedColumn<int> damageMinimum = GeneratedColumn<int>(
    'damage_minimum',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _replacementScopeMeta = const VerificationMeta(
    'replacementScope',
  );
  @override
  late final GeneratedColumn<String> replacementScope = GeneratedColumn<String>(
    'replacement_scope',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dynamicDamageMeta = const VerificationMeta(
    'dynamicDamage',
  );
  @override
  late final GeneratedColumn<bool> dynamicDamage = GeneratedColumn<bool>(
    'dynamic_damage',
    aliasedName,
    true,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("dynamic_damage" IN (0, 1))',
    ),
  );
  static const VerificationMeta _triggerConditionTextMeta =
      const VerificationMeta('triggerConditionText');
  @override
  late final GeneratedColumn<String> triggerConditionText =
      GeneratedColumn<String>(
        'trigger_condition_text',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _effectDetailMeta = const VerificationMeta(
    'effectDetail',
  );
  @override
  late final GeneratedColumn<String> effectDetail = GeneratedColumn<String>(
    'effect_detail',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _effectExtraConditionsMeta =
      const VerificationMeta('effectExtraConditions');
  @override
  late final GeneratedColumn<String> effectExtraConditions =
      GeneratedColumn<String>(
        'effect_extra_conditions',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _confidenceMeta = const VerificationMeta(
    'confidence',
  );
  @override
  late final GeneratedColumn<int> confidence = GeneratedColumn<int>(
    'confidence',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    normalizedPattern,
    trigger,
    triggerDetail,
    extraConditions,
    shortLabelTemplate,
    shortLabelEnTemplate,
    hasDamageAmount,
    damageTarget,
    damageMultiplier,
    damageMinimum,
    replacementScope,
    dynamicDamage,
    triggerConditionText,
    effectDetail,
    effectExtraConditions,
    confidence,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'learned_rules';
  @override
  VerificationContext validateIntegrity(
    Insertable<LearnedRule> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('normalized_pattern')) {
      context.handle(
        _normalizedPatternMeta,
        normalizedPattern.isAcceptableOrUnknown(
          data['normalized_pattern']!,
          _normalizedPatternMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_normalizedPatternMeta);
    }
    if (data.containsKey('trigger')) {
      context.handle(
        _triggerMeta,
        trigger.isAcceptableOrUnknown(data['trigger']!, _triggerMeta),
      );
    } else if (isInserting) {
      context.missing(_triggerMeta);
    }
    if (data.containsKey('trigger_detail')) {
      context.handle(
        _triggerDetailMeta,
        triggerDetail.isAcceptableOrUnknown(
          data['trigger_detail']!,
          _triggerDetailMeta,
        ),
      );
    }
    if (data.containsKey('extra_conditions')) {
      context.handle(
        _extraConditionsMeta,
        extraConditions.isAcceptableOrUnknown(
          data['extra_conditions']!,
          _extraConditionsMeta,
        ),
      );
    }
    if (data.containsKey('short_label_template')) {
      context.handle(
        _shortLabelTemplateMeta,
        shortLabelTemplate.isAcceptableOrUnknown(
          data['short_label_template']!,
          _shortLabelTemplateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_shortLabelTemplateMeta);
    }
    if (data.containsKey('short_label_en_template')) {
      context.handle(
        _shortLabelEnTemplateMeta,
        shortLabelEnTemplate.isAcceptableOrUnknown(
          data['short_label_en_template']!,
          _shortLabelEnTemplateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_shortLabelEnTemplateMeta);
    }
    if (data.containsKey('has_damage_amount')) {
      context.handle(
        _hasDamageAmountMeta,
        hasDamageAmount.isAcceptableOrUnknown(
          data['has_damage_amount']!,
          _hasDamageAmountMeta,
        ),
      );
    }
    if (data.containsKey('damage_target')) {
      context.handle(
        _damageTargetMeta,
        damageTarget.isAcceptableOrUnknown(
          data['damage_target']!,
          _damageTargetMeta,
        ),
      );
    }
    if (data.containsKey('damage_multiplier')) {
      context.handle(
        _damageMultiplierMeta,
        damageMultiplier.isAcceptableOrUnknown(
          data['damage_multiplier']!,
          _damageMultiplierMeta,
        ),
      );
    }
    if (data.containsKey('damage_minimum')) {
      context.handle(
        _damageMinimumMeta,
        damageMinimum.isAcceptableOrUnknown(
          data['damage_minimum']!,
          _damageMinimumMeta,
        ),
      );
    }
    if (data.containsKey('replacement_scope')) {
      context.handle(
        _replacementScopeMeta,
        replacementScope.isAcceptableOrUnknown(
          data['replacement_scope']!,
          _replacementScopeMeta,
        ),
      );
    }
    if (data.containsKey('dynamic_damage')) {
      context.handle(
        _dynamicDamageMeta,
        dynamicDamage.isAcceptableOrUnknown(
          data['dynamic_damage']!,
          _dynamicDamageMeta,
        ),
      );
    }
    if (data.containsKey('trigger_condition_text')) {
      context.handle(
        _triggerConditionTextMeta,
        triggerConditionText.isAcceptableOrUnknown(
          data['trigger_condition_text']!,
          _triggerConditionTextMeta,
        ),
      );
    }
    if (data.containsKey('effect_detail')) {
      context.handle(
        _effectDetailMeta,
        effectDetail.isAcceptableOrUnknown(
          data['effect_detail']!,
          _effectDetailMeta,
        ),
      );
    }
    if (data.containsKey('effect_extra_conditions')) {
      context.handle(
        _effectExtraConditionsMeta,
        effectExtraConditions.isAcceptableOrUnknown(
          data['effect_extra_conditions']!,
          _effectExtraConditionsMeta,
        ),
      );
    }
    if (data.containsKey('confidence')) {
      context.handle(
        _confidenceMeta,
        confidence.isAcceptableOrUnknown(data['confidence']!, _confidenceMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LearnedRule map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LearnedRule(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      normalizedPattern: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}normalized_pattern'],
      )!,
      trigger: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}trigger'],
      )!,
      triggerDetail: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}trigger_detail'],
      ),
      extraConditions: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}extra_conditions'],
      ),
      shortLabelTemplate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}short_label_template'],
      )!,
      shortLabelEnTemplate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}short_label_en_template'],
      )!,
      hasDamageAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}has_damage_amount'],
      )!,
      damageTarget: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}damage_target'],
      ),
      damageMultiplier: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}damage_multiplier'],
      ),
      damageMinimum: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}damage_minimum'],
      ),
      replacementScope: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}replacement_scope'],
      ),
      dynamicDamage: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}dynamic_damage'],
      ),
      triggerConditionText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}trigger_condition_text'],
      ),
      effectDetail: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}effect_detail'],
      ),
      effectExtraConditions: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}effect_extra_conditions'],
      ),
      confidence: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}confidence'],
      )!,
    );
  }

  @override
  $LearnedRulesTable createAlias(String alias) {
    return $LearnedRulesTable(attachedDatabase, alias);
  }
}

class LearnedRule extends DataClass implements Insertable<LearnedRule> {
  final int id;
  final String normalizedPattern;
  final String trigger;
  final String? triggerDetail;
  final String? extraConditions;
  final String shortLabelTemplate;
  final String shortLabelEnTemplate;
  final bool hasDamageAmount;
  final String? damageTarget;
  final int? damageMultiplier;
  final int? damageMinimum;
  final String? replacementScope;
  final bool? dynamicDamage;
  final String? triggerConditionText;
  final String? effectDetail;
  final String? effectExtraConditions;
  final int confidence;
  const LearnedRule({
    required this.id,
    required this.normalizedPattern,
    required this.trigger,
    this.triggerDetail,
    this.extraConditions,
    required this.shortLabelTemplate,
    required this.shortLabelEnTemplate,
    required this.hasDamageAmount,
    this.damageTarget,
    this.damageMultiplier,
    this.damageMinimum,
    this.replacementScope,
    this.dynamicDamage,
    this.triggerConditionText,
    this.effectDetail,
    this.effectExtraConditions,
    required this.confidence,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['normalized_pattern'] = Variable<String>(normalizedPattern);
    map['trigger'] = Variable<String>(trigger);
    if (!nullToAbsent || triggerDetail != null) {
      map['trigger_detail'] = Variable<String>(triggerDetail);
    }
    if (!nullToAbsent || extraConditions != null) {
      map['extra_conditions'] = Variable<String>(extraConditions);
    }
    map['short_label_template'] = Variable<String>(shortLabelTemplate);
    map['short_label_en_template'] = Variable<String>(shortLabelEnTemplate);
    map['has_damage_amount'] = Variable<bool>(hasDamageAmount);
    if (!nullToAbsent || damageTarget != null) {
      map['damage_target'] = Variable<String>(damageTarget);
    }
    if (!nullToAbsent || damageMultiplier != null) {
      map['damage_multiplier'] = Variable<int>(damageMultiplier);
    }
    if (!nullToAbsent || damageMinimum != null) {
      map['damage_minimum'] = Variable<int>(damageMinimum);
    }
    if (!nullToAbsent || replacementScope != null) {
      map['replacement_scope'] = Variable<String>(replacementScope);
    }
    if (!nullToAbsent || dynamicDamage != null) {
      map['dynamic_damage'] = Variable<bool>(dynamicDamage);
    }
    if (!nullToAbsent || triggerConditionText != null) {
      map['trigger_condition_text'] = Variable<String>(triggerConditionText);
    }
    if (!nullToAbsent || effectDetail != null) {
      map['effect_detail'] = Variable<String>(effectDetail);
    }
    if (!nullToAbsent || effectExtraConditions != null) {
      map['effect_extra_conditions'] = Variable<String>(effectExtraConditions);
    }
    map['confidence'] = Variable<int>(confidence);
    return map;
  }

  LearnedRulesCompanion toCompanion(bool nullToAbsent) {
    return LearnedRulesCompanion(
      id: Value(id),
      normalizedPattern: Value(normalizedPattern),
      trigger: Value(trigger),
      triggerDetail: triggerDetail == null && nullToAbsent
          ? const Value.absent()
          : Value(triggerDetail),
      extraConditions: extraConditions == null && nullToAbsent
          ? const Value.absent()
          : Value(extraConditions),
      shortLabelTemplate: Value(shortLabelTemplate),
      shortLabelEnTemplate: Value(shortLabelEnTemplate),
      hasDamageAmount: Value(hasDamageAmount),
      damageTarget: damageTarget == null && nullToAbsent
          ? const Value.absent()
          : Value(damageTarget),
      damageMultiplier: damageMultiplier == null && nullToAbsent
          ? const Value.absent()
          : Value(damageMultiplier),
      damageMinimum: damageMinimum == null && nullToAbsent
          ? const Value.absent()
          : Value(damageMinimum),
      replacementScope: replacementScope == null && nullToAbsent
          ? const Value.absent()
          : Value(replacementScope),
      dynamicDamage: dynamicDamage == null && nullToAbsent
          ? const Value.absent()
          : Value(dynamicDamage),
      triggerConditionText: triggerConditionText == null && nullToAbsent
          ? const Value.absent()
          : Value(triggerConditionText),
      effectDetail: effectDetail == null && nullToAbsent
          ? const Value.absent()
          : Value(effectDetail),
      effectExtraConditions: effectExtraConditions == null && nullToAbsent
          ? const Value.absent()
          : Value(effectExtraConditions),
      confidence: Value(confidence),
    );
  }

  factory LearnedRule.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LearnedRule(
      id: serializer.fromJson<int>(json['id']),
      normalizedPattern: serializer.fromJson<String>(json['normalizedPattern']),
      trigger: serializer.fromJson<String>(json['trigger']),
      triggerDetail: serializer.fromJson<String?>(json['triggerDetail']),
      extraConditions: serializer.fromJson<String?>(json['extraConditions']),
      shortLabelTemplate: serializer.fromJson<String>(
        json['shortLabelTemplate'],
      ),
      shortLabelEnTemplate: serializer.fromJson<String>(
        json['shortLabelEnTemplate'],
      ),
      hasDamageAmount: serializer.fromJson<bool>(json['hasDamageAmount']),
      damageTarget: serializer.fromJson<String?>(json['damageTarget']),
      damageMultiplier: serializer.fromJson<int?>(json['damageMultiplier']),
      damageMinimum: serializer.fromJson<int?>(json['damageMinimum']),
      replacementScope: serializer.fromJson<String?>(json['replacementScope']),
      dynamicDamage: serializer.fromJson<bool?>(json['dynamicDamage']),
      triggerConditionText: serializer.fromJson<String?>(
        json['triggerConditionText'],
      ),
      effectDetail: serializer.fromJson<String?>(json['effectDetail']),
      effectExtraConditions: serializer.fromJson<String?>(
        json['effectExtraConditions'],
      ),
      confidence: serializer.fromJson<int>(json['confidence']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'normalizedPattern': serializer.toJson<String>(normalizedPattern),
      'trigger': serializer.toJson<String>(trigger),
      'triggerDetail': serializer.toJson<String?>(triggerDetail),
      'extraConditions': serializer.toJson<String?>(extraConditions),
      'shortLabelTemplate': serializer.toJson<String>(shortLabelTemplate),
      'shortLabelEnTemplate': serializer.toJson<String>(shortLabelEnTemplate),
      'hasDamageAmount': serializer.toJson<bool>(hasDamageAmount),
      'damageTarget': serializer.toJson<String?>(damageTarget),
      'damageMultiplier': serializer.toJson<int?>(damageMultiplier),
      'damageMinimum': serializer.toJson<int?>(damageMinimum),
      'replacementScope': serializer.toJson<String?>(replacementScope),
      'dynamicDamage': serializer.toJson<bool?>(dynamicDamage),
      'triggerConditionText': serializer.toJson<String?>(triggerConditionText),
      'effectDetail': serializer.toJson<String?>(effectDetail),
      'effectExtraConditions': serializer.toJson<String?>(
        effectExtraConditions,
      ),
      'confidence': serializer.toJson<int>(confidence),
    };
  }

  LearnedRule copyWith({
    int? id,
    String? normalizedPattern,
    String? trigger,
    Value<String?> triggerDetail = const Value.absent(),
    Value<String?> extraConditions = const Value.absent(),
    String? shortLabelTemplate,
    String? shortLabelEnTemplate,
    bool? hasDamageAmount,
    Value<String?> damageTarget = const Value.absent(),
    Value<int?> damageMultiplier = const Value.absent(),
    Value<int?> damageMinimum = const Value.absent(),
    Value<String?> replacementScope = const Value.absent(),
    Value<bool?> dynamicDamage = const Value.absent(),
    Value<String?> triggerConditionText = const Value.absent(),
    Value<String?> effectDetail = const Value.absent(),
    Value<String?> effectExtraConditions = const Value.absent(),
    int? confidence,
  }) => LearnedRule(
    id: id ?? this.id,
    normalizedPattern: normalizedPattern ?? this.normalizedPattern,
    trigger: trigger ?? this.trigger,
    triggerDetail: triggerDetail.present
        ? triggerDetail.value
        : this.triggerDetail,
    extraConditions: extraConditions.present
        ? extraConditions.value
        : this.extraConditions,
    shortLabelTemplate: shortLabelTemplate ?? this.shortLabelTemplate,
    shortLabelEnTemplate: shortLabelEnTemplate ?? this.shortLabelEnTemplate,
    hasDamageAmount: hasDamageAmount ?? this.hasDamageAmount,
    damageTarget: damageTarget.present ? damageTarget.value : this.damageTarget,
    damageMultiplier: damageMultiplier.present
        ? damageMultiplier.value
        : this.damageMultiplier,
    damageMinimum: damageMinimum.present
        ? damageMinimum.value
        : this.damageMinimum,
    replacementScope: replacementScope.present
        ? replacementScope.value
        : this.replacementScope,
    dynamicDamage: dynamicDamage.present
        ? dynamicDamage.value
        : this.dynamicDamage,
    triggerConditionText: triggerConditionText.present
        ? triggerConditionText.value
        : this.triggerConditionText,
    effectDetail: effectDetail.present ? effectDetail.value : this.effectDetail,
    effectExtraConditions: effectExtraConditions.present
        ? effectExtraConditions.value
        : this.effectExtraConditions,
    confidence: confidence ?? this.confidence,
  );
  LearnedRule copyWithCompanion(LearnedRulesCompanion data) {
    return LearnedRule(
      id: data.id.present ? data.id.value : this.id,
      normalizedPattern: data.normalizedPattern.present
          ? data.normalizedPattern.value
          : this.normalizedPattern,
      trigger: data.trigger.present ? data.trigger.value : this.trigger,
      triggerDetail: data.triggerDetail.present
          ? data.triggerDetail.value
          : this.triggerDetail,
      extraConditions: data.extraConditions.present
          ? data.extraConditions.value
          : this.extraConditions,
      shortLabelTemplate: data.shortLabelTemplate.present
          ? data.shortLabelTemplate.value
          : this.shortLabelTemplate,
      shortLabelEnTemplate: data.shortLabelEnTemplate.present
          ? data.shortLabelEnTemplate.value
          : this.shortLabelEnTemplate,
      hasDamageAmount: data.hasDamageAmount.present
          ? data.hasDamageAmount.value
          : this.hasDamageAmount,
      damageTarget: data.damageTarget.present
          ? data.damageTarget.value
          : this.damageTarget,
      damageMultiplier: data.damageMultiplier.present
          ? data.damageMultiplier.value
          : this.damageMultiplier,
      damageMinimum: data.damageMinimum.present
          ? data.damageMinimum.value
          : this.damageMinimum,
      replacementScope: data.replacementScope.present
          ? data.replacementScope.value
          : this.replacementScope,
      dynamicDamage: data.dynamicDamage.present
          ? data.dynamicDamage.value
          : this.dynamicDamage,
      triggerConditionText: data.triggerConditionText.present
          ? data.triggerConditionText.value
          : this.triggerConditionText,
      effectDetail: data.effectDetail.present
          ? data.effectDetail.value
          : this.effectDetail,
      effectExtraConditions: data.effectExtraConditions.present
          ? data.effectExtraConditions.value
          : this.effectExtraConditions,
      confidence: data.confidence.present
          ? data.confidence.value
          : this.confidence,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LearnedRule(')
          ..write('id: $id, ')
          ..write('normalizedPattern: $normalizedPattern, ')
          ..write('trigger: $trigger, ')
          ..write('triggerDetail: $triggerDetail, ')
          ..write('extraConditions: $extraConditions, ')
          ..write('shortLabelTemplate: $shortLabelTemplate, ')
          ..write('shortLabelEnTemplate: $shortLabelEnTemplate, ')
          ..write('hasDamageAmount: $hasDamageAmount, ')
          ..write('damageTarget: $damageTarget, ')
          ..write('damageMultiplier: $damageMultiplier, ')
          ..write('damageMinimum: $damageMinimum, ')
          ..write('replacementScope: $replacementScope, ')
          ..write('dynamicDamage: $dynamicDamage, ')
          ..write('triggerConditionText: $triggerConditionText, ')
          ..write('effectDetail: $effectDetail, ')
          ..write('effectExtraConditions: $effectExtraConditions, ')
          ..write('confidence: $confidence')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    normalizedPattern,
    trigger,
    triggerDetail,
    extraConditions,
    shortLabelTemplate,
    shortLabelEnTemplate,
    hasDamageAmount,
    damageTarget,
    damageMultiplier,
    damageMinimum,
    replacementScope,
    dynamicDamage,
    triggerConditionText,
    effectDetail,
    effectExtraConditions,
    confidence,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LearnedRule &&
          other.id == this.id &&
          other.normalizedPattern == this.normalizedPattern &&
          other.trigger == this.trigger &&
          other.triggerDetail == this.triggerDetail &&
          other.extraConditions == this.extraConditions &&
          other.shortLabelTemplate == this.shortLabelTemplate &&
          other.shortLabelEnTemplate == this.shortLabelEnTemplate &&
          other.hasDamageAmount == this.hasDamageAmount &&
          other.damageTarget == this.damageTarget &&
          other.damageMultiplier == this.damageMultiplier &&
          other.damageMinimum == this.damageMinimum &&
          other.replacementScope == this.replacementScope &&
          other.dynamicDamage == this.dynamicDamage &&
          other.triggerConditionText == this.triggerConditionText &&
          other.effectDetail == this.effectDetail &&
          other.effectExtraConditions == this.effectExtraConditions &&
          other.confidence == this.confidence);
}

class LearnedRulesCompanion extends UpdateCompanion<LearnedRule> {
  final Value<int> id;
  final Value<String> normalizedPattern;
  final Value<String> trigger;
  final Value<String?> triggerDetail;
  final Value<String?> extraConditions;
  final Value<String> shortLabelTemplate;
  final Value<String> shortLabelEnTemplate;
  final Value<bool> hasDamageAmount;
  final Value<String?> damageTarget;
  final Value<int?> damageMultiplier;
  final Value<int?> damageMinimum;
  final Value<String?> replacementScope;
  final Value<bool?> dynamicDamage;
  final Value<String?> triggerConditionText;
  final Value<String?> effectDetail;
  final Value<String?> effectExtraConditions;
  final Value<int> confidence;
  const LearnedRulesCompanion({
    this.id = const Value.absent(),
    this.normalizedPattern = const Value.absent(),
    this.trigger = const Value.absent(),
    this.triggerDetail = const Value.absent(),
    this.extraConditions = const Value.absent(),
    this.shortLabelTemplate = const Value.absent(),
    this.shortLabelEnTemplate = const Value.absent(),
    this.hasDamageAmount = const Value.absent(),
    this.damageTarget = const Value.absent(),
    this.damageMultiplier = const Value.absent(),
    this.damageMinimum = const Value.absent(),
    this.replacementScope = const Value.absent(),
    this.dynamicDamage = const Value.absent(),
    this.triggerConditionText = const Value.absent(),
    this.effectDetail = const Value.absent(),
    this.effectExtraConditions = const Value.absent(),
    this.confidence = const Value.absent(),
  });
  LearnedRulesCompanion.insert({
    this.id = const Value.absent(),
    required String normalizedPattern,
    required String trigger,
    this.triggerDetail = const Value.absent(),
    this.extraConditions = const Value.absent(),
    required String shortLabelTemplate,
    required String shortLabelEnTemplate,
    this.hasDamageAmount = const Value.absent(),
    this.damageTarget = const Value.absent(),
    this.damageMultiplier = const Value.absent(),
    this.damageMinimum = const Value.absent(),
    this.replacementScope = const Value.absent(),
    this.dynamicDamage = const Value.absent(),
    this.triggerConditionText = const Value.absent(),
    this.effectDetail = const Value.absent(),
    this.effectExtraConditions = const Value.absent(),
    this.confidence = const Value.absent(),
  }) : normalizedPattern = Value(normalizedPattern),
       trigger = Value(trigger),
       shortLabelTemplate = Value(shortLabelTemplate),
       shortLabelEnTemplate = Value(shortLabelEnTemplate);
  static Insertable<LearnedRule> custom({
    Expression<int>? id,
    Expression<String>? normalizedPattern,
    Expression<String>? trigger,
    Expression<String>? triggerDetail,
    Expression<String>? extraConditions,
    Expression<String>? shortLabelTemplate,
    Expression<String>? shortLabelEnTemplate,
    Expression<bool>? hasDamageAmount,
    Expression<String>? damageTarget,
    Expression<int>? damageMultiplier,
    Expression<int>? damageMinimum,
    Expression<String>? replacementScope,
    Expression<bool>? dynamicDamage,
    Expression<String>? triggerConditionText,
    Expression<String>? effectDetail,
    Expression<String>? effectExtraConditions,
    Expression<int>? confidence,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (normalizedPattern != null) 'normalized_pattern': normalizedPattern,
      if (trigger != null) 'trigger': trigger,
      if (triggerDetail != null) 'trigger_detail': triggerDetail,
      if (extraConditions != null) 'extra_conditions': extraConditions,
      if (shortLabelTemplate != null)
        'short_label_template': shortLabelTemplate,
      if (shortLabelEnTemplate != null)
        'short_label_en_template': shortLabelEnTemplate,
      if (hasDamageAmount != null) 'has_damage_amount': hasDamageAmount,
      if (damageTarget != null) 'damage_target': damageTarget,
      if (damageMultiplier != null) 'damage_multiplier': damageMultiplier,
      if (damageMinimum != null) 'damage_minimum': damageMinimum,
      if (replacementScope != null) 'replacement_scope': replacementScope,
      if (dynamicDamage != null) 'dynamic_damage': dynamicDamage,
      if (triggerConditionText != null)
        'trigger_condition_text': triggerConditionText,
      if (effectDetail != null) 'effect_detail': effectDetail,
      if (effectExtraConditions != null)
        'effect_extra_conditions': effectExtraConditions,
      if (confidence != null) 'confidence': confidence,
    });
  }

  LearnedRulesCompanion copyWith({
    Value<int>? id,
    Value<String>? normalizedPattern,
    Value<String>? trigger,
    Value<String?>? triggerDetail,
    Value<String?>? extraConditions,
    Value<String>? shortLabelTemplate,
    Value<String>? shortLabelEnTemplate,
    Value<bool>? hasDamageAmount,
    Value<String?>? damageTarget,
    Value<int?>? damageMultiplier,
    Value<int?>? damageMinimum,
    Value<String?>? replacementScope,
    Value<bool?>? dynamicDamage,
    Value<String?>? triggerConditionText,
    Value<String?>? effectDetail,
    Value<String?>? effectExtraConditions,
    Value<int>? confidence,
  }) {
    return LearnedRulesCompanion(
      id: id ?? this.id,
      normalizedPattern: normalizedPattern ?? this.normalizedPattern,
      trigger: trigger ?? this.trigger,
      triggerDetail: triggerDetail ?? this.triggerDetail,
      extraConditions: extraConditions ?? this.extraConditions,
      shortLabelTemplate: shortLabelTemplate ?? this.shortLabelTemplate,
      shortLabelEnTemplate: shortLabelEnTemplate ?? this.shortLabelEnTemplate,
      hasDamageAmount: hasDamageAmount ?? this.hasDamageAmount,
      damageTarget: damageTarget ?? this.damageTarget,
      damageMultiplier: damageMultiplier ?? this.damageMultiplier,
      damageMinimum: damageMinimum ?? this.damageMinimum,
      replacementScope: replacementScope ?? this.replacementScope,
      dynamicDamage: dynamicDamage ?? this.dynamicDamage,
      triggerConditionText: triggerConditionText ?? this.triggerConditionText,
      effectDetail: effectDetail ?? this.effectDetail,
      effectExtraConditions:
          effectExtraConditions ?? this.effectExtraConditions,
      confidence: confidence ?? this.confidence,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (normalizedPattern.present) {
      map['normalized_pattern'] = Variable<String>(normalizedPattern.value);
    }
    if (trigger.present) {
      map['trigger'] = Variable<String>(trigger.value);
    }
    if (triggerDetail.present) {
      map['trigger_detail'] = Variable<String>(triggerDetail.value);
    }
    if (extraConditions.present) {
      map['extra_conditions'] = Variable<String>(extraConditions.value);
    }
    if (shortLabelTemplate.present) {
      map['short_label_template'] = Variable<String>(shortLabelTemplate.value);
    }
    if (shortLabelEnTemplate.present) {
      map['short_label_en_template'] = Variable<String>(
        shortLabelEnTemplate.value,
      );
    }
    if (hasDamageAmount.present) {
      map['has_damage_amount'] = Variable<bool>(hasDamageAmount.value);
    }
    if (damageTarget.present) {
      map['damage_target'] = Variable<String>(damageTarget.value);
    }
    if (damageMultiplier.present) {
      map['damage_multiplier'] = Variable<int>(damageMultiplier.value);
    }
    if (damageMinimum.present) {
      map['damage_minimum'] = Variable<int>(damageMinimum.value);
    }
    if (replacementScope.present) {
      map['replacement_scope'] = Variable<String>(replacementScope.value);
    }
    if (dynamicDamage.present) {
      map['dynamic_damage'] = Variable<bool>(dynamicDamage.value);
    }
    if (triggerConditionText.present) {
      map['trigger_condition_text'] = Variable<String>(
        triggerConditionText.value,
      );
    }
    if (effectDetail.present) {
      map['effect_detail'] = Variable<String>(effectDetail.value);
    }
    if (effectExtraConditions.present) {
      map['effect_extra_conditions'] = Variable<String>(
        effectExtraConditions.value,
      );
    }
    if (confidence.present) {
      map['confidence'] = Variable<int>(confidence.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LearnedRulesCompanion(')
          ..write('id: $id, ')
          ..write('normalizedPattern: $normalizedPattern, ')
          ..write('trigger: $trigger, ')
          ..write('triggerDetail: $triggerDetail, ')
          ..write('extraConditions: $extraConditions, ')
          ..write('shortLabelTemplate: $shortLabelTemplate, ')
          ..write('shortLabelEnTemplate: $shortLabelEnTemplate, ')
          ..write('hasDamageAmount: $hasDamageAmount, ')
          ..write('damageTarget: $damageTarget, ')
          ..write('damageMultiplier: $damageMultiplier, ')
          ..write('damageMinimum: $damageMinimum, ')
          ..write('replacementScope: $replacementScope, ')
          ..write('dynamicDamage: $dynamicDamage, ')
          ..write('triggerConditionText: $triggerConditionText, ')
          ..write('effectDetail: $effectDetail, ')
          ..write('effectExtraConditions: $effectExtraConditions, ')
          ..write('confidence: $confidence')
          ..write(')'))
        .toString();
  }
}

class $CardAttachmentsTable extends CardAttachments
    with TableInfo<$CardAttachmentsTable, CardAttachment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CardAttachmentsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _equipmentDefinitionIdMeta =
      const VerificationMeta('equipmentDefinitionId');
  @override
  late final GeneratedColumn<int> equipmentDefinitionId = GeneratedColumn<int>(
    'equipment_definition_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetDefinitionIdMeta =
      const VerificationMeta('targetDefinitionId');
  @override
  late final GeneratedColumn<int> targetDefinitionId = GeneratedColumn<int>(
    'target_definition_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    deckId,
    equipmentDefinitionId,
    targetDefinitionId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'card_attachments';
  @override
  VerificationContext validateIntegrity(
    Insertable<CardAttachment> instance, {
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
    if (data.containsKey('equipment_definition_id')) {
      context.handle(
        _equipmentDefinitionIdMeta,
        equipmentDefinitionId.isAcceptableOrUnknown(
          data['equipment_definition_id']!,
          _equipmentDefinitionIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_equipmentDefinitionIdMeta);
    }
    if (data.containsKey('target_definition_id')) {
      context.handle(
        _targetDefinitionIdMeta,
        targetDefinitionId.isAcceptableOrUnknown(
          data['target_definition_id']!,
          _targetDefinitionIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_targetDefinitionIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {deckId, equipmentDefinitionId},
  ];
  @override
  CardAttachment map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CardAttachment(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      deckId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}deck_id'],
      )!,
      equipmentDefinitionId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}equipment_definition_id'],
      )!,
      targetDefinitionId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}target_definition_id'],
      )!,
    );
  }

  @override
  $CardAttachmentsTable createAlias(String alias) {
    return $CardAttachmentsTable(attachedDatabase, alias);
  }
}

class CardAttachment extends DataClass implements Insertable<CardAttachment> {
  final int id;
  final int deckId;
  final int equipmentDefinitionId;
  final int targetDefinitionId;
  const CardAttachment({
    required this.id,
    required this.deckId,
    required this.equipmentDefinitionId,
    required this.targetDefinitionId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['deck_id'] = Variable<int>(deckId);
    map['equipment_definition_id'] = Variable<int>(equipmentDefinitionId);
    map['target_definition_id'] = Variable<int>(targetDefinitionId);
    return map;
  }

  CardAttachmentsCompanion toCompanion(bool nullToAbsent) {
    return CardAttachmentsCompanion(
      id: Value(id),
      deckId: Value(deckId),
      equipmentDefinitionId: Value(equipmentDefinitionId),
      targetDefinitionId: Value(targetDefinitionId),
    );
  }

  factory CardAttachment.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CardAttachment(
      id: serializer.fromJson<int>(json['id']),
      deckId: serializer.fromJson<int>(json['deckId']),
      equipmentDefinitionId: serializer.fromJson<int>(
        json['equipmentDefinitionId'],
      ),
      targetDefinitionId: serializer.fromJson<int>(json['targetDefinitionId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'deckId': serializer.toJson<int>(deckId),
      'equipmentDefinitionId': serializer.toJson<int>(equipmentDefinitionId),
      'targetDefinitionId': serializer.toJson<int>(targetDefinitionId),
    };
  }

  CardAttachment copyWith({
    int? id,
    int? deckId,
    int? equipmentDefinitionId,
    int? targetDefinitionId,
  }) => CardAttachment(
    id: id ?? this.id,
    deckId: deckId ?? this.deckId,
    equipmentDefinitionId: equipmentDefinitionId ?? this.equipmentDefinitionId,
    targetDefinitionId: targetDefinitionId ?? this.targetDefinitionId,
  );
  CardAttachment copyWithCompanion(CardAttachmentsCompanion data) {
    return CardAttachment(
      id: data.id.present ? data.id.value : this.id,
      deckId: data.deckId.present ? data.deckId.value : this.deckId,
      equipmentDefinitionId: data.equipmentDefinitionId.present
          ? data.equipmentDefinitionId.value
          : this.equipmentDefinitionId,
      targetDefinitionId: data.targetDefinitionId.present
          ? data.targetDefinitionId.value
          : this.targetDefinitionId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CardAttachment(')
          ..write('id: $id, ')
          ..write('deckId: $deckId, ')
          ..write('equipmentDefinitionId: $equipmentDefinitionId, ')
          ..write('targetDefinitionId: $targetDefinitionId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, deckId, equipmentDefinitionId, targetDefinitionId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CardAttachment &&
          other.id == this.id &&
          other.deckId == this.deckId &&
          other.equipmentDefinitionId == this.equipmentDefinitionId &&
          other.targetDefinitionId == this.targetDefinitionId);
}

class CardAttachmentsCompanion extends UpdateCompanion<CardAttachment> {
  final Value<int> id;
  final Value<int> deckId;
  final Value<int> equipmentDefinitionId;
  final Value<int> targetDefinitionId;
  const CardAttachmentsCompanion({
    this.id = const Value.absent(),
    this.deckId = const Value.absent(),
    this.equipmentDefinitionId = const Value.absent(),
    this.targetDefinitionId = const Value.absent(),
  });
  CardAttachmentsCompanion.insert({
    this.id = const Value.absent(),
    required int deckId,
    required int equipmentDefinitionId,
    required int targetDefinitionId,
  }) : deckId = Value(deckId),
       equipmentDefinitionId = Value(equipmentDefinitionId),
       targetDefinitionId = Value(targetDefinitionId);
  static Insertable<CardAttachment> custom({
    Expression<int>? id,
    Expression<int>? deckId,
    Expression<int>? equipmentDefinitionId,
    Expression<int>? targetDefinitionId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (deckId != null) 'deck_id': deckId,
      if (equipmentDefinitionId != null)
        'equipment_definition_id': equipmentDefinitionId,
      if (targetDefinitionId != null)
        'target_definition_id': targetDefinitionId,
    });
  }

  CardAttachmentsCompanion copyWith({
    Value<int>? id,
    Value<int>? deckId,
    Value<int>? equipmentDefinitionId,
    Value<int>? targetDefinitionId,
  }) {
    return CardAttachmentsCompanion(
      id: id ?? this.id,
      deckId: deckId ?? this.deckId,
      equipmentDefinitionId:
          equipmentDefinitionId ?? this.equipmentDefinitionId,
      targetDefinitionId: targetDefinitionId ?? this.targetDefinitionId,
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
    if (equipmentDefinitionId.present) {
      map['equipment_definition_id'] = Variable<int>(
        equipmentDefinitionId.value,
      );
    }
    if (targetDefinitionId.present) {
      map['target_definition_id'] = Variable<int>(targetDefinitionId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CardAttachmentsCompanion(')
          ..write('id: $id, ')
          ..write('deckId: $deckId, ')
          ..write('equipmentDefinitionId: $equipmentDefinitionId, ')
          ..write('targetDefinitionId: $targetDefinitionId')
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
  late final $LearnedRulesTable learnedRules = $LearnedRulesTable(this);
  late final $CardAttachmentsTable cardAttachments = $CardAttachmentsTable(
    this,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    decks,
    cardDefinitions,
    deckCards,
    cardEffects,
    learnedRules,
    cardAttachments,
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
      Value<String?> printedName,
      Value<String?> printedText,
      Value<String?> printedTypeLine,
      Value<double?> rating,
      Value<String?> keywords,
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
      Value<String?> printedName,
      Value<String?> printedText,
      Value<String?> printedTypeLine,
      Value<double?> rating,
      Value<String?> keywords,
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

  ColumnFilters<String> get printedName => $composableBuilder(
    column: $table.printedName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get printedText => $composableBuilder(
    column: $table.printedText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get printedTypeLine => $composableBuilder(
    column: $table.printedTypeLine,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get rating => $composableBuilder(
    column: $table.rating,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get keywords => $composableBuilder(
    column: $table.keywords,
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

  ColumnOrderings<String> get printedName => $composableBuilder(
    column: $table.printedName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get printedText => $composableBuilder(
    column: $table.printedText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get printedTypeLine => $composableBuilder(
    column: $table.printedTypeLine,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get rating => $composableBuilder(
    column: $table.rating,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get keywords => $composableBuilder(
    column: $table.keywords,
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

  GeneratedColumn<String> get printedName => $composableBuilder(
    column: $table.printedName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get printedText => $composableBuilder(
    column: $table.printedText,
    builder: (column) => column,
  );

  GeneratedColumn<String> get printedTypeLine => $composableBuilder(
    column: $table.printedTypeLine,
    builder: (column) => column,
  );

  GeneratedColumn<double> get rating =>
      $composableBuilder(column: $table.rating, builder: (column) => column);

  GeneratedColumn<String> get keywords =>
      $composableBuilder(column: $table.keywords, builder: (column) => column);
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
                Value<String?> printedName = const Value.absent(),
                Value<String?> printedText = const Value.absent(),
                Value<String?> printedTypeLine = const Value.absent(),
                Value<double?> rating = const Value.absent(),
                Value<String?> keywords = const Value.absent(),
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
                printedName: printedName,
                printedText: printedText,
                printedTypeLine: printedTypeLine,
                rating: rating,
                keywords: keywords,
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
                Value<String?> printedName = const Value.absent(),
                Value<String?> printedText = const Value.absent(),
                Value<String?> printedTypeLine = const Value.absent(),
                Value<double?> rating = const Value.absent(),
                Value<String?> keywords = const Value.absent(),
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
                printedName: printedName,
                printedText: printedText,
                printedTypeLine: printedTypeLine,
                rating: rating,
                keywords: keywords,
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
      Value<String?> triggerDetail,
      Value<String?> extraConditions,
      Value<String> shortLabel,
      Value<String?> shortLabelEn,
      required String description,
      Value<int?> damageAmount,
      Value<String?> damageTarget,
      Value<String?> replacementScope,
      Value<bool?> dynamicDamage,
      Value<int?> damageMultiplier,
      Value<int?> damageMinimum,
      Value<String?> triggerConditionText,
      Value<int?> triggersEffectId,
      Value<String?> effectType,
      Value<String?> ceScope,
      Value<String?> effectDetail,
      Value<String?> effectExtraConditions,
    });
typedef $$CardEffectsTableUpdateCompanionBuilder =
    CardEffectsCompanion Function({
      Value<int> id,
      Value<int> cardDefinitionId,
      Value<String> trigger,
      Value<String?> triggerDetail,
      Value<String?> extraConditions,
      Value<String> shortLabel,
      Value<String?> shortLabelEn,
      Value<String> description,
      Value<int?> damageAmount,
      Value<String?> damageTarget,
      Value<String?> replacementScope,
      Value<bool?> dynamicDamage,
      Value<int?> damageMultiplier,
      Value<int?> damageMinimum,
      Value<String?> triggerConditionText,
      Value<int?> triggersEffectId,
      Value<String?> effectType,
      Value<String?> ceScope,
      Value<String?> effectDetail,
      Value<String?> effectExtraConditions,
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

  ColumnFilters<String> get triggerDetail => $composableBuilder(
    column: $table.triggerDetail,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get extraConditions => $composableBuilder(
    column: $table.extraConditions,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get shortLabel => $composableBuilder(
    column: $table.shortLabel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get shortLabelEn => $composableBuilder(
    column: $table.shortLabelEn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get damageAmount => $composableBuilder(
    column: $table.damageAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get damageTarget => $composableBuilder(
    column: $table.damageTarget,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get replacementScope => $composableBuilder(
    column: $table.replacementScope,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get dynamicDamage => $composableBuilder(
    column: $table.dynamicDamage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get damageMultiplier => $composableBuilder(
    column: $table.damageMultiplier,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get damageMinimum => $composableBuilder(
    column: $table.damageMinimum,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get triggerConditionText => $composableBuilder(
    column: $table.triggerConditionText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get triggersEffectId => $composableBuilder(
    column: $table.triggersEffectId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get effectType => $composableBuilder(
    column: $table.effectType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ceScope => $composableBuilder(
    column: $table.ceScope,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get effectDetail => $composableBuilder(
    column: $table.effectDetail,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get effectExtraConditions => $composableBuilder(
    column: $table.effectExtraConditions,
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

  ColumnOrderings<String> get triggerDetail => $composableBuilder(
    column: $table.triggerDetail,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get extraConditions => $composableBuilder(
    column: $table.extraConditions,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get shortLabel => $composableBuilder(
    column: $table.shortLabel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get shortLabelEn => $composableBuilder(
    column: $table.shortLabelEn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get damageAmount => $composableBuilder(
    column: $table.damageAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get damageTarget => $composableBuilder(
    column: $table.damageTarget,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get replacementScope => $composableBuilder(
    column: $table.replacementScope,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get dynamicDamage => $composableBuilder(
    column: $table.dynamicDamage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get damageMultiplier => $composableBuilder(
    column: $table.damageMultiplier,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get damageMinimum => $composableBuilder(
    column: $table.damageMinimum,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get triggerConditionText => $composableBuilder(
    column: $table.triggerConditionText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get triggersEffectId => $composableBuilder(
    column: $table.triggersEffectId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get effectType => $composableBuilder(
    column: $table.effectType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ceScope => $composableBuilder(
    column: $table.ceScope,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get effectDetail => $composableBuilder(
    column: $table.effectDetail,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get effectExtraConditions => $composableBuilder(
    column: $table.effectExtraConditions,
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

  GeneratedColumn<String> get triggerDetail => $composableBuilder(
    column: $table.triggerDetail,
    builder: (column) => column,
  );

  GeneratedColumn<String> get extraConditions => $composableBuilder(
    column: $table.extraConditions,
    builder: (column) => column,
  );

  GeneratedColumn<String> get shortLabel => $composableBuilder(
    column: $table.shortLabel,
    builder: (column) => column,
  );

  GeneratedColumn<String> get shortLabelEn => $composableBuilder(
    column: $table.shortLabelEn,
    builder: (column) => column,
  );

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<int> get damageAmount => $composableBuilder(
    column: $table.damageAmount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get damageTarget => $composableBuilder(
    column: $table.damageTarget,
    builder: (column) => column,
  );

  GeneratedColumn<String> get replacementScope => $composableBuilder(
    column: $table.replacementScope,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get dynamicDamage => $composableBuilder(
    column: $table.dynamicDamage,
    builder: (column) => column,
  );

  GeneratedColumn<int> get damageMultiplier => $composableBuilder(
    column: $table.damageMultiplier,
    builder: (column) => column,
  );

  GeneratedColumn<int> get damageMinimum => $composableBuilder(
    column: $table.damageMinimum,
    builder: (column) => column,
  );

  GeneratedColumn<String> get triggerConditionText => $composableBuilder(
    column: $table.triggerConditionText,
    builder: (column) => column,
  );

  GeneratedColumn<int> get triggersEffectId => $composableBuilder(
    column: $table.triggersEffectId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get effectType => $composableBuilder(
    column: $table.effectType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get ceScope =>
      $composableBuilder(column: $table.ceScope, builder: (column) => column);

  GeneratedColumn<String> get effectDetail => $composableBuilder(
    column: $table.effectDetail,
    builder: (column) => column,
  );

  GeneratedColumn<String> get effectExtraConditions => $composableBuilder(
    column: $table.effectExtraConditions,
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
                Value<String?> triggerDetail = const Value.absent(),
                Value<String?> extraConditions = const Value.absent(),
                Value<String> shortLabel = const Value.absent(),
                Value<String?> shortLabelEn = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<int?> damageAmount = const Value.absent(),
                Value<String?> damageTarget = const Value.absent(),
                Value<String?> replacementScope = const Value.absent(),
                Value<bool?> dynamicDamage = const Value.absent(),
                Value<int?> damageMultiplier = const Value.absent(),
                Value<int?> damageMinimum = const Value.absent(),
                Value<String?> triggerConditionText = const Value.absent(),
                Value<int?> triggersEffectId = const Value.absent(),
                Value<String?> effectType = const Value.absent(),
                Value<String?> ceScope = const Value.absent(),
                Value<String?> effectDetail = const Value.absent(),
                Value<String?> effectExtraConditions = const Value.absent(),
              }) => CardEffectsCompanion(
                id: id,
                cardDefinitionId: cardDefinitionId,
                trigger: trigger,
                triggerDetail: triggerDetail,
                extraConditions: extraConditions,
                shortLabel: shortLabel,
                shortLabelEn: shortLabelEn,
                description: description,
                damageAmount: damageAmount,
                damageTarget: damageTarget,
                replacementScope: replacementScope,
                dynamicDamage: dynamicDamage,
                damageMultiplier: damageMultiplier,
                damageMinimum: damageMinimum,
                triggerConditionText: triggerConditionText,
                triggersEffectId: triggersEffectId,
                effectType: effectType,
                ceScope: ceScope,
                effectDetail: effectDetail,
                effectExtraConditions: effectExtraConditions,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int cardDefinitionId,
                required String trigger,
                Value<String?> triggerDetail = const Value.absent(),
                Value<String?> extraConditions = const Value.absent(),
                Value<String> shortLabel = const Value.absent(),
                Value<String?> shortLabelEn = const Value.absent(),
                required String description,
                Value<int?> damageAmount = const Value.absent(),
                Value<String?> damageTarget = const Value.absent(),
                Value<String?> replacementScope = const Value.absent(),
                Value<bool?> dynamicDamage = const Value.absent(),
                Value<int?> damageMultiplier = const Value.absent(),
                Value<int?> damageMinimum = const Value.absent(),
                Value<String?> triggerConditionText = const Value.absent(),
                Value<int?> triggersEffectId = const Value.absent(),
                Value<String?> effectType = const Value.absent(),
                Value<String?> ceScope = const Value.absent(),
                Value<String?> effectDetail = const Value.absent(),
                Value<String?> effectExtraConditions = const Value.absent(),
              }) => CardEffectsCompanion.insert(
                id: id,
                cardDefinitionId: cardDefinitionId,
                trigger: trigger,
                triggerDetail: triggerDetail,
                extraConditions: extraConditions,
                shortLabel: shortLabel,
                shortLabelEn: shortLabelEn,
                description: description,
                damageAmount: damageAmount,
                damageTarget: damageTarget,
                replacementScope: replacementScope,
                dynamicDamage: dynamicDamage,
                damageMultiplier: damageMultiplier,
                damageMinimum: damageMinimum,
                triggerConditionText: triggerConditionText,
                triggersEffectId: triggersEffectId,
                effectType: effectType,
                ceScope: ceScope,
                effectDetail: effectDetail,
                effectExtraConditions: effectExtraConditions,
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
typedef $$LearnedRulesTableCreateCompanionBuilder =
    LearnedRulesCompanion Function({
      Value<int> id,
      required String normalizedPattern,
      required String trigger,
      Value<String?> triggerDetail,
      Value<String?> extraConditions,
      required String shortLabelTemplate,
      required String shortLabelEnTemplate,
      Value<bool> hasDamageAmount,
      Value<String?> damageTarget,
      Value<int?> damageMultiplier,
      Value<int?> damageMinimum,
      Value<String?> replacementScope,
      Value<bool?> dynamicDamage,
      Value<String?> triggerConditionText,
      Value<String?> effectDetail,
      Value<String?> effectExtraConditions,
      Value<int> confidence,
    });
typedef $$LearnedRulesTableUpdateCompanionBuilder =
    LearnedRulesCompanion Function({
      Value<int> id,
      Value<String> normalizedPattern,
      Value<String> trigger,
      Value<String?> triggerDetail,
      Value<String?> extraConditions,
      Value<String> shortLabelTemplate,
      Value<String> shortLabelEnTemplate,
      Value<bool> hasDamageAmount,
      Value<String?> damageTarget,
      Value<int?> damageMultiplier,
      Value<int?> damageMinimum,
      Value<String?> replacementScope,
      Value<bool?> dynamicDamage,
      Value<String?> triggerConditionText,
      Value<String?> effectDetail,
      Value<String?> effectExtraConditions,
      Value<int> confidence,
    });

class $$LearnedRulesTableFilterComposer
    extends Composer<_$AppDatabase, $LearnedRulesTable> {
  $$LearnedRulesTableFilterComposer({
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

  ColumnFilters<String> get normalizedPattern => $composableBuilder(
    column: $table.normalizedPattern,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get trigger => $composableBuilder(
    column: $table.trigger,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get triggerDetail => $composableBuilder(
    column: $table.triggerDetail,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get extraConditions => $composableBuilder(
    column: $table.extraConditions,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get shortLabelTemplate => $composableBuilder(
    column: $table.shortLabelTemplate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get shortLabelEnTemplate => $composableBuilder(
    column: $table.shortLabelEnTemplate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get hasDamageAmount => $composableBuilder(
    column: $table.hasDamageAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get damageTarget => $composableBuilder(
    column: $table.damageTarget,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get damageMultiplier => $composableBuilder(
    column: $table.damageMultiplier,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get damageMinimum => $composableBuilder(
    column: $table.damageMinimum,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get replacementScope => $composableBuilder(
    column: $table.replacementScope,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get dynamicDamage => $composableBuilder(
    column: $table.dynamicDamage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get triggerConditionText => $composableBuilder(
    column: $table.triggerConditionText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get effectDetail => $composableBuilder(
    column: $table.effectDetail,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get effectExtraConditions => $composableBuilder(
    column: $table.effectExtraConditions,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get confidence => $composableBuilder(
    column: $table.confidence,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LearnedRulesTableOrderingComposer
    extends Composer<_$AppDatabase, $LearnedRulesTable> {
  $$LearnedRulesTableOrderingComposer({
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

  ColumnOrderings<String> get normalizedPattern => $composableBuilder(
    column: $table.normalizedPattern,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get trigger => $composableBuilder(
    column: $table.trigger,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get triggerDetail => $composableBuilder(
    column: $table.triggerDetail,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get extraConditions => $composableBuilder(
    column: $table.extraConditions,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get shortLabelTemplate => $composableBuilder(
    column: $table.shortLabelTemplate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get shortLabelEnTemplate => $composableBuilder(
    column: $table.shortLabelEnTemplate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get hasDamageAmount => $composableBuilder(
    column: $table.hasDamageAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get damageTarget => $composableBuilder(
    column: $table.damageTarget,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get damageMultiplier => $composableBuilder(
    column: $table.damageMultiplier,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get damageMinimum => $composableBuilder(
    column: $table.damageMinimum,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get replacementScope => $composableBuilder(
    column: $table.replacementScope,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get dynamicDamage => $composableBuilder(
    column: $table.dynamicDamage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get triggerConditionText => $composableBuilder(
    column: $table.triggerConditionText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get effectDetail => $composableBuilder(
    column: $table.effectDetail,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get effectExtraConditions => $composableBuilder(
    column: $table.effectExtraConditions,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get confidence => $composableBuilder(
    column: $table.confidence,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LearnedRulesTableAnnotationComposer
    extends Composer<_$AppDatabase, $LearnedRulesTable> {
  $$LearnedRulesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get normalizedPattern => $composableBuilder(
    column: $table.normalizedPattern,
    builder: (column) => column,
  );

  GeneratedColumn<String> get trigger =>
      $composableBuilder(column: $table.trigger, builder: (column) => column);

  GeneratedColumn<String> get triggerDetail => $composableBuilder(
    column: $table.triggerDetail,
    builder: (column) => column,
  );

  GeneratedColumn<String> get extraConditions => $composableBuilder(
    column: $table.extraConditions,
    builder: (column) => column,
  );

  GeneratedColumn<String> get shortLabelTemplate => $composableBuilder(
    column: $table.shortLabelTemplate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get shortLabelEnTemplate => $composableBuilder(
    column: $table.shortLabelEnTemplate,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get hasDamageAmount => $composableBuilder(
    column: $table.hasDamageAmount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get damageTarget => $composableBuilder(
    column: $table.damageTarget,
    builder: (column) => column,
  );

  GeneratedColumn<int> get damageMultiplier => $composableBuilder(
    column: $table.damageMultiplier,
    builder: (column) => column,
  );

  GeneratedColumn<int> get damageMinimum => $composableBuilder(
    column: $table.damageMinimum,
    builder: (column) => column,
  );

  GeneratedColumn<String> get replacementScope => $composableBuilder(
    column: $table.replacementScope,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get dynamicDamage => $composableBuilder(
    column: $table.dynamicDamage,
    builder: (column) => column,
  );

  GeneratedColumn<String> get triggerConditionText => $composableBuilder(
    column: $table.triggerConditionText,
    builder: (column) => column,
  );

  GeneratedColumn<String> get effectDetail => $composableBuilder(
    column: $table.effectDetail,
    builder: (column) => column,
  );

  GeneratedColumn<String> get effectExtraConditions => $composableBuilder(
    column: $table.effectExtraConditions,
    builder: (column) => column,
  );

  GeneratedColumn<int> get confidence => $composableBuilder(
    column: $table.confidence,
    builder: (column) => column,
  );
}

class $$LearnedRulesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LearnedRulesTable,
          LearnedRule,
          $$LearnedRulesTableFilterComposer,
          $$LearnedRulesTableOrderingComposer,
          $$LearnedRulesTableAnnotationComposer,
          $$LearnedRulesTableCreateCompanionBuilder,
          $$LearnedRulesTableUpdateCompanionBuilder,
          (
            LearnedRule,
            BaseReferences<_$AppDatabase, $LearnedRulesTable, LearnedRule>,
          ),
          LearnedRule,
          PrefetchHooks Function()
        > {
  $$LearnedRulesTableTableManager(_$AppDatabase db, $LearnedRulesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LearnedRulesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LearnedRulesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LearnedRulesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> normalizedPattern = const Value.absent(),
                Value<String> trigger = const Value.absent(),
                Value<String?> triggerDetail = const Value.absent(),
                Value<String?> extraConditions = const Value.absent(),
                Value<String> shortLabelTemplate = const Value.absent(),
                Value<String> shortLabelEnTemplate = const Value.absent(),
                Value<bool> hasDamageAmount = const Value.absent(),
                Value<String?> damageTarget = const Value.absent(),
                Value<int?> damageMultiplier = const Value.absent(),
                Value<int?> damageMinimum = const Value.absent(),
                Value<String?> replacementScope = const Value.absent(),
                Value<bool?> dynamicDamage = const Value.absent(),
                Value<String?> triggerConditionText = const Value.absent(),
                Value<String?> effectDetail = const Value.absent(),
                Value<String?> effectExtraConditions = const Value.absent(),
                Value<int> confidence = const Value.absent(),
              }) => LearnedRulesCompanion(
                id: id,
                normalizedPattern: normalizedPattern,
                trigger: trigger,
                triggerDetail: triggerDetail,
                extraConditions: extraConditions,
                shortLabelTemplate: shortLabelTemplate,
                shortLabelEnTemplate: shortLabelEnTemplate,
                hasDamageAmount: hasDamageAmount,
                damageTarget: damageTarget,
                damageMultiplier: damageMultiplier,
                damageMinimum: damageMinimum,
                replacementScope: replacementScope,
                dynamicDamage: dynamicDamage,
                triggerConditionText: triggerConditionText,
                effectDetail: effectDetail,
                effectExtraConditions: effectExtraConditions,
                confidence: confidence,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String normalizedPattern,
                required String trigger,
                Value<String?> triggerDetail = const Value.absent(),
                Value<String?> extraConditions = const Value.absent(),
                required String shortLabelTemplate,
                required String shortLabelEnTemplate,
                Value<bool> hasDamageAmount = const Value.absent(),
                Value<String?> damageTarget = const Value.absent(),
                Value<int?> damageMultiplier = const Value.absent(),
                Value<int?> damageMinimum = const Value.absent(),
                Value<String?> replacementScope = const Value.absent(),
                Value<bool?> dynamicDamage = const Value.absent(),
                Value<String?> triggerConditionText = const Value.absent(),
                Value<String?> effectDetail = const Value.absent(),
                Value<String?> effectExtraConditions = const Value.absent(),
                Value<int> confidence = const Value.absent(),
              }) => LearnedRulesCompanion.insert(
                id: id,
                normalizedPattern: normalizedPattern,
                trigger: trigger,
                triggerDetail: triggerDetail,
                extraConditions: extraConditions,
                shortLabelTemplate: shortLabelTemplate,
                shortLabelEnTemplate: shortLabelEnTemplate,
                hasDamageAmount: hasDamageAmount,
                damageTarget: damageTarget,
                damageMultiplier: damageMultiplier,
                damageMinimum: damageMinimum,
                replacementScope: replacementScope,
                dynamicDamage: dynamicDamage,
                triggerConditionText: triggerConditionText,
                effectDetail: effectDetail,
                effectExtraConditions: effectExtraConditions,
                confidence: confidence,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LearnedRulesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LearnedRulesTable,
      LearnedRule,
      $$LearnedRulesTableFilterComposer,
      $$LearnedRulesTableOrderingComposer,
      $$LearnedRulesTableAnnotationComposer,
      $$LearnedRulesTableCreateCompanionBuilder,
      $$LearnedRulesTableUpdateCompanionBuilder,
      (
        LearnedRule,
        BaseReferences<_$AppDatabase, $LearnedRulesTable, LearnedRule>,
      ),
      LearnedRule,
      PrefetchHooks Function()
    >;
typedef $$CardAttachmentsTableCreateCompanionBuilder =
    CardAttachmentsCompanion Function({
      Value<int> id,
      required int deckId,
      required int equipmentDefinitionId,
      required int targetDefinitionId,
    });
typedef $$CardAttachmentsTableUpdateCompanionBuilder =
    CardAttachmentsCompanion Function({
      Value<int> id,
      Value<int> deckId,
      Value<int> equipmentDefinitionId,
      Value<int> targetDefinitionId,
    });

class $$CardAttachmentsTableFilterComposer
    extends Composer<_$AppDatabase, $CardAttachmentsTable> {
  $$CardAttachmentsTableFilterComposer({
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

  ColumnFilters<int> get equipmentDefinitionId => $composableBuilder(
    column: $table.equipmentDefinitionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get targetDefinitionId => $composableBuilder(
    column: $table.targetDefinitionId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CardAttachmentsTableOrderingComposer
    extends Composer<_$AppDatabase, $CardAttachmentsTable> {
  $$CardAttachmentsTableOrderingComposer({
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

  ColumnOrderings<int> get equipmentDefinitionId => $composableBuilder(
    column: $table.equipmentDefinitionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get targetDefinitionId => $composableBuilder(
    column: $table.targetDefinitionId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CardAttachmentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CardAttachmentsTable> {
  $$CardAttachmentsTableAnnotationComposer({
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

  GeneratedColumn<int> get equipmentDefinitionId => $composableBuilder(
    column: $table.equipmentDefinitionId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get targetDefinitionId => $composableBuilder(
    column: $table.targetDefinitionId,
    builder: (column) => column,
  );
}

class $$CardAttachmentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CardAttachmentsTable,
          CardAttachment,
          $$CardAttachmentsTableFilterComposer,
          $$CardAttachmentsTableOrderingComposer,
          $$CardAttachmentsTableAnnotationComposer,
          $$CardAttachmentsTableCreateCompanionBuilder,
          $$CardAttachmentsTableUpdateCompanionBuilder,
          (
            CardAttachment,
            BaseReferences<
              _$AppDatabase,
              $CardAttachmentsTable,
              CardAttachment
            >,
          ),
          CardAttachment,
          PrefetchHooks Function()
        > {
  $$CardAttachmentsTableTableManager(
    _$AppDatabase db,
    $CardAttachmentsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CardAttachmentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CardAttachmentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CardAttachmentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> deckId = const Value.absent(),
                Value<int> equipmentDefinitionId = const Value.absent(),
                Value<int> targetDefinitionId = const Value.absent(),
              }) => CardAttachmentsCompanion(
                id: id,
                deckId: deckId,
                equipmentDefinitionId: equipmentDefinitionId,
                targetDefinitionId: targetDefinitionId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int deckId,
                required int equipmentDefinitionId,
                required int targetDefinitionId,
              }) => CardAttachmentsCompanion.insert(
                id: id,
                deckId: deckId,
                equipmentDefinitionId: equipmentDefinitionId,
                targetDefinitionId: targetDefinitionId,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CardAttachmentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CardAttachmentsTable,
      CardAttachment,
      $$CardAttachmentsTableFilterComposer,
      $$CardAttachmentsTableOrderingComposer,
      $$CardAttachmentsTableAnnotationComposer,
      $$CardAttachmentsTableCreateCompanionBuilder,
      $$CardAttachmentsTableUpdateCompanionBuilder,
      (
        CardAttachment,
        BaseReferences<_$AppDatabase, $CardAttachmentsTable, CardAttachment>,
      ),
      CardAttachment,
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
  $$LearnedRulesTableTableManager get learnedRules =>
      $$LearnedRulesTableTableManager(_db, _db.learnedRules);
  $$CardAttachmentsTableTableManager get cardAttachments =>
      $$CardAttachmentsTableTableManager(_db, _db.cardAttachments);
}
