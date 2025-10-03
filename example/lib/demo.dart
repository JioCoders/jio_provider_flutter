// We’ll build a simple demo:
//
// CounterNotifier – a JioNotifier that simulates async initialization.
//
// UniversalFenixLazyJioProvider – provides it lazily & recreates it after disposal.
//
// Two screens (CounterScreen and SecondScreen) both using the same provider to show shared state, lazy creation, auto-dispose, and recreation.

import 'dart:async';
import 'package:flutter/material.dart';

/// ✅ Base Notifier
abstract class JioNotifier {
  void dispose();
}

/// ✅ Basic Provider (inherits)
class BasicJioProvider<T extends JioNotifier> extends InheritedWidget {
  final T notifier;

  const BasicJioProvider({
    super.key,
    required this.notifier,
    required super.child,
  });

  @override
  bool updateShouldNotify(covariant BasicJioProvider<T> oldWidget) =>
      notifier != oldWidget.notifier;
}

/// 🦅 Universal Fenix Lazy Provider
class UniversalFenixLazyJioProvider<T extends JioNotifier>
    implements JioProviderBuilder {
  final FutureOr<T> Function() creator;
  final bool autoDispose;

  T? _sharedInstance;
  int _refCount = 0;
  Future<T>? _creationFuture;

  UniversalFenixLazyJioProvider(this.creator, {this.autoDispose = true});

  void _addRef() => _refCount++;
  void _releaseRef() {
    if (_refCount > 0) _refCount--;
    if (_refCount == 0 && autoDispose) {
      _sharedInstance?.dispose();
      _sharedInstance = null;
    }
  }

  Future<T> getInstance() async {
    if (_sharedInstance != null) return _sharedInstance!;
    if (_creationFuture != null) return await _creationFuture!;

    final result = creator();
    if (result is Future<T>) {
      _creationFuture = result.then((value) {
        _sharedInstance = value;
        _creationFuture = null;
        return value;
      });
      return await _creationFuture!;
    } else {
      _sharedInstance = result as T;
      return _sharedInstance!;
    }
  }

  T? get maybeInstance => _sharedInstance;

  static T of<T extends JioNotifier>(BuildContext context) {
    final provider =
    context.dependOnInheritedWidgetOfExactType<BasicJioProvider<T>>();
    if (provider == null) {
      throw FlutterError(
          'No BasicJioProvider<$T> found in the widget tree.');
    }
    return provider.notifier;
  }

  @override
  Widget build(Widget child) {
    return _UniversalFenixLazyJioProviderWrapper<T>(
      provider: this,
      child: child,
    );
  }
}

abstract class JioProviderBuilder {
  Widget build(Widget child);
}

class _UniversalFenixLazyJioProviderWrapper<T extends JioNotifier>
    extends StatefulWidget {
  final UniversalFenixLazyJioProvider<T> provider;
  final Widget child;

  const _UniversalFenixLazyJioProviderWrapper({
    required this.provider,
    required this.child,
  });

  @override
  State<_UniversalFenixLazyJioProviderWrapper<T>> createState() =>
      _UniversalFenixLazyJioProviderWrapperState<T>();
}

class _UniversalFenixLazyJioProviderWrapperState<T extends JioNotifier>
    extends State<_UniversalFenixLazyJioProviderWrapper<T>> {
  T? instance;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    widget.provider._addRef();
    widget.provider.getInstance().then((value) {
      if (mounted) {
        setState(() {
          instance = value;
          _isLoading = false;
        });
      }
    });
  }

  @override
  void dispose() {
    widget.provider._releaseRef();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading || instance == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return BasicJioProvider<T>(
      notifier: instance!,
      child: widget.child,
    );
  }
}

/// 🧠 Context extension for easy access
extension JioProviderX on BuildContext {
  T watch<T extends JioNotifier>() {
    return UniversalFenixLazyJioProvider.of<T>(this);
  }

  T? maybeWatch<T extends JioNotifier>() {
    return dependOnInheritedWidgetOfExactType<BasicJioProvider<T>>()?.notifier;
  }
}

/// 🧮 Example Notifier
class CounterNotifier extends JioNotifier {
  int value = 0;

  CounterNotifier._();

  static Future<CounterNotifier> create() async {
    // Simulate async initialization
    await Future.delayed(const Duration(seconds: 2));
    return CounterNotifier._();
  }

  void increment() => value++;

  @override
  void dispose() {
    debugPrint('🗑️ CounterNotifier disposed');
  }
}

void main() {
  runApp(
    UniversalFenixLazyJioProvider<CounterNotifier>(
      CounterNotifier.create,
    ).build(const MyApp()),
  );
}

/// 🌐 App
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const CounterScreen(),
    );
  }
}

/// 🖥️ Screen 1
class CounterScreen extends StatelessWidget {
  const CounterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final counter = context.watch<CounterNotifier>();

    return Scaffold(
      appBar: AppBar(title: const Text('Counter Screen 1')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Counter: ${counter.value}',
                style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                counter.increment();
                (context as Element).markNeedsBuild();
              },
              child: const Text('Increment'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const SecondScreen()));
              },
              child: const Text('Go to Screen 2'),
            ),
          ],
        ),
      ),
    );
  }
}

/// 🖥️ Screen 2
class SecondScreen extends StatelessWidget {
  const SecondScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final counter = context.watch<CounterNotifier>();

    return Scaffold(
      appBar: AppBar(title: const Text('Counter Screen 2')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Counter: ${counter.value}',
                style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                counter.increment();
                (context as Element).markNeedsBuild();
              },
              child: const Text('Increment'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Back'),
            ),
          ],
        ),
      ),
    );
  }
}
// 🧪 What This Demo Shows
//
// ✅ Lazy Creation:
//
// CounterNotifier is created only when the widget tree needs it (first watch() call).
//
// Notice the CircularProgressIndicator shows during the 2-second async creation.
//
// ✅ Shared State:
//
// Both CounterScreen and SecondScreen use the same notifier instance and share state.
//
// ✅ Reference Counting:
//
// If you leave all screens and the provider is unused, _refCount becomes 0 and the notifier is disposed (🗑️ printed in console).
//
// ✅ Fenix Recreation:
//
// When you navigate back into the app again, the notifier is recreated automatically.
//
// ✅ Convenient Consumption:
//
// Use context.watch<MyNotifier>() or context.maybeWatch<MyNotifier>() anywhere inside the tree.