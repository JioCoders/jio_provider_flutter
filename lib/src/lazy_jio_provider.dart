import 'package:flutter/material.dart';
import 'package:jio_provider/src/basic_jio_provider.dart' show BasicJioProvider;
import 'package:jio_provider/src/jio_notifier.dart' show JioNotifier;
import 'package:jio_provider/src/jio_provider_builder.dart'
    show JioProviderBuilder;

/// 💤 Fenix-style Lazy provider - created only when accessed for the first time
class LazyJioProvider<T extends JioNotifier> implements JioProviderBuilder {
  final T Function() create;
  final bool autoDispose;

  LazyJioProvider(this.create, {this.autoDispose = true});

  @override
  Widget build(Widget child) {
    // We don't create immediately — we wrap with a lazy proxy
    return _LazyJioProviderWrapper<T>(
      creator: create,
      autoDispose: autoDispose,
      child: child,
    );
  }
}

/// 🪄 Internal wrapper to lazily instantiate the notifier
class _LazyJioProviderWrapper<T extends JioNotifier> extends StatefulWidget {
  final T Function() creator;
  final Widget child;
  final bool autoDispose;

  const _LazyJioProviderWrapper({
    required this.creator,
    required this.child,
    this.autoDispose = true,
  });

  @override
  State<_LazyJioProviderWrapper<T>> createState() =>
      _LazyJioProviderWrapperState<T>();
}

class _LazyJioProviderWrapperState<T extends JioNotifier>
    extends State<_LazyJioProviderWrapper<T>> {
  T? _instance;

  /// ❗️Lazy + Fenix creation: only when first accessed (or immediately if desired)
  T get instance {
    _instance ??= widget.creator();
    return _instance!;
  }

  // @override
  // void initState() {
  //   super.initState();
  //   // ❗️Lazy creation: only when first accessed (or immediately if desired)
  //   _instance = widget.creator();
  // }

  @override
  void dispose() {
    // ✅ If the instance was ever created, dispose it before this widget is removed
    if (widget.autoDispose) {
      _instance?.dispose();
    }
    _instance = null; // 🪄 Fenix allows recreation later
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BasicJioProvider<T>(notifier: instance, child: widget.child);
  }
}
