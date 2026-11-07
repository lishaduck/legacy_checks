/// Implement [expect] and [expectLater] from `package:matcher` in `package:checks`.
library;

import 'dart:convert';

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
  /// Throws [ArgumentError] for an [AsyncMatcher]. Its result must be awaited
  /// through [legacyMatcherAsync], not checked synchronously.
  ///
  /// See also:
  ///
  /// * [legacyMatcherAsync] for asynchronous matchers.
  void legacyMatcher(Matcher matcher) {
    if (matcher is AsyncMatcher) {
      throw ArgumentError.value(
        matcher,
        'matcher',
        'Use legacyMatcherAsync for an AsyncMatcher.',
      );
    }
    context.expect(
      () =>
          LineSplitter.split(matcher.describe(StringDescription()).toString()),
      (value) {
        final matchState = <Object?, Object?>{};
        if (!matcher.matches(value, matchState)) {
          final mismatchDescription = matcher.describeMismatch(
            value,
            StringDescription(),
            matchState,
            false,
          );

          return Rejection(
            which: LineSplitter.split(mismatchDescription.toString()),
          );
        }
        return null;
      },
    );
  }

  /// Support legacy [AsyncMatcher]s in `package:checks` expectations.
  ///
  /// A `null` result succeeds and a [String] result fails, even if empty.
  /// Both immediate results and results returned through a [Future] are supported.
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
  /// Unfortunately, many matchers that need [LegacyMatcher] are asynchronous, so you may need to use this method.
  ///
  /// See also:
  ///
  /// * [legacyMatcher] for synchronous matchers.
  Future<void> legacyMatcherAsync(AsyncMatcher matcher) async {
    await context.expectAsync(
      () =>
          LineSplitter.split(matcher.describe(StringDescription()).toString()),
      (actual) async {
        final Object? match = await matcher.matchAsync(actual);

        switch (match) {
          case String _:
            return Rejection(which: LineSplitter.split(match));
          case null:
            return null;
          default:
            // This should never happen.
            throw AssertionError(
              'matchAsync() may only return a String, a Future, or null.',
            );
        }
      },
    );
  }
}
