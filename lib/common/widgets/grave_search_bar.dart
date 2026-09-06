import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

import "../../app/l10n/app_localizations.dart";
import "../../app/theme/app_theme.dart";
import "../providers/search_query_provider.dart";

class GraveSearchBar extends HookConsumerWidget {
  const GraveSearchBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useTextEditingController();
    final query = ref.watch(searchQueryProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Material(
        elevation: 4,
        borderRadius: BorderRadius.circular(28),
        color: context.colorScheme.surface,
        child: TextField(
          controller: controller,
          onChanged: (value) => ref.read(searchQueryProvider.notifier).setQuery(value),
          style: context.textTheme.bodyLarge,
          decoration: InputDecoration(
            hintText: AppLocalizations.of(context)!.search_graves_hint,
            prefixIcon: const Icon(Icons.search),
            suffixIcon: query.isEmpty
                ? null
                : IconButton(
                    icon: const Icon(Icons.clear),
                    tooltip: AppLocalizations.of(context)!.clear_search,
                    onPressed: () {
                      controller.clear();
                      ref.read(searchQueryProvider.notifier).clear();
                    },
                  ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(28), borderSide: BorderSide.none),
            filled: true,
            fillColor: context.colorScheme.surface,
          ),
        ),
      ),
    );
  }
}
