import 'package:drift/drift.dart' as drift;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/database/app_database.dart';
import '../data/import/deck_list_parser.dart';
import '../data/parser/card_text_parser.dart';
import '../data/scryfall/scryfall_client.dart';
import '../shared/models/trigger_type.dart';
import 'database_provider.dart';

/// Eine Karten-Definition mit allen zugehörigen Exemplaren (gleiches Deck +
/// gleicher Board-Abschnitt), für die gruppierte Darstellung in der UI.
class DeckCardGroup {
  const DeckCardGroup({
    required this.definition,
    required this.board,
    required this.deckCards,
  });

  final CardDefinition definition;
  final String board;
  final List<DeckCard> deckCards;

  int get total => deckCards.length;
  int get inPlayCount => deckCards.where((c) => c.inPlay).length;
}

final decksProvider = StreamProvider<List<Deck>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.select(db.decks).watch();
});

/// Karten eines Decks, inkl. der Eigenschaften der Karten-Definition.
final cardsForDeckProvider =
    StreamProvider.family<List<(DeckCard, CardDefinition)>, int>((
      ref,
      deckId,
    ) {
      final db = ref.watch(databaseProvider);
      final query = db.select(db.deckCards).join([
        drift.innerJoin(
          db.cardDefinitions,
          db.cardDefinitions.id.equalsExp(db.deckCards.cardDefinitionId),
        ),
      ])..where(db.deckCards.deckId.equals(deckId));

      return query.watch().map((rows) {
        return rows
            .map(
              (row) => (
                row.readTable(db.deckCards),
                row.readTable(db.cardDefinitions),
              ),
            )
            .toList();
      });
    });

/// Karten eines Decks, gruppiert nach Karten-Definition + Board-Abschnitt
/// (z.B. "4x Lightning Bolt" statt 4 Einzelzeilen).
final groupedCardsForDeckProvider =
    Provider.family<AsyncValue<List<DeckCardGroup>>, int>((ref, deckId) {
      final cards = ref.watch(cardsForDeckProvider(deckId));
      return cards.whenData((entries) {
        final groups = <String, DeckCardGroup>{};
        for (final (deckCard, definition) in entries) {
          final key = '${definition.id}_${deckCard.board}';
          final existing = groups[key];
          if (existing == null) {
            groups[key] = DeckCardGroup(
              definition: definition,
              board: deckCard.board,
              deckCards: [deckCard],
            );
          } else {
            groups[key] = DeckCardGroup(
              definition: existing.definition,
              board: existing.board,
              deckCards: [...existing.deckCards, deckCard],
            );
          }
        }
        return groups.values.toList()
          ..sort((a, b) => a.definition.name.compareTo(b.definition.name));
      });
    });

/// Die Trigger-Typen, für die mind. ein Effekt in der Datenbank erfasst ist.
final usedTriggerTypesProvider = StreamProvider<Set<TriggerType>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.select(db.cardEffects).watch().map((effects) {
    return {
      for (final effect in effects)
        ...TriggerType.values.where((t) => t.name == effect.trigger),
    };
  });
});

final effectsForCardDefinitionProvider =
    StreamProvider.family<List<CardEffect>, int>((ref, cardDefinitionId) {
      final db = ref.watch(databaseProvider);
      return (db.select(
        db.cardEffects,
      )..where((e) => e.cardDefinitionId.equals(cardDefinitionId))).watch();
    });

/// Effekte aller im Spiel befindlichen Karten, deren Trigger zu [trigger]
/// passt. Liefert Paare aus auslösender Karten-Definition und Effekt.
final effectsForTriggerProvider =
    StreamProvider.family<List<(CardDefinition, CardEffect)>, TriggerType>((
      ref,
      trigger,
    ) {
      final db = ref.watch(databaseProvider);
      final query = db.select(db.deckCards).join([
        drift.innerJoin(
          db.cardDefinitions,
          db.cardDefinitions.id.equalsExp(db.deckCards.cardDefinitionId),
        ),
        drift.innerJoin(
          db.cardEffects,
          db.cardEffects.cardDefinitionId.equalsExp(db.cardDefinitions.id),
        ),
      ])
        ..where(db.deckCards.inPlay.equals(true))
        ..where(db.cardEffects.trigger.equals(trigger.name));

      return query.watch().map((rows) {
        return rows
            .map(
              (row) => (
                row.readTable(db.cardDefinitions),
                row.readTable(db.cardEffects),
              ),
            )
            .toList();
      });
    });

/// Effekte aller im Spiel befindlichen Karten des aktiven Decks, gruppiert
/// nach Trigger-Typ. Liefert nur Trigger, für die mind. ein Effekt existiert.
final activeTriggerEffectsProvider =
    StreamProvider.family<Map<TriggerType, List<(CardDefinition, CardEffect)>>, int>((
      ref,
      deckId,
    ) {
      final db = ref.watch(databaseProvider);
      final query = db.select(db.deckCards).join([
        drift.innerJoin(
          db.cardDefinitions,
          db.cardDefinitions.id.equalsExp(db.deckCards.cardDefinitionId),
        ),
        drift.innerJoin(
          db.cardEffects,
          db.cardEffects.cardDefinitionId.equalsExp(db.cardDefinitions.id),
        ),
      ])
        ..where(db.deckCards.inPlay.equals(true))
        ..where(db.deckCards.deckId.equals(deckId))
        ..where(db.deckCards.board.equals('main'));

      return query.watch().map((rows) {
        final map = <TriggerType, List<(CardDefinition, CardEffect)>>{};
        for (final row in rows) {
          final definition = row.readTable(db.cardDefinitions);
          final effect = row.readTable(db.cardEffects);
          for (final trigger in TriggerType.values) {
            // continuousEffect gehört nur in den Status-Tab, nicht hierher
            if (trigger == TriggerType.continuousEffect) break;
            if (trigger.name == effect.trigger) {
              map.putIfAbsent(trigger, () => []).add((definition, effect));
              break;
            }
          }
        }
        return map;
      });
    });

/// Dauereffekte aller im Spiel befindlichen Karten des aktiven Decks
/// (trigger = continuousEffect).
final activeContinuousEffectsProvider =
    StreamProvider.family<List<(CardDefinition, CardEffect)>, int>((ref, deckId) {
      final db = ref.watch(databaseProvider);
      final query = db.select(db.deckCards).join([
        drift.innerJoin(
          db.cardDefinitions,
          db.cardDefinitions.id.equalsExp(db.deckCards.cardDefinitionId),
        ),
        drift.innerJoin(
          db.cardEffects,
          db.cardEffects.cardDefinitionId.equalsExp(db.cardDefinitions.id),
        ),
      ])
        ..where(db.deckCards.inPlay.equals(true))
        ..where(db.deckCards.deckId.equals(deckId))
        ..where(db.deckCards.board.equals('main'))
        ..where(db.cardEffects.trigger.equals(TriggerType.continuousEffect.name));

      return query.watch().map(
        (rows) => rows
            .map((r) => (r.readTable(db.cardDefinitions), r.readTable(db.cardEffects)))
            .toList(),
      );
    });

/// Keywords aller im Spiel befindlichen Karten des aktiven Decks, die
/// mindestens ein Scryfall-Keyword haben. Dedupliziert nach CardDefinition.
final activeCardKeywordsProvider =
    StreamProvider.family<List<(CardDefinition, List<String>)>, int>((ref, deckId) {
      final db = ref.watch(databaseProvider);
      final query = db.select(db.deckCards).join([
        drift.innerJoin(
          db.cardDefinitions,
          db.cardDefinitions.id.equalsExp(db.deckCards.cardDefinitionId),
        ),
      ])
        ..where(db.deckCards.inPlay.equals(true))
        ..where(db.deckCards.deckId.equals(deckId))
        ..where(db.deckCards.board.equals('main'))
        ..groupBy([db.cardDefinitions.id]);

      return query.watch().map((rows) {
        final result = <(CardDefinition, List<String>)>[];
        for (final row in rows) {
          final def = row.readTable(db.cardDefinitions);
          final kws = def.keywords
                  ?.split(',')
                  .map((k) => k.trim())
                  .where((k) => k.isNotEmpty)
                  .toList() ??
              [];
          if (kws.isNotEmpty) result.add((def, kws));
        }
        return result;
      });
    });

class DeckRepository {
  DeckRepository(this._db);
  final AppDatabase _db;

  Future<int> createDeck(String name) {
    final now = DateTime.now();
    return _db
        .into(_db.decks)
        .insert(
          DecksCompanion.insert(name: name, createdAt: now, updatedAt: now),
        );
  }

  Future<void> deleteDeck(int id) async {
    final cards =
        await (_db.select(
          _db.deckCards,
        )..where((c) => c.deckId.equals(id))).get();
    for (final card in cards) {
      await _deleteDeckCard(card);
    }
    await (_db.delete(_db.decks)..where((d) => d.id.equals(id))).go();
  }

  /// Legt eine neue Karten-Definition und ein Exemplar im Deck an.
  Future<void> createCard(int deckId, String name) async {
    final definitionId = await _db
        .into(_db.cardDefinitions)
        .insert(CardDefinitionsCompanion.insert(name: name));
    await _db
        .into(_db.deckCards)
        .insert(
          DeckCardsCompanion.insert(
            deckId: deckId,
            cardDefinitionId: definitionId,
          ),
        );
  }

  Future<void> deleteCard(DeckCard deckCard) => _deleteDeckCard(deckCard);

  Future<void> _deleteDeckCard(DeckCard deckCard) async {
    await (_db.delete(
      _db.deckCards,
    )..where((c) => c.id.equals(deckCard.id))).go();

    // Definition + Effekte aufräumen, wenn sie von keinem anderen Exemplar
    // mehr referenziert wird.
    final remaining =
        await (_db.select(_db.deckCards)..where(
              (c) => c.cardDefinitionId.equals(deckCard.cardDefinitionId),
            ))
            .get();
    if (remaining.isEmpty) {
      await (_db.delete(_db.cardEffects)..where(
            (e) => e.cardDefinitionId.equals(deckCard.cardDefinitionId),
          ))
          .go();
      await (_db.delete(
        _db.cardDefinitions,
      )..where((d) => d.id.equals(deckCard.cardDefinitionId))).go();
    }
  }

  Future<void> setInPlay(int deckCardId, bool inPlay) {
    return (_db.update(
      _db.deckCards,
    )..where((c) => c.id.equals(deckCardId))).write(
      DeckCardsCompanion(inPlay: drift.Value(inPlay)),
    );
  }

  /// Setzt für eine Kartengruppe genau [count] der Exemplare auf "im Spiel".
  Future<void> setInPlayCount(DeckCardGroup group, int count) async {
    final ids = group.deckCards.map((c) => c.id).toList();
    final clamped = count.clamp(0, ids.length);
    await _db.transaction(() async {
      for (var i = 0; i < ids.length; i++) {
        await (_db.update(_db.deckCards)..where((c) => c.id.equals(ids[i])))
            .write(DeckCardsCompanion(inPlay: drift.Value(i < clamped)));
      }
    });
  }

  /// Importiert eine Deckliste: legt ein neues Deck an und für jede Zeile
  /// die passende Anzahl Exemplare. Karten-Definitionen werden anhand von
  /// Name + Set + Collector-Nr. wiederverwendet, falls schon vorhanden.
  Future<int> importDeckList(String deckName, List<ParsedCard> cards) async {
    return _db.transaction(() async {
      final deckId = await createDeck(deckName);

      for (final card in cards) {
        final existing =
            await (_db.select(_db.cardDefinitions)..where(
                  (d) =>
                      d.name.equals(card.name) &
                      (card.setCode == null
                          ? d.setCode.isNull()
                          : d.setCode.equals(card.setCode!)) &
                      (card.collectorNumber == null
                          ? d.collectorNumber.isNull()
                          : d.collectorNumber.equals(card.collectorNumber!)),
                ))
                .getSingleOrNull();

        final definitionId =
            existing?.id ??
            await _db
                .into(_db.cardDefinitions)
                .insert(
                  CardDefinitionsCompanion.insert(
                    name: card.name,
                    setCode: drift.Value(card.setCode),
                    collectorNumber: drift.Value(card.collectorNumber),
                  ),
                );

        for (var i = 0; i < card.quantity; i++) {
          await _db
              .into(_db.deckCards)
              .insert(
                DeckCardsCompanion.insert(
                  deckId: deckId,
                  cardDefinitionId: definitionId,
                  board: drift.Value(card.board),
                ),
              );
        }
      }

      return deckId;
    });
  }

  Future<void> addEffect(
    int cardDefinitionId,
    TriggerType trigger,
    String shortLabel,
    String shortLabelEn,
    String description, {
    String? triggerDetail,
    String? triggerConditionText,
    String? effectType,
    String? ceScope,
    Set<TriggerCondition> extraConditions = const {},
    int? damageAmount,
    DamageTarget? damageTarget,
    int? damageMultiplier,
    int? damageMinimum,
    ReplacementScope? replacementScope,
    bool dynamicDamage = false,
    String? effectDetail,
    Set<EffectCondition> effectExtraConditions = const {},
  }) {
    return _db
        .into(_db.cardEffects)
        .insert(
          CardEffectsCompanion.insert(
            cardDefinitionId: cardDefinitionId,
            trigger: trigger.name,
            triggerDetail: drift.Value(triggerDetail),
            triggerConditionText: drift.Value(triggerConditionText),
            effectType: drift.Value(effectType),
            ceScope: drift.Value(ceScope),
            extraConditions: drift.Value(
              extraConditions.isEmpty
                  ? null
                  : extraConditions.map((c) => c.name).join(','),
            ),
            shortLabel: drift.Value(shortLabel),
            shortLabelEn: drift.Value(shortLabelEn.isEmpty ? null : shortLabelEn),
            description: description,
            damageAmount: drift.Value(damageAmount),
            damageTarget: drift.Value(damageTarget?.name),
            damageMultiplier: drift.Value(damageMultiplier),
            damageMinimum: drift.Value(damageMinimum),
            replacementScope: drift.Value(replacementScope?.name),
            dynamicDamage: drift.Value(dynamicDamage ? true : null),
            effectDetail: drift.Value(effectDetail),
            effectExtraConditions: drift.Value(
              effectExtraConditions.isEmpty
                  ? null
                  : effectExtraConditions.map((c) => c.name).join(','),
            ),
          ),
        );
  }

  /// Verschiebt alle Exemplare einer Kartengruppe in ein anderes Board-Segment.
  Future<void> moveGroupToBoard(DeckCardGroup group, String board) {
    return _db.transaction(() async {
      for (final card in group.deckCards) {
        await (_db.update(_db.deckCards)..where((c) => c.id.equals(card.id)))
            .write(DeckCardsCompanion(board: drift.Value(board)));
      }
    });
  }

  Future<void> attachEquipment(
    int deckId,
    int equipmentDefinitionId,
    int targetDefinitionId,
  ) async {
    await (_db.delete(_db.cardAttachments)
          ..where(
            (a) =>
                a.deckId.equals(deckId) &
                a.equipmentDefinitionId.equals(equipmentDefinitionId),
          ))
        .go();
    await _db.into(_db.cardAttachments).insert(
      CardAttachmentsCompanion.insert(
        deckId: deckId,
        equipmentDefinitionId: equipmentDefinitionId,
        targetDefinitionId: targetDefinitionId,
      ),
    );
  }

  Future<void> detachEquipment(int deckId, int equipmentDefinitionId) {
    return (_db.delete(_db.cardAttachments)
          ..where(
            (a) =>
                a.deckId.equals(deckId) &
                a.equipmentDefinitionId.equals(equipmentDefinitionId),
          ))
        .go();
  }

  /// Löscht alle Attachment-Einträge für ein Deck (z.B. beim Runden-Reset).
  Future<void> clearAttachments(int deckId) {
    return (_db.delete(_db.cardAttachments)
          ..where((a) => a.deckId.equals(deckId)))
        .go();
  }

  /// Löscht alle erfassten Effekte für alle Karten eines Decks.
  Future<void> clearEffectsForDeck(int deckId) async {
    final defIds = await (_db.selectOnly(_db.deckCards)
          ..addColumns([_db.deckCards.cardDefinitionId])
          ..where(_db.deckCards.deckId.equals(deckId)))
        .map((r) => r.read(_db.deckCards.cardDefinitionId)!)
        .get();
    if (defIds.isEmpty) return;
    await (_db.delete(_db.cardEffects)
          ..where((e) => e.cardDefinitionId.isIn(defIds)))
        .go();
  }

  /// Setzt alle Karten eines Decks auf "nicht im Spiel" (Rundenreset).
  Future<void> resetAllInPlay(int deckId) async {
    await (_db.update(_db.deckCards)..where((c) => c.deckId.equals(deckId)))
        .write(const DeckCardsCompanion(inPlay: drift.Value(false)));
    await clearAttachments(deckId);
  }

  Future<void> updateRating(int cardDefinitionId, double? rating) {
    return (_db.update(_db.cardDefinitions)
          ..where((d) => d.id.equals(cardDefinitionId)))
        .write(CardDefinitionsCompanion(rating: drift.Value(rating)));
  }

  Future<void> deleteEffect(int effectId) {
    return (_db.delete(
      _db.cardEffects,
    )..where((e) => e.id.equals(effectId))).go();
  }

  // ── Learned Rules ───────────────────────────────────────────────────────────

  Future<List<LearnedRuleEntry>> getAllLearnedRules() async {
    final rows = await _db.select(_db.learnedRules).get();
    return rows.map((r) => LearnedRuleEntry(
      normalizedPattern: r.normalizedPattern,
      trigger: r.trigger,
      shortLabelTemplate: r.shortLabelTemplate,
      shortLabelEnTemplate: r.shortLabelEnTemplate,
      hasDamageAmount: r.hasDamageAmount,
      triggerDetail: r.triggerDetail,
      extraConditions: r.extraConditions,
      damageTarget: r.damageTarget,
      damageMultiplier: r.damageMultiplier,
      damageMinimum: r.damageMinimum,
      replacementScope: r.replacementScope,
      dynamicDamage: r.dynamicDamage,
    )).toList();
  }

  /// Fügt eine neue Regel ein oder erhöht die Konfidenz einer bestehenden.
  /// Das Upsert geschieht über den UNIQUE-Index auf `normalized_pattern`.
  Future<void> upsertLearnedRule({
    required String pattern,
    required String trigger,
    required String shortLabelTemplate,
    required String shortLabelEnTemplate,
    required bool hasDamageAmount,
    String? triggerDetail,
    String? triggerConditionText,
    String? extraConditions,
    String? damageTarget,
    int? damageMultiplier,
    int? damageMinimum,
    String? replacementScope,
    bool? dynamicDamage,
    String? effectDetail,
    String? effectExtraConditions,
  }) {
    return _db.customStatement(
      '''
      INSERT INTO learned_rules (
        normalized_pattern, trigger, trigger_detail, extra_conditions,
        short_label_template, short_label_en_template, has_damage_amount,
        damage_target, damage_multiplier, damage_minimum,
        replacement_scope, dynamic_damage, trigger_condition_text,
        effect_detail, effect_extra_conditions, confidence
      ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 1)
      ON CONFLICT(normalized_pattern) DO UPDATE SET
        confidence      = confidence + 1,
        trigger         = excluded.trigger,
        trigger_detail  = excluded.trigger_detail,
        extra_conditions= excluded.extra_conditions,
        short_label_template    = excluded.short_label_template,
        short_label_en_template = excluded.short_label_en_template,
        has_damage_amount= excluded.has_damage_amount,
        damage_target   = excluded.damage_target,
        damage_multiplier= excluded.damage_multiplier,
        damage_minimum  = excluded.damage_minimum,
        replacement_scope= excluded.replacement_scope,
        dynamic_damage  = excluded.dynamic_damage,
        trigger_condition_text = excluded.trigger_condition_text,
        effect_detail          = excluded.effect_detail,
        effect_extra_conditions= excluded.effect_extra_conditions
      ''',
      [
        pattern,
        trigger,
        triggerDetail,
        extraConditions,
        shortLabelTemplate,
        shortLabelEnTemplate,
        hasDamageAmount ? 1 : 0,
        damageTarget,
        damageMultiplier,
        damageMinimum,
        replacementScope,
        dynamicDamage == true ? 1 : 0,
        triggerConditionText,
        effectDetail,
        effectExtraConditions,
      ],
    );
  }

  // ── Card Definitions ────────────────────────────────────────────────────────

  Future<List<CardDefinition>> getCardDefinitionsForDeck(int deckId) async {
    final rows = await (_db.select(_db.cardDefinitions).join([
      drift.innerJoin(
        _db.deckCards,
        _db.deckCards.cardDefinitionId.equalsExp(_db.cardDefinitions.id),
      ),
    ])
          ..where(_db.deckCards.deckId.equals(deckId))
          ..groupBy([_db.cardDefinitions.id]))
        .get();
    return rows.map((row) => row.readTable(_db.cardDefinitions)).toList();
  }

  Future<bool> hasEffects(int cardDefinitionId) async {
    final list = await (_db.select(_db.cardEffects)
          ..where((e) => e.cardDefinitionId.equals(cardDefinitionId)))
        .get();
    return list.isNotEmpty;
  }

  /// Gibt true zurück, wenn für [cardDefinitionId] bereits ein
  /// continuousEffect-Eintrag mit exakt dieser [description] existiert.
  Future<bool> hasContinuousEffectForDescription(
    int cardDefinitionId,
    String description,
  ) async {
    final list = await (_db.select(_db.cardEffects)
          ..where(
            (e) =>
                e.cardDefinitionId.equals(cardDefinitionId) &
                e.trigger.equals(TriggerType.continuousEffect.name) &
                e.description.equals(description),
          ))
        .get();
    return list.isNotEmpty;
  }

  /// Lädt für alle Karten-Definitionen eines Decks mit Set + Sammelnummer
  /// die fehlenden Werte (Manakosten, Typ, Text, ...) von Scryfall nach.
  /// Mit [onlyMissing] = true werden nur Karten ohne `scryfallId` abgerufen.
  /// Gibt die Anzahl der aktualisierten Karten-Definitionen zurück.
  Future<int> enrichDeckFromScryfall(
    int deckId, {
    bool onlyMissing = false,
    ScryfallClient? client,
    void Function(int done, int total, String cardName)? onProgress,
  }) async {
    final definitions =
        await (_db.select(_db.cardDefinitions).join([
              drift.innerJoin(
                _db.deckCards,
                _db.deckCards.cardDefinitionId.equalsExp(
                  _db.cardDefinitions.id,
                ),
              ),
            ])
              ..where(_db.deckCards.deckId.equals(deckId))
              ..groupBy([_db.cardDefinitions.id]))
            .map((row) => row.readTable(_db.cardDefinitions))
            .get();

    final toFetch = definitions.where(
      (d) =>
          d.setCode != null &&
          d.collectorNumber != null &&
          (!onlyMissing || d.scryfallId == null),
    ).toList();
    if (toFetch.isEmpty) return 0;

    final scryfall = client ?? ScryfallClient();
    final cards = await scryfall.fetchCards(
      [for (final d in toFetch) (d.setCode!, d.collectorNumber!)],
      onProgress: onProgress,
    );

    final byKey = {
      for (final c in cards) '${c.setCode}_${c.collectorNumber}': c,
    };

    var updated = 0;
    await _db.transaction(() async {
      for (final d in toFetch) {
        final card = byKey['${d.setCode!.toUpperCase()}_${d.collectorNumber}'];
        if (card == null) continue;
        await (_db.update(_db.cardDefinitions)..where((c) => c.id.equals(d.id)))
            .write(
              CardDefinitionsCompanion(
                scryfallId: drift.Value(card.scryfallId),
                manaCost: drift.Value(card.manaCost),
                cmc: drift.Value(card.cmc),
                typeLine: drift.Value(card.typeLine),
                oracleText: drift.Value(card.oracleText),
                colors: drift.Value(card.colors),
                power: drift.Value(card.power),
                toughness: drift.Value(card.toughness),
                imageUri: drift.Value(card.imageUri),
                printedName: drift.Value(card.printedName),
                printedText: drift.Value(card.printedText),
                printedTypeLine: drift.Value(card.printedTypeLine),
                keywords: drift.Value(card.keywords),
              ),
            );
        updated++;
      }
    });
    return updated;
  }
}

/// Alle Equipment-Zuordnungen für ein Deck: equipmentDefinitionId → targetDefinitionId.
final attachmentsForDeckProvider =
    StreamProvider.family<Map<int, int>, int>((ref, deckId) {
  final db = ref.watch(databaseProvider);
  return (db.select(db.cardAttachments)
        ..where((a) => a.deckId.equals(deckId)))
      .watch()
      .map((rows) => {
            for (final r in rows)
              r.equipmentDefinitionId: r.targetDefinitionId,
          });
});

/// Wie [attachmentsForDeckProvider], aber mit aufgelösten CardDefinitions:
/// equipmentDefinitionId → CardDefinition der Zielkarte.
final attachmentsWithDefsProvider =
    StreamProvider.family<Map<int, CardDefinition>, int>((ref, deckId) {
  final db = ref.watch(databaseProvider);
  final target = db.alias(db.cardDefinitions, 'target');
  final query = db.select(db.cardAttachments).join([
    drift.innerJoin(
      target,
      target.id.equalsExp(db.cardAttachments.targetDefinitionId),
    ),
  ])..where(db.cardAttachments.deckId.equals(deckId));

  return query.watch().map((rows) => {
        for (final row in rows)
          row.readTable(db.cardAttachments).equipmentDefinitionId:
              row.readTable(target),
      });
});

final deckRepositoryProvider = Provider<DeckRepository>((ref) {
  return DeckRepository(ref.watch(databaseProvider));
});
