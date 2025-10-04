# jio_provider

![Flutter CI](https://github.com/jiocoders/jio_provider_flutter/actions/workflows/flutter-ci.yml/badge.svg)

## Description(s)

A Flutter package for android, iOS and web which provides reactive widget.
Two types of JioProvider are available:
1. BasicJioProvider
2. MultiJioProvider
MultiJioProvider has two approaches:
   1. EagerJioProvider
   2. LazyJioProvider
   3. LazyJioAsyncProvider
   4. LazyJioUniversalProvider

## Performance Metrics

- **Build Status:** The current status of the CI build.
- **Build Time:** Average build time for the CI.

## Getting Started

Published package url -
```
https://pub.dev/packages/jio_provider
```

## Usage

[Example](https://github.com/jiocoders/jio_provider_flutter/blob/main/example/lib/main.dart)

To use this package :

- add the dependency to your [pubspec.yaml](https://github.com/jiocoders/jio_provider_flutter/blob/main/pubspec.yaml) file.

```yaml
dependencies:
  flutter:
    sdk: flutter
  jio_provider:
```

### How to use

```dart
import 'package:flutter/material.dart';
import 'package:jio_provider/jio_provider.dart';

void main() {
  runApp(BasicJioProvider(notifier: CounterViewModel(), child: const MyApp()));
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
  bool _option = false;
  int _count = 0;

  bool get option => _option;

  int get count => _count;

  void changeOption() {
    _option = !_option;
    notifyListeners();
  }

  void increment() {
    _count++;
    notifyListeners();
  }
}

class CounterView extends StatelessWidget {
  const CounterView({super.key});

  @override
  Widget build(BuildContext context) {
    final counter = JioProvider.of<CounterViewModel>(context); // OK | OK for small app

    return Scaffold(
      appBar: AppBar(title: Text(counter.option ? 'OPTION1' : 'OPTION2')),
      body: Column(
        children: [
          Center(
            child: Row(
              children: [
                ElevatedButton(
                  onPressed: () => counter.changeOption(),
                  child: Text('OPTIONS'),
                ),
              ],
            ),
          ),
          Center(
            child: Text(
              'Count: ${counter.count}',
              style: const TextStyle(fontSize: 28),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: counter.increment, 
        child: const Icon(Icons.add),
      ),
    );
  }
}

```

[![Pub](https://img.shields.io/pub/v/jio_provider.svg)](https://pub.dev/packages/jio_provider)
[![GitHub release](https://img.shields.io/github/release/jiocoders/jio_provider_flutter.svg)](https://github.com/jiocoders/jio_provider_flutter/releases/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

# License

Copyright (c) 2025 Jiocoders

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

## Getting Started

For help getting started with Flutter, view our online [documentation](https://flutter.io/).

For help on editing package code, view the [documentation](https://flutter.io/developing-packages/).
