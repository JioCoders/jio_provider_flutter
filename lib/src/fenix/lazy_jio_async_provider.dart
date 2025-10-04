import 'package:flutter/material.dart'
    show
        StatefulWidget,
        Widget,
        State,
        BuildContext,
        Center,
        CircularProgressIndicator;
import 'package:jio_provider/jio_provider.dart' show JioNotifier;
import 'package:jio_provider/src/basic_jio_provider.dart' show BasicJioProvider;
import 'package:jio_provider/src/jio_provider_builder.dart'
    show JioProviderBuilder;

/// 🦅 Async Fenix Lazy Provider with reference counting
class LazyJioAsyncProvider<T extends JioNotifier>
    implements JioProviderBuilder {
  final Future<T> Function() createAsync;
  final bool autoDispose;

  T? _sharedInstance;
  int _refCount = 0;
  Future<T>? _creationFuture;

  LazyJioAsyncProvider(this.createAsync, {this.autoDispose = true});

  /// Get the instance, creating it if necessary
  Future<T> getInstance() async {
    // If instance exists, return immediately
    if (_sharedInstance != null) return _sharedInstance!;

    // If a creation is already in progress, await it
    if (_creationFuture != null) return await _creationFuture!;

    // Otherwise, start creation
    _creationFuture = createAsync();
    _sharedInstance = await _creationFuture!;
    _creationFuture = null; // reset future after creation
    return _sharedInstance!;
  }

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

  @override
  Widget build(Widget child) {
    return _LazyJioAsyncProviderWrapper<T>(provider: this, child: child);
  }
}

/// Internal wrapper for per-widget lifecycle
class _LazyJioAsyncProviderWrapper<T extends JioNotifier>
    extends StatefulWidget {
  final LazyJioAsyncProvider<T> provider;
  final Widget child;

  const _LazyJioAsyncProviderWrapper({
    required this.provider,
    required this.child,
  });

  @override
  State<_LazyJioAsyncProviderWrapper<T>> createState() =>
      _AsyncFenixLazyJioProviderWrapperState<T>();
}

class _AsyncFenixLazyJioProviderWrapperState<T extends JioNotifier>
    extends State<_LazyJioAsyncProviderWrapper<T>> {
  T? instance;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    widget.provider._addRef();

    // Trigger lazy async creation
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
      // You can customize this loading placeholder
      return const Center(child: CircularProgressIndicator());
    }

    return BasicJioProvider<T>(notifier: instance!, child: widget.child);
  }
}
