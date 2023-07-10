# Hooks Reduct

A flutter hooks for [reduct](https://pub.dev/packages/reduct) library.

## Install

```yaml
flutter pub add hooks_reduct
```

## useAtom

```dart
final counterState = Atom(0);

...
// Inside HookWidget builder:
final counter = useAtom(counterState);
```

## useAtomListener

```dart
final counterState = Atom(0);

...
// Inside HookWidget builder:
useAtomListener(counterState, (count) {
    final snackBar = SnackBar(content: Text('Counter: $count'));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
});
```

## useAtomSelector

```dart
final listState = Atom([0, 1, 2]);

...
// Inside HookWidget builder:
final length = useAtomSelector(listState, (value) => value.length);
```

## useInitState

```dart
final initialize = Atom.action();

...
// Inside HookWidget builder:
useInitState(() => initialize());
```

## useDispose

```dart
// Inside HookWidget builder:
useDispose(() => other.dispose());
```