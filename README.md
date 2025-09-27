# jio_provider

![Flutter CI](https://github.com/jiocoders/jio_provider_flutter/actions/workflows/flutter-ci.yml/badge.svg)

## Description(s)

A Flutter plugin for android, iOS and web which provides reactive widget.

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
import 'package:jio_provider/jio_provider.dart' show Reactive, RexController;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const ReactiveCounterView(),
    );
  }
}

class ReactiveCounterView extends StatelessWidget {
  const ReactiveCounterView({super.key});

  @override
  Widget build(BuildContext context) {
    // Bind the CounterController using `RexController` or directly
    final CounterController counterController = CounterController();

    return Scaffold(
      appBar: AppBar(title: Text('Reactive Counter')),
      body: Center(
        // Use `Reactive` widget to rebuild when the counter value changes
        child: Reactive<int>(
          stream: counterController.stateStream,
          builder: (context, counter) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Counter: $counter', style: TextStyle(fontSize: 40)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: counterController.increment,
                      child: Text('Increment'),
                    ),
                    SizedBox(width: 20),
                    ElevatedButton(
                      onPressed: counterController.decrement,
                      child: Text('Decrement'),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class CounterController extends RexController<int> {
  CounterController() : super(0); // Initialize with a counter of 0

  // Increment the counter value
  void increment() {
    updateState(state + 5);
  }

  // Decrement the counter value
  void decrement() {
    updateState(state - 5);
  }
}

```

[![Pub](https://img.shields.io/pub/v/jio_provider.svg)](https://pub.dev/packages/jio_provider)
[![GitHub release](https://img.shields.io/github/release/jiocoders/jio_provider_flutter.svg)](https://github.com/jiocoders/jio_provider_flutter/releases/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

# License

Copyright (c) 2024 Jiocoders

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
