// MyNotifier notifier = UniversalFenixLazyJioProvider.of<MyNotifier>(context);
// Works like Provider.of or Riverpod.watch.
// Throws an error if the provider is not found in the widget tree.
// maybeInstance property:
// Returns the notifier if already created, else null.
// Useful if you want to avoid triggering lazy creation prematurely.
// Fully lazy, Fenix-style, async-ready, reference counted, and easy to consume in your widgets.

import 'dart:async' show FutureOr;

import 'package:flutter/material.dart'
    show
        StatefulWidget,
        Widget,
        State,
        BuildContext,
        Center,
        CircularProgressIndicator,
        FlutterError;
import 'package:jio_provider/jio_provider.dart' show JioNotifier;
import 'package:jio_provider/src/basic_jio_provider.dart' show BasicJioProvider;
import 'package:jio_provider/src/jio_provider_builder.dart'
    show JioProviderBuilder;

/// 🦅 Universal Fenix Lazy Provider (sync or async)
class LazyJioUniversalProvider<T extends JioNotifier>
    implements JioProviderBuilder {
  final FutureOr<T> Function() creator;
  final bool autoDispose;

  T? _sharedInstance;
  int _refCount = 0;
  Future<T>? _creationFuture;

  LazyJioUniversalProvider(this.creator, {this.autoDispose = true});

  /// Increment reference count
  void _addRef() => _refCount++;

  /// Decrement reference count & dispose if needed
  void _releaseRef() {
    if (_refCount > 0) _refCount--;
    if (_refCount == 0 && autoDispose) {
      _sharedInstance?.dispose();
      _sharedInstance = null;
    }
  }

  /// Get instance, creating lazily
  /// Lazy creation (sync or async)
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
      _sharedInstance = result;
      return _sharedInstance!;
    }
  }

  /// 🪄 Synchronous access if already created, else null
  T? get maybeInstance => _sharedInstance;

  /// 🪄 Watch / access from context
  static T? of<T extends JioNotifier>(BuildContext context) {
    final provider = context
        .dependOnInheritedWidgetOfExactType<BasicJioProvider<T>>();
    if (provider == null) {
      throw FlutterError(
        'No BasicJioProvider<$T> found in context. Make sure you wrapped your widget with the provider.',
      );
    }
    return provider.notifier;
  }

  @override
  Widget build(Widget child) {
    return _LazyJioUniversalProviderWrapper<T>(provider: this, child: child);
  }
}

/// Internal wrapper to handle widget lifecycle
class _LazyJioUniversalProviderWrapper<T extends JioNotifier>
    extends StatefulWidget {
  final LazyJioUniversalProvider<T> provider;
  final Widget child;

  const _LazyJioUniversalProviderWrapper({
    required this.provider,
    required this.child,
  });

  @override
  State<_LazyJioUniversalProviderWrapper<T>> createState() =>
      _UniversalFenixLazyJioProviderWrapperState<T>();
}

class _UniversalFenixLazyJioProviderWrapperState<T extends JioNotifier>
    extends State<_LazyJioUniversalProviderWrapper<T>> {
  T? instance;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    widget.provider._addRef();

    // Lazy creation (sync or async)
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
      // Customize loading widget if needed
      return const Center(child: CircularProgressIndicator());
    }

    return BasicJioProvider<T>(notifier: instance!, child: widget.child);
  }
}
