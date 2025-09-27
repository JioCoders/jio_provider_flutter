import 'package:flutter/widgets.dart'
    show BuildContext, FlutterError, InheritedNotifier;
import 'package:jio_provider/src/jio_notifier.dart' show JioNotifier;

/// 🪄 Custom Provider that holds a JioNotifier and notifies listeners
class BasicJioProvider<T extends JioNotifier> extends InheritedNotifier<T> {
  const BasicJioProvider({
    super.key,
    required T notifier, // ✅ must be provided, not nullable
    required super.child,
  }) : super(notifier: notifier);

  /// Access the provider from context
  static T of<T extends JioNotifier>(
    BuildContext context, {
    bool listen = true,
  }) {
    final provider = listen
        ? context.dependOnInheritedWidgetOfExactType<BasicJioProvider<T>>()
        : context
                  .getElementForInheritedWidgetOfExactType<
                    BasicJioProvider<T>
                  >()
                  ?.widget
              as BasicJioProvider<T>?;

    if (provider == null) {
      throw FlutterError(
        'No JioProvider<$T> found in context.\n'
        'Make sure you wrap your widget tree with JioProvider<$T>.',
      );
    }
    // ✅ notifier is guaranteed non-null now
    return provider.notifier!;
  }
}
