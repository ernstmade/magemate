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

class TriggersScreen extends ConsumerWidget {
  const TriggersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppL10n.of(context);
    final activeDeckId = ref.watch(activeDeckProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.triggersTitle),
        actions: const [LocaleToggleButton()],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.triggersHint),
            const SizedBox(height: 8),
            Expanded(
              child: activeDeckId == null
                  ? Center(child: Text(l10n.noActiveTriggers))
                  : ref.watch(activeTriggerEffectsProvider(activeDeckId)).when(
                      data: (effectsByTrigger) {
                        final activeTriggers = TriggerType.values
                            .where((t) => effectsByTrigger[t]?.isNotEmpty ?? false)
                            .toList();
                        if (activeTriggers.isEmpty) {
                          return Center(child: Text(l10n.noActiveTriggers));
                        }
                        return _TriggerSections(
                          activeTriggers: activeTriggers,
                          effectsByTrigger: effectsByTrigger,
                        );
                      },
                      error: (e, _) => Center(child: Text('Error: $e')),
                      loading: () => const Center(child: CircularProgressIndicator()),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TriggerSections extends StatefulWidget {
  const _TriggerSections({
    required this.activeTriggers,
    required this.effectsByTrigger,
  });

  final List<TriggerType> activeTriggers;
  final Map<TriggerType, List<(CardDefinition, CardEffect)>> effectsByTrigger;

  @override
  State<_TriggerSections> createState() => _TriggerSectionsState();
}

class _TriggerSectionsState extends State<_TriggerSections> {
  final _scrollController = ScrollController();

  /// Ein Key pro Trigger-Klasse als unsichtbarer Scroll-Anker.
  final _groupKeys = <String, GlobalKey>{};

  GlobalKey _keyForGroup(TriggerGroupDef group) =>
      _groupKeys.putIfAbsent(group.label, () => GlobalKey());

  void _scrollToGroup(TriggerGroupDef group) {
    final ctx = _keyForGroup(group).currentContext;
    if (ctx == null) return;
    Scrollable.ensureVisible(
      ctx,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final activeSet = widget.activeTriggers.toSet();
    final theme = Theme.of(context);

    // Nur Klassen mit mind. einem aktiven Trigger, in fester Reihenfolge
    final activeGroups = triggerGroupDefs
        .where((g) => g.triggers.any(activeSet.contains))
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Navigations-Chips (eine Klasse = ein Chip) ──────────────────────
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final group in activeGroups)
              ActionChip(
                avatar: Icon(group.icon, color: group.color, size: 18),
                label: Text(group.label),
                onPressed: () => _scrollToGroup(group),
              ),
          ],
        ),
        const SizedBox(height: 8),

        // ── Scrollbarer Inhalt ───────────────────────────────────────────────
        Expanded(
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (int i = 0; i < activeGroups.length; i++) ...[
                  // Unsichtbarer Anker ganz oben in der Gruppe
                  SizedBox(key: _keyForGroup(activeGroups[i]), height: 0),

                  // Ab Gruppe 2: Trennstrich davor
                  if (i > 0) ...[
                    const Divider(thickness: 1, height: 1),
                    const SizedBox(height: 10),
                  ],
                  // Klassenüberschrift immer anzeigen
                  Text(
                    activeGroups[i].label.toUpperCase(),
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: activeGroups[i].color,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Einzelne Trigger-Abschnitte innerhalb der Klasse
                  for (final trigger
                      in activeGroups[i].triggers.where(activeSet.contains))
                    TriggerEffectSection(
                      title: triggerTypeLabel(trigger, isDe: Localizations.localeOf(context).languageCode == 'de'),
                      trigger: trigger,
                      entries: widget.effectsByTrigger[trigger] ?? const [],
                      highlighted: trigger == TriggerType.staticDamageModifier,
                      showCount: true,
                    ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}
