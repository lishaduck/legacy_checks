# `flutter_checks`

Add support for legacy matchers from `package:flutter_test` to `package:checks` expectations.

## Features

- Support for all subclasses of `FinderBase` (including `Finder`).
- Support for accessibility checks.

## Getting started

This is wrapper around `package:flutter_test` and `package:legacy_checks`.

You'll only want this package if you're using Flutter.
If you have an existing pure-Dart project with tests using `package:matcher` (exposed by `package:test`),
then you want `package:legacy_checks` instead,
though it's worth considering if migrating directly to `package:checks` would be more beneficial,
as `package:checks` is better tested, at least, and the cost of migration is about the same.

_If_ you have _existing_ custom matchers, or use matchers that aren't yet ported to `package:checks`,
you will want `package:legacy_checks` package.
It can be installed with `dart pub add legacy_checks`.

If you are using Flutter, you will want this package.

## Usage

```dart
check(find.text('Save')).findsOne();
```

## Caveats

- Most synchronous matchers don't have inverted versions.
  Use `.not((it) => it.legacyMatcher)` instead.
  Like `package:matcher`, `checks` doesn't have
- Deprecated matchers weren't included.
  This includes `findsOneWidget` & co., as one should use `findsOne` instead.
  If you find this unduly restrictive, please [file an issue][new-issue]!

## Additional information

This package is maintained _solely_ for the use of [`@PHS-TSA`][phs-tsa], but is published so anyone can use it if they find it helpful.
We intend on strictly adhering to SemVer,
but that doesn't mean that we'll shy away from ergonomics in the name of back-compat.
Feel free to file issues, we appreciate it.
We also accept PRs, but please read the contributing guidelines first
(TL;DR: Don't send anything enormous our way without prior communtation, and follow to CoC).

[new-issue]: https://github.com/lishaduck/legacy_checks/issues/new
[phs-tsa]: https://github.com/PHS-TSA
