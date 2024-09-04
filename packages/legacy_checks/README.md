# `legacy_checks`

Add support for legacy matchers from `package:matcher` to `package:checks` expectations.

## Features

- Support for both `Matcher` and `AsyncMatcher`.

## Getting started

You probably don't want this package if you're getting started on a new project;
rather, use `package:checks` directly.
If you're using Flutter, install `package:flutter_checks` instead, via `flutter pub add flutter_checks`.
It provides a much safer, more convenient API surface out-of-the-box.

If you have an existing pure-Dart project with tests using `package:matcher` (exposed by `package:test`),
then you _might_ want this package.
Consider if migrating directly to `package:checks` would be more beneficial,
as `package:checks` is better tested, at least, and the cost of migration is about the same.

_If_ you have _existing_ custom matchers, or use matchers that aren't yet ported to `package:checks`,
you will want this package.
It can be installed with `dart pub add legacy_checks`.

## Usage

For a full example, see [`example/legacy_checks_example.dart`](./example/legacy_checks_example.dart).

```dart
check(42).legacyMatcher(matcher.equals(42));
```

## Additional information

This package is maintained _solely_ for use in `flutter_checks`.
We intend on strictly adhering to SemVer,
but that doesn't mean that we'll shy away from ergonomics in the name of back-compat.
Feel free to file issues, we appreciate it.
We also accept PRs, but please read the contributing guidelines first
(TL;DR: Don't send anything enormous our way without prior communtation, and follow to CoC).
