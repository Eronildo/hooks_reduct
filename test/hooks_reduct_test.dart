import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:hooks_reduct/hooks_reduct.dart';
import 'package:reduct/reduct.dart';

void main() {
  testWidgets('useAtom', (tester) async {
    late int counter;
    late HookElement element;
    final state = Atom<int>(42);

    await tester.pumpWidget(HookBuilder(
      builder: (context) {
        element = context as HookElement;
        counter = useAtom(state);
        return Container();
      },
    ));

    expect(counter, 42);
    expect(element.dirty, false);

    state.value++;
    expect(element.dirty, true);
    await tester.pump();

    expect(counter, 43);
    expect(element.dirty, false);
  });

  testWidgets('useInitState', (tester) async {
    late HookElement element;
    final state = Atom<int>(42);
    var counter = 0;

    expect(counter, 0);

    await tester.pumpWidget(HookBuilder(
      builder: (context) {
        element = context as HookElement;
        useAtom(state);
        useInitState(() {
          counter++;
        });
        return Container();
      },
    ));

    expect(element.dirty, false);
    expect(counter, 1);

    state.value++;
    expect(element.dirty, true);
    await tester.pump();

    expect(counter, 1);
    expect(element.dirty, false);
  });

  testWidgets('useDispose', (tester) async {
    bool disposed = false;

    await tester.pumpWidget(HookBuilder(
      builder: (context) {
        useDispose(() {
          disposed = true;
        });
        return Container();
      },
    ));

    expect(disposed, false);

    // dispose
    await tester.pumpWidget(const SizedBox());
    await tester.pump();

    expect(disposed, true);
  });

  testWidgets('useAtomSelector', (tester) async {
    late int length;
    final state = Atom<List<int>>([5]);

    await tester.pumpWidget(HookBuilder(
      builder: (context) {
        length = useAtomSelector(state, (value) => value.length);
        return Container();
      },
    ));

    expect(length, 1);

    state.setValue([0, 1]);
    await tester.pump();

    expect(length, 2);
  });

  testWidgets('useAtomListener', (tester) async {
    int counter = -1;
    final state = Atom<int>(0);

    await tester.pumpWidget(HookBuilder(
      builder: (context) {
        useAtomListener(state, (value) {
          counter = value;
        });
        return Container();
      },
    ));

    expect(counter, -1);

    state.value++;
    await tester.pump();

    expect(counter, 1);

    state.setValue(50);
    await tester.pump();

    expect(counter, 50);
  });
}
