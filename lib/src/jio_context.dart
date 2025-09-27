import 'package:flutter/material.dart' show BuildContext;
import 'package:jio_provider/basic_jio_provider.dart' show BasicJioProvider;
import 'package:jio_provider/jio_notifier.dart' show JioNotifier;

/// 🔧 Extension methods for easier usage
extension JioContext on BuildContext {
  /// 🪄 Watch for changes — rebuilds when notifyListeners() is called
  T jioWatch<T extends JioNotifier>() =>
      BasicJioProvider.of<T>(this, listen: true);

  /// 🪄 Read without rebuild — useful for methods or callbacks
  /// Does not rebuild (for actions, callbacks, etc.)
  T jioRead<T extends JioNotifier>() =>
      BasicJioProvider.of<T>(this, listen: false);
}
