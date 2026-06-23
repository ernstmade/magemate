import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import '../../data/import/deck_list_parser.dart';
import '../../l10n/app_localizations.dart';

class NewDeckResult {
  const NewDeckResult({required this.name, this.cards});

  final String name;

  /// Null = leeres Deck (nur Name), non-null = Deck aus Import
  final List<ParsedCard>? cards;
}

class NewDeckDialog extends StatefulWidget {
  const NewDeckDialog({super.key});

  @override
  State<NewDeckDialog> createState() => _NewDeckDialogState();
}

class _NewDeckDialogState extends State<NewDeckDialog> {
  final _nameController = TextEditingController();
  List<ParsedCard>? _importedCards;
  String? _fileName;
  String? _error;
  bool _picking = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    setState(() { _picking = true; _error = null; });
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['txt'],
        withData: true,
      );
      if (result == null || result.files.isEmpty) return;

      final file = result.files.single;
      final content = file.bytes != null
          ? String.fromCharCodes(file.bytes!)
          : await File(file.path!).readAsString();

      final cards = parseDeckList(content);
      if (cards.isEmpty) {
        setState(() => _error = AppL10n.of(context).importEmptyError);
        return;
      }

      final baseName = file.name.replaceAll(RegExp(r'\.txt$'), '');
      setState(() {
        _importedCards = cards;
        _fileName = file.name;
        if (_nameController.text.isEmpty) _nameController.text = baseName;
      });
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() => _picking = false);
    }
  }

  void _submit() {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;
    Navigator.of(context).pop(NewDeckResult(name: name, cards: _importedCards));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);
    final canSubmit = _nameController.text.trim().isNotEmpty;

    return AlertDialog(
      title: Text(l10n.newDeckTitle),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _nameController,
            autofocus: _importedCards == null,
            decoration: InputDecoration(labelText: l10n.newDeckNameHint),
            textCapitalization: TextCapitalization.sentences,
            onChanged: (_) => setState(() {}),
            onSubmitted: (_) { if (canSubmit) _submit(); },
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: _picking ? null : _pickFile,
            icon: _picking
                ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                : const Icon(Icons.file_upload_outlined),
            label: Text(l10n.newDeckImportFile),
          ),
          if (_fileName != null) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.check_circle_outline, color: Colors.green, size: 16),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    l10n.newDeckFileSelected(_fileName!),
                    style: Theme.of(context).textTheme.bodySmall,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
          if (_error != null) ...[
            const SizedBox(height: 8),
            Text(_error!, style: TextStyle(color: Theme.of(context).colorScheme.error, fontSize: 12)),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.actionCancel),
        ),
        FilledButton(
          onPressed: canSubmit ? _submit : null,
          child: Text(l10n.actionCreate),
        ),
      ],
    );
  }
}
