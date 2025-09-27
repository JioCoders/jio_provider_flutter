git push origin -d branch-name
git branch --delete <branch-name>
git pull --rebase origin main
//----------------------------------------------
export PATH=~/Documents/src/flutter/bin:$PATH
//----------------------download module------------------------
flutter create --template=plugin --platforms=android,ios --org com.jiocoders --android-language kotlin --ios-language swift jio_provider
---------------------Webview.dart--------------------
dart run build_runner build
dart pub login
dart pub logout
https://github.com/JioCoders/jio_provider_flutter.git
dart pub token add https://some-package-repo.com/my-org/my-repo
Enter secret token: <Type token on stdin>
dart pub token add https://other-package-repo.com/ --env-var TOKEN_VAR
Requests to "https://other-package-repo.com/" will now be authenticated using the secret token stored in the environment variable "TOKEN_VAR".
dart pub token remove https://other-package-repo.com
dart pub token remove --all
---------------------main.dart--------------------
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