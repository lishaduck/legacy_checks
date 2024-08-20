/// Implement [expect] and [expectLater] from `package:matcher` in `package:checks`.
library;

import 'package:checks/checks.dart';
import 'package:checks/context.dart';
import 'package:matcher/expect.dart'
    // Only used in the docs.
    show
        completion,
        expect,
        expectLater;
import 'package:matcher/matcher.dart' show Matcher, StringDescription;
// `AsyncMatcher` is not exposed by `package:matcher`, as `package:checks` is the modern replacement.
// ignore: implementation_imports
import 'package:matcher/src/expect/async_matcher.dart' show AsyncMatcher;

/// Enable legacy matchers from `package:matcher` and `package:flutter_test` in `package:checks` expectations.
extension LegacyMatcher<T> on Subject<T> {
  /// Support legacy [Matcher]s in `package:checks` expectations.
  ///
  /// Note that many [AsyncMatcher]s are exposed as [Matcher]s instead, because [AsyncMatcher] is not exposed by `package:matcher`.
  /// In that case, cast the [Matcher] to [AsyncMatcher] and call [legacyMatcherAsync] instead.
  ///
  /// See also:
  ///
  /// * [legacyMatcherAsync] for asynchronous matchers.
  void legacyMatcher(Matcher matcher) {
    context.expect(() => [], (value) {
      final matchState = <Object?, Object?>{};
      if (!matcher.matches(value, matchState)) {
        final description = matcher.describe(StringDescription());
        final mismatchDescription = matcher.describeMismatch(
          value,
          StringDescription(),
          matchState,
          false,
        );

        return Rejection(
          which: [description.toString()],
          actual: [mismatchDescription.toString()],
        );
      }
      return null;
    });
  }

  /// Support legacy [AsyncMatcher]s in `package:checks` expectations.
  ///
  /// Note that many [AsyncMatcher]s are exposed as [Matcher]s instead, because [AsyncMatcher] is not exposed by `package:matcher`.
  /// In that case, cast the [Matcher] to [AsyncMatcher] before calling this method rather than using [legacyMatcher].
  /// For example, see the [completion] matcher in `package:matcher`.
  ///
  /// For reference, [AsyncMatcher] is exposed only at `package:matcher/src/expect/async_matcher.dart`.
  /// This is because it used to be part of `package:test_api`,
  /// and depends on `test_api` internals which the Dart team doesn't wish to expose given that `package:checks` doesn't need them.
  /// For more information, see [dart-lang/matcher#199 (comment)](https://github.com/dart-lang/matcher/issues/199#issuecomment-1432422108).
  /// You have been warned, only use this method at your own risk.
  /// Unfortunately, most matchers that need [LegacyMatcher] are asynchronous, so you may need to use this method.
  ///
  /// See also:
  ///
  /// * [legacyMatcher] for synchronous matchers.
  Future<void> legacyMatcherAsync(AsyncMatcher matcher) async {
    await context.expectAsync(() => [], (actual) async {
      final Object? match = await matcher.matchAsync(actual);

      check(
        because: 'matchAsync() may only return a String, a Future, or null.',
        match,
      ).anyOf([
        (it) => it.isNull(),
        (it) => it.isA<Future<String?>>(),
        (it) => it.isA<String>(),
      ]);

      switch (match) {
        case String _:
          return Rejection(which: [match]);
        case Future<String?> _:
          final realResult = await match;
          if (realResult == null) return null;
          return Rejection(which: [realResult]);
        default:
          return null;
      }
    });
  }
}
