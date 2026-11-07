import 'package:checks/checks.dart';
import 'package:checks/context.dart';
import 'package:legacy_checks/legacy_checks.dart';
import 'package:matcher/expect.dart' as matcher show completion, equals;
import 'package:matcher/matcher.dart' show Description, Matcher;
import 'package:matcher/src/expect/async_matcher.dart' show AsyncMatcher;
import 'package:test/test.dart' show TestFailure, test;

void main() {
  test('legacyMatcher', () {
    check(42).legacyMatcher(matcher.equals(42));
  });

  test('legacyMatcher preserves diagnostics and supports negation', () {
    const legacy = _Equals42();
    final failure = softCheck<int>(41, (s) => s.legacyMatcher(legacy))!;
    check(failure.rejection.actual).deepEquals(['<41>']);
    check(
      failure.rejection.which,
    ).isNotNull().deepEquals(['differs by 1', 'outside tolerance']);
    check(
      describe<int>((s) => s.legacyMatcher(legacy)),
    ).deepEquals(['  equals 42', '  with no tolerance']);

    check(41).not((s) => s.legacyMatcher(legacy));
    final negated = softCheck<int>(
      42,
      (s) => s.not((s) => s.legacyMatcher(legacy)),
    )!;
    check(negated.rejection.actual).deepEquals(['<42>']);
    check(negated.rejection.which).isNotNull().contains('    equals 42');
    check(() => check(42).legacyMatcher(_AsyncResult(null, deferred: false)))
        .throws<ArgumentError>()
        .has((e) => e.message, 'message')
        .isA<String>()
        .contains('legacyMatcherAsync');
  });

  test('legacyMatcherAsync', () async {
    await check(
      Future.value(42),
    ).legacyMatcherAsync(matcher.completion(42) as AsyncMatcher);
  });

  test('legacyMatcherAsync handles immediate and future results', () async {
    for (final deferred in [false, true]) {
      for (final result in [
        null,
        '',
        'wrong value\r\ntry again\rlast line\n',
      ]) {
        final legacy = _AsyncResult(result, deferred: deferred);
        final failure = await softCheckAsync<int>(
          41,
          (s) => s.legacyMatcherAsync(legacy),
        );
        if (result == null) {
          check(failure).isNull();
        } else {
          check(failure).isNotNull();
          check(failure!.rejection.actual).deepEquals(['<41>']);
          final which = check(failure.rejection.which).isNotNull();
          if (result.isEmpty) {
            which.isEmpty();
          } else {
            which.deepEquals(['wrong value', 'try again', 'last line']);
          }
          await check(
            check(41).legacyMatcherAsync(legacy),
          ).throws<TestFailure>();
        }
        check(
          await describeAsync<int>((s) => s.legacyMatcherAsync(legacy)),
        ).deepEquals(['  an accepted value', '  after matching']);
      }
    }
  });
}

class _Equals42 extends Matcher {
  const _Equals42();

  @override
  bool matches(Object? item, Map<Object?, Object?> matchState) {
    matchState['difference'] = 42 - (item! as int);
    return item == 42;
  }

  @override
  Description describe(Description description) =>
      description.add('equals 42\r\nwith no tolerance');

  @override
  Description describeMismatch(
    Object? item,
    Description mismatchDescription,
    Map<Object?, Object?> matchState,
    bool verbose,
  ) => mismatchDescription.add(
    'differs by ${matchState['difference']}\r\noutside tolerance',
  );
}

class _AsyncResult extends AsyncMatcher {
  _AsyncResult(this.result, {required this.deferred});

  final String? result;
  final bool deferred;

  @override
  dynamic matchAsync(Object? item) =>
      deferred ? Future<String?>.value(result) : result;

  @override
  Description describe(Description description) =>
      description.add('an accepted value\r\nafter matching');
}
