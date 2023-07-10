import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart' hide Reducer;
import 'package:reduct/reduct.dart';

/// Subscribes to an [Atom] and returns its value.
T useAtom<T>(Atom<T> atom) {
  use(_AtomHook<T>(atom));

  return atom.value;
}

class _AtomHook<T> extends Hook<void> {
  const _AtomHook(this.atom);

  final Atom<T> atom;

  @override
  _AtomStateHook<T> createState() => _AtomStateHook<T>();
}

class _AtomStateHook<T> extends HookState<void, _AtomHook<T>> {
  late VoidCallback disposer;

  void _listener(_) {
    setState(() {
      return;
    });
  }

  @override
  void initHook() {
    super.initHook();
    disposer = hook.atom.addListener(_listener);
  }

  @override
  void didUpdateHook(_AtomHook<T> oldHook) {
    super.didUpdateHook(oldHook);
    if (hook.atom != oldHook.atom) {
      disposer();
      disposer = hook.atom.addListener(_listener);
    }
  }

  @override
  void build(BuildContext context) {
    return;
  }

  @override
  void dispose() {
    disposer();
  }

  @override
  String get debugLabel => 'useAtom';

  @override
  Atom<T> get debugValue => hook.atom;
}

/// Equivalent of [State.initState] for [HookWidget].
void useInitState(void Function() initializer) {
  use(_InitStateHook(initializer));
}

class _InitStateHook extends Hook<void> {
  const _InitStateHook(this.initializer);

  final void Function() initializer;

  @override
  _InitializerStateHook createState() => _InitializerStateHook();
}

class _InitializerStateHook extends HookState<void, _InitStateHook> {
  @override
  void initHook() {
    super.initHook();
    hook.initializer();
  }

  @override
  void build(BuildContext context) {
    return;
  }

  @override
  String get debugLabel => 'useInitState';

  @override
  VoidCallback get debugValue => hook.initializer;
}

/// Equivalent of [State.dispose] for [HookWidget].
void useDispose(void Function() disposer) {
  use(_DisposerHook(disposer));
}

class _DisposerHook extends Hook<void> {
  const _DisposerHook(this.disposer);

  final void Function() disposer;

  @override
  _DisposerStateHook createState() => _DisposerStateHook();
}

class _DisposerStateHook extends HookState<void, _DisposerHook> {
  @override
  void dispose() {
    super.dispose();
    hook.disposer();
  }

  @override
  void build(BuildContext context) {
    return;
  }

  @override
  String get debugLabel => 'useDispose';

  @override
  VoidCallback get debugValue => hook.disposer;
}

/// Rebuild only when there is a change in the selector result.
///
/// ```dart
/// final bool valueIsEmpty = useAtomSelector(atom, (value) => value.isEmpty);
/// ```
///
R useAtomSelector<R, T>(
  Atom<T> atom,
  R Function(T value) selector,
) {
  return use(_AtomSelectorHook(atom, selector));
}

class _AtomSelectorHook<R, T> extends Hook<R> {
  const _AtomSelectorHook(this.atom, this.selector);

  final Atom<T> atom;
  final R Function(T value) selector;

  @override
  _AtomSelectorHookState<R, T> createState() => _AtomSelectorHookState<R, T>();
}

class _AtomSelectorHookState<R, T>
    extends HookState<R, _AtomSelectorHook<R, T>> {
  late R _selectorResult = hook.selector(hook.atom.value);
  late VoidCallback disposer;

  void _listener(T value) {
    final latestSelectorResult = hook.selector(value);
    if (_selectorResult != latestSelectorResult) {
      setState(() {
        _selectorResult = latestSelectorResult;
      });
    }
  }

  @override
  void initHook() {
    super.initHook();
    disposer = hook.atom.addListener(_listener);
  }

  @override
  void didUpdateHook(_AtomSelectorHook<R, T> oldHook) {
    super.didUpdateHook(oldHook);

    if (hook.selector != oldHook.selector) {
      setState(() {
        _selectorResult = hook.selector(hook.atom.value);
      });
    }

    if (hook.atom != oldHook.atom) {
      disposer();
      disposer = hook.atom.addListener(_listener);
      _selectorResult = hook.selector(hook.atom.value);
    }
  }

  @override
  R build(BuildContext context) => _selectorResult;

  @override
  void dispose() {
    disposer();
  }

  @override
  String get debugLabel => 'useAtomSelector<$R, $T>';

  @override
  bool get debugSkipValue => true;
}

/// Takes an [atom] and invokes the [listener] in response to [Atom.value] changes.
/// It should be used for functionality that needs to occur only in response to
/// a `value` change such as navigation, showing a `SnackBar`, showing
/// a `Dialog`, etc...
void useAtomListener<T>(
  Atom<T> atom,
  void Function(T value) listener,
) {
  return use(_AtomListenerHook(atom, listener));
}

class _AtomListenerHook<T> extends Hook<void> {
  const _AtomListenerHook(this.atom, this.listener);

  final Atom<T> atom;
  final void Function(T value) listener;

  @override
  _AtomListenerHookState<T> createState() => _AtomListenerHookState<T>();
}

class _AtomListenerHookState<T> extends HookState<void, _AtomListenerHook<T>> {
  late VoidCallback disposer;

  @override
  void initHook() {
    super.initHook();
    disposer = hook.atom.addListener(hook.listener);
  }

  @override
  void didUpdateHook(_AtomListenerHook<T> oldHook) {
    super.didUpdateHook(oldHook);

    if (hook.atom != oldHook.atom) {
      disposer();
      disposer = hook.atom.addListener(hook.listener);
      hook.listener(hook.atom.value);
    }
  }

  @override
  void build(BuildContext context) {
    return;
  }

  @override
  void dispose() {
    disposer();
  }

  @override
  String get debugLabel => 'useAtomListener<$T>';

  @override
  bool get debugSkipValue => true;
}
