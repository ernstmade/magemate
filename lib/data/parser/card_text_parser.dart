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
    this.triggerConditionText,
    this.damageAmount,
    this.damageTarget,
    this.damageMultiplier,
    this.damageMinimum,
    this.replacementScope,
    this.dynamicDamage = false,
    this.extraConditions = const {},
    this.effectDetail,
    this.effectExtraConditions = const {},
    this.modeGroupId,
  });

  final TriggerType trigger;
  final String? triggerDetail;
  /// Zusatzbedingung auf dem TRIGGER (z.B. "if you control a creature with
  /// power 7 or greater"). Teil von WANN — nicht was der Effekt tut.
  final String? triggerConditionText;
  final String shortLabel;
  final String shortLabelEn;
  final String description;
  final int? damageAmount;
  final DamageTarget? damageTarget;
  final int? damageMultiplier;
  final int? damageMinimum;
  final ReplacementScope? replacementScope;
  final bool dynamicDamage;
  final Set<TriggerCondition> extraConditions;
  /// Freitext-Einschränkung auf den EFFEKT (z.B. "only flying creatures").
  final String? effectDetail;
  /// Strukturierte Einschränkungen auf den EFFEKT (z.B. onlyIfYourTurn).
  final Set<EffectCondition> effectExtraConditions;
  /// Nicht-null wenn dieser Effekt Teil einer "Choose one"-Auswahl ist.
  /// Alle Effekte mit gleicher groupId sind exklusiv (nur einer feuert).
  final int? modeGroupId;

  ParsedEffect withModeGroupId(int id) => ParsedEffect(
    trigger: trigger,
    shortLabel: shortLabel,
    shortLabelEn: shortLabelEn,
    description: description,
    triggerDetail: triggerDetail,
    triggerConditionText: triggerConditionText,
    damageAmount: damageAmount,
    damageTarget: damageTarget,
    damageMultiplier: damageMultiplier,
    damageMinimum: damageMinimum,
    replacementScope: replacementScope,
    dynamicDamage: dynamicDamage,
    extraConditions: extraConditions,
    effectDetail: effectDetail,
    effectExtraConditions: effectExtraConditions,
    modeGroupId: id,
  );
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

    // Erkennt "Choose one —" und markiert Effekte in dieser Gruppe mit
    // derselben modeGroupId, damit die UI exklusive Modi anzeigen kann.
    // "Choose two/three" werden NICHT gruppiert — dort können mehrere Modi
    // gleichzeitig gelten (z.B. Fiery Confluence).
    int? currentGroupId;
    int nextGroupId = 0;

    for (final rawLine in oracleText.split('\n')) {
      final line = rawLine.trim();
      if (line.isEmpty) continue;
      final t = line.toLowerCase();

      // "Choose one —" → neue Gruppe starten
      if (RegExp(r'^choose one\b').hasMatch(t)) {
        currentGroupId = nextGroupId++;
        continue;
      }
      // Bullet-Zeilen ("•") gehören zur aktuellen Gruppe;
      // jede andere Zeile beendet die Gruppe.
      if (currentGroupId != null && !line.startsWith('•')) {
        currentGroupId = null;
      }

      final parsed = _parseLine(line, selfName: selfName, learnedByPattern: byPattern);
      final gid = currentGroupId;
      if (gid != null) {
        results.addAll(parsed.map((e) => e.withModeGroupId(gid)));
      } else {
        results.addAll(parsed);
      }
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
    // Aktivierte Fähigkeiten überspringen: Zeile beginnt mit Kosten ({T}, {2}{R}, …)
    // gefolgt von einem Doppelpunkt. Das sind keine Trigger, sondern bezahlbare
    // Aktionen (z.B. Shivan Gorge "{2}{R}, {T}: deals 1 damage to each opponent").
    if (RegExp(r'^\{[^}]+\}').hasMatch(line.trim())) return [];

    // Gelernte Regel hat Vorrang vor eingebauten Regex-Regeln
    final normalized = normalize(line, selfName: selfName);
    final learned = learnedByPattern[normalized];
    if (learned != null) return [_applyLearnedRule(learned, line)];

    final t = line.toLowerCase();

    // ── Phase triggers ────────────────────────────────────────────────────────
    if (t.contains('at the beginning of your upkeep')) {
      final lbl = _effectLabelFromLine(line);
      return [ParsedEffect(trigger: TriggerType.upkeep, shortLabel: lbl?.de ?? '', shortLabelEn: lbl?.en ?? '', description: line)];
    }
    if (t.contains('at the beginning of your end step') || t.contains('at the beginning of each end step')) {
      final lbl = _effectLabelFromLine(line);
      return [ParsedEffect(trigger: TriggerType.endStep, shortLabel: lbl?.de ?? '', shortLabelEn: lbl?.en ?? '', description: line)];
    }

    // ── Landfall ─────────────────────────────────────────────────────────────
    if (t.startsWith('landfall') || (t.contains('whenever a land enters') && t.contains('under your control'))) {
      final dmg = _extractDamage(t);
      final target = _extractTarget(t);
      if (dmg != null && target != null) {
        return [ParsedEffect(
          trigger: TriggerType.landfall,
          shortLabel: '$dmg ${_targetLabelDe(target)}',
          shortLabelEn: '$dmg ${_targetLabelEn(target)}',
          description: line,
          damageAmount: dmg,
          damageTarget: target,
        )];
      }
      final lbl = _effectLabelFromLine(line);
      return [ParsedEffect(trigger: TriggerType.landfall, shortLabel: lbl?.de ?? '', shortLabelEn: lbl?.en ?? '', description: line)];
    }

    // ── Card draw ────────────────────────────────────────────────────────────
    if (t.contains('whenever you draw a card') || t.contains('whenever a player draws a card')) {
      final lbl = _effectLabelFromLine(line);
      return [ParsedEffect(trigger: TriggerType.cardDrawn, shortLabel: lbl?.de ?? '', shortLabelEn: lbl?.en ?? '', description: line)];
    }

    // ── Life gain ────────────────────────────────────────────────────────────
    if (t.contains('whenever you gain life') || t.contains('whenever you gain one or more life')) {
      final lbl = _effectLabelFromLine(line);
      return [ParsedEffect(trigger: TriggerType.lifeGain, shortLabel: lbl?.de ?? '', shortLabelEn: lbl?.en ?? '', description: line)];
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
    // Breites Regex: erlaubt Extra-Text zwischen "spell you control" und "deals damage"
    // (z.B. Imodane: "...spell you control that targets only a single creature deals damage...")
    if (RegExp(r'whenever (?:an? )?(?:instant or sorcery |)spell you control\b.*\bdeals damage\b', caseSensitive: false).hasMatch(t) ||
        (t.contains('whenever a source you control deals damage') && t.contains('creature'))) {
      final isInstantSorcery = t.contains('instant or sorcery spell');
      final isSingleCreature = t.contains('only a single creature') || t.contains('targets only a single creature');
      // "deals damage to an opponent" — Schaden muss an einen Gegner (Spieler) gehen,
      // nicht an Kreaturen (z.B. Satyr Firedancer, Chandra's Incinerator follow-up)
      final toOpponent = t.contains('deals damage to an opponent') || t.contains('deals damage to target opponent');
      final lbl = _effectLabelFromLine(line);
      final conditions = <TriggerCondition>{
        if (isSingleCreature) TriggerCondition.singleCreatureTarget,
        if (toOpponent) TriggerCondition.damageToOpponent,
      };
      return [ParsedEffect(
        trigger: TriggerType.spellDealsDamage,
        triggerDetail: isInstantSorcery ? SpellCategory.instantOrSorcery.name : null,
        extraConditions: conditions,
        shortLabel: lbl?.de ?? '',
        shortLabelEn: lbl?.en ?? '',
        description: line,
      )];
    }

    // ── dealsNoncombatDamage ─────────────────────────────────────────────────
    if (t.contains('whenever you deal noncombat damage') ||
        (t.contains('whenever') && t.contains('deals noncombat damage'))) {
      final isRed = t.contains('red source');
      final toOpponent = t.contains('to an opponent') || t.contains('to target opponent');
      final lbl = _effectLabelFromLine(line);
      return [ParsedEffect(
        trigger: TriggerType.dealsNoncombatDamage,
        triggerDetail: isRed ? SourceFilter.redSource.name : SourceFilter.anySource.name,
        shortLabel: lbl?.de ?? '',
        shortLabelEn: lbl?.en ?? '',
        description: line,
        extraConditions: toOpponent ? {TriggerCondition.damageToOpponent} : {},
      )];
    }

    // ── staticDamageModifier (replacement effects) ────────────────────────────

    // "minimum damage equal to power" — z.B. Ojer Axonil
    // "...would deal an amount of noncombat damage less than [card]'s power to an opponent,
    //  that source deals damage equal to [card]'s power instead."
    if (t.contains('less than') && t.contains("'s power") && t.contains('instead') &&
        (t.contains('to an opponent') || t.contains('to each opponent'))) {
      final isRed = t.contains('red source');
      return [ParsedEffect(
        trigger: TriggerType.staticDamageModifier,
        triggerDetail: isRed ? SourceFilter.redSource.name : SourceFilter.anySource.name,
        shortLabel: 'Min. Schaden = Stärke',
        shortLabelEn: 'Min. damage = power',
        description: line,
        dynamicDamage: true,
        replacementScope: ReplacementScope.opponentOnly,
      )];
    }

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

    // "deals double damage" / "deals double that damage" (Sawhorn) / "damage is doubled"
    if (t.contains('deals double damage') || t.contains('deals double that damage') ||
        (t.contains('doubled') && t.contains('damage'))) {
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

    // ── continuousEffect (dauerhafte, statische Fähigkeiten) ──────────────────
    // Erkennungsmerkmale: Satz gibt Kreaturen/Permanenten eine dauerhafte
    // Eigenschaft oder einen Bonus, OHNE ein auslösendes Ereignis.
    // Muster: "creatures you control have/get ...", "X get +N/+N",
    //          "each creature gets ...", "permanents ... have ..."
    {
      final continuousPatterns = [
        RegExp(r'\bcreatures you control (have|get)\b', caseSensitive: false),
        RegExp(r'\byour creatures (have|get)\b', caseSensitive: false),
        RegExp(r'\beach creature (you control )?(gets?|has)\b', caseSensitive: false),
        RegExp(r'\b(dragons?|goblins?|elves?|wizards?|humans?|soldiers?|warriors?|vampires?|merfolk|spirits?|angels?|demons?|beasts?|elementals?) (you control )?(get|have|gets?|has)\b', caseSensitive: false),
        RegExp(r'\b(other creatures|all creatures) (you control )?(have|get)\b', caseSensitive: false),
        RegExp(r'\bpermanents? you control (have|get)\b', caseSensitive: false),
      ];
      // Kostenreduktion für Sprüche (z.B. Longshot "cost {1} less")
      final costReductionMatch = RegExp(
        r'(noncreature spells?|instants?(?: or sorceries?)?|sorceries|spells?) you cast cost \{?(\d+|[xX])\}? less',
        caseSensitive: false,
      ).firstMatch(t);
      if (costReductionMatch != null) {
        final raw = costReductionMatch.group(1)!.toLowerCase();
        final amount = costReductionMatch.group(2) ?? '1';
        final (typeDe, typeEn) = raw.contains('noncreature')
            ? ('Nicht-Kreatur-Sprüche', 'Noncreature spells')
            : raw.contains('instant')
                ? ('Spontanzauber/Hexereien', 'Instants/sorceries')
                : ('Sprüche', 'Spells');
        return [ParsedEffect(
          trigger: TriggerType.continuousEffect,
          shortLabel: '$typeDe kosten {$amount} weniger',
          shortLabelEn: '$typeEn cost {$amount} less',
          description: line,
        )];
      }

      if (continuousPatterns.any((p) => p.hasMatch(t))) {
        final dmg = _extractDamage(t);
        final hasTrample = t.contains('trample');
        final hasFlying  = t.contains('flying');
        final hasVigilance = t.contains('vigilance');
        final hasHaste  = t.contains('haste');
        final hasLifelink = t.contains('lifelink');
        final hasIndestructible = t.contains('indestructible');
        // Build a compact label from detected bonuses
        final parts = <String>[];
        if (dmg != null) parts.add('+$dmg/+$dmg');
        if (hasTrample)   parts.add('Trample');
        if (hasFlying)    parts.add('Flying');
        if (hasVigilance) parts.add('Vigilance');
        if (hasHaste)     parts.add('Haste');
        if (hasLifelink)  parts.add('Lifelink');
        if (hasIndestructible) parts.add('Indestructible');
        final label = parts.isNotEmpty ? parts.join(', ') : 'Dauerhafter Bonus';
        final labelEn = parts.isNotEmpty ? parts.join(', ') : 'Continuous bonus';
        return [ParsedEffect(
          trigger: TriggerType.continuousEffect,
          shortLabel: label,
          shortLabelEn: labelEn,
          description: line,
        )];
      }
    }

    // ── ETB (self) ────────────────────────────────────────────────────────────
    if (_isSelfTrigger(t, selfName, 'enters')) {
      final dmg = _extractDamage(t);
      final target = _extractTarget(t);
      if (dmg != null && target != null) {
        return [ParsedEffect(
          trigger: TriggerType.enterBattlefield,
          shortLabel: '$dmg ${_targetLabelDe(target)}',
          shortLabelEn: '$dmg ${_targetLabelEn(target)}',
          description: line,
          damageAmount: dmg,
          damageTarget: target,
        )];
      }
      // Versuche einen bekannten Nicht-Schaden-Effekt zu extrahieren; reine
      // Setup-Effekte (z.B. "choose a player") ergeben null → überspringen.
      final etbEffect = _effectLabelFromLine(line);
      if (etbEffect != null) {
        return [ParsedEffect(
          trigger: TriggerType.enterBattlefield,
          shortLabel: etbEffect.de,
          shortLabelEn: etbEffect.en,
          description: line,
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
          shortLabel: '$dmg ${_targetLabelDe(target)}',
          shortLabelEn: '$dmg ${_targetLabelEn(target)}',
          description: line,
          damageAmount: dmg,
          damageTarget: target,
        )];
      }
      final diesEffect = _effectLabelFromLine(line);
      final deLbl = diesEffect?.de ?? '';
      final enLbl = diesEffect?.en ?? '';
      return [ParsedEffect(trigger: TriggerType.dies, shortLabel: deLbl, shortLabelEn: enLbl, description: line)];
    }

    // ── Attacks (self) ────────────────────────────────────────────────────────
    if (_isSelfTrigger(t, selfName, 'attacks')) {
      final dmg = _extractDamage(t);
      final target = _extractTarget(t);
      if (dmg != null && target != null) {
        return [ParsedEffect(
          trigger: TriggerType.attacks,
          shortLabel: '$dmg ${_targetLabelDe(target)}',
          shortLabelEn: '$dmg ${_targetLabelEn(target)}',
          description: line,
          damageAmount: dmg,
          damageTarget: target,
        )];
      }
      final attacksEffect = _effectLabelFromLine(line);
      final deLbl = attacksEffect?.de ?? '';
      final enLbl = attacksEffect?.en ?? '';
      // Flashback-Gewährung: Einschränkung auf Kartentyp und Kosten erfassen.
      // z.B. Backdraft Hellkite: "each instant and sorcery card ... gains flashback ... mana cost"
      String? effectDetail;
      if (t.contains('flashback')) {
        final parts = <String>[];
        if (t.contains('instant and sorcery') || t.contains('instant or sorcery')) parts.add('Instant/Sorcery');
        if (t.contains('mana cost')) parts.add('Flashback Cost = Mana Cost');
        if (parts.isNotEmpty) effectDetail = parts.join('; ');
      }
      return [ParsedEffect(trigger: TriggerType.attacks, shortLabel: deLbl, shortLabelEn: enLbl, description: line, effectDetail: effectDetail)];
    }

    // ── Combat damage (self) ──────────────────────────────────────────────────
    if (t.contains('deals combat damage to a player') ||
        t.contains('deals combat damage to an opponent') ||
        t.contains('deals combat damage to a player or planeswalker')) {
      final lbl = _effectLabelFromLine(line);
      return [ParsedEffect(trigger: TriggerType.dealsCombatDamage, shortLabel: lbl?.de ?? '', shortLabelEn: lbl?.en ?? '', description: line)];
    }

    // ── spellResolved: eigener Schadenseffekt ─────────────────────────────────
    // Eigene Effekte beim Ausspielen einer Karte sind im Trigger→Effekt-Modell
    // dieser App grundsätzlich nicht vorgesehen — der Cast-Spell-Screen behandelt
    // ausgespielte Karten, keine Trigger-Reaktionen. Einzige Ausnahme: der
    // Schadensrechner braucht den Schadenswert, damit andere Karten (Guttersnipe,
    // Satyr Firedancer …) ihren Folgeschaden berechnen können. Deshalb werden hier
    // nur Schadenszeilen erfasst. Nicht-Schaden-Modi von "Wähle eins"-Karten
    // (z.B. Abrades "Artefakt zerstören") werden bewusst ignoriert.
    final ownDmgMatch = RegExp(r'deals (\d+) damage to ([^,.]+)', caseSensitive: false).firstMatch(line);
    if (ownDmgMatch != null) {
      final dmg = int.tryParse(ownDmgMatch.group(1) ?? '');
      final targetStr = (ownDmgMatch.group(2) ?? '').toLowerCase();
      // Karte trifft gleichzeitig jede Kreatur UND jeden Gegner (z.B. Tectonic Hazard)
      if (dmg != null && targetStr.contains('each creature') &&
          (targetStr.contains('each opponent') || targetStr.contains('each player'))) {
        return [
          ParsedEffect(
            trigger: TriggerType.spellResolved,
            shortLabel: '$dmg ${_targetLabelDe(DamageTarget.eachCreature)}',
            shortLabelEn: '$dmg ${_targetLabelEn(DamageTarget.eachCreature)}',
            description: line,
            damageAmount: dmg,
            damageTarget: DamageTarget.eachCreature,
          ),
          ParsedEffect(
            trigger: TriggerType.spellResolved,
            shortLabel: '$dmg ${_targetLabelDe(DamageTarget.eachOpponent)}',
            shortLabelEn: '$dmg ${_targetLabelEn(DamageTarget.eachOpponent)}',
            description: line,
            damageAmount: dmg,
            damageTarget: DamageTarget.eachOpponent,
          ),
        ];
      }
      final target = _extractTarget(targetStr);
      if (dmg != null && target != null) {
        return [ParsedEffect(
          trigger: TriggerType.spellResolved,
          shortLabel: '$dmg ${_targetLabelDe(target)}',
          shortLabelEn: '$dmg ${_targetLabelEn(target)}',
          description: line,
          damageAmount: dmg,
          damageTarget: target,
        )];
      }
    }

    // "deals damage equal to" — dynamischer Schaden (nur wenn kein Replacement-Effekt,
    // d.h. kein "instead" am Ende — sonst wäre es ein staticDamageModifier wie Ojer Axonil)
    if ((t.contains('deals damage equal to') || t.contains('deal damage equal to')) &&
        !t.contains('instead')) {
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

    // ── Nicht-Schaden-Effekte für bereits erkannte Trigger ────────────────────
    // Wenn bis hierhin ein Trigger erkannt wurde (line enthält bekannte Trigger-
    // Schlüsselwörter), versuchen wir den Effekt-Teil zu extrahieren und zu
    // klassifizieren. So bekommen auch Draw/Token/etc.-Effekte sinnvolle Labels.
    final hasTriggerKeyword =
        t.contains('whenever') || t.contains('when ') ||
        t.contains('at the beginning') || t.contains('at the end');

    if (hasTriggerKeyword) {
      final parts = extractEffectParts(line);
      if (parts.effect != null) {
        final effectLabel = parseEffectClause(parts.effect!);
        final (labelDe, labelEn) = effectLabel != null
            ? (effectLabel.de, effectLabel.en)
            : ('? – ${parts.effect!.length > 50 ? '${parts.effect!.substring(0, 50)}…' : parts.effect!}',
               '? – ${parts.effect!.length > 50 ? '${parts.effect!.substring(0, 50)}…' : parts.effect!}');

        // Trigger-Typ aus bekannten Mustern ableiten
        final trigger = _inferTrigger(t);
        if (trigger != null) {
          return [ParsedEffect(
            trigger: trigger,
            shortLabel: labelDe,
            shortLabelEn: labelEn,
            description: line,
            triggerConditionText: parts.condition,
          )];
        }
      }
    }

    return [];
  }

  /// Leitet den TriggerType aus bekannten Schlüsselwörtern ab.
  /// Nur für Fälle wo die spezifischeren Checks oben nicht gegriffen haben.
  static TriggerType? _inferTrigger(String t) {
    if (t.contains('whenever') || t.contains('when ')) {
      if (t.contains('attacks')) return TriggerType.attacks;
      if (t.contains('blocks')) return TriggerType.blocks;
      if (t.contains('dies') || t.contains('is put into a graveyard')) return TriggerType.dies;
      if (t.contains('deals combat damage')) return TriggerType.dealsCombatDamage;
      if (t.contains('takes damage') || t.contains('is dealt damage')) return TriggerType.takesDamage;
      if (t.contains('cast')) return TriggerType.castSpell;
      if (t.contains('enters')) return TriggerType.enterBattlefield;
      if (t.contains('leaves')) return TriggerType.leaveBattlefield;
      if (t.contains('draw')) return TriggerType.cardDrawn;
      if (t.contains('gain life') || t.contains('gains life')) return TriggerType.lifeGain;
      if (t.contains('lose life') || t.contains('loses life') || t.contains('lost life')) return TriggerType.lifeLoss;
      if (t.contains('discard')) return TriggerType.discard;
      if (t.contains('land')) return TriggerType.landfall;
    }
    if (t.contains('at the beginning')) {
      if (t.contains('combat')) return TriggerType.beginningOfCombat;
      if (t.contains('upkeep')) return TriggerType.upkeep;
      if (t.contains('draw')) return TriggerType.draw;
      if (t.contains('end step') || t.contains('end of turn')) return TriggerType.endStep;
    }
    if (t.contains('at the end')) {
      if (t.contains('end step') || t.contains('end of turn') || t.contains('your turn')) {
        return TriggerType.endStep;
      }
    }
    return null;
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
          ? rule.extraConditions!.split(',').map((c) => TriggerCondition.values.byName(c)).toSet()
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
        shortLabel: '$dmg ${_targetLabelDe(target)}',
        shortLabelEn: '$dmg ${_targetLabelEn(target)}',
        description: line,
        damageAmount: dmg,
        damageTarget: target,
        extraConditions: _singleTargetConditions(target),
      );
    }
    // Kein fester Schaden — prüfen ob variabler Schaden (z.B. Satyr Firedancer: "deals
    // damage equal to that spell's converted mana cost"). Ziel extrahieren für das Label.
    if (t.contains('deals damage equal to') && !t.contains('instead')) {
      final dynTarget = _extractTarget(t);
      return ParsedEffect(
        trigger: TriggerType.castSpell,
        triggerDetail: category.name,
        shortLabel: dynTarget != null ? _targetLabelDe(dynTarget) : 'Schaden (variabel)',
        shortLabelEn: dynTarget != null ? _targetLabelEn(dynTarget) : 'Damage (variable)',
        description: line,
        damageTarget: dynTarget,
      );
    }
    // Kein Schaden — Effekt-Klausel extrahieren. triggerDetail zeigt
    // die Kategorie bereits separat, daher kein Präfix im shortLabel.
    final effectLabel = _effectLabelFromLine(line);
    return ParsedEffect(
      trigger: TriggerType.castSpell,
      triggerDetail: category.name,
      shortLabel: effectLabel?.de ?? '',
      shortLabelEn: effectLabel?.en ?? '',
      description: line,
    );
  }

  static ParsedEffect _buildCastSpellGeneric(String line, String t) {
    final dmg = _extractDamage(t);
    final target = _extractTarget(t);
    if (dmg != null && target != null) {
      return ParsedEffect(
        trigger: TriggerType.castSpell,
        shortLabel: '$dmg ${_targetLabelDe(target)}',
        shortLabelEn: '$dmg ${_targetLabelEn(target)}',
        description: line,
        damageAmount: dmg,
        damageTarget: target,
        extraConditions: _singleTargetConditions(target),
      );
    }
    final effectLabel = _effectLabelFromLine(line);
    return ParsedEffect(
      trigger: TriggerType.castSpell,
      shortLabel: effectLabel != null ? 'Spruch: ${effectLabel.de}' : '',
      shortLabelEn: effectLabel != null ? 'Spell: ${effectLabel.en}' : '',
      description: line,
    );
  }

  /// Extrahiert den Effekt-Teil eines Trigger-Satzes und liefert ein bekanntes
  /// (de, en)-Label via [parseEffectClause], oder null wenn unbekannt.
  static ({String de, String en})? _effectLabelFromLine(String line) {
    final parts = extractEffectParts(line);
    if (parts.effect == null) return null;
    return parseEffectClause(parts.effect!);
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
    if (text.contains('any target')) return DamageTarget.anyTarget;
    if (text.contains('target creature or planeswalker')) return DamageTarget.singleCreature;
    if (text.contains('target creature')) return DamageTarget.singleCreature;
    if (text.contains('target permanent')) return DamageTarget.singleCreature;
    if (text.contains('each creature')) return DamageTarget.eachCreature;
    if (text.contains('each permanent')) return DamageTarget.eachCreature;
    if (text.contains('opponent')) return DamageTarget.singleOpponent;
    return null;
  }

  static Set<TriggerCondition> _singleTargetConditions(DamageTarget target) {
    if (target == DamageTarget.singleOpponent) return {TriggerCondition.singleTarget};
    if (target == DamageTarget.singleCreature) return {TriggerCondition.singleCreatureTarget};
    return {};
  }

  static String _targetLabelDe(DamageTarget target) => switch (target) {
    DamageTarget.eachOpponent => 'Schaden an jeden Gegner',
    DamageTarget.singleOpponent => 'Schaden an Gegner',
    DamageTarget.singleCreature => 'Schaden an Kreatur',
    DamageTarget.eachCreature => 'Schaden an jede Kreatur',
    DamageTarget.eachOpponentCreatures => 'Schaden an Kreaturen',
    DamageTarget.anyTarget => 'Schaden an beliebiges Ziel',
  };

  static String _targetLabelEn(DamageTarget target) => switch (target) {
    DamageTarget.eachOpponent => 'damage to each opp.',
    DamageTarget.singleOpponent => 'damage to opponent',
    DamageTarget.singleCreature => 'damage to creature',
    DamageTarget.eachCreature => 'damage to each creature',
    DamageTarget.eachOpponentCreatures => 'damage to creatures',
    DamageTarget.anyTarget => 'damage to any target',
  };

  // ── Effekt-Extraktion ──────────────────────────────────────────────────────

  /// Zerlegt einen Triggered-Ability-Satz in drei Teile:
  /// - Trigger-Bedingung (bekannt, z.B. "whenever you cast...") → wird ignoriert
  /// - Optionale Zusatzbedingung ("if ..., ")
  /// - Effekt-Clause (der Rest)
  ///
  /// Gibt `(triggerCondition, effectClause)` zurück.
  /// `triggerCondition` ist null wenn keine "if..."-Klausel gefunden wurde.
  static ({String? condition, String? effect}) extractEffectParts(String oracleText) {
    final t = oracleText.trim();

    // Schritt 1: Trigger-Prefix entfernen ("whenever X, " / "when X, " / "at ... ,")
    final triggerStripped = RegExp(
      r'^(?:whenever|when|at the beginning of|at the end of|at the start of)[^,]+,\s*',
      caseSensitive: false,
    ).firstMatch(t);
    final afterTrigger = triggerStripped != null
        ? t.substring(triggerStripped.end).trim()
        : null;

    if (afterTrigger == null) return (condition: null, effect: null);

    // Schritt 2: "if ..., " Zusatzbedingung herausziehen
    final condMatch = RegExp(
      r'^(if [^,]+),\s*(.+)',
      caseSensitive: false,
      dotAll: true,
    ).firstMatch(afterTrigger);

    if (condMatch != null) {
      return (
        condition: condMatch.group(1)!.trim(),
        effect: condMatch.group(2)!.trim(),
      );
    }

    return (condition: null, effect: afterTrigger);
  }

  /// Erkennt bekannte nicht-Schaden-Effekte und gibt (labelDe, labelEn) zurück.
  /// Gibt null zurück wenn der Effekt unbekannt ist.
  static ({String de, String en})? parseEffectClause(String effectClause) {
    final t = effectClause.toLowerCase();

    // Karten ziehen — Ziffern und Zahlenwörter (one/two/three/four/five)
    final drawN = RegExp(r'draw (\d+) cards?').firstMatch(t);
    if (drawN != null) {
      final n = drawN.group(1)!;
      return (de: '$n Karte(n) ziehen', en: 'Draw $n card(s)');
    }
    if (t.contains('draw a card') || t.contains('draw one card')) return (de: '1 Karte ziehen', en: 'Draw 1 card');
    if (t.contains('draw two cards')) return (de: '2 Karten ziehen', en: 'Draw 2 cards');
    if (t.contains('draw three cards')) return (de: '3 Karten ziehen', en: 'Draw 3 cards');
    if (t.contains('draw four cards')) return (de: '4 Karten ziehen', en: 'Draw 4 cards');
    if (t.contains('draw five cards')) return (de: '5 Karten ziehen', en: 'Draw 5 cards');

    // Token erstellen
    final tokenCopy = RegExp(r"create .{0,40} copy of").firstMatch(t);
    if (tokenCopy != null) return (de: 'Token erstellen (Kopie)', en: 'Create token (copy)');
    if (t.contains('create') && t.contains('token')) {
      return (de: 'Token erstellen', en: 'Create token');
    }

    // +1/+1-Marken
    final counterN = RegExp(r'put (\d+) \+1/\+1 counter').firstMatch(t);
    if (counterN != null) {
      final n = counterN.group(1)!;
      return (de: '$n×+1/+1 Marke(n)', en: '$n×+1/+1 counter(s)');
    }
    if (t.contains('put a +1/+1 counter') || t.contains('+1/+1 counter on')) {
      return (de: '+1/+1 Marke', en: '+1/+1 counter');
    }

    // Leben gewinnen / verlieren
    final gainLife = RegExp(r'gain (\d+) life').firstMatch(t);
    if (gainLife != null) return (de: '+${gainLife.group(1)} Leben', en: '+${gainLife.group(1)} life');
    final loseLife = RegExp(r'lose (\d+) life').firstMatch(t);
    if (loseLife != null) return (de: '-${loseLife.group(1)} Leben', en: '-${loseLife.group(1)} life');

    // Exilieren / Zerstören
    if (t.contains('exile')) return (de: 'Exilieren', en: 'Exile');
    if (t.contains('destroy')) return (de: 'Zerstören', en: 'Destroy');

    // Kopieren
    if (t.contains('copy') && (t.contains('spell') || t.contains('ability'))) {
      return (de: 'Kopieren', en: 'Copy');
    }

    // Bibliothek
    if (t.contains('search your library')) return (de: 'Bibliothek durchsuchen', en: 'Search library');
    if (t.contains('look at the top')) return (de: 'Bibliothek ansehen', en: 'Look at library');

    // Zähler / Marken anderer Art
    if (t.contains('counter on') || t.contains('counters on')) {
      return (de: 'Marke setzen', en: 'Put counter');
    }

    // Dynamischer Schaden ("deals that much damage to [target]")
    if (t.contains('deals that much damage') || t.contains('deal that much damage')) {
      if (t.contains('each opponent') || t.contains('all opponents')) {
        return (de: 'Gleicher Schaden an alle Gegner', en: 'Same damage to each opponent');
      }
      if (t.contains('target opponent') || t.contains('an opponent')) {
        return (de: 'Gleicher Schaden an Gegner', en: 'Same damage to opponent');
      }
      if (t.contains('creature') && t.contains('planeswalker')) {
        return (de: 'Gleicher Schaden an Kreatur/PW', en: 'Same damage to creature/PW');
      }
      if (t.contains('creature')) {
        return (de: 'Gleicher Schaden an Kreatur', en: 'Same damage to creature');
      }
      if (t.contains('planeswalker')) {
        return (de: 'Gleicher Schaden an Planeswalker', en: 'Same damage to planeswalker');
      }
      return (de: 'Gleicher Schaden', en: 'Same damage');
    }

    // Flashback-Gewährung (z.B. Backdraft Hellkite)
    if (t.contains('flashback')) return (de: 'Flashback gewähren', en: 'Gain flashback');

    // Enttappen / Tappen (nur "tap target" um false positives wie "tapped" zu vermeiden)
    if (t.contains('untap')) return (de: 'Enttappen', en: 'Untap');
    if (RegExp(r'\btap target\b|\btap each\b|\btap all\b').hasMatch(t)) return (de: 'Tappen', en: 'Tap');

    // Kämpfen
    if (RegExp(r'\bfights?\b').hasMatch(t)) return (de: 'Kampf', en: 'Fight');

    // Transformieren (vor "return to battlefield" prüfen, da "tapped and transformed" beides enthält)
    if (t.contains('transform')) return (de: 'Transformieren', en: 'Transform');

    // Zurückbringen
    if (t.contains('return') && (t.contains('to your hand') || t.contains('to the battlefield'))) {
      return (de: 'Zurückbringen', en: 'Return');
    }

    // Scrying / Lookin
    if (t.contains('scry')) {
      final n = RegExp(r'scry (\d+)').firstMatch(t)?.group(1) ?? '1';
      return (de: 'Scry $n', en: 'Scry $n');
    }

    // Anlegen / Equip (z.B. Ardenn "attach any number of Auras and Equipment")
    if (t.contains('attach') || t.contains('equip')) {
      return (de: 'Anlegen', en: 'Attach/Equip');
    }

    // Temporärer Stat-Boost "gets +N/+N until end of turn"
    final statBoostMatch = RegExp(r'gets? \+(\d+)/[+\-−](\d+)').firstMatch(t);
    if (statBoostMatch != null) {
      final p = statBoostMatch.group(1)!;
      final q = statBoostMatch.group(2)!;
      return (de: '+$p/+$q (bis EOT)', en: '+$p/+$q (until EOT)');
    }

    // Mana erzeugen "add {R}" / "add {G}{G}"
    if (t.contains('add {') || RegExp(r'\badd \{').hasMatch(t)) {
      return (de: 'Mana erzeugen', en: 'Add mana');
    }

    // Opfern als Effekt "sacrifice a creature / permanent"
    if (RegExp(r'\bsacrifice\b').hasMatch(t) && !t.contains('you may sacrifice')) {
      return (de: 'Opfern', en: 'Sacrifice');
    }
    if (t.contains('you may sacrifice')) {
      return (de: 'Opfern (optional)', en: 'Sacrifice (optional)');
    }

    // Abwerfen als Effekt "discard a card" / "discard your hand"
    if (RegExp(r'\bdiscard\b').hasMatch(t)) {
      if (t.contains('hand')) return (de: 'Hand abwerfen', en: 'Discard hand');
      final discardN = RegExp(r'discard (\d+)').firstMatch(t);
      if (discardN != null) return (de: '${discardN.group(1)} Karte(n) abwerfen', en: 'Discard ${discardN.group(1)} card(s)');
      return (de: 'Karte abwerfen', en: 'Discard a card');
    }

    // Ins Spiel bringen "put ... onto the battlefield"
    if (t.contains('onto the battlefield')) {
      return (de: 'Ins Spiel bringen', en: 'Put onto battlefield');
    }

    // Temporäre Keywords "gains flying/deathtouch/... until end of turn"
    if (t.contains('until end of turn') || t.contains('until your next turn')) {
      final keywords = <String>[];
      if (t.contains('flying')) keywords.add('Flying');
      if (t.contains('deathtouch')) keywords.add('Deathtouch');
      if (t.contains('hexproof')) keywords.add('Hexproof');
      if (t.contains('indestructible')) keywords.add('Indestructible');
      if (t.contains('lifelink')) keywords.add('Lifelink');
      if (t.contains('trample')) keywords.add('Trample');
      if (t.contains('haste')) keywords.add('Haste');
      if (t.contains('first strike')) keywords.add('First Strike');
      if (t.contains('double strike')) keywords.add('Double Strike');
      if (keywords.isNotEmpty) {
        return (de: '${keywords.join(', ')} (bis EOT)', en: '${keywords.join(', ')} (until EOT)');
      }
    }

    return null;
  }
}
