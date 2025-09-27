import 'package:flutter/material.dart';
import 'package:jio_provider/jio_provider.dart' show JioProvider, JioNotifier, JioContext;

void main() {
  runApp(
    JioProvider(
      notifier: TodoViewModel(),
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
      home: TodoView(),
    );
  }
}
//=====================COUNTER==================
class CounterViewModel extends JioNotifier {
  bool _option = false;
  int _count = 0;

  bool get option => _option;
  int get count => _count;

  void changeOption(){
    _option = !_option;
    notifyListeners();
  }

  void increment() {
    _count++;
    notifyListeners();
  }
}

class CounterView extends StatelessWidget {
  static int _buildCount = 0;
  const CounterView({super.key});

  @override
  Widget build(BuildContext context) {
    _buildCount++;
    debugPrint('🔁 Counter built $_buildCount times');
    // final counter = JioProvider.of<CounterViewModel>(context);
    final counter = context.jioWatch<CounterViewModel>(); // rebuilds on change

    return Scaffold(
      appBar: AppBar(title: Text(counter.option ? 'OPTION1': 'OPTION2')),
      body: Column(
        children: [
          Center(child: Row(children: [
            ElevatedButton(onPressed: ()=> context.jioRead<CounterViewModel>().changeOption(), child: Text('OPTIONS'))
          ])),
          Center(
            child: Text(
              'Count: ${counter.count}',
              style: const TextStyle(fontSize: 28),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: context.jioRead<CounterViewModel>().increment, // no rebuild
        child: const Icon(Icons.add),
      ),
    );
  }
}

//=====================TO DO==================
class TodoViewModel extends JioNotifier {
  final List<String> _todos = [];
  List<String> get todos => List.unmodifiable(_todos);

  void addTodo() {
    _todos.add("Task ${_todos.length + 1}");
    notifyListeners(); // 🔥 Triggers rebuild for watchers
  }

  int get count => _todos.length;
}

class TodoView extends StatelessWidget {
  static int _buildCount = 0;
  const TodoView({super.key});

  @override
  Widget build(BuildContext context) {
    _buildCount++;
    debugPrint('🔁 TodoList built $_buildCount times');
    // ✅ This part WATCHES the ViewModel → rebuilds when todos change
    final todos = context.jioWatch<TodoViewModel>().todos;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo Demo'),
        actions: [
          // ❌ This part READS only → does NOT rebuild when state changes
          Padding(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: Text(
                "Total: ${context.jioRead<TodoViewModel>().count}",
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: todos.length,
        itemBuilder: (context, index) => ListTile(
          title: Text(todos[index]),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // ✅ Use READ because we don't want to rebuild this FAB widget
          context.jioRead<TodoViewModel>().addTodo();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}