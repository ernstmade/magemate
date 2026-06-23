import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/database/app_database.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/active_deck_provider.dart';
import '../../providers/deck_providers.dart';
import '../../shared/models/trigger_style.dart';
import '../../shared/models/trigger_type.dart';
import '../../shared/widgets/trigger_effect_section.dart';
import '../play/play_screen.dart' show LocaleToggleButton;

/// Nur passive statische Keyword-Fähigkeiten sind als "Status" relevant.
/// Triggered Abilities (Landfall, Offspring, Transform, Fight, …),
/// aktivierte Fähigkeiten und Kosten-Modifier werden ausgeblendet.
const _passiveKeywords = {
  'flying', 'reach', 'trample', 'lifelink', 'deathtouch',
  'first strike', 'double strike', 'vigilance', 'haste', 'menace',
  'indestructible', 'hexproof', 'shroud', 'flash',
  'wither', 'infect', 'persist', 'undying', 'defender',
  'protection', 'ward', 'skulk', 'shadow', 'fear', 'intimidate',
  'cascade', 'riot', 'convoke', 'affinity',
};

const _keywordDe = <String, String>{
  'flying':        'Fliegend',
  'reach':         'Reichweite',
  'trample':       'Trampeln',
  'lifelink':      'Lebensband',
  'deathtouch':    'Todesberührung',
  'first strike':  'Erststrike',
  'double strike': 'Doppelstrike',
  'vigilance':     'Wachsamkeit',
  'haste':         'Eile',
  'menace':        'Bedrohung',
  'indestructible':'Unzerstörbar',
  'hexproof':      'Hexensicherheit',
  'shroud':        'Schutzmantel',
  'flash':         'Blitz',
  'wither':        'Hinsiechen',
  'infect':        'Ansteckung',
  'persist':       'Weiterleben',
  'undying':       'Untod',
  'defender':      'Verteidiger',
  'protection':    'Schutz',
  'ward':          'Hut',
  'skulk':         'Schleichen',
  'shadow':        'Schatten',
  'fear':          'Furcht',
  'intimidate':    'Einschüchterung',
  'cascade':       'Kaskade',
  'riot':          'Randale',
  'convoke':       'Einberufung',
  'affinity':      'Affinität',
};

String _localizeKeyword(String kw, {required bool isDe}) =>
    isDe ? (_keywordDe[kw.toLowerCase()] ?? kw) : kw;

enum _ViewMode { byCard, byEffect }

class StatusScreen extends ConsumerStatefulWidget {
  const StatusScreen({super.key});

  @override
  ConsumerState<StatusScreen> createState() => _StatusScreenState();
}

class _StatusScreenState extends ConsumerState<StatusScreen> {
  _ViewMode _mode = _ViewMode.byCard;

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);
    final activeDeckId = ref.watch(activeDeckProvider);
    final continuousAsync = activeDeckId != null
        ? ref.watch(activeContinuousEffectsProvider(activeDeckId))
        : const AsyncData(<(CardDefinition, CardEffect)>[]);
    final keywordsAsync = activeDeckId != null
        ? ref.watch(activeCardKeywordsProvider(activeDeckId))
        : const AsyncData(<(CardDefinition, List<String>)>[]);
    final attachmentsAsync = activeDeckId != null
        ? ref.watch(attachmentsWithDefsProvider(activeDeckId))
        : const AsyncData(<int, CardDefinition>{});

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.statusTitle),
        actions: [
          IconButton(
            icon: Icon(
              _mode == _ViewMode.byCard ? Icons.format_list_bulleted : Icons.label_outline,
              color: Theme.of(context).colorScheme.primary,
            ),
            tooltip: _mode == _ViewMode.byCard ? 'Gruppieren nach Effekt' : 'Gruppieren nach Karte',
            onPressed: () => setState(() {
              _mode = _mode == _ViewMode.byCard ? _ViewMode.byEffect : _ViewMode.byCard;
            }),
          ),
          const LocaleToggleButton(),
        ],
      ),
      body: continuousAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (continuousEffects) => keywordsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Error: $e')),
          data: (rawKeywords) => attachmentsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Error: $e')),
            data: (attachmentsByEquipmentId) {
              final cardKeywords = rawKeywords
                  .map((e) => (
                        e.$1,
                        e.$2.where((k) => _passiveKeywords.contains(k.toLowerCase())).toList(),
                      ))
                  .where((e) => e.$2.isNotEmpty)
                  .toList();

              if (continuousEffects.isEmpty && cardKeywords.isEmpty) {
                return Center(child: Text(l10n.statusEmpty));
              }

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: _mode == _ViewMode.byCard
                    ? _ByCardView(
                        continuousEffects: continuousEffects,
                        cardKeywords: cardKeywords,
                        attachmentsByEquipmentId: attachmentsByEquipmentId,
                        l10n: l10n,
                      )
                    : _ByEffectView(
                        continuousEffects: continuousEffects,
                        cardKeywords: cardKeywords,
                        attachmentsByEquipmentId: attachmentsByEquipmentId,
                        l10n: l10n,
                      ),
              );
            },
          ),
        ),
      ),
    );
  }
}

// ── Ansicht: Karte → Effekte ──────────────────────────────────────────────────

class _ByCardView extends StatelessWidget {
  const _ByCardView({
    required this.continuousEffects,
    required this.cardKeywords,
    required this.attachmentsByEquipmentId,
    required this.l10n,
  });

  final List<(CardDefinition, CardEffect)> continuousEffects;
  final List<(CardDefinition, List<String>)> cardKeywords;
  final Map<int, CardDefinition> attachmentsByEquipmentId;
  final AppL10n l10n;

  @override
  Widget build(BuildContext context) {
    final isDe = Localizations.localeOf(context).languageCode == 'de';

    // Split CEs: active vs. unattached equipment
    final activeCEs = continuousEffects
        .where((e) =>
            e.$2.ceScope != 'oneTarget' ||
            attachmentsByEquipmentId.containsKey(e.$1.id))
        .toList();
    final unattachedCEs = continuousEffects
        .where((e) =>
            e.$2.ceScope == 'oneTarget' &&
            !attachmentsByEquipmentId.containsKey(e.$1.id))
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (activeCEs.isNotEmpty)
          TriggerEffectSection(
            title: l10n.statusContinuousEffects,
            trigger: TriggerType.continuousEffect,
            entries: activeCEs,
            showCount: true,
          ),
        if (unattachedCEs.isNotEmpty) ...[
          if (activeCEs.isNotEmpty) const SizedBox(height: 8),
          _UnattachedEquipmentSection(
              effects: unattachedCEs, isDe: isDe, l10n: l10n),
        ],
        if (cardKeywords.isNotEmpty) ...[
          if (activeCEs.isNotEmpty || unattachedCEs.isNotEmpty)
            const Divider(height: 32),
          _KeywordsByCardSection(title: l10n.statusKeywords, cards: cardKeywords),
        ],
      ],
    );
  }
}

// ── Ansicht: Effekt → Karten ──────────────────────────────────────────────────

class _ByEffectView extends StatelessWidget {
  const _ByEffectView({
    required this.continuousEffects,
    required this.cardKeywords,
    required this.attachmentsByEquipmentId,
    required this.l10n,
  });

  final List<(CardDefinition, CardEffect)> continuousEffects;
  final List<(CardDefinition, List<String>)> cardKeywords;
  final Map<int, CardDefinition> attachmentsByEquipmentId;
  final AppL10n l10n;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDe = Localizations.localeOf(context).languageCode == 'de';

    // Split CEs: active vs. unattached equipment
    final activeCEs = continuousEffects
        .where((e) =>
            e.$2.ceScope != 'oneTarget' ||
            attachmentsByEquipmentId.containsKey(e.$1.id))
        .toList();
    final unattachedCEs = continuousEffects
        .where((e) =>
            e.$2.ceScope == 'oneTarget' &&
            !attachmentsByEquipmentId.containsKey(e.$1.id))
        .toList();

    // Continuous effects: nach Label gruppieren (nur aktive)
    final effectGroups = <String, List<CardDefinition>>{};
    for (final (def, effect) in activeCEs) {
      final label = isDe
          ? (effect.shortLabel.isNotEmpty ? effect.shortLabel : (effect.shortLabelEn ?? effect.trigger))
          : (effect.shortLabelEn?.isNotEmpty == true ? effect.shortLabelEn! : (effect.shortLabel.isNotEmpty ? effect.shortLabel : effect.trigger));
      effectGroups.putIfAbsent(label, () => []).add(def);
    }

    // Keywords: nach lokalisiertem Keyword gruppieren
    final keywordGroups = <String, List<CardDefinition>>{};
    for (final (def, kws) in cardKeywords) {
      for (final kw in kws) {
        final label = _localizeKeyword(kw, isDe: isDe);
        keywordGroups.putIfAbsent(label, () => []).add(def);
      }
    }

    final style = triggerStyle(TriggerType.continuousEffect);
    final hasBoth = (effectGroups.isNotEmpty || unattachedCEs.isNotEmpty) &&
        keywordGroups.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (effectGroups.isNotEmpty) ...[
          Row(
            children: [
              Icon(style.icon, color: style.color),
              const SizedBox(width: 8),
              Text(
                '${l10n.statusContinuousEffects} (${effectGroups.length})',
                style: theme.textTheme.titleMedium,
              ),
            ],
          ),
          const SizedBox(height: 8),
          for (final entry in effectGroups.entries)
            _EffectGroupTile(label: entry.key, defs: entry.value, isDe: isDe),
        ],
        if (unattachedCEs.isNotEmpty) ...[
          if (effectGroups.isNotEmpty) const SizedBox(height: 8),
          _UnattachedEquipmentSection(
              effects: unattachedCEs, isDe: isDe, l10n: l10n),
        ],
        if (hasBoth) const Divider(height: 32),
        if (keywordGroups.isNotEmpty) ...[
          Row(
            children: [
              const Icon(Icons.local_offer_outlined, color: Colors.teal),
              const SizedBox(width: 8),
              Text(
                '${l10n.statusKeywords} (${keywordGroups.length})',
                style: theme.textTheme.titleMedium,
              ),
            ],
          ),
          const SizedBox(height: 8),
          for (final entry in keywordGroups.entries)
            _EffectGroupTile(label: entry.key, defs: entry.value, isDe: isDe),
        ],
      ],
    );
  }
}

class _EffectGroupTile extends StatelessWidget {
  const _EffectGroupTile({required this.label, required this.defs, required this.isDe});

  final String label;
  final List<CardDefinition> defs;
  final bool isDe;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 3),
          Wrap(
            spacing: 6,
            runSpacing: 4,
            children: [
              for (final def in defs)
                Chip(
                  label: Text(
                    isDe ? (def.printedName ?? def.name) : def.name,
                    style: theme.textTheme.labelSmall,
                  ),
                  padding: EdgeInsets.zero,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  visualDensity: VisualDensity.compact,
                  side: const BorderSide(color: Colors.teal),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Nicht angelegt (Equipment ohne Zielkarte) ─────────────────────────────────

class _UnattachedEquipmentSection extends StatelessWidget {
  const _UnattachedEquipmentSection({
    required this.effects,
    required this.isDe,
    required this.l10n,
  });

  final List<(CardDefinition, CardEffect)> effects;
  final bool isDe;
  final AppL10n l10n;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Opacity(
      opacity: 0.5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.link_off, size: 20, color: theme.colorScheme.outline),
              const SizedBox(width: 8),
              Text(
                l10n.equipmentNotAttached,
                style: theme.textTheme.titleSmall?.copyWith(
                  color: theme.colorScheme.outline,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          for (final (def, effect) in effects)
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                children: [
                  const Icon(Icons.link_off, size: 14),
                  const SizedBox(width: 6),
                  Text(
                    isDe ? (def.printedName ?? def.name) : def.name,
                    style: theme.textTheme.bodySmall,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '– ${effect.shortLabel.isNotEmpty ? effect.shortLabel : (effect.shortLabelEn ?? '')}',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

// ── Keywords nach Karte (byCard-Modus) ───────────────────────────────────────

class _KeywordsByCardSection extends StatelessWidget {
  const _KeywordsByCardSection({required this.title, required this.cards});

  final String title;
  final List<(CardDefinition, List<String>)> cards;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDe = Localizations.localeOf(context).languageCode == 'de';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.local_offer_outlined, color: Colors.teal),
            const SizedBox(width: 8),
            Text('$title (${cards.length})', style: theme.textTheme.titleMedium),
          ],
        ),
        const SizedBox(height: 8),
        for (final (def, kws) in cards)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isDe ? (def.printedName ?? def.name) : def.name,
                  style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: [
                    for (final kw in kws)
                      Chip(
                        label: Text(
                          _localizeKeyword(kw, isDe: isDe),
                          style: theme.textTheme.labelSmall,
                        ),
                        padding: EdgeInsets.zero,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        visualDensity: VisualDensity.compact,
                        side: const BorderSide(color: Colors.teal),
                      ),
                  ],
                ),
              ],
            ),
          ),
      ],
    );
  }
}
