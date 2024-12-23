import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui/presentation/pages/search_page/widgets/product_price.dart';

void main() {
  group('ProductPrice Widget Tests', () {
    testWidgets('ProductPrice displays the correct price', (WidgetTester tester) async {
      const String price = '\$99.99';

      // Build the ProductPrice widget
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProductPrice(price: price),
          ),
        ),
      );

      // Verify that the price text is displayed
      expect(find.text(price), findsOneWidget);

      // Verify the text style
      final Text textWidget = tester.widget(find.text(price));
      expect(textWidget.style?.fontSize, 14);
      expect(textWidget.style?.color, Colors.green);
      expect(textWidget.style?.fontWeight, FontWeight.w600);
    });
  });
}
