import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/database/app_database.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/deck_providers.dart';
import '../../shared/models/trigger_style.dart';
import '../../shared/models/trigger_type.dart';
import '../play/effect_tile.dart';

class TriggersScreen extends ConsumerWidget {
  const TriggersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppL10n.of(context);
    final activeEffects = ref.watch(activeTriggerEffectsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.triggersTitle)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.triggersHint),
            const SizedBox(height: 8),
            Expanded(
              child: activeEffects.when(
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
  final _sectionKeys = <TriggerType, GlobalKey>{};

  GlobalKey _keyFor(TriggerType trigger) {
    return _sectionKeys.putIfAbsent(trigger, () => GlobalKey());
  }

  void _scrollTo(TriggerType trigger) {
    final context = _keyFor(trigger).currentContext;
    if (context == null) return;
    Scrollable.ensureVisible(
      context,
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final trigger in widget.activeTriggers)
              ActionChip(
                avatar: Icon(
                  triggerStyle(trigger).icon,
                  color: triggerStyle(trigger).color,
                  size: 18,
                ),
                label: Text(trigger.name),
                onPressed: () => _scrollTo(trigger),
              ),
          ],
        ),
        const SizedBox(height: 8),
        Expanded(
          child: ListView(
            controller: _scrollController,
            children: [
              for (final trigger in widget.activeTriggers)
                _TriggerSection(
                  key: _keyFor(trigger),
                  trigger: trigger,
                  entries: widget.effectsByTrigger[trigger] ?? const [],
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TriggerSection extends StatelessWidget {
  const _TriggerSection({
    super.key,
    required this.trigger,
    required this.entries,
  });

  final TriggerType trigger;
  final List<(CardDefinition, CardEffect)> entries;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                triggerStyle(trigger).icon,
                color: triggerStyle(trigger).color,
              ),
              const SizedBox(width: 8),
              Text(
                trigger.name,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
          for (final (definition, effect) in entries)
            EffectTile(effect: effect, cardName: definition.name),
        ],
      ),
    );
  }
}
