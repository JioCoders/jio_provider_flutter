import 'package:flutter/material.dart'
    show StatelessWidget, BuildContext, Widget;
import 'package:jio_provider/src/jio_provider_builder.dart'
    show JioProviderBuilder;

/// 🧰 A container that holds multiple providers — cleaner than nesting many `JioProvider`s.
class MultiJioProvider extends StatelessWidget {
  final List<JioProviderBuilder> providers;
  final Widget child;

  const MultiJioProvider({
    super.key,
    required this.providers,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    Widget tree = child;

    // Wrap providers in reverse order — so the first one appears at the top
    for (final p in providers.reversed) {
      tree = p.build(tree);
    }

    return tree;
  }
}
