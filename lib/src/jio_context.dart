// class MyWidget extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     // Watch the provider (throws if not in tree)
//     final notifier = context.watch<MyNotifier>();
//
//     // Or access only if already created
//     final maybeNotifier = context.maybeWatch<MyNotifier>();
//
//     return Text('Value: ${notifier.value}');
//   }
// }

import 'package:flutter/material.dart' show BuildContext;
import 'package:jio_provider/jio_provider.dart' show LazyJioUniversalProvider;
import 'package:jio_provider/src/basic_jio_provider.dart' show BasicJioProvider;
import 'package:jio_provider/src/jio_notifier.dart' show JioNotifier;

/// 🔧 BuildContext extension methods for easier usage
extension JioContext on BuildContext {
  /// 🪄 Watch for changes — rebuilds when notifyListeners() is called
  T watch<T extends JioNotifier>() =>
      BasicJioProvider.of<T>(this, listen: true);

  /// Synchronous access to the notifier (throws if not found)
  T? fenixWatch<T extends JioNotifier>() {
    return LazyJioUniversalProvider.of<T>(this);
  }

  /// Synchronous access to the notifier if already created, else null
  T? maybeWatch<T extends JioNotifier>() {
    final provider = dependOnInheritedWidgetOfExactType<BasicJioProvider<T>>();
    return provider?.notifier;
  }

  /// 🪄 Read without rebuild — useful for methods or callbacks
  /// Does not rebuild (for actions, callbacks, etc.)
  T read<T extends JioNotifier>() =>
      BasicJioProvider.of<T>(this, listen: false);
}
