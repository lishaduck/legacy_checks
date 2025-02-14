/// Wrap the `flutter_test` package to provide a modern, type-safe API for testing Flutter widgets.
///
/// @docImport 'package:flutter_test/flutter_test.dart';
library;

import 'dart:ui' show Color, Image, Offset, Path, Rect, Size, TextDirection;

import 'package:checks/checks.dart';
import 'package:flutter/foundation.dart'
    show
        DiagnosticableTree,
        describeIdentity,
        precisionErrorTolerance,
        shortHash;
import 'package:flutter/material.dart' show Card;
import 'package:flutter/painting.dart'
    show BorderRadius, BoxShape, ColorSwatch, ShapeBorder;
import 'package:flutter/rendering.dart'
    show
        RenderClipOval,
        RenderClipPath,
        RenderClipRRect,
        RenderClipRect,
        RenderPhysicalModel,
        RenderPhysicalShape,
        ShapeBorderClipper;
import 'package:flutter/semantics.dart'
    show AttributedString, CustomSemanticsAction, SemanticsNode;
import 'package:flutter/services.dart' show MethodCall;
import 'package:flutter/widgets.dart' show Offstage, RepaintBoundary;
import 'package:flutter_test/flutter_test.dart'
    as flutter_matcher
    show
        GoldenFileComparator,
        LocalFileComparator,
        MatchesGoldenFile,
        clipsWithBoundingRect,
        containsSemantics,
        coversSameAreaAs,
        doesNotMeetGuideline,
        equalsIgnoringHashCodes,
        findsAny,
        findsAtLeast,
        findsExactly,
        findsNothing,
        findsOne,
        goldenFileComparator,
        hasAGoodToStringDeep,
        hasNoImmediateClip,
        hasOneLineDescription,
        isInCard,
        isMethodCall,
        isOffstage,
        isOnstage,
        isSameColorAs,
        isSameColorSwatchAs,
        matchesReferenceImage,
        matchesSemantics,
        matrix3MoreOrLessEquals,
        matrixMoreOrLessEquals,
        meetsGuideline,
        moreOrLessEquals,
        offsetMoreOrLessEquals,
        rectMoreOrLessEquals,
        rendersOnPhysicalModel,
        rendersOnPhysicalShape,
        within;
import 'package:flutter_test/flutter_test.dart'
    as flutter_test
    show
        AccessibilityGuideline,
        CommonFinders,
        DistanceFunction,
        Finder,
        FinderBase,
        SemanticsController,
        WidgetTester,
        androidTapTargetGuideline,
        colorEpsilon,
        iOSTapTargetGuideline,
        labeledTapTargetGuideline,
        textContrastGuideline;
import 'package:legacy_checks/legacy_checks.dart';
import 'package:matcher/expect.dart' as matcher show Matcher, closeTo;
import 'package:vector_math/vector_math_64.dart' show Matrix3, Matrix4;

/// Enable accessibility checks.
///
///
/// {@template pub.flutter_checks.legacy_matcher_disclosure}
/// Under the hood, this extension uses the [LegacyMatcher] extension to support legacy matchers.
/// {@endtemplate}
extension AccessibilityChecks on Subject<flutter_test.WidgetTester> {
  /// Asserts that the currently rendered widget meets the provided accessibility
  /// `guideline`.
  ///
  /// This matcher requires the result to be awaited and for semantics to be
  /// enabled first.
  ///
  /// ## Sample code
  ///
  /// ```dart
  /// testWidgets('containsSemantics', (flutter_test.WidgetTester tester) async {
  ///   final SemanticsHandle handle = tester.ensureSemantics();
  ///   // ...
  ///   await check(tester).meetsGuideline(textContrastGuideline);
  ///   handle.dispose();
  /// });
  /// ```
  ///
  /// Supported [flutter_test.AccessibilityGuideline]s include:
  ///
  ///   - [flutter_test.androidTapTargetGuideline], for Android minimum tappable area guidelines.
  ///   - [flutter_test.iOSTapTargetGuideline], for iOS minimum tappable area guidelines.
  ///   - [flutter_test.textContrastGuideline], for WCAG minimum text contrast guidelines.
  ///   - [flutter_test.labeledTapTargetGuideline], for enforcing labels on tappable areas.
  ///   - [flutter_matcher.meetsGuideline], the backing matcher.
  Future<void> meetsGuideline(
    flutter_test.AccessibilityGuideline guideline,
  ) async {
    await legacyMatcherAsync(flutter_matcher.meetsGuideline(guideline));
  }

  /// The inverse check of [meetsGuideline].
  ///
  /// This is needed because [not] does not compose with asynchronous expections.
  Future<void> doesNotMeetGuideline(
    flutter_test.AccessibilityGuideline guideline,
  ) async {
    await legacyMatcherAsync(flutter_matcher.doesNotMeetGuideline(guideline));
  }
}

/// Enable [flutter_test.FinderBase] checks.
///
/// {@macro pub.flutter_checks.legacy_matcher_disclosure}
extension FinderBaseChecks<T> on Subject<flutter_test.FinderBase<T>> {
  /// Asserts that the [flutter_test.FinderBase] matches nothing in the available candidates.
  ///
  /// ## Sample code
  ///
  /// ```dart
  /// check(find.text('Save')).findsNothing();
  /// ```
  ///
  /// See also:
  ///
  ///  - [findsAny], when you want the finder to find one or more candidates.
  ///  - [findsOne], when you want the finder to find exactly one candidate.
  ///  - [findsExactly], when you want the finder to find a specific number of candidates.
  ///  - [findsAtLeast], when you want the finder to find at least a specific number of candidates.
  ///  - [flutter_matcher.findsNothing], the backing matcher.
  void findsNothing() {
    legacyMatcher(flutter_matcher.findsNothing);
  }

  /// Asserts that the [flutter_test.FinderBase] locates at least one matching candidate.
  ///
  /// ## Sample code
  ///
  /// ```dart
  /// check(find.text('Save')).findsAny();
  /// ```
  ///
  /// See also:
  ///
  ///  - [findsNothing], when you want the finder to not find anything.
  ///  - [findsOne], when you want the finder to find exactly one candidate.
  ///  - [findsExactly], when you want the finder to find a specific number of candidates.
  ///  - [findsAtLeast], when you want the finder to find at least a specific number of candidates.
  ///  - [flutter_matcher.findsAny], the backing matcher.
  void findsAny() {
    legacyMatcher(flutter_matcher.findsAny);
  }

  /// Asserts that the [flutter_test.FinderBase] finds exactly one matching candidate.
  ///
  /// ## Sample code
  ///
  /// ```dart
  /// check(find.text('Save')).findsOne();
  /// ```
  ///
  /// See also:
  ///
  ///  - [findsNothing], when you want the finder to not find anything.
  ///  - [findsAny], when you want the finder to find one or more candidates.
  ///  - [findsExactly], when you want the finder to find a specific number candidates.
  ///  - [findsAtLeast], when you want the finder to find at least a specific number of candidates.
  ///  - [flutter_matcher.findsOne], the backing matcher.
  void findsOne() {
    legacyMatcher(flutter_matcher.findsOne);
  }

  /// Asserts that the [flutter_test.FinderBase] locates the specified number of candidates.
  ///
  /// ## Sample code
  ///
  /// ```dart
  /// check(find.text('Save')).findsExactly(2)));
  /// ```
  ///
  /// See also:
  ///
  ///  - [findsNothing], when you want the finder to not find anything.
  ///  - [findsAny], when you want the finder to find one or more candidates.
  ///  - [findsOne], when you want the finder to find exactly one candidates.
  ///  - [findsAtLeast], when you want the finder to find at least a specific number of candidates.
  ///  - [flutter_matcher.findsExactly], the backing matcher.
  void findsExactly(int count) {
    legacyMatcher(flutter_matcher.findsExactly(count));
  }

  /// Asserts that the [flutter_test.FinderBase] locates at least the given number of candidates.
  ///
  /// ## Sample code
  ///
  /// ```dart
  /// check(find.text('Save')).findsAtLeast(2)));
  /// ```
  ///
  /// See also:
  ///
  ///  - [findsNothing], when you want the finder to not find anything.
  ///  - [findsAny], when you want the finder to find one or more candidates.
  ///  - [findsOne], when you want the finder to find exactly one candidates.
  ///  - [findsExactly], when you want the finder to find a specific number of candidates.
  ///  - [flutter_matcher.findsAtLeast], the backing matcher.
  void findsAtLeast(int count) {
    legacyMatcher(flutter_matcher.findsAtLeast(count));
  }
}

/// Enable [flutter_test.Finder] checks.
///
/// {@macro pub.flutter_checks.legacy_matcher_disclosure}
extension FinderChecks on Subject<flutter_test.Finder> {
  /// Asserts that the [flutter_test.Finder] locates a single widget that has at
  /// least one [Offstage] widget ancestor.
  ///
  /// It's important to use a full finder,
  /// since by default finders exclude offstage widgets.
  ///
  /// ## Sample code
  ///
  /// ```dart
  /// check(find.text('Save', skipOffstage: false)).isOffstage();
  /// ```
  ///
  /// See also:
  ///
  ///  - [isOnstage], the opposite.
  ///  - [flutter_matcher.isOffstage], the backing matcher.
  void isOffstage() {
    legacyMatcher(flutter_matcher.isOffstage);
  }

  /// Asserts that the [flutter_test.Finder] locates a single widget that has no
  /// [Offstage] widget ancestors.
  ///
  /// ## Sample code
  ///
  /// ```dart
  /// check(find.text('Save')).isOnstage();
  /// ```
  ///
  /// See also:
  ///
  ///  - [isOffstage], the opposite.
  ///  - [flutter_matcher.isOnstage], the backing matcher.
  void isOnstage() {
    legacyMatcher(flutter_matcher.isOnstage);
  }

  /// Asserts that the [flutter_test.Finder] locates a single widget that has at
  /// least one [Card] widget ancestor.
  ///
  /// Note that there is not a corresponding `isNotInCard` matcher,
  /// since you can use [not] to invert a check.
  ///
  /// See also:
  ///
  ///  - [flutter_matcher.isInCard], the backing matcher.
  void isInCard() {
    legacyMatcher(flutter_matcher.isInCard);
  }

  /// Asserts that an [flutter_test.Finder] matches the
  /// golden image file identified by [key], with an optional [version] number.
  ///
  /// The [flutter_test.Finder] must match exactly one widget and
  /// the rendered image of the first [RepaintBoundary] ancestor of the widget is
  /// treated as the image for the widget. As such, you may choose to wrap a test
  /// widget in a [RepaintBoundary] to specify a particular focus for the test.
  ///
  /// {@template pub.flutter_checks.matchesGoldenFile}
  /// The [version] is a number that can be used to differentiate historical
  /// golden files. This parameter is optional.
  ///
  /// ## Golden File Testing
  ///
  /// The term __golden file__ refers to a master image that is considered the true
  /// rendering of a given widget, state, application, or other visual
  /// representation you have chosen to capture.
  ///
  /// The master golden image files that are tested against can be created or
  /// updated by running `flutter test --update-goldens` on the test.
  ///
  /// {@tool snippet}
  /// Sample invocations of [matchesGoldenFile].
  ///
  /// ```dart
  /// await check(find.text('Save')).matchesGoldenFile('save.png');
  /// await check(image).matchesGoldenFile('save.png');
  /// await check(imageFuture).matchesGoldenFile('save.png', version: 2);
  /// await check(find.byType(MyWidget)).matchesGoldenFile(matchesGoldenFile('goldens/myWidget.png'));
  /// ```
  /// {@end-tool}
  /// {@endtemplate}
  ///
  /// {@template pub.flutter_checks.matchesGoldenFile.custom_fonts}
  /// ## Including Fonts
  ///
  /// Custom fonts may render differently across different platforms, or
  /// between different versions of Flutter. For example, a golden file generated
  /// on Windows with fonts will likely differ from the one produced by another
  /// operating system. Even on the same platform, if the generated golden is
  /// tested with a different Flutter version, the test may fail and require an
  /// updated image.
  ///
  /// By default, the Flutter framework uses a font called 'Ahem' which shows
  /// squares instead of characters, however, it is possible to render images using
  /// custom fonts. For example, this is how to load the 'Roboto' font for a
  /// golden test:
  ///
  /// {@tool snippet}
  /// How to load a custom font for golden images.
  /// ```dart
  /// testWidgets('Creating a golden image with a custom font', (flutter_test.WidgetTester tester) async {
  ///   // Assuming the 'Roboto.ttf' file is declared in the pubspec.yaml file
  ///   final Future<ByteData> font = rootBundle.load('path/to/font-file/Roboto.ttf');
  ///
  ///   final FontLoader fontLoader = FontLoader('Roboto')..addFont(font);
  ///   await fontLoader.load();
  ///
  ///   await tester.pumpWidget(const MyWidget());
  ///
  ///   await check(find.byType(MyWidget)).matchesGoldenFile('myWidget.png');
  /// });
  /// ```
  /// {@end-tool}
  ///
  /// The example above loads the desired font only for that specific test. To load
  /// a font for all golden file tests, the `FontLoader.load()` call could be
  /// moved in the `flutter_test_config.dart`. In this way, the font will always be
  /// loaded before a test:
  ///
  /// {@tool snippet}
  /// Loading a custom font from the flutter_test_config.dart file.
  /// ```dart
  /// Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  ///   setUpAll(() async {
  ///     final FontLoader fontLoader = FontLoader('SomeFont')..addFont(someFont);
  ///     await fontLoader.load();
  ///   });
  ///
  ///   await testMain();
  /// }
  /// ```
  /// {@end-tool}
  /// {@endtemplate}
  ///
  /// See also:
  ///
  ///  - [matchesGoldenFileStringPath], which is the same but takes a [String] instead of a [Uri].
  ///  - [flutter_matcher.goldenFileComparator], which acts as the backend for this matcher.
  ///  - [flutter_matcher.LocalFileComparator], which is the default [flutter_matcher.GoldenFileComparator]
  ///    implementation for `flutter test`.
  ///  - [matchesReferenceImage], which should be used instead if you want to
  ///    verify that two different code paths create identical images.
  ///  - [flutter_test] for a discussion of test configurations, whereby callers
  ///    may swap out the backend for this matcher.
  ///  - [ImageChecks.matchesGoldenFile], which is for [Image]s.
  ///  - [FutureImageChecks.matchesGoldenFile], which is for [Future<Image>]s.
  ///  - [flutter_matcher.MatchesGoldenFile], the backing matcher.
  Future<void> matchesGoldenFile(Uri key, {int? version}) async {
    await legacyMatcherAsync(flutter_matcher.MatchesGoldenFile(key, version));
  }

  /// Asserts that an [flutter_test.Finder] matches the
  /// golden image file identified by [key], with an optional [version] number.
  ///
  /// The [flutter_test.Finder] must match exactly one widget and
  /// the rendered image of the first [RepaintBoundary] ancestor of the widget is
  /// treated as the image for the widget. As such, you may choose to wrap a test
  /// widget in a [RepaintBoundary] to specify a particular focus for the test.
  ///
  /// {@macro pub.flutter_checks.matchesGoldenFile}
  ///
  /// {@macro pub.flutter_checks.matchesGoldenFile.custom_fonts}
  ///
  /// See also:
  ///
  ///  - [matchesGoldenFile], which is the same but takes a [Uri] instead of a [String].
  ///  - [flutter_matcher.goldenFileComparator], which acts as the backend for this matcher.
  ///  - [flutter_matcher.LocalFileComparator], which is the default [flutter_matcher.GoldenFileComparator]
  ///    implementation for `flutter test`.
  ///  - [matchesReferenceImage], which should be used instead if you want to
  ///    verify that two different code paths create identical images.
  ///  - [flutter_test] for a discussion of test configurations, whereby callers
  ///    may swap out the backend for this matcher.
  ///  - [ImageChecks.matchesGoldenFileStringPath], which is for [Image]s.
  ///  - [FutureImageChecks.matchesGoldenFileStringPath], which is for [Future<Image>]s.
  ///  - [flutter_matcher.MatchesGoldenFile.forStringPath], the backing matcher.
  Future<void> matchesGoldenFileStringPath(String key, {int? version}) async {
    await legacyMatcherAsync(
      flutter_matcher.MatchesGoldenFile.forStringPath(key, version),
    );
  }

  /// Asserts that a [flutter_test.Finder] matches a
  /// reference image identified by [image].
  ///
  /// The [flutter_test.Finder] must match exactly one widget and
  /// the rendered image of the first [RepaintBoundary] ancestor of the widget is
  /// treated as the image for the widget.
  ///
  /// {@template pub.flutter_checks.matchesReferenceImage}
  /// ## Sample code
  ///
  /// ```dart
  /// testWidgets('matchesReferenceImage', (WidgetTester tester) async {
  ///   final ui.Paint paint = ui.Paint()
  ///     ..style = ui.PaintingStyle.stroke
  ///     ..strokeWidth = 1.0;
  ///   final ui.PictureRecorder recorder = ui.PictureRecorder();
  ///   final ui.Canvas pictureCanvas = ui.Canvas(recorder);
  ///   pictureCanvas.drawCircle(Offset.zero, 20.0, paint);
  ///   final ui.Picture picture = recorder.endRecording();
  ///   addTearDown(picture.dispose);
  ///   ui.Image referenceImage = await picture.toImage(50, 50);
  ///   addTearDown(referenceImage.dispose);
  ///
  ///   await check(find.text('Save')).matchesReferenceImage(referenceImage);
  ///   await check(image).matchesReferenceImage(referenceImage);
  ///   await check(imageFuture).matchesReferenceImage(referenceImage);
  /// });
  /// ```
  /// {@endtemplate}
  ///
  /// See also:
  ///
  ///  - [matchesGoldenFile], which should be used instead if you need to verify
  ///    that a [flutter_test.Finder] matches a golden image.
  ///  - [flutter_matcher.matchesReferenceImage], the backing matcher.
  Future<void> matchesReferenceImage(Image image) async {
    await legacyMatcherAsync(flutter_matcher.matchesReferenceImage(image));
  }

  /// Asserts that a [flutter_test.Finder] locates a single object whose root RenderObject
  /// is a [RenderClipRect] with no clipper set, or an equivalent
  /// [RenderClipPath].
  ///
  /// See also:
  ///
  ///  - [flutter_matcher.clipsWithBoundingRect], the backing matcher.
  void clipsWithBoundingRect() {
    legacyMatcher(flutter_matcher.clipsWithBoundingRect);
  }

  /// Asserts that a [flutter_test.Finder] locates a single object whose root RenderObject is
  /// not a [RenderClipRect], [RenderClipRRect], [RenderClipOval], or
  /// [RenderClipPath].
  ///
  /// See also:
  ///
  ///  - [flutter_matcher.hasNoImmediateClip], the backing matcher.
  void hasNoImmediateClip() {
    legacyMatcher(flutter_matcher.hasNoImmediateClip);
  }

  /// Asserts that a [flutter_test.Finder] locates a single object whose root RenderObject
  /// is a [RenderPhysicalModel] or a [RenderPhysicalShape].
  ///
  ///  - If the render object is a [RenderPhysicalModel]
  ///    - If [shape] is non null asserts that [RenderPhysicalModel.shape] is equal to
  ///   [shape].
  ///    - If [borderRadius] is non null asserts that [RenderPhysicalModel.borderRadius] is equal to
  ///   [borderRadius].
  ///     - If [elevation] is non null asserts that [RenderPhysicalModel.elevation] is equal to
  ///   [elevation].
  ///  - If the render object is a [RenderPhysicalShape]
  ///    - If [borderRadius] is non null asserts that the shape is a rounded
  ///   rectangle with this radius.
  ///    - If [borderRadius] is null, asserts that the shape is equivalent to
  ///   [shape].
  ///    - If [elevation] is non null asserts that [RenderPhysicalModel.elevation] is equal to
  ///   [elevation].
  ///
  /// See also:
  ///
  ///  - [flutter_matcher.rendersOnPhysicalModel], the backing matcher.
  void rendersOnPhysicalModel(
    BoxShape? shape,
    BorderRadius? borderRadius,
    double? elevation,
  ) {
    legacyMatcher(
      flutter_matcher.rendersOnPhysicalModel(
        shape: shape,
        borderRadius: borderRadius,
        elevation: elevation,
      ),
    );
  }

  /// Asserts that a [flutter_test.Finder] locates a single object whose root RenderObject
  /// is [RenderPhysicalShape] that uses a [ShapeBorderClipper] that clips to
  /// [shape] as its clipper.
  /// If [elevation] is non null asserts that [RenderPhysicalShape.elevation] is
  /// equal to [elevation].
  ///
  /// See also:
  ///
  ///  - [flutter_matcher.rendersOnPhysicalShape], the backing matcher.
  void rendersOnPhysicalShape({required ShapeBorder shape, double? elevation}) {
    legacyMatcher(
      flutter_matcher.rendersOnPhysicalShape(
        shape: shape,
        elevation: elevation,
      ),
    );
  }
}

/// Enable [Color] checks.
///
/// {@macro pub.flutter_checks.legacy_matcher_disclosure}
extension ColorChecks on Subject<Color> {
  /// Asserts that the object represents the same color as [color] when used to paint.
  ///
  /// Specifically this matcher checks the object is of type [Color] and its color
  /// components fall below the delta specified by [threshold].
  ///
  /// See also:
  ///  - [flutter_matcher.isSameColorAs], the backing matcher.
  void isSameColorAs(
    Color color, {
    double threshold = flutter_test.colorEpsilon,
  }) {
    legacyMatcher(flutter_matcher.isSameColorAs(color, threshold: threshold));
  }
}

/// Enable [ColorSwatch] checks.
///
/// {@macro pub.flutter_checks.legacy_matcher_disclosure}
extension ColorSwatchChecks<T> on Subject<ColorSwatch<T>> {
  /// Asserts that the object represents the same color swatch as [color] when
  /// used to paint.
  ///
  /// Specifically this matcher checks the object is of type [ColorSwatch] and its
  /// color components fall below the delta specified by [threshold].
  ///
  /// Note: This doesn't recurse into the swatches [Color] type, instead treating
  /// them as [Color]s.
  void isSameColorSwatchAs(
    ColorSwatch<T> color, {
    double threshold = flutter_test.colorEpsilon,
  }) {
    legacyMatcher(
      flutter_matcher.isSameColorSwatchAs(color, threshold: threshold),
    );
  }
}

/// Enable [Object] checks.
///
/// {@macro pub.flutter_checks.legacy_matcher_disclosure}
extension ObjectChecks<T> on Subject<T> {
  /// Asserts that an object's toString() is a plausible one-line description.
  ///
  /// Specifically, this matcher checks that the string does not contains newline
  /// characters, and does not have leading or trailing whitespace, is not
  /// empty, and does not contain the default `Instance of ...` string.
  ///
  /// See also:
  ///  - [flutter_matcher.hasOneLineDescription], the backing matcher.
  void hasOneLineDescription() {
    legacyMatcher(flutter_matcher.hasOneLineDescription);
  }

  /// Asserts that an object's toStringDeep() is a plausible multiline
  /// description.
  ///
  /// Specifically, this matcher checks that an object's
  /// `toStringDeep(prefixLineOne, prefixOtherLines)`:
  ///
  ///  - Does not have leading or trailing whitespace.
  ///  - Does not contain the default `Instance of ...` string.
  ///  - The last line has characters other than tree connector characters and
  ///    whitespace. For example: the line ` │ ║ ╎` has only tree connector
  ///    characters and whitespace.
  ///  - Does not contain lines with trailing white space.
  ///  - Has multiple lines.
  ///  - The first line starts with `prefixLineOne`
  ///  - All subsequent lines start with `prefixOtherLines`.
  ///
  /// See also:
  ///  - [flutter_matcher.hasAGoodToStringDeep], the backing matcher.
  void hasAGoodToStringDeep() {
    legacyMatcher(flutter_matcher.hasAGoodToStringDeep);
  }

  /// Asserts that two values are within a certain distance from each other.
  ///
  /// The distance is computed by a [flutter_test.DistanceFunction].
  ///
  /// If `distanceFunction` is null, a standard distance function is used for the
  /// [T] generic argument. Standard functions are defined for the following
  /// types:
  ///
  ///  - [Color], whose distance is the maximum component-wise delta.
  ///  - [Offset], whose distance is the Euclidean distance computed using the
  ///    method [Offset.distance].
  ///  - [Rect], whose distance is the maximum component-wise delta.
  ///  - [Size], whose distance is the [Offset.distance] of the offset computed as
  ///    the difference between two sizes.
  ///  - [int], whose distance is the absolute difference between two integers.
  ///  - [double], whose distance is the absolute difference between two doubles.
  ///
  /// See also:
  ///
  ///  - [DoubleChecks.moreOrLessEquals], which is similar to this function, but specializes in
  ///    [double]s and has an optional `epsilon` parameter.
  ///  - [RectChecks.rectMoreOrLessEquals], which is similar to this function, but
  ///    specializes in [Rect]s and has an optional `epsilon` parameter.
  ///  - [flutter_matcher.within], the backing matcher.
  ///  - [matcher.closeTo], a [matcher.Matcher] which specializes in numbers only.
  void within({
    required num distance,
    required T from,
    flutter_test.DistanceFunction<T>? distanceFunction,
  }) {
    legacyMatcher(
      flutter_matcher.within(
        distance: distance,
        from: from,
        distanceFunction: distanceFunction,
      ),
    );
  }
}

/// Enable [double] checks.
///
/// {@macro pub.flutter_checks.legacy_matcher_disclosure}
extension DoubleChecks on Subject<double> {
  /// Asserts that two [double]s are equal, within some tolerated error.
  ///
  /// {@template pub.flutter_checks.moreOrLessEquals}
  /// Two values are considered equal if the difference between them is within
  /// [precisionErrorTolerance] of the larger one. This is an arbitrary value
  /// which can be adjusted using the `epsilon` argument. This matcher is intended
  /// to compare floating point numbers that are the result of different sequences
  /// of operations, such that they may have accumulated slightly different
  /// errors.
  /// {@endtemplate}
  ///
  /// See also:
  ///
  ///  - [RectChecks.rectMoreOrLessEquals] and [OffsetChecks.offsetMoreOrLessEquals], which do something
  ///    similar but for [Rect]s and [Offset]s respectively.
  ///  - [flutter_matcher.moreOrLessEquals], the backing matcher.
  ///  - [matcher.closeTo], a [matcher.Matcher] which is identical except that the epsilon argument is
  ///    required and not named.
  ///    You can use `legacyMatcher` to use this matcher with `package:checks`.
  void moreOrLessEquals(
    double value, {
    double epsilon = precisionErrorTolerance,
  }) {
    legacyMatcher(flutter_matcher.moreOrLessEquals(value, epsilon: epsilon));
  }
}

/// Enable [Rect] checks.
///
/// {@macro pub.flutter_checks.legacy_matcher_disclosure}
extension RectChecks on Subject<Rect> {
  /// Asserts that two [Rect]s are equal, within some tolerated error.
  ///
  /// {@macro pub.flutter_checks.moreOrLessEquals}
  ///
  /// See also:
  ///
  ///  - [DoubleChecks.moreOrLessEquals], which is for [double]s.
  ///  - [OffsetChecks.offsetMoreOrLessEquals], which is for [Offset]s.
  ///  - [within], which offers a generic version of this functionality that can
  ///    be used to match [Rect]s as well as other types.
  ///  - [flutter_matcher.rectMoreOrLessEquals], the backing matcher.
  void rectMoreOrLessEquals(
    Rect rect, {
    double epsilon = precisionErrorTolerance,
  }) {
    legacyMatcher(flutter_matcher.rectMoreOrLessEquals(rect, epsilon: epsilon));
  }
}

/// Enable [Matrix4] checks
///
/// {@macro pub.flutter_checks.legacy_matcher_disclosure}
extension Matrix4Checks on Subject<Matrix4> {
  /// Asserts that two [Matrix4]s are equal, within some tolerated error.
  ///
  /// {@macro pub.flutter_checks.moreOrLessEquals}
  ///
  /// See also:
  ///  - [DoubleChecks.moreOrLessEquals], which is for [double]s.
  ///  - [OffsetChecks.offsetMoreOrLessEquals], which is for [Offset]s.
  ///  - [Matrix3Checks.matrix3MoreOrLessEquals], which is for [Matrix3]s.
  ///  - [flutter_matcher.matrixMoreOrLessEquals], the backing matcher.
  void matrixMoreOrLessEquals(
    Matrix4 matrix4, {
    double epsilon = precisionErrorTolerance,
  }) {
    legacyMatcher(
      flutter_matcher.matrixMoreOrLessEquals(matrix4, epsilon: epsilon),
    );
  }
}

/// Enable [Matrix3] checks
///
/// {@macro pub.flutter_checks.legacy_matcher_disclosure}
extension Matrix3Checks on Subject<Matrix3> {
  /// Asserts that two [Matrix3]s are equal, within some tolerated error.
  ///
  /// {@macro pub.flutter_checks.moreOrLessEquals}
  ///
  /// See also:
  ///  - [DoubleChecks.moreOrLessEquals], which is for [double]s.
  ///  - [OffsetChecks.offsetMoreOrLessEquals], which is for [Offset]s.
  ///  - [Matrix4Checks.matrixMoreOrLessEquals], which is for [Matrix4]s.
  ///  - [flutter_matcher.matrix3MoreOrLessEquals], the backing matcher.
  void matrix3MoreOrLessEquals(
    Matrix3 matrix3, {
    double epsilon = precisionErrorTolerance,
  }) {
    legacyMatcher(
      flutter_matcher.matrix3MoreOrLessEquals(matrix3, epsilon: epsilon),
    );
  }
}

/// Enable [Offset] checks.
///
/// {@macro pub.flutter_checks.legacy_matcher_disclosure}
extension OffsetChecks on Subject<Offset> {
  /// Asserts that two [Offset]s are equal, within some tolerated error.
  ///
  /// {@macro pub.flutter_checks.moreOrLessEquals}
  ///
  /// See also:
  ///
  ///  - [DoubleChecks.moreOrLessEquals], which is for [double]s.
  ///  - [RectChecks.rectMoreOrLessEquals], which is for [Rect]s.
  ///  - [within], which offers a generic version of this functionality that can
  ///    be used to match [Offset]s as well as other types.
  ///  - [flutter_matcher.offsetMoreOrLessEquals], the backing matcher.
  void offsetMoreOrLessEquals(
    Offset offset, {
    double epsilon = precisionErrorTolerance,
  }) {
    legacyMatcher(
      flutter_matcher.offsetMoreOrLessEquals(offset, epsilon: epsilon),
    );
  }
}

/// Enable [String] checks.
///
/// {@macro pub.flutter_checks.legacy_matcher_disclosure}
extension StringChecks on Subject<String> {
  /// Asserts that two [String]s are equal after
  /// normalizing likely hash codes.
  ///
  /// A `#` followed by 5 hexadecimal digits is assumed to be a short hash code
  /// and is normalized to `#00000`.
  ///
  /// See Also:
  ///
  ///  - [IterableStringChecks.equalsIgnoringHashCodes], which is for [Iterable]s of [String]s.
  ///  - [describeIdentity], a method that generates short descriptions of objects
  ///    with ids that match the pattern `#[0-9a-f]{5}`.
  ///  - [shortHash], a method that generates a 5 character long hexadecimal
  ///    [String] based on [Object.hashCode].
  ///  - [DiagnosticableTree.toStringDeep], a method that returns a [String]
  ///    typically containing multiple hash codes.
  ///  - [flutter_matcher.equalsIgnoringHashCodes], the backing matcher.
  void equalsIgnoringHashCodes(String value) {
    legacyMatcher(flutter_matcher.equalsIgnoringHashCodes(value));
  }
}

/// Enable [Iterable<String>] checks.
///
/// {@macro pub.flutter_checks.legacy_matcher_disclosure}
extension IterableStringChecks on Subject<Iterable<String>> {
  /// Asserts that two `Iterable<String>`s are equal after
  /// normalizing likely hash codes.
  ///
  /// A `#` followed by 5 hexadecimal digits is assumed to be a short hash code
  /// and is normalized to `#00000`.
  ///
  /// See Also:
  ///
  ///  - [StringChecks.equalsIgnoringHashCodes], a method that normalizes a single [String].
  ///  - [describeIdentity], a method that generates short descriptions of objects
  ///    with ids that match the pattern `#[0-9a-f]{5}`.
  ///  - [shortHash], a method that generates a 5 character long hexadecimal
  ///    [String] based on [Object.hashCode].
  ///  - [DiagnosticableTree.toStringDeep], a method that returns a [String]
  ///    typically containing multiple hash codes.
  ///  - [flutter_matcher.equalsIgnoringHashCodes], the backing matcher.
  void equalsIgnoringHashCodes(Iterable<String> value) {
    legacyMatcher(flutter_matcher.equalsIgnoringHashCodes(value));
  }
}

/// Enable [MethodCall] checks.
///
/// {@macro pub.flutter_checks.legacy_matcher_disclosure}
extension MethodCallChecks on Subject<MethodCall> {
  /// A matcher for [MethodCall]s, asserting that it has the specified
  /// method [name] and [arguments].
  ///
  /// Arguments checking implements deep equality for [List] and [Map] types.
  ///
  /// See also:
  ///  - [flutter_matcher.isMethodCall], the backing matcher.
  void isMethodCall(String name, {required Object? arguments}) {
    legacyMatcher(flutter_matcher.isMethodCall(name, arguments: arguments));
  }
}

/// Enable [Path] checks.
///
/// {@macro pub.flutter_checks.legacy_matcher_disclosure}
extension PathChecks on Subject<Path> {
  /// Asserts that 2 paths cover the same area by sampling multiple points.
  ///
  /// Samples at least [sampleSize]^2 points inside [areaToCompare], and asserts
  /// that the [Path.contains] method returns the same value for each of the
  /// points for both paths.
  ///
  /// When using this matcher you typically want to use a rectangle larger than
  /// the area you expect to paint in for [areaToCompare] to catch errors where
  /// the path draws outside the expected area.
  ///
  /// See also:
  ///
  ///  - [flutter_matcher.coversSameAreaAs], the backing matcher.
  void coversSameAreaAs(
    Path expectedPath, {
    required Rect areaToCompare,
    int sampleSize = 20,
  }) {
    legacyMatcher(
      flutter_matcher.coversSameAreaAs(
        expectedPath,
        areaToCompare: areaToCompare,
        sampleSize: sampleSize,
      ),
    );
  }
}

/// Enable [Image] checks.
///
/// {@macro pub.flutter_checks.legacy_matcher_disclosure}
extension ImageChecks on Subject<Image> {
  /// Asserts that an [Image] matches the
  /// golden image file identified by [key], with an optional [version] number.
  ///
  /// {@macro pub.flutter_checks.matchesGoldenFile}
  ///
  /// {@macro pub.flutter_checks.matchesGoldenFile.custom_fonts}
  ///
  /// See also:
  ///
  ///  - [matchesGoldenFileStringPath], which is the same but takes a [String] instead of a [Uri].
  ///  - [flutter_matcher.goldenFileComparator], which acts as the backend for this matcher.
  ///  - [flutter_matcher.LocalFileComparator], which is the default [flutter_matcher.GoldenFileComparator]
  ///    implementation for `flutter test`.
  ///  - [matchesReferenceImage], which should be used instead if you want to
  ///    verify that two different code paths create identical images.
  ///  - [flutter_test] for a discussion of test configurations, whereby callers
  ///    may swap out the backend for this matcher.
  ///  - [FinderChecks.matchesGoldenFile], which is for [flutter_test.Finder]s.
  ///  - [FutureImageChecks.matchesGoldenFile], which is for [Future<Image>]s.
  ///  - [flutter_matcher.MatchesGoldenFile], the backing matcher.
  Future<void> matchesGoldenFile(Uri key, {int? version}) async {
    await legacyMatcherAsync(flutter_matcher.MatchesGoldenFile(key, version));
  }

  /// Asserts that an [Image] matches the
  /// golden image file identified by [key], with an optional [version] number.
  ///
  /// {@macro pub.flutter_checks.matchesGoldenFile}
  ///
  /// {@macro pub.flutter_checks.matchesGoldenFile.custom_fonts}
  ///
  /// See also:
  ///
  ///  - [matchesGoldenFile], which is the same but takes a [Uri] instead of a [String].
  ///  - [flutter_matcher.goldenFileComparator], which acts as the backend for this matcher.
  ///  - [flutter_matcher.LocalFileComparator], which is the default [flutter_matcher.GoldenFileComparator]
  ///    implementation for `flutter test`.
  ///  - [matchesReferenceImage], which should be used instead if you want to
  ///    verify that two different code paths create identical images.
  ///  - [flutter_test] for a discussion of test configurations, whereby callers
  ///    may swap out the backend for this matcher.
  ///  - [FinderChecks.matchesGoldenFile], which is for [flutter_test.Finder]s.
  ///  - [FutureImageChecks.matchesGoldenFile], which is for [Future<Image>]s.
  ///  - [flutter_matcher.MatchesGoldenFile.forStringPath], the backing matcher.
  Future<void> matchesGoldenFileStringPath(String key, int? version) async {
    await legacyMatcherAsync(
      flutter_matcher.MatchesGoldenFile.forStringPath(key, version),
    );
  }

  /// Asserts that an [Image] matches a
  /// reference image identified by [image].
  ///
  /// {@macro pub.flutter_checks.matchesReferenceImage}
  ///
  /// See also:
  ///
  ///  - [matchesGoldenFile], which should be used instead if you need to verify
  ///    that a [flutter_test.Finder] matches a golden image.
  ///  - [flutter_matcher.matchesReferenceImage], the backing matcher.
  Future<void> matchesReferenceImage(Image image) async {
    await legacyMatcherAsync(flutter_matcher.matchesReferenceImage(image));
  }
}

/// Enable [Future<Image>] checks.
///
/// {@macro pub.flutter_checks.legacy_matcher_disclosure}
extension FutureImageChecks on Subject<Future<Image>> {
  /// Asserts that a [Future<Image>] matches the
  /// golden image file identified by [key], with an optional [version] number.
  ///
  /// {@macro pub.flutter_checks.matchesGoldenFile}
  ///
  /// {@macro pub.flutter_checks.matchesGoldenFile.custom_fonts}
  ///
  /// See also:
  ///
  ///  - [matchesGoldenFileStringPath], which is the same but takes a [String] instead of a [Uri].
  ///  - [flutter_matcher.goldenFileComparator], which acts as the backend for this matcher.
  ///  - [flutter_matcher.LocalFileComparator], which is the default [flutter_matcher.GoldenFileComparator]
  ///    implementation for `flutter test`.
  ///  - [matchesReferenceImage], which should be used instead if you want to
  ///    verify that two different code paths create identical images.
  ///  - [flutter_test] for a discussion of test configurations, whereby callers
  ///    may swap out the backend for this matcher.
  ///  - [FinderChecks.matchesGoldenFile], which is for [flutter_test.Finder]s.
  ///  - [ImageChecks.matchesGoldenFile], which is for [Image]s.
  ///  - [flutter_matcher.MatchesGoldenFile], the backing matcher.
  Future<void> matchesGoldenFile(Uri key, {int? version}) async {
    await legacyMatcherAsync(flutter_matcher.MatchesGoldenFile(key, version));
  }

  /// Asserts that an [Future<Image>] matches the
  /// golden image file identified by [key], with an optional [version] number.
  ///
  /// {@macro pub.flutter_checks.matchesGoldenFile}
  ///
  /// {@macro pub.flutter_checks.matchesGoldenFile.custom_fonts}
  ///
  /// See also:
  ///
  ///  - [matchesGoldenFile], which is the same but takes a [Uri] instead of a [String].
  ///  - [flutter_matcher.goldenFileComparator], which acts as the backend for this matcher.
  ///  - [flutter_matcher.LocalFileComparator], which is the default [flutter_matcher.GoldenFileComparator]
  ///    implementation for `flutter test`.
  ///  - [matchesReferenceImage], which should be used instead if you want to
  ///    verify that two different code paths create identical images.
  ///  - [flutter_test] for a discussion of test configurations, whereby callers
  ///    may swap out the backend for this matcher.
  ///  - [FinderChecks.matchesGoldenFile], which is for [flutter_test.Finder]s.
  ///  - [ImageChecks.matchesGoldenFile, which is for [Future<Image>]s.
  ///  - [flutter_matcher.MatchesGoldenFile.forStringPath], the backing matcher.
  Future<void> matchesGoldenFileStringPath(String key, int? version) async {
    await legacyMatcherAsync(
      flutter_matcher.MatchesGoldenFile.forStringPath(key, version),
    );
  }

  /// Asserts that an [Future<Image>] matches a
  /// reference image identified by [image].
  ///
  /// {@macro pub.flutter_checks.matchesReferenceImage}
  ///
  /// See also:
  ///
  ///  - [matchesGoldenFile], which should be used instead if you need to verify
  ///    that a [flutter_test.Finder] matches a golden image.
  ///  - [flutter_matcher.matchesReferenceImage], the backing matcher.
  Future<void> matchesReferenceImage(Image image) async {
    await legacyMatcherAsync(flutter_matcher.matchesReferenceImage(image));
  }
}

/// Enable [SemanticsNode] checks.
///
/// {@macro pub.flutter_checks.legacy_matcher_disclosure}
extension SemanticsNodeChecks on Subject<SemanticsNode> {
  /// Asserts that a [SemanticsNode] contains the specified information.
  ///
  /// If either the label, hint, value, textDirection, or rect fields are not
  /// provided, then they are not part of the comparison. All of the boolean
  /// flag and action fields must match, and default to false.
  ///
  /// To find a [SemanticsNode] directly, use [flutter_test.CommonFinders.semantics].
  /// These methods will search the semantics tree directly and avoid the edge
  /// cases that [flutter_test.SemanticsController.find] sometimes runs into.
  ///
  /// To retrieve the semantics data of a widget, use [flutter_test.SemanticsController.find]
  /// with a [flutter_test.Finder] that returns a single widget. Semantics must be enabled
  /// in order to use this method.
  ///
  /// ## Sample code
  ///
  /// ```dart
  /// testWidgets('matchesSemantics', (WidgetTester tester) async {
  ///   final SemanticsHandle handle = tester.ensureSemantics();
  ///   // ...
  ///   check(tester.getSemantics(find.text('hello'))).matchesSemantics(label: 'hello');
  ///   handle.dispose();
  /// });
  /// ```
  ///
  /// See also:
  ///
  ///  - [flutter_test.SemanticsController.find] under [WidgetTester.semantics], the tester method which retrieves semantics.
  ///  - [containsSemantics], a similar matcher without default values for flags or actions.
  ///  - [flutter_matcher.matchesSemantics], the backing matcher.
  void matchesSemantics({
    String? identifier,
    String? label,
    AttributedString? attributedLabel,
    String? hint,
    AttributedString? attributedHint,
    String? value,
    AttributedString? attributedValue,
    String? increasedValue,
    AttributedString? attributedIncreasedValue,
    String? decreasedValue,
    AttributedString? attributedDecreasedValue,
    String? tooltip,
    TextDirection? textDirection,
    Rect? rect,
    Size? size,
    double? elevation,
    double? thickness,
    int? platformViewId,
    int? maxValueLength,
    int? currentValueLength,
    // Flags //
    bool hasCheckedState = false,
    bool isChecked = false,
    bool isCheckStateMixed = false,
    bool isSelected = false,
    bool isButton = false,
    bool isSlider = false,
    bool isKeyboardKey = false,
    bool isLink = false,
    bool isFocused = false,
    bool isFocusable = false,
    bool isTextField = false,
    bool isReadOnly = false,
    bool hasEnabledState = false,
    bool isEnabled = false,
    bool isInMutuallyExclusiveGroup = false,
    bool isHeader = false,
    bool isObscured = false,
    bool isMultiline = false,
    bool namesRoute = false,
    bool scopesRoute = false,
    bool isHidden = false,
    bool isImage = false,
    bool isLiveRegion = false,
    bool hasToggledState = false,
    bool isToggled = false,
    bool hasImplicitScrolling = false,
    bool hasExpandedState = false,
    bool isExpanded = false,
    // Actions //
    bool hasTapAction = false,
    bool hasFocusAction = false,
    bool hasLongPressAction = false,
    bool hasScrollLeftAction = false,
    bool hasScrollRightAction = false,
    bool hasScrollUpAction = false,
    bool hasScrollDownAction = false,
    bool hasIncreaseAction = false,
    bool hasDecreaseAction = false,
    bool hasShowOnScreenAction = false,
    bool hasMoveCursorForwardByCharacterAction = false,
    bool hasMoveCursorBackwardByCharacterAction = false,
    bool hasMoveCursorForwardByWordAction = false,
    bool hasMoveCursorBackwardByWordAction = false,
    bool hasSetTextAction = false,
    bool hasSetSelectionAction = false,
    bool hasCopyAction = false,
    bool hasCutAction = false,
    bool hasPasteAction = false,
    bool hasDidGainAccessibilityFocusAction = false,
    bool hasDidLoseAccessibilityFocusAction = false,
    bool hasDismissAction = false,
    // Custom actions and overrides
    String? onTapHint,
    String? onLongPressHint,
    List<CustomSemanticsAction>? customActions,
    List<matcher.Matcher>? children,
  }) {
    legacyMatcher(
      flutter_matcher.matchesSemantics(
        identifier: identifier,
        label: label,
        attributedLabel: attributedLabel,
        hint: hint,
        attributedHint: attributedHint,
        value: value,
        attributedValue: attributedValue,
        increasedValue: increasedValue,
        attributedIncreasedValue: attributedIncreasedValue,
        decreasedValue: decreasedValue,
        attributedDecreasedValue: attributedDecreasedValue,
        tooltip: tooltip,
        textDirection: textDirection,
        rect: rect,
        size: size,
        elevation: elevation,
        thickness: thickness,
        platformViewId: platformViewId,
        customActions: customActions,
        maxValueLength: maxValueLength,
        currentValueLength: currentValueLength,
        // Flags
        hasCheckedState: hasCheckedState,
        isChecked: isChecked,
        isCheckStateMixed: isCheckStateMixed,
        isSelected: isSelected,
        isButton: isButton,
        isSlider: isSlider,
        isKeyboardKey: isKeyboardKey,
        isLink: isLink,
        isFocused: isFocused,
        isFocusable: isFocusable,
        isTextField: isTextField,
        isReadOnly: isReadOnly,
        hasEnabledState: hasEnabledState,
        isEnabled: isEnabled,
        isInMutuallyExclusiveGroup: isInMutuallyExclusiveGroup,
        isHeader: isHeader,
        isObscured: isObscured,
        isMultiline: isMultiline,
        namesRoute: namesRoute,
        scopesRoute: scopesRoute,
        isHidden: isHidden,
        isImage: isImage,
        isLiveRegion: isLiveRegion,
        hasToggledState: hasToggledState,
        isToggled: isToggled,
        hasImplicitScrolling: hasImplicitScrolling,
        hasExpandedState: hasExpandedState,
        isExpanded: isExpanded,
        // Actions
        hasTapAction: hasTapAction,
        hasFocusAction: hasFocusAction,
        hasLongPressAction: hasLongPressAction,
        hasScrollLeftAction: hasScrollLeftAction,
        hasScrollRightAction: hasScrollRightAction,
        hasScrollUpAction: hasScrollUpAction,
        hasScrollDownAction: hasScrollDownAction,
        hasIncreaseAction: hasIncreaseAction,
        hasDecreaseAction: hasDecreaseAction,
        hasShowOnScreenAction: hasShowOnScreenAction,
        hasMoveCursorForwardByCharacterAction:
            hasMoveCursorForwardByCharacterAction,
        hasMoveCursorBackwardByCharacterAction:
            hasMoveCursorBackwardByCharacterAction,
        hasMoveCursorForwardByWordAction: hasMoveCursorForwardByWordAction,
        hasMoveCursorBackwardByWordAction: hasMoveCursorBackwardByWordAction,
        hasSetTextAction: hasSetTextAction,
        hasSetSelectionAction: hasSetSelectionAction,
        hasCopyAction: hasCopyAction,
        hasCutAction: hasCutAction,
        hasPasteAction: hasPasteAction,
        hasDidGainAccessibilityFocusAction: hasDidGainAccessibilityFocusAction,
        hasDidLoseAccessibilityFocusAction: hasDidLoseAccessibilityFocusAction,
        hasDismissAction: hasDismissAction,
        // Custom actions and overrides
        children: children,
        onLongPressHint: onLongPressHint,
        onTapHint: onTapHint,
      ),
    );
  }

  /// Asserts that a [SemanticsNode] contains the specified information.
  ///
  /// There are no default expected values, so no unspecified values will be
  /// validated.
  ///
  /// To find a [SemanticsNode] directly, use [flutter_test.CommonFinders.semantics].
  /// These methods will search the semantics tree directly and avoid the edge
  /// cases that [flutter_test.SemanticsController.find] sometimes runs into.
  ///
  /// To retrieve the semantics data of a widget, use [flutter_test.SemanticsController.find]
  /// with a [flutter_test.Finder] that returns a single widget. Semantics must be enabled
  /// in order to use this method.
  ///
  /// ## Sample code
  ///
  /// ```dart
  /// testWidgets('containsSemantics', (WidgetTester tester) async {
  ///   final SemanticsHandle handle = tester.ensureSemantics();
  ///   // ...
  ///   expect(tester.getSemantics(find.text('hello'))).containsSemantics(label: 'hello');
  ///   handle.dispose();
  /// });
  /// ```
  ///
  /// See also:
  ///
  ///  - [flutter_test.SemanticsController.find] under [WidgetTester.semantics], the tester method which retrieves semantics.
  ///  - [matchesSemantics], a similar matcher with default values for flags and actions.
  ///  - [flutter_matcher.containsSemantics], the backing matcher.
  void containsSemantics({
    String? identifier,
    String? label,
    AttributedString? attributedLabel,
    String? hint,
    AttributedString? attributedHint,
    String? value,
    AttributedString? attributedValue,
    String? increasedValue,
    AttributedString? attributedIncreasedValue,
    String? decreasedValue,
    AttributedString? attributedDecreasedValue,
    String? tooltip,
    TextDirection? textDirection,
    Rect? rect,
    Size? size,
    double? elevation,
    double? thickness,
    int? platformViewId,
    int? maxValueLength,
    int? currentValueLength,
    // Flags
    bool? hasCheckedState,
    bool? isChecked,
    bool? isCheckStateMixed,
    bool? isSelected,
    bool? isButton,
    bool? isSlider,
    bool? isKeyboardKey,
    bool? isLink,
    bool? isFocused,
    bool? isFocusable,
    bool? isTextField,
    bool? isReadOnly,
    bool? hasEnabledState,
    bool? isEnabled,
    bool? isInMutuallyExclusiveGroup,
    bool? isHeader,
    bool? isObscured,
    bool? isMultiline,
    bool? namesRoute,
    bool? scopesRoute,
    bool? isHidden,
    bool? isImage,
    bool? isLiveRegion,
    bool? hasToggledState,
    bool? isToggled,
    bool? hasImplicitScrolling,
    bool? hasExpandedState,
    bool? isExpanded,
    // Actions
    bool? hasTapAction,
    bool? hasFocusAction,
    bool? hasLongPressAction,
    bool? hasScrollLeftAction,
    bool? hasScrollRightAction,
    bool? hasScrollUpAction,
    bool? hasScrollDownAction,
    bool? hasIncreaseAction,
    bool? hasDecreaseAction,
    bool? hasShowOnScreenAction,
    bool? hasMoveCursorForwardByCharacterAction,
    bool? hasMoveCursorBackwardByCharacterAction,
    bool? hasMoveCursorForwardByWordAction,
    bool? hasMoveCursorBackwardByWordAction,
    bool? hasSetTextAction,
    bool? hasSetSelectionAction,
    bool? hasCopyAction,
    bool? hasCutAction,
    bool? hasPasteAction,
    bool? hasDidGainAccessibilityFocusAction,
    bool? hasDidLoseAccessibilityFocusAction,
    bool? hasDismissAction,
    // Custom actions and overrides
    String? onTapHint,
    String? onLongPressHint,
    List<CustomSemanticsAction>? customActions,
    List<matcher.Matcher>? children,
  }) {
    legacyMatcher(
      flutter_matcher.containsSemantics(
        identifier: identifier,
        label: label,
        attributedLabel: attributedLabel,
        hint: hint,
        attributedHint: attributedHint,
        value: value,
        attributedValue: attributedValue,
        increasedValue: increasedValue,
        attributedIncreasedValue: attributedIncreasedValue,
        decreasedValue: decreasedValue,
        attributedDecreasedValue: attributedDecreasedValue,
        tooltip: tooltip,
        textDirection: textDirection,
        rect: rect,
        size: size,
        elevation: elevation,
        thickness: thickness,
        platformViewId: platformViewId,
        customActions: customActions,
        maxValueLength: maxValueLength,
        currentValueLength: currentValueLength,
        // Flags
        hasCheckedState: hasCheckedState,
        isChecked: isChecked,
        isCheckStateMixed: isCheckStateMixed,
        isSelected: isSelected,
        isButton: isButton,
        isSlider: isSlider,
        isKeyboardKey: isKeyboardKey,
        isLink: isLink,
        isFocused: isFocused,
        isFocusable: isFocusable,
        isTextField: isTextField,
        isReadOnly: isReadOnly,
        hasEnabledState: hasEnabledState,
        isEnabled: isEnabled,
        isInMutuallyExclusiveGroup: isInMutuallyExclusiveGroup,
        isHeader: isHeader,
        isObscured: isObscured,
        isMultiline: isMultiline,
        namesRoute: namesRoute,
        scopesRoute: scopesRoute,
        isHidden: isHidden,
        isImage: isImage,
        isLiveRegion: isLiveRegion,
        hasToggledState: hasToggledState,
        isToggled: isToggled,
        hasImplicitScrolling: hasImplicitScrolling,
        hasExpandedState: hasExpandedState,
        isExpanded: isExpanded,
        // Actions
        hasTapAction: hasTapAction,
        hasFocusAction: hasFocusAction,
        hasLongPressAction: hasLongPressAction,
        hasScrollLeftAction: hasScrollLeftAction,
        hasScrollRightAction: hasScrollRightAction,
        hasScrollUpAction: hasScrollUpAction,
        hasScrollDownAction: hasScrollDownAction,
        hasIncreaseAction: hasIncreaseAction,
        hasDecreaseAction: hasDecreaseAction,
        hasShowOnScreenAction: hasShowOnScreenAction,
        hasMoveCursorForwardByCharacterAction:
            hasMoveCursorForwardByCharacterAction,
        hasMoveCursorBackwardByCharacterAction:
            hasMoveCursorBackwardByCharacterAction,
        hasMoveCursorForwardByWordAction: hasMoveCursorForwardByWordAction,
        hasMoveCursorBackwardByWordAction: hasMoveCursorBackwardByWordAction,
        hasSetTextAction: hasSetTextAction,
        hasSetSelectionAction: hasSetSelectionAction,
        hasCopyAction: hasCopyAction,
        hasCutAction: hasCutAction,
        hasPasteAction: hasPasteAction,
        hasDidGainAccessibilityFocusAction: hasDidGainAccessibilityFocusAction,
        hasDidLoseAccessibilityFocusAction: hasDidLoseAccessibilityFocusAction,
        hasDismissAction: hasDismissAction,
        // Custom actions and overrides
        children: children,
        onLongPressHint: onLongPressHint,
        onTapHint: onTapHint,
      ),
    );
  }
}
