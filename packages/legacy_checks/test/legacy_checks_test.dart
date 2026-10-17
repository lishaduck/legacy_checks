import 'package:checks/checks.dart';
import 'package:legacy_checks/legacy_checks.dart';
import 'package:matcher/expect.dart' as matcher show completion, equals;
import 'package:matcher/src/expect/async_matcher.dart' show AsyncMatcher;
import 'package:test/test.dart';

void main() {
  test('legacyMatcher', () {
    check(42).legacyMatcher(matcher.equals(42));
  });

  test('legacyMatcherAsync', () async {
    await check(Future.value(42))
        .legacyMatcherAsync(matcher.completion(42) as AsyncMatcher);
  });
}
