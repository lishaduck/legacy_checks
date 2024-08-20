import 'package:checks/checks.dart';
import 'package:legacy_checks/legacy_checks.dart';
import 'package:matcher/matcher.dart' as matcher;
import 'package:test/test.dart';

void main() {
  test('Example', () {
    check(42).legacyMatcher(matcher.equals(42));
  });
}
