import 'package:flutter/material.dart' show Widget;
import 'package:jio_provider/src/basic_jio_provider.dart' show BasicJioProvider;
import 'package:jio_provider/src/jio_notifier.dart' show JioNotifier;
import 'package:jio_provider/src/jio_provider_builder.dart'
    show JioProviderBuilder;

/// ✅ Helper class to keep type info
/// 🧰 Eager provider (created immediately)
class EagerJioProvider<T extends JioNotifier> implements JioProviderBuilder {
  final T notifier;

  const EagerJioProvider({required this.notifier});

  @override
  Widget build(Widget child) {
    return BasicJioProvider<T>(notifier: notifier, child: child);
  }
}
