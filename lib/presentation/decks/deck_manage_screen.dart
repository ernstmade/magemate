import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/deck_providers.dart';
import '../play/card_info_sheet.dart';
import 'deck_analysis_screen.dart';

enum _MenuAction { syncScryfall, analyseEffects, resetEffects }

class DeckManageScreen extends ConsumerStatefulWidget {
  const DeckManageScreen({
    super.key,
    required this.deckId,
    required this.deckName,
  });

  final int deckId;
  final String deckName;

  @override
  ConsumerState<DeckManageScreen> createState() => _DeckManageScreenState();
}

class _DeckManageScreenState extends ConsumerState<DeckManageScreen> {
  bool _syncing = false;
  String? _syncStatus;

  final _scrollController = ScrollController();
  final _mainKey = GlobalKey();
  final _sideKey = GlobalKey();

  void _scrollTo(GlobalKey key) {
    final ctx = key.currentContext;
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

  Future<void> _syncMissing() async {
    setState(() {
      _syncing = true;
      _syncStatus = null;
    });
    try {
      final count = await ref.read(deckRepositoryProvider).enrichDeckFromScryfall(
        widget.deckId,
        onlyMissing: true,
        onProgress: (done, total, name) {
          if (mounted) setState(() => _syncStatus = '$name ($done/$total)');
        },
      );
      if (mounted) {
        setState(() {
          _syncing = false;
          _syncStatus = null;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$count Karten aktualisiert')),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _syncing = false;
          _syncStatus = null;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Fehler: $e')),
        );
      }
    }
  }

  void _openAnalysis() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => DeckAnalysisScreen(
          deckId: widget.deckId,
          deckName: widget.deckName,
          skipScryfall: true,
        ),
      ),
    );
  }

  Future<void> _resetEffects() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Effekte zurücksetzen'),
        content: const Text(
          'Alle erfassten Effekte für dieses Deck werden gelöscht. '
          'Anschließend wird die Analyse neu gestartet.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Abbrechen'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Zurücksetzen'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    await ref.read(deckRepositoryProvider).clearEffectsForDeck(widget.deckId);
    if (!mounted) return;
    _openAnalysis();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);
    final theme = Theme.of(context);
    final grouped = ref.watch(groupedCardsForDeckProvider(widget.deckId));

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.deckName),
        actions: [
          if (_syncing)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            )
          else
            PopupMenuButton<_MenuAction>(
              onSelected: (action) {
                switch (action) {
                  case _MenuAction.syncScryfall:
                    _syncMissing();
                  case _MenuAction.analyseEffects:
                    _openAnalysis();
                  case _MenuAction.resetEffects:
                    _resetEffects();
                }
              },
              itemBuilder: (_) => [
                PopupMenuItem(
                  value: _MenuAction.syncScryfall,
                  child: ListTile(
                    leading: const Icon(Icons.cloud_sync),
                    title: Text(l10n.scryfallSyncTooltip),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                PopupMenuItem(
                  value: _MenuAction.analyseEffects,
                  child: ListTile(
                    leading: const Icon(Icons.auto_fix_high),
                    title: Text(l10n.analyseEffectsTooltip),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                const PopupMenuDivider(),
                PopupMenuItem(
                  value: _MenuAction.resetEffects,
                  child: ListTile(
                    leading: const Icon(Icons.delete_sweep_outlined),
                    title: const Text('Effekte zurücksetzen'),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
        ],
      ),
      body: grouped.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (groups) {
          final main = groups.where((g) => g.board == 'main').toList()
            ..sort((a, b) => a.definition.name.compareTo(b.definition.name));
          final side = groups.where((g) => g.board == 'side').toList()
            ..sort((a, b) => a.definition.name.compareTo(b.definition.name));

          if (groups.isEmpty) return Center(child: Text(l10n.cardsEmpty));

          return Column(
            children: [
              // ── Ankernavigation ─────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
                child: Wrap(
                  spacing: 8,
                  children: [
                    ActionChip(
                      avatar: Icon(Icons.home, size: 18, color: theme.colorScheme.primary),
                      label: Text(l10n.boardMain),
                      onPressed: () => _scrollTo(_mainKey),
                    ),
                    if (side.isNotEmpty)
                      ActionChip(
                        avatar: Icon(Symbols.garage_home, size: 18, color: theme.colorScheme.primary),
                        label: Text(l10n.boardSide),
                        onPressed: () => _scrollTo(_sideKey),
                      ),
                  ],
                ),
              ),

              // ── Sync-Fortschrittsanzeige ────────────────────────────────────
              if (_syncing && _syncStatus != null) ...[
                LinearProgressIndicator(
                  backgroundColor: theme.colorScheme.surfaceContainerHighest,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: Text(_syncStatus!, style: theme.textTheme.bodySmall),
                ),
              ],

              // ── Kartenliste ─────────────────────────────────────────────────
              Expanded(
                child: ListView(
                  controller: _scrollController,
                  children: [
                    SizedBox(key: _mainKey, height: 0),
                    _BoardSection(
                      count: main.fold(0, (s, g) => s + g.total),
                      groups: main,
                      targetBoard: 'side',
                    ),
                    if (side.isNotEmpty) ...[
                      const Divider(height: 1),
                      SizedBox(key: _sideKey, height: 0),
                      _BoardSection(
                        count: side.fold(0, (s, g) => s + g.total),
                        groups: side,
                        targetBoard: 'main',
                      ),
                    ],
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _BoardSection extends ConsumerWidget {
  const _BoardSection({
    required this.count,
    required this.groups,
    required this.targetBoard,
  });

  final int count;
  final List<DeckCardGroup> groups;

  // 'side' → aktueller Abschnitt ist Mainboard; 'main' → Sideboard
  final String targetBoard;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppL10n.of(context);
    final repo = ref.read(deckRepositoryProvider);
    final isDe = Localizations.localeOf(context).languageCode == 'de';

    final isMainSection = targetBoard == 'side';
    final sectionIcon = isMainSection ? Icons.home : Symbols.garage_home;
    final moveIcon = isMainSection
        ? Icons.vertical_align_bottom
        : Icons.vertical_align_top;
    final sectionLabel = isMainSection ? l10n.boardMain : l10n.boardSide;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Row(
            children: [
              Icon(sectionIcon, size: 20, color: theme.colorScheme.primary),
              const SizedBox(width: 8),
              Text(
                '$sectionLabel ($count)',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
        for (final group in groups)
          ListTile(
            dense: true,
            onTap: () => showCardInfoSheet(context, group.definition),
            leading: Text(
              '${group.total}×',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            title: Text(
              isDe
                  ? (group.definition.printedName ?? group.definition.name)
                  : group.definition.name,
            ),
            subtitle: group.definition.typeLine != null
                ? Text(
                    isDe
                        ? (group.definition.printedTypeLine ?? group.definition.typeLine!)
                        : group.definition.typeLine!,
                    style: theme.textTheme.bodySmall,
                  )
                : null,
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _EffectStatusIcon(cardDefinitionId: group.definition.id),
                const SizedBox(width: 2),
                _ScryfallStatusIcon(group: group),
                IconButton(
                  icon: Icon(moveIcon, size: 20),
                  onPressed: () => repo.moveGroupToBoard(group, targetBoard),
                ),
              ],
            ),
          ),
        const SizedBox(height: 8),
      ],
    );
  }
}

class _EffectStatusIcon extends ConsumerWidget {
  const _EffectStatusIcon({required this.cardDefinitionId});

  final int cardDefinitionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppL10n.of(context);
    final effects = ref.watch(effectsForCardDefinitionProvider(cardDefinitionId));

    return effects.when(
      loading: () => const SizedBox(width: 18),
      error: (e, st) => const SizedBox(width: 18),
      data: (list) {
        if (list.isEmpty) {
          return Tooltip(
            message: l10n.effectsNotParsed,
            child: Icon(
              Icons.bolt,
              size: 18,
              color: Theme.of(context).colorScheme.outlineVariant,
            ),
          );
        }
        return Tooltip(
          message: l10n.effectsParsed(list.length),
          child: const Icon(Icons.bolt, size: 18, color: Colors.amber),
        );
      },
    );
  }
}

class _ScryfallStatusIcon extends StatelessWidget {
  const _ScryfallStatusIcon({required this.group});

  final DeckCardGroup group;

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);
    final def = group.definition;

    if (def.setCode == null || def.collectorNumber == null) {
      return Tooltip(
        message: l10n.scryfallNoSetInfo,
        child: Icon(
          Icons.cloud_off,
          size: 18,
          color: Theme.of(context).colorScheme.outlineVariant,
        ),
      );
    }

    if (def.scryfallId != null) {
      return Tooltip(
        message: l10n.scryfallSynced,
        child: const Icon(Icons.cloud_done, size: 18, color: Colors.teal),
      );
    }

    return Tooltip(
      message: l10n.scryfallMissing,
      child: Icon(Icons.cloud_queue, size: 18, color: Colors.amber.shade700),
    );
  }
}
