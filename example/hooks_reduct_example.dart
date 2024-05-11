import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart' hide Reducer;
import 'package:hooks_reduct/hooks_reduct.dart';
import 'package:reduct/reduct.dart';

void main() {
  CounterReducer();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hooks Reduct',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Hooks for Reduct'),
    );
  }
}

class MyHomePage extends HookWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    useAtomListener(counterState, (count) {
      final snackBar = SnackBar(content: Text('Counter: $count'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });

    final isOdd = useAtomSelector(counterState, (value) => value.isOdd);

    final counter = useAtom(counterState);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
      ),
      body: Center(
        child: Text(
          'Counter: $counter \nisOdd: $isOdd',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: incrementAction.call,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

// atoms
final counterState = Atom(0);
final incrementAction = Atom.action();

// reducer
class CounterReducer extends Reducer {
  CounterReducer() {
    on(incrementAction, (_) => counterState.value++);
  }
}
