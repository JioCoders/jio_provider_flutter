import 'package:flutter/material.dart';
import 'package:jio_provider/jio_provider.dart' show JioProvider, JioNotifier;

void main() {
  runApp(
    JioProvider(
      notifier: CounterViewModel(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CounterView(),
    );
  }
}

class CounterViewModel extends JioNotifier {
  int _count = 0;
  int get count => _count;

  void increment() {
    _count++;
    notifyListeners();
  }
}

class CounterView extends StatelessWidget {
  const CounterView({super.key});

  @override
  Widget build(BuildContext context) {
    final counter = JioProvider.of<CounterViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Custom Provider Demo')),
      body: Center(
        child: Text(
          'Count: ${counter.count}',
          style: const TextStyle(fontSize: 28),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: counter.increment,
        child: const Icon(Icons.add),
      ),
    );
  }
}
