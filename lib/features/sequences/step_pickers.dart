import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../data/corpus/asana_catalogue.dart';
import '../../design_system/tokens.dart';
import '../../design_system/typography.dart';
import '../../l10n/l10n_x.dart';

class AsanaPicker extends StatelessWidget {
  const AsanaPicker({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  final String selected;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final l = context.l;
    final ids = AsanaCatalogue.asanas.map((a) => a.id).toList();

    return _Picker(
      ids: ids,
      selected: selected,
      onChanged: onChanged,
      labels: {
        for (final asana in AsanaCatalogue.asanas)
          asana.id: '${l.asanaName(asana.id)} · ${asana.iast}',
      },
    );
  }
}

class TextPicker extends ConsumerWidget {
  const TextPicker({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  final String selected;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final code = ref.watch(localeCodeProvider(Localizations.localeOf(context)));
    final texts =
        ref.watch(workProvider((workId: 'ys', locale: code))).valueOrNull ??
        const [];

    if (texts.isEmpty) return const SizedBox.shrink();

    return _Picker(
      ids: texts.map((t) => t.text.id).toList(),
      selected: selected,
      onChanged: onChanged,
      labels: {
        for (final item in texts)
          item.text.id: '${item.text.reference} · ${item.translation.body}',
      },
    );
  }
}

class _Picker extends StatelessWidget {
  const _Picker({
    required this.ids,
    required this.labels,
    required this.selected,
    required this.onChanged,
  });

  final List<String> ids;
  final Map<String, String> labels;
  final String selected;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      initialValue: ids.contains(selected) ? selected : ids.first,
      isExpanded: true,
      decoration: const InputDecoration(isDense: true),
      style: AppType.uiBody.copyWith(color: context.colors.ink),
      items: [
        for (final id in ids)
          DropdownMenuItem(
            value: id,
            child: Text(
              labels[id]!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
      ],
      onChanged: (v) => v == null ? null : onChanged(v),
    );
  }
}
