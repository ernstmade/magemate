import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/database/app_database.dart';
import '../../data/import/deck_list_parser.dart';
import '../../data/parser/card_text_parser.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/active_deck_provider.dart';
import '../../providers/database_provider.dart';
import '../../providers/deck_providers.dart';
import '../../shared/models/trigger_type.dart';
import '../play/effect_suggestion_screen.dart';

class DeckAnalysisScreen extends ConsumerStatefulWidget {
  const DeckAnalysisScreen({
    super.key,
    required this.deckId,
    required this.deckName,
    this.importedCards = const [],
    this.skipScryfall = false,
  });

  final int deckId;
  final String deckName;
  final List<ParsedCard> importedCards;
  final bool skipScryfall;

  @override
  ConsumerState<DeckAnalysisScreen> createState() => _DeckAnalysisScreenState();
}

enum _Phase { fetching, parsing, done }

class _DeckAnalysisScreenState extends ConsumerState<DeckAnalysisScreen> {
  late _Phase _phase;
  int _fetchDone = 0;
  int _fetchTotal = 0;
  String _currentCard = '';

  // Ergebnis
  int _cardCount = 0;
  int _triggerCount = 0;
  int _continuousCount = 0;
  int _keywordCardCount = 0;
  List<(CardDefinition, ParsedEffect)> _suggestions = [];

  @override
  void initState() {
    super.initState();
    _phase = widget.skipScryfall ? _Phase.parsing : _Phase.fetching;
    WidgetsBinding.instance.addPostFrameCallback((_) => _run());
  }

  Future<void> _run() async {
    final repo = ref.read(deckRepositoryProvider);

    // Phase 1: Scryfall (nur beim ersten Import, nicht bei manuellem Re-Scan)
    if (!widget.skipScryfall) {
      await repo.enrichDeckFromScryfall(
        widget.deckId,
        onProgress: (done, total, cardName) {
          if (!mounted) return;
          setState(() {
            _fetchDone = done;
            _fetchTotal = total;
            _currentCard = cardName;
          });
        },
      );
      if (!mounted) return;
      setState(() => _phase = _Phase.parsing);
    }

    // Phase 2: Parser
    final definitions = await repo.getCardDefinitionsForDeck(widget.deckId);
    final learnedRules = await repo.getAllLearnedRules();
    final suggestions = <(CardDefinition, ParsedEffect)>[];

    for (final def in definitions) {
      if (def.oracleText == null) continue;
      final effects = CardTextParser.parse(
        def.oracleText!,
        cardName: def.name,
        learnedRules: learnedRules,
      );
      // continuousEffect → Review-Liste (mit Duplikat-Schutz, unabhängig von hasEffects)
      for (final e in effects.where((e) => e.trigger == TriggerType.continuousEffect)) {
        final already = await repo.hasContinuousEffectForDescription(def.id, e.description);
        if (!already) suggestions.add((def, e));
      }
      // Alle anderen außer spellResolved → Review-Liste, nur wenn noch keine Effekte.
      // spellResolved (eigener Schadenseffekt) wird nicht persistiert —
      // der Cast-Spell-Screen parst ihn direkt aus dem Oracle-Text.
      if (!await repo.hasEffects(def.id)) {
        for (final e in effects.where((e) =>
            e.trigger != TriggerType.continuousEffect &&
            e.trigger != TriggerType.spellResolved)) {
          suggestions.add((def, e));
        }
      }
    }

    // Zusammenfassung berechnen
    int triggerCount = 0;
    int continuousCount = 0;
    int keywordCardCount = 0;
    for (final def in definitions) {
      final kws = def.keywords?.split(',').map((k) => k.trim()).where((k) => k.isNotEmpty).toList() ?? [];
      if (kws.isNotEmpty) keywordCardCount++;
    }
    final allEffects = await _loadAllEffects(repo, definitions);
    for (final e in allEffects) {
      if (e.trigger == TriggerType.continuousEffect.name) {
        continuousCount++;
      } else {
        triggerCount++;
      }
    }

    if (!mounted) return;
    setState(() {
      _phase = _Phase.done;
      _cardCount = definitions.length;
      _triggerCount = triggerCount + suggestions.where((s) => s.$2.trigger != TriggerType.continuousEffect).length;
      _continuousCount = continuousCount;
      _keywordCardCount = keywordCardCount;
      _suggestions = suggestions;
    });

    // Als aktives Deck setzen
    ref.read(activeDeckProvider.notifier).state = widget.deckId;
  }

  Future<List<CardEffect>> _loadAllEffects(DeckRepository repo, List<CardDefinition> defs) async {
    final db = ref.read(databaseProvider);
    final defIds = defs.map((d) => d.id).toSet();
    final all = await db.select(db.cardEffects).get();
    return all.where((e) => defIds.contains(e.cardDefinitionId)).toList();
  }

  Future<void> _openReview() async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => EffectSuggestionScreen(suggestions: _suggestions),
      ),
    );
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.analysisTitle),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: switch (_phase) {
          _Phase.fetching => _FetchingView(
              done: _fetchDone,
              total: _fetchTotal,
              currentCard: _currentCard,
              l10n: l10n,
              theme: theme,
            ),
          _Phase.parsing => _ParsingView(l10n: l10n, theme: theme),
          _Phase.done => _DoneView(
              deckName: widget.deckName,
              cardCount: _cardCount,
              triggerCount: _triggerCount,
              continuousCount: _continuousCount,
              keywordCardCount: _keywordCardCount,
              suggestions: _suggestions,
              l10n: l10n,
              theme: theme,
              onReview: _openReview,
              onDone: () => Navigator.of(context).pop(),
            ),
        },
      ),
    );
  }
}

// ── Phase-Widgets ─────────────────────────────────────────────────────────────

class _FetchingView extends StatelessWidget {
  const _FetchingView({
    required this.done,
    required this.total,
    required this.currentCard,
    required this.l10n,
    required this.theme,
  });

  final int done;
  final int total;
  final String currentCard;
  final AppL10n l10n;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    final progress = total > 0 ? done / total : null;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Icon(Icons.cloud_download_outlined, size: 48, color: theme.colorScheme.primary),
        const SizedBox(height: 24),
        Text(
          total > 0 ? l10n.analysisFetchingCard(done, total) : l10n.analysisFetchingCard(0, 0),
          textAlign: TextAlign.center,
          style: theme.textTheme.titleMedium,
        ),
        const SizedBox(height: 16),
        LinearProgressIndicator(value: progress),
        if (currentCard.isNotEmpty) ...[
          const SizedBox(height: 12),
          Text(
            currentCard,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ],
    );
  }
}

class _ParsingView extends StatelessWidget {
  const _ParsingView({required this.l10n, required this.theme});

  final AppL10n l10n;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Icon(Icons.auto_fix_high, size: 48, color: theme.colorScheme.primary),
        const SizedBox(height: 24),
        Text(l10n.analysisParsing, textAlign: TextAlign.center, style: theme.textTheme.titleMedium),
        const SizedBox(height: 16),
        const LinearProgressIndicator(),
      ],
    );
  }
}

class _DoneView extends StatelessWidget {
  const _DoneView({
    required this.deckName,
    required this.cardCount,
    required this.triggerCount,
    required this.continuousCount,
    required this.keywordCardCount,
    required this.suggestions,
    required this.l10n,
    required this.theme,
    required this.onReview,
    required this.onDone,
  });

  final String deckName;
  final int cardCount;
  final int triggerCount;
  final int continuousCount;
  final int keywordCardCount;
  final List<(CardDefinition, ParsedEffect)> suggestions;
  final AppL10n l10n;
  final ThemeData theme;
  final VoidCallback onReview;
  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Spacer(),
        Icon(Icons.check_circle_outline, size: 56, color: theme.colorScheme.primary),
        const SizedBox(height: 16),
        Text(
          l10n.analysisDoneTitle,
          textAlign: TextAlign.center,
          style: theme.textTheme.headlineSmall,
        ),
        const SizedBox(height: 8),
        Text(
          deckName,
          textAlign: TextAlign.center,
          style: theme.textTheme.titleMedium?.copyWith(color: theme.colorScheme.primary),
        ),
        const SizedBox(height: 32),
        _SummaryRow(icon: Icons.style_outlined, label: l10n.analysisSummaryCards(cardCount)),
        const SizedBox(height: 8),
        _SummaryRow(icon: Icons.flash_on_outlined, label: l10n.analysisSummaryTriggers(triggerCount)),
        const SizedBox(height: 8),
        _SummaryRow(icon: Icons.all_inclusive, label: l10n.analysisSummaryContinuous(continuousCount)),
        const SizedBox(height: 8),
        _SummaryRow(icon: Icons.local_offer_outlined, label: l10n.analysisSummaryKeywords(keywordCardCount)),
        const Spacer(),
        if (suggestions.isNotEmpty) ...[
          FilledButton.icon(
            onPressed: onReview,
            icon: const Icon(Icons.checklist),
            label: Text(l10n.analysisReviewButton(suggestions.length)),
          ),
          const SizedBox(height: 10),
        ],
        OutlinedButton(
          onPressed: onDone,
          child: Text(l10n.analysisDoneButton),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 12),
        Text(label, style: Theme.of(context).textTheme.bodyLarge),
      ],
    );
  }
}
