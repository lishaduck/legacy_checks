/// Wrap the `flutter_test` package to provide a modern, type-safe API for testing Flutter widgets.
library;

import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart'
    show
        AccessibilityGuideline,
        FinderBase,
        WidgetTester,
        androidTapTargetGuideline,
        iOSTapTargetGuideline,
        labeledTapTargetGuideline,
        textContrastGuideline;
import 'package:flutter_test/flutter_test.dart' as flutter_matcher
    show
        findsAny,
        findsAtLeast,
        findsExactly,
        findsNothing,
        findsOne,
        meetsGuideline;
import 'package:legacy_checks/legacy_checks.dart';

/// Enable accessibility checks.
///
/// Under the hood, this extension uses the [LegacyMatcher] extension to support legacy matchers.
extension AccessibilityExpect on Subject<WidgetTester> {
  /// Asserts that the currently rendered widget meets the provided accessibility
  /// `guideline`.
  ///
  /// This matcher requires the result to be awaited and for semantics to be
  /// enabled first.
  ///
  /// ## Sample code
  ///
  /// ```dart
  /// testWidgets('containsSemantics', (WidgetTester tester) async {
  ///   final SemanticsHandle handle = tester.ensureSemantics();
  ///   // ...
  ///   await check(tester).meetsGuideline(textContrastGuideline);
  ///   handle.dispose();
  /// });
  /// ```
  ///
  /// Supported [AccessibilityGuideline]s include:
  ///
  ///   * [androidTapTargetGuideline], for Android minimum tappable area guidelines.
  ///   * [iOSTapTargetGuideline], for iOS minimum tappable area guidelines.
  ///   * [textContrastGuideline], for WCAG minimum text contrast guidelines.
  ///   * [labeledTapTargetGuideline], for enforcing labels on tappable areas.
  Future<void> meetsGuideline(AccessibilityGuideline guideline) async {
    await legacyMatcherAsync(flutter_matcher.meetsGuideline(guideline));
  }
}

/// Enable [Finder][FinderBase] checks.
///
/// Under the hood, this extension uses the [LegacyMatcher] extension to support legacy matchers.
extension FinderExpect<T> on Subject<FinderBase<T>> {
  /// Asserts that the [FinderBase] matches nothing in the available candidates.
  ///
  /// ## Sample code
  ///
  /// ```dart
  /// check(find.text('Save')).findsNothing();
  /// ```
  ///
  /// See also:
  ///
  ///  * [findsAny], when you want the finder to find one or more candidates.
  ///  * [findsOne], when you want the finder to find exactly one candidate.
  ///  * [findsExactly], when you want the finder to find a specific number of candidates.
  ///  * [findsAtLeast], when you want the finder to find at least a specific number of candidates.

  void findsNothing() {
    legacyMatcher(flutter_matcher.findsNothing);
  }

  /// Asserts that the [FinderBase] locates at least one matching candidate.
  ///
  /// ## Sample code
  ///
  /// ```dart
  /// check(find.text('Save')).findsAny();
  /// ```
  ///
  /// See also:
  ///
  ///  * [findsNothing], when you want the finder to not find anything.
  ///  * [findsOne], when you want the finder to find exactly one candidate.
  ///  * [findsExactly], when you want the finder to find a specific number of candidates.
  ///  * [findsAtLeast], when you want the finder to find at least a specific number of candidates.
  void findsAny() {
    legacyMatcher(flutter_matcher.findsAny);
  }

  /// Asserts that the [FinderBase] finds exactly one matching candidate.
  ///
  /// ## Sample code
  ///
  /// ```dart
  /// check(find.text('Save')).findsOne();
  /// ```
  ///
  /// See also:
  ///
  ///  * [findsNothing], when you want the finder to not find anything.
  ///  * [findsAny], when you want the finder to find one or more candidates.
  ///  * [findsExactly], when you want the finder to find a specific number candidates.
  ///  * [findsAtLeast], when you want the finder to find at least a specific number of candidates.
  void findsOne() {
    legacyMatcher(flutter_matcher.findsOne);
  }

  /// Asserts that the [FinderBase] locates the specified number of candidates.
  ///
  /// ## Sample code
  ///
  /// ```dart
  /// check(find.text('Save')).findsExactly(2)));
  /// ```
  ///
  /// See also:
  ///
  ///  * [findsNothing], when you want the finder to not find anything.
  ///  * [findsAny], when you want the finder to find one or more candidates.
  ///  * [findsOne], when you want the finder to find exactly one candidates.
  ///  * [findsAtLeast], when you want the finder to find at least a specific number of candidates.
  void findsExactly(int count) {
    legacyMatcher(flutter_matcher.findsExactly(count));
  }

  /// Asserts that the [FinderBase] locates at least the given number of candidates.
  ///
  /// ## Sample code
  ///
  /// ```dart
  /// check(find.text('Save')).findsAtLeast(2)));
  /// ```
  ///
  /// See also:
  ///
  ///  * [findsNothing], when you want the finder to not find anything.
  ///  * [findsAny], when you want the finder to find one or more candidates.
  ///  * [findsOne], when you want the finder to find exactly one candidates.
  ///  * [findsExactly], when you want the finder to find a specific number of candidates.
  void findsAtLeast(int count) {
    legacyMatcher(flutter_matcher.findsAtLeast(count));
  }
}
