import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui/presentation/pages/product_details_page/widgets/primary_cta_buttons.dart';


void main() {
  group('PrimaryCTAButtons Widget Tests', () {
    testWidgets('Displays "Add to Cart" and "Buy Now" buttons', (WidgetTester tester) async {
      bool addToCartPressed = false;
      bool buyNowPressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrimaryCTAButtons(
              onAddToCart: () {
                addToCartPressed = true;
              },
              onBuyNow: () {
                buyNowPressed = true;
              },
            ),
          ),
        ),
      );

      // Check if "Add to Cart" and "Buy Now" buttons are displayed
      expect(find.text('Add to Cart'), findsOneWidget);
      expect(find.text('Buy Now'), findsOneWidget);

      // Simulate tapping on "Add to Cart" button
      await tester.tap(find.text('Add to Cart'));
      await tester.pump();

      // Check if "Add to Cart" button was pressed
      expect(addToCartPressed, true);

      // Simulate tapping on "Buy Now" button
      await tester.tap(find.text('Buy Now'));
      await tester.pump();

      // Check if "Buy Now" button was pressed
      expect(buyNowPressed, true);
    });

    testWidgets('Displays "Out of Stock" state for buttons when isOutOfStock is true', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrimaryCTAButtons(
              onAddToCart: () {},
              onBuyNow: () {},
              isOutOfStock: true,
            ),
          ),
        ),
      );

      // Check if buttons display "Out of Stock" and are disabled
      expect(find.text('Out of Stock'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
      expect(find.byType(OutlinedButton), findsOneWidget);

      // Check if ElevatedButton and OutlinedButton are disabled
      final ElevatedButton elevatedButton = tester.widget(find.byType(ElevatedButton));
      final OutlinedButton outlinedButton = tester.widget(find.byType(OutlinedButton));
      expect(elevatedButton.onPressed, isNull);
      expect(outlinedButton.onPressed, isNull);
    });

    testWidgets('Buttons are enabled and functional when isOutOfStock is false', (WidgetTester tester) async {
      bool addToCartPressed = false;
      bool buyNowPressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrimaryCTAButtons(
              onAddToCart: () {
                addToCartPressed = true;
              },
              onBuyNow: () {
                buyNowPressed = true;
              },
              isOutOfStock: false,
            ),
          ),
        ),
      );

      // Check if buttons are enabled
      final ElevatedButton elevatedButton = tester.widget(find.byType(ElevatedButton));
      final OutlinedButton outlinedButton = tester.widget(find.byType(OutlinedButton));
      expect(elevatedButton.onPressed, isNotNull);
      expect(outlinedButton.onPressed, isNotNull);

      // Simulate tapping on "Add to Cart" button
      await tester.tap(find.text('Add to Cart'));
      await tester.pump();

      // Check if "Add to Cart" button was pressed
      expect(addToCartPressed, true);

      // Simulate tapping on "Buy Now" button
      await tester.tap(find.text('Buy Now'));
      await tester.pump();

      // Check if "Buy Now" button was pressed
      expect(buyNowPressed, true);
    });
  });
}