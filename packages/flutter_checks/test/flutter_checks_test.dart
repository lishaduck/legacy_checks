import 'dart:ui' show SemanticsInputType, SemanticsRole;

import 'package:checks/checks.dart';
import 'package:checks/context.dart' show softCheck;
import 'package:flutter/semantics.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_checks/flutter_checks.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'partial semantics ignores omitted fields but honors explicit false',
    () {
      final node = SemanticsNode()
        ..updateWith(
          config: SemanticsConfiguration()
            ..label = 'Email'
            ..textDirection = TextDirection.ltr
            ..isSelected = true
            ..isRequired = true
            ..onTap = () {}
            ..validationResult = SemanticsValidationResult.invalid,
        );

      check(node).isSemantics(label: 'Email');
      // Exercise the deprecated compatibility alias.
      // ignore: deprecated_member_use_from_same_package
      check(node).containsSemantics(label: 'Email');
      check(node).isSemantics(
        hasSelectedState: true,
        isSelected: true,
        hasRequiredState: true,
        isRequired: true,
        hasTapAction: true,
      );
      final rejections = <void Function(Subject<SemanticsNode>)>[
        (s) => s.isSemantics(hasSelectedState: false),
        (s) => s.isSemantics(isSelected: false),
        (s) => s.isSemantics(hasRequiredState: false),
        (s) => s.isSemantics(isRequired: false),
        (s) => s.isSemantics(hasTapAction: false),
        // Exercise the deprecated compatibility alias.
        // ignore: deprecated_member_use_from_same_package
        (s) => s.containsSemantics(isSelected: false),
        // Exercise the deprecated compatibility alias.
        // ignore: deprecated_member_use_from_same_package
        (s) => s.containsSemantics(hasTapAction: false),
        (s) => s.matchesSemantics(label: 'Email'),
      ];
      for (final condition in rejections) {
        check(softCheck(node, condition)).isNotNull();
      }
      check(node).matchesSemantics(
        label: 'Email',
        hasSelectedState: true,
        isSelected: true,
        hasRequiredState: true,
        isRequired: true,
        hasTapAction: true,
        validationResult: SemanticsValidationResult.invalid,
      );
    },
  );

  test('semantics metadata is checked by both exact and partial wrappers', () {
    final node = SemanticsNode()
      ..updateWith(
        config: SemanticsConfiguration()
          ..label = 'Quantity'
          ..textDirection = TextDirection.ltr
          ..validationResult = SemanticsValidationResult.invalid
          ..inputType = SemanticsInputType.text
          ..minValue = '2'
          ..maxValue = '9'
          ..role = SemanticsRole.tab
          ..traversalParentIdentifier = 'parent',
      );

    check(node).isSemantics(
      label: 'Quantity',
      validationResult: SemanticsValidationResult.invalid,
      inputType: SemanticsInputType.text,
      minValue: '2',
      maxValue: '9',
      role: SemanticsRole.tab,
      traversalParentIdentifier: 'parent',
    );
    check(node).matchesSemantics(
      label: 'Quantity',
      validationResult: SemanticsValidationResult.invalid,
      inputType: SemanticsInputType.text,
      minValue: '2',
      maxValue: '9',
      role: SemanticsRole.tab,
      traversalParentIdentifier: 'parent',
    );

    final rejections = <void Function(Subject<SemanticsNode>)>[
      (s) => s.isSemantics(validationResult: SemanticsValidationResult.valid),
      (s) => s.isSemantics(inputType: SemanticsInputType.email),
      (s) => s.isSemantics(minValue: '9'),
      (s) => s.isSemantics(maxValue: '2'),
      (s) => s.isSemantics(role: SemanticsRole.dialog),
      (s) => s.matchesSemantics(),
      (s) =>
          s.matchesSemantics(validationResult: SemanticsValidationResult.valid),
      (s) => s.matchesSemantics(
        validationResult: SemanticsValidationResult.invalid,
        inputType: SemanticsInputType.email,
      ),
      (s) => s.matchesSemantics(
        validationResult: SemanticsValidationResult.invalid,
        minValue: '9',
      ),
      (s) => s.matchesSemantics(
        validationResult: SemanticsValidationResult.invalid,
        maxValue: '2',
      ),
      (s) => s.matchesSemantics(
        validationResult: SemanticsValidationResult.invalid,
        role: SemanticsRole.dialog,
      ),
    ];
    for (final condition in rejections) {
      check(softCheck(node, condition)).isNotNull();
    }
  });

  test('exact semantics rejects unspecified selected and required state', () {
    for (final config in [
      SemanticsConfiguration()..isSelected = false,
      SemanticsConfiguration()..isRequired = false,
      SemanticsConfiguration()..onTap = () {},
    ]) {
      final node = SemanticsNode()..updateWith(config: config);
      check(node).isSemantics();
      // Exercise the deprecated compatibility alias.
      // ignore: deprecated_member_use_from_same_package
      check(node).containsSemantics();
      check(softCheck(node, (s) => s.matchesSemantics())).isNotNull();
    }
    final empty = SemanticsNode()..updateWith(config: SemanticsConfiguration());
    check(empty).matchesSemantics();
  });

  testWidgets('system text scaler checks provenance and optional scale', (
    tester,
  ) async {
    tester.platformDispatcher.textScaleFactorTestValue = 1.7;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    late TextScaler scaler;
    await tester.pumpWidget(
      MediaQuery.fromView(
        view: tester.view,
        child: Builder(
          builder: (context) {
            scaler = MediaQuery.textScalerOf(context);
            return const SizedBox();
          },
        ),
      ),
    );
    check(scaler).isSystemTextScaler();
    check(scaler).isSystemTextScaler(withScaleFactor: 1.7);
    check(softCheck(scaler, (s) => s.isSystemTextScaler(withScaleFactor: 1.2)))
        .isNotNull();
    check(
      softCheck<TextScaler>(
        const TextScaler.linear(1.7),
        (s) => s.isSystemTextScaler(),
      ),
    ).isNotNull();
  });

  testWidgets('clip wrappers check the supplied radius and shape', (
    tester,
  ) async {
    const radius = BorderRadius.only(topLeft: Radius.circular(7));
    const otherRadius = BorderRadius.all(Radius.circular(3));
    await tester.pumpWidget(
      const ClipRRect(
        borderRadius: radius,
        child: SizedBox(width: 20, height: 30),
      ),
    );
    check(find.byType(ClipRRect)).clipsWithBoundingRRect(borderRadius: radius);
    check(
      softCheck(
        find.byType(ClipRRect),
        (s) => s.clipsWithBoundingRRect(borderRadius: otherRadius),
      ),
    ).isNotNull();

    const shape = RoundedRectangleBorder(borderRadius: radius);
    await tester.pumpWidget(
      const ClipPath(
        clipper: ShapeBorderClipper(shape: shape),
        child: SizedBox(width: 20, height: 30),
      ),
    );
    check(find.byType(ClipPath)).clipsWithShapeBorder(shape: shape);
    check(
      softCheck(
        find.byType(ClipPath),
        (s) => s.clipsWithShapeBorder(shape: const CircleBorder()),
      ),
    ).isNotNull();
  });

  testWidgets('announcement wrapper checks message and optional metadata', (
    tester,
  ) async {
    await SemanticsService.sendAnnouncement(
      tester.view,
      'Saved',
      TextDirection.rtl,
      assertiveness: Assertiveness.assertive,
    );
    final announcement = tester.takeAnnouncements().single;
    check(announcement).isAccessibilityAnnouncement('Saved');
    check(announcement).isAccessibilityAnnouncement(
      'Saved',
      textDirection: TextDirection.rtl,
      assertiveness: Assertiveness.assertive,
      viewId: tester.view.viewId,
    );
    final rejections =
        <void Function(Subject<CapturedAccessibilityAnnouncement>)>[
          (s) => s.isAccessibilityAnnouncement('Deleted'),
          (s) => s.isAccessibilityAnnouncement(
            'Saved',
            textDirection: TextDirection.ltr,
          ),
          (s) => s.isAccessibilityAnnouncement(
            'Saved',
            assertiveness: Assertiveness.polite,
          ),
          (s) => s.isAccessibilityAnnouncement(
            'Saved',
            viewId: tester.view.viewId + 1,
          ),
        ];
    for (final condition in rejections) {
      check(softCheck(announcement, condition)).isNotNull();
    }
  });
}
