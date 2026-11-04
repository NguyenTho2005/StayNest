import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:staynest/widgets/responsive_app_shell.dart';

void main() {
  Widget buildTestWidget({required Size screenSize, required Widget child}) =>
      MaterialApp(
        home: MediaQuery(
          data: MediaQueryData(size: screenSize),
          child: ResponsiveAppShell(child: child),
        ),
      );

  group('ResponsiveAppShell Viewport Tests', () {
    testWidgets('mobile 390x844: renders natural full width', (tester) async {
      await tester.binding.setSurfaceSize(const Size(390, 844));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      double? innerWidth;
      await tester.pumpWidget(
        buildTestWidget(
          screenSize: const Size(390, 844),
          child: Builder(
            builder: (context) {
              innerWidth = MediaQuery.sizeOf(context).width;
              return const Scaffold(body: Text('Mobile 390'));
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(innerWidth, 390.0);
      expect(find.text('Mobile 390'), findsOneWidget);
    });

    testWidgets('mobile 393x852: renders natural full width', (tester) async {
      await tester.binding.setSurfaceSize(const Size(393, 852));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      double? innerWidth;
      await tester.pumpWidget(
        buildTestWidget(
          screenSize: const Size(393, 852),
          child: Builder(
            builder: (context) {
              innerWidth = MediaQuery.sizeOf(context).width;
              return const Scaffold(body: Text('Mobile 393'));
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(innerWidth, 393.0);
      expect(find.text('Mobile 393'), findsOneWidget);
    });

    testWidgets('tablet 768x1024: clamps to centered 390px mobile frame', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(768, 1024));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      double? innerWidth;
      await tester.pumpWidget(
        buildTestWidget(
          screenSize: const Size(768, 1024),
          child: Builder(
            builder: (context) {
              innerWidth = MediaQuery.sizeOf(context).width;
              return const Scaffold(body: Text('Tablet Frame'));
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(innerWidth, ResponsiveAppShell.standardMobileWidth);
      expect(find.text('Tablet Frame'), findsOneWidget);

      final renderBox = tester.renderObject<RenderBox>(find.byType(Scaffold));
      expect(renderBox.size.width, ResponsiveAppShell.standardMobileWidth);
    });

    testWidgets(
      'desktop 1920x1080: clamps to centered 390px mobile frame without horizontal stretching',
      (tester) async {
        await tester.binding.setSurfaceSize(const Size(1920, 1080));
        addTearDown(() => tester.binding.setSurfaceSize(null));

        double? innerWidth;
        await tester.pumpWidget(
          buildTestWidget(
            screenSize: const Size(1920, 1080),
            child: Builder(
              builder: (context) {
                innerWidth = MediaQuery.sizeOf(context).width;
                return const Scaffold(
                  body: TextField(
                    decoration: InputDecoration(hintText: 'Enter name'),
                  ),
                );
              },
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(innerWidth, ResponsiveAppShell.standardMobileWidth);

        // Verify the Scaffold width inside the shell is exactly 390px
        final scaffoldBox = tester.renderObject<RenderBox>(
          find.byType(Scaffold),
        );
        expect(scaffoldBox.size.width, 390.0);

        // Verify text field inside scaffold is within 390px and not stretched to 1920px
        final fieldBox = tester.renderObject<RenderBox>(find.byType(TextField));
        expect(fieldBox.size.width, lessThanOrEqualTo(390.0));
      },
    );
  });
}
