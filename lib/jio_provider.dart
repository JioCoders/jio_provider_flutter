import 'package:flutter/widgets.dart';

/// 1️⃣ Create a simple notifier base class
class JioNotifier extends ChangeNotifier {
  // You can extend this class for your viewmodels
}

/// 2️⃣ Custom InheritedWidget to hold the state
class MyProvider<T extends JioNotifier> extends InheritedNotifier<T> {
  const MyProvider({
    super.key,
    required T notifier,
    required Widget child,
  }) : super(notifier: notifier, child: child);

  /// Access the provider from context
  static T of<T extends JioNotifier>(BuildContext context) {
    final provider =
    context.dependOnInheritedWidgetOfExactType<MyProvider<T>>();
    if (provider == null) {
      throw FlutterError('No MyProvider<$T> found in context');
    }
    return provider.notifier!;
  }
}
