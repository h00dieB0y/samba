import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui/presentation/pages/product_details_page/widgets/price_and_availability.dart';

void main() {
  group('PriceAndAvailability Widget Tests', () {
    final String price = '99.99';
    final String oldPrice = '120.00';
    final String discount = '20%';
    final String stockStatusInStock = 'In Stock';
    final String stockStatusOutOfStock = 'Out of Stock';
    final String shippingLabel = 'Free Shipping';
    final DateTime offerEndTime = DateTime.now().add(Duration(hours: 5));

    testWidgets('Displays price, old price, and discount correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PriceAndAvailability(
              price: price,
              oldPrice: oldPrice,
              discount: discount,
              stockStatus: stockStatusInStock,
              shippingLabel: shippingLabel,
              offerEndTime: offerEndTime,
            ),
          ),
        ),
      );

      // Check if the price is displayed correctly
      expect(find.text('\$99.99'), findsOneWidget);

      // Check if the old price is displayed with strikethrough
      final oldPriceText = tester.widget<Text>(find.text('\$120.00'));
      expect(oldPriceText.style?.decoration, TextDecoration.lineThrough);

      // Check if the discount is displayed correctly
      expect(find.text('20%'), findsOneWidget);
    });

    testWidgets('Displays "Offer ends in" countdown if offerEndTime is provided', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PriceAndAvailability(
              price: price,
              oldPrice: oldPrice,
              discount: discount,
              stockStatus: stockStatusInStock,
              shippingLabel: shippingLabel,
              offerEndTime: offerEndTime,
            ),
          ),
        ),
      );

      // Check if the countdown timer is displayed
      expect(find.textContaining('Offer ends in'), findsOneWidget);
    });

    testWidgets('Does not display countdown if offerEndTime is null', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PriceAndAvailability(
              price: price,
              oldPrice: oldPrice,
              discount: discount,
              stockStatus: stockStatusInStock,
              shippingLabel: shippingLabel,
              offerEndTime: null,
            ),
          ),
        ),
      );

      // Check that no countdown is shown
      expect(find.textContaining('Offer ends in'), findsNothing);
    });

    testWidgets('Displays "Out of Stock" for stock status correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PriceAndAvailability(
              price: price,
              oldPrice: oldPrice,
              discount: discount,
              stockStatus: stockStatusOutOfStock,
              shippingLabel: shippingLabel,
              offerEndTime: offerEndTime,
            ),
          ),
        ),
      );

      // Check if the stock status is displayed with correct styling
      expect(find.text('Out of Stock'), findsOneWidget);
    });

    testWidgets('Displays "In Stock" for stock status correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PriceAndAvailability(
              price: price,
              oldPrice: oldPrice,
              discount: discount,
              stockStatus: stockStatusInStock,
              shippingLabel: shippingLabel,
              offerEndTime: offerEndTime,
            ),
          ),
        ),
      );

      // Check if the stock status is displayed with correct styling
      expect(find.text('In Stock'), findsOneWidget);
    });

    testWidgets('Displays shipping label correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PriceAndAvailability(
              price: price,
              oldPrice: oldPrice,
              discount: discount,
              stockStatus: stockStatusInStock,
              shippingLabel: shippingLabel,
              offerEndTime: offerEndTime,
            ),
          ),
        ),
      );

      // Check if the shipping label is displayed
      expect(find.text('Free Shipping'), findsOneWidget);
    });

    testWidgets('Displays savings information if oldPrice and discount are provided', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PriceAndAvailability(
              price: price,
              oldPrice: oldPrice,
              discount: discount,
              stockStatus: stockStatusInStock,
              shippingLabel: shippingLabel,
              offerEndTime: offerEndTime,
            ),
          ),
        ),
      );

      // Check if the savings information is displayed
      expect(find.text('You save \$20.01 (20%)'), findsOneWidget);
    });

    testWidgets('Does not display savings information if oldPrice or discount are not provided', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PriceAndAvailability(
              price: price,
              oldPrice: null,
              discount: null,
              stockStatus: stockStatusInStock,
              shippingLabel: shippingLabel,
              offerEndTime: offerEndTime,
            ),
          ),
        ),
      );

      // Check if savings information is not displayed
      expect(find.textContaining('You save'), findsNothing);
    });
  });
}