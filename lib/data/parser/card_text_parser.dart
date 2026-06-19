import '../../shared/models/trigger_type.dart';

/// Kompaktes DTO für eine gelernte Regel aus der DB — entkoppelt den Parser
/// von Drift-generierten Typen.
class LearnedRuleEntry {
  const LearnedRuleEntry({
    required this.normalizedPattern,
    required this.trigger,
    required this.shortLabelTemplate,
    required this.shortLabelEnTemplate,
    required this.hasDamageAmount,
    this.triggerDetail,
    this.extraConditions,
    this.damageTarget,
    this.damageMultiplier,
    this.damageMinimum,
    this.replacementScope,
    this.dynamicDamage,
  });

  final String normalizedPattern;
  final String trigger;
  final String shortLabelTemplate;
  final String shortLabelEnTemplate;
  final bool hasDamageAmount;
  final String? triggerDetail;
  final String? extraConditions;
  final String? damageTarget;
  final int? damageMultiplier;
  final int? damageMinimum;
  final String? replacementScope;
  final bool? dynamicDamage;
}

class ParsedEffect {
  const ParsedEffect({
    required this.trigger,
    required this.shortLabel,
    required this.shortLabelEn,
    required this.description,
    this.triggerDetail,
    this.damageAmount,
    this.damageTarget,
    this.damageMultiplier,
    this.damageMinimum,
    this.replacementScope,
    this.dynamicDamage = false,
    this.extraConditions = const {},
  });

  final TriggerType trigger;
  final String? triggerDetail;
  final String shortLabel;
  final String shortLabelEn;
  final String description;
  final int? damageAmount;
  final DamageTarget? damageTarget;
  final int? damageMultiplier;
  final int? damageMinimum;
  final ReplacementScope? replacementScope;
  final bool dynamicDamage;
  final Set<EffectCondition> extraConditions;
}

/// Rule-based parser for English MTG oracle text.
/// Checks [learnedRules] (user-confirmed patterns) before falling back to
/// built-in regex rules. No external dependencies; pure Dart.
class CardTextParser {
  CardTextParser._();

  // ── Public API ─────────────────────────────────────────────────────────────

  static List<ParsedEffect> parse(
    String oracleText, {
    String? cardName,
    List<LearnedRuleEntry> learnedRules = const [],
  }) {
    final results = <ParsedEffect>[];
    final selfName = (cardName ?? '').toLowerCase();
    final byPattern = {for (final r in learnedRules) r.normalizedPattern: r};
    for (final rawLine in oracleText.split('\n')) {
      final line = rawLine.trim();
      if (line.isEmpty) continue;
      results.addAll(_parseLine(line, selfName: selfName, learnedByPattern: byPattern));
    }
    return results;
  }

  /// Normalisiert eine Orakelzeile: Kartenname → {self}, Zahlen → {N}.
  /// Wird beim Speichern und beim Nachschlagen als Schlüssel verwendet.
  static String normalize(String line, {String? selfName}) {
    var t = line.trim();
    if (selfName != null && selfName.isNotEmpty) {
      t = t.replaceAll(RegExp(RegExp.escape(selfName), caseSensitive: false), '{self}');
    }
    return t.replaceAll(RegExp(r'\b\d+\b'), '{N}').toLowerCase();
  }

  /// Erstellt eine Label-Vorlage, indem [n] durch {N} ersetzt wird.
  static String makeTemplate(String label, int? n) {
    if (n == null) return label;
    return label.replaceAll(n.toString(), '{N}');
  }

  // ── Internes Parsing ───────────────────────────────────────────────────────

  static List<ParsedEffect> _parseLine(
    String line, {
    required String selfName,
    required Map<String, LearnedRuleEntry> learnedByPattern,
  }) {
    // Gelernte Regel hat Vorrang vor eingebauten Regex-Regeln
    final normalized = normalize(line, selfName: selfName);
    final learned = learnedByPattern[normalized];
    if (learned != null) return [_applyLearnedRule(learned, line)];

    final t = line.toLowerCase();

    // ── Phase triggers ────────────────────────────────────────────────────────
    if (t.contains('at the beginning of your upkeep')) {
      return [ParsedEffect(trigger: TriggerType.upkeep, shortLabel: 'Unterhalt', shortLabelEn: 'Upkeep', description: line)];
    }
    if (t.contains('at the beginning of your end step') || t.contains('at the beginning of each end step')) {
      return [ParsedEffect(trigger: TriggerType.endStep, shortLabel: 'Endschritt', shortLabelEn: 'End step', description: line)];
    }

    // ── Landfall ─────────────────────────────────────────────────────────────
    if (t.startsWith('landfall') || (t.contains('whenever a land enters') && t.contains('under your control'))) {
      return [ParsedEffect(trigger: TriggerType.landfall, shortLabel: 'Landfall', shortLabelEn: 'Landfall', description: line)];
    }

    // ── Card draw ────────────────────────────────────────────────────────────
    if (t.contains('whenever you draw a card') || t.contains('whenever a player draws a card')) {
      return [ParsedEffect(trigger: TriggerType.cardDrawn, shortLabel: 'Karte gezogen', shortLabelEn: 'Card drawn', description: line)];
    }

    // ── Life gain ────────────────────────────────────────────────────────────
    if (t.contains('whenever you gain life') || t.contains('whenever you gain one or more life')) {
      return [ParsedEffect(trigger: TriggerType.lifeGain, shortLabel: 'Lebenspunkte +', shortLabelEn: 'Life gain', description: line)];
    }

    // ── castSpell triggers ────────────────────────────────────────────────────
    if (t.contains('whenever you cast an instant or sorcery spell')) {
      return [_buildCastSpell(line, t, SpellCategory.instantOrSorcery)];
    }
    if (t.contains('whenever you cast a noncreature spell') || t.contains('whenever you cast another noncreature spell')) {
      return [_buildCastSpell(line, t, SpellCategory.noncreatureSpell)];
    }
    if (t.contains('whenever you cast a spell') || t.contains('whenever you cast another spell')) {
      return [_buildCastSpellGeneric(line, t)];
    }

    // ── spellDealsDamage ─────────────────────────────────────────────────────
    if (t.contains('whenever a spell you control deals damage') ||
        (t.contains('whenever a source you control deals damage') && t.contains('creature'))) {
      // triggerDetail null: passt für alle Spell-Typen (keine Einschränkung ableitbar)
      return [ParsedEffect(
        trigger: TriggerType.spellDealsDamage,
        shortLabel: 'Spruchschaden',
        shortLabelEn: 'Spell damage',
        description: line,
      )];
    }

    // ── dealsNoncombatDamage ─────────────────────────────────────────────────
    if (t.contains('whenever you deal noncombat damage') ||
        (t.contains('whenever') && t.contains('deals noncombat damage'))) {
      final isRed = t.contains('red source');
      return [ParsedEffect(
        trigger: TriggerType.dealsNoncombatDamage,
        triggerDetail: isRed ? SourceFilter.redSource.name : SourceFilter.anySource.name,
        shortLabel: 'Nicht-Kampfschaden',
        shortLabelEn: 'Noncombat damage',
        description: line,
      )];
    }

    // ── staticDamageModifier (replacement effects) ────────────────────────────

    // "deals that much damage plus N instead" — z.B. Torbran
    final replacePlusMatch = RegExp(r'deals that much damage plus (\d+)', caseSensitive: false).firstMatch(t);
    if (replacePlusMatch != null) {
      final n = int.tryParse(replacePlusMatch.group(1) ?? '') ?? 1;
      final isRed = t.contains('red source');
      // BUG FIX: wenn "permanent" im Text vorkommt, gilt der Effekt für
      // Gegner UND deren Permanente (all), nicht nur für Gegner (opponentOnly).
      final isOpponentOnly = !(t.contains('creature') || t.contains('permanent'));
      return [ParsedEffect(
        trigger: TriggerType.staticDamageModifier,
        triggerDetail: isRed ? SourceFilter.redSource.name : SourceFilter.anySource.name,
        shortLabel: '+$n Schaden',
        shortLabelEn: '+$n damage',
        description: line,
        damageAmount: n,
        replacementScope: isOpponentOnly ? ReplacementScope.opponentOnly : ReplacementScope.all,
      )];
    }

    // "deals N more damage" (statisch, kein when/whenever)
    if (!t.contains('whenever') && !t.contains('when ')) {
      final dealsMoreMatch = RegExp(r'deals? (\d+) more damage', caseSensitive: false).firstMatch(t);
      if (dealsMoreMatch != null) {
        final n = int.tryParse(dealsMoreMatch.group(1) ?? '') ?? 1;
        final isRed = t.contains('red source');
        final isOpponentOnly = !(t.contains('creature') || t.contains('permanent'));
        return [ParsedEffect(
          trigger: TriggerType.staticDamageModifier,
          triggerDetail: isRed ? SourceFilter.redSource.name : SourceFilter.anySource.name,
          shortLabel: '+$n Schaden',
          shortLabelEn: '+$n damage',
          description: line,
          damageAmount: n,
          replacementScope: isOpponentOnly ? ReplacementScope.opponentOnly : ReplacementScope.all,
        )];
      }
    }

    // "deals double damage" / "damage is doubled"
    if (t.contains('deals double damage') || (t.contains('doubled') && t.contains('damage'))) {
      // Einzelner gewählter Spieler (z.B. Sawhorn Nemesis "choose a player")
      final singleChosen = t.contains('choose a player') || t.contains('choose an opponent');
      final target = singleChosen ? DamageTarget.singleOpponent : null;
      // Gilt auch für Permanente/Kreaturen des gewählten Spielers?
      final coversCreatures = t.contains('permanent') || t.contains('creature');
      final shortLabelDe = (singleChosen && coversCreatures)
          ? '×2 Schaden (Spieler + Kreaturen)'
          : '×2 Schaden';
      final shortLabelEn = (singleChosen && coversCreatures)
          ? '×2 damage (player + creatures)'
          : '×2 damage';
      return [ParsedEffect(
        trigger: TriggerType.staticDamageModifier,
        triggerDetail: SourceFilter.anySource.name,
        shortLabel: shortLabelDe,
        shortLabelEn: shortLabelEn,
        description: line,
        damageMultiplier: 2,
        damageTarget: target,
        replacementScope: ReplacementScope.all,
      )];
    }

    // ── ETB (self) ────────────────────────────────────────────────────────────
    // Nur parsen wenn ein konkreter Schadenseffekt erkennbar ist (z.B. Coruscation
    // Mage). Reine Auswahl- oder Setup-Effekte (z.B. Sawhorn Nemesis "choose a
    // player") werden übersprungen — deren laufender Replacement-Effekt wird
    // weiter oben bereits korrekt erkannt.
    if (_isSelfTrigger(t, selfName, 'enters')) {
      final dmg = _extractDamage(t);
      final target = _extractTarget(t);
      if (dmg != null && target != null) {
        return [ParsedEffect(
          trigger: TriggerType.enterBattlefield,
          shortLabel: 'ETB: $dmg ${_targetLabelDe(target)}',
          shortLabelEn: 'ETB: $dmg ${_targetLabelEn(target)}',
          description: line,
          damageAmount: dmg,
          damageTarget: target,
        )];
      }
      return [];
    }

    // ── Dies (self) ───────────────────────────────────────────────────────────
    if (_isSelfTrigger(t, selfName, 'dies')) {
      final dmg = _extractDamage(t);
      final target = _extractTarget(t);
      if (dmg != null && target != null) {
        return [ParsedEffect(
          trigger: TriggerType.dies,
          shortLabel: 'Tod: $dmg ${_targetLabelDe(target)}',
          shortLabelEn: 'Dies: $dmg ${_targetLabelEn(target)}',
          description: line,
          damageAmount: dmg,
          damageTarget: target,
          // BUG FIX: singleTarget nicht für dies-Trigger
        )];
      }
      return [ParsedEffect(trigger: TriggerType.dies, shortLabel: 'Tod', shortLabelEn: 'Dies', description: line)];
    }

    // ── Attacks (self) ────────────────────────────────────────────────────────
    if (_isSelfTrigger(t, selfName, 'attacks')) {
      final dmg = _extractDamage(t);
      final target = _extractTarget(t);
      if (dmg != null && target != null) {
        return [ParsedEffect(
          trigger: TriggerType.attacks,
          shortLabel: 'Angriff: $dmg ${_targetLabelDe(target)}',
          shortLabelEn: 'Attack: $dmg ${_targetLabelEn(target)}',
          description: line,
          damageAmount: dmg,
          damageTarget: target,
        )];
      }
      return [ParsedEffect(trigger: TriggerType.attacks, shortLabel: 'Angriff', shortLabelEn: 'Attack', description: line)];
    }

    // ── Combat damage (self) ──────────────────────────────────────────────────
    if (t.contains('deals combat damage to a player') ||
        t.contains('deals combat damage to an opponent') ||
        t.contains('deals combat damage to a player or planeswalker')) {
      return [ParsedEffect(trigger: TriggerType.dealsCombatDamage, shortLabel: 'Kampfschaden', shortLabelEn: 'Combat damage', description: line)];
    }

    // ── spellResolved: eigener Schadenseffekt ─────────────────────────────────
    // Intentionally last — catches "deals N damage to [target]" as direct spell effect.
    final ownDmgMatch = RegExp(r'deals (\d+) damage to ([^,.]+)', caseSensitive: false).firstMatch(line);
    if (ownDmgMatch != null) {
      final dmg = int.tryParse(ownDmgMatch.group(1) ?? '');
      final targetStr = (ownDmgMatch.group(2) ?? '').toLowerCase();
      final target = _extractTarget(targetStr);
      if (dmg != null && target != null) {
        return [ParsedEffect(
          trigger: TriggerType.spellResolved,
          shortLabel: '$dmg ${_targetLabelDe(target)}',
          shortLabelEn: '$dmg ${_targetLabelEn(target)}',
          description: line,
          damageAmount: dmg,
          damageTarget: target,
          extraConditions: _singleTargetConditions(target),
        )];
      }
    }

    // "deals damage equal to" — dynamischer Schaden
    if (t.contains('deals damage equal to') || t.contains('deal damage equal to')) {
      final target = _extractTarget(t);
      return [ParsedEffect(
        trigger: TriggerType.spellResolved,
        shortLabel: 'Dynamischer Schaden',
        shortLabelEn: 'Dynamic damage',
        description: line,
        damageTarget: target,
        dynamicDamage: true,
      )];
    }

    return [];
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  static ParsedEffect _applyLearnedRule(LearnedRuleEntry rule, String originalLine) {
    // Erste Zahl aus dem Originaltext extrahieren und in Vorlagen einsetzen
    final nStr = RegExp(r'\d+').firstMatch(originalLine)?.group(0);
    final n = nStr != null ? int.tryParse(nStr) : null;
    String applyN(String tmpl) => tmpl.replaceAll('{N}', nStr ?? '?');

    return ParsedEffect(
      trigger: TriggerType.values.byName(rule.trigger),
      triggerDetail: rule.triggerDetail,
      shortLabel: applyN(rule.shortLabelTemplate),
      shortLabelEn: applyN(rule.shortLabelEnTemplate),
      description: originalLine,
      damageAmount: rule.hasDamageAmount ? n : null,
      damageTarget: rule.damageTarget != null ? DamageTarget.values.byName(rule.damageTarget!) : null,
      damageMultiplier: rule.damageMultiplier,
      damageMinimum: rule.damageMinimum,
      replacementScope: rule.replacementScope != null ? ReplacementScope.values.byName(rule.replacementScope!) : null,
      dynamicDamage: rule.dynamicDamage ?? false,
      extraConditions: (rule.extraConditions?.isNotEmpty ?? false)
          ? rule.extraConditions!.split(',').map((c) => EffectCondition.values.byName(c)).toSet()
          : {},
    );
  }

  static ParsedEffect _buildCastSpell(String line, String t, SpellCategory category) {
    final dmg = _extractDamage(t);
    final target = _extractTarget(t);
    if (dmg != null && target != null) {
      return ParsedEffect(
        trigger: TriggerType.castSpell,
        triggerDetail: category.name,
        shortLabel: '+$dmg ${_targetLabelDe(target)}',
        shortLabelEn: '+$dmg ${_targetLabelEn(target)}',
        description: line,
        damageAmount: dmg,
        damageTarget: target,
        extraConditions: _singleTargetConditions(target),
      );
    }
    final isInstant = category == SpellCategory.instantOrSorcery;
    return ParsedEffect(
      trigger: TriggerType.castSpell,
      triggerDetail: category.name,
      shortLabel: isInstant ? 'Instant/Sorcery' : 'Nicht-Kreatur-Spruch',
      shortLabelEn: isInstant ? 'Instant/Sorcery' : 'Noncreature spell',
      description: line,
    );
  }

  static ParsedEffect _buildCastSpellGeneric(String line, String t) {
    final dmg = _extractDamage(t);
    final target = _extractTarget(t);
    if (dmg != null && target != null) {
      return ParsedEffect(
        trigger: TriggerType.castSpell,
        shortLabel: '+$dmg ${_targetLabelDe(target)}',
        shortLabelEn: '+$dmg ${_targetLabelEn(target)}',
        description: line,
        damageAmount: dmg,
        damageTarget: target,
        extraConditions: _singleTargetConditions(target),
      );
    }
    return ParsedEffect(trigger: TriggerType.castSpell, shortLabel: 'Spruch gespielt', shortLabelEn: 'Spell cast', description: line);
  }

  static bool _isSelfTrigger(String t, String selfName, String keyword) {
    if (!t.contains(keyword)) return false;
    if (selfName.isNotEmpty && t.contains(selfName)) return true;
    return t.contains('this creature') || t.contains('this permanent') || t.contains('this card');
  }

  static int? _extractDamage(String text) {
    final m = RegExp(r'deals (\d+) damage', caseSensitive: false).firstMatch(text);
    if (m != null) return int.tryParse(m.group(1) ?? '');
    return null;
  }

  static DamageTarget? _extractTarget(String text) {
    if (text.contains('each opponent')) return DamageTarget.eachOpponent;
    if (text.contains('each player')) return DamageTarget.eachOpponent;
    if (text.contains('target player or planeswalker')) return DamageTarget.singleOpponent;
    if (text.contains('target player')) return DamageTarget.singleOpponent;
    if (text.contains('target opponent')) return DamageTarget.singleOpponent;
    if (text.contains('any target')) return DamageTarget.singleOpponent;
    if (text.contains('target creature or planeswalker')) return DamageTarget.singleCreature;
    if (text.contains('target creature')) return DamageTarget.singleCreature;
    if (text.contains('target permanent')) return DamageTarget.singleCreature;
    if (text.contains('each creature')) return DamageTarget.eachCreature;
    if (text.contains('each permanent')) return DamageTarget.eachCreature;
    if (text.contains('opponent')) return DamageTarget.singleOpponent;
    return null;
  }

  static Set<EffectCondition> _singleTargetConditions(DamageTarget target) {
    if (target == DamageTarget.singleOpponent) return {EffectCondition.singleTarget};
    if (target == DamageTarget.singleCreature) return {EffectCondition.singleCreatureTarget};
    return {};
  }

  static String _targetLabelDe(DamageTarget target) => switch (target) {
    DamageTarget.eachOpponent => 'an jeden Gegner',
    DamageTarget.singleOpponent => 'an Gegner',
    DamageTarget.singleCreature => 'an Kreatur',
    DamageTarget.eachCreature => 'an jede Kreatur',
    DamageTarget.eachOpponentCreatures => 'an Kreaturen',
  };

  static String _targetLabelEn(DamageTarget target) => switch (target) {
    DamageTarget.eachOpponent => 'to each opp.',
    DamageTarget.singleOpponent => 'to opponent',
    DamageTarget.singleCreature => 'to creature',
    DamageTarget.eachCreature => 'to each creature',
    DamageTarget.eachOpponentCreatures => 'to creatures',
  };
}
