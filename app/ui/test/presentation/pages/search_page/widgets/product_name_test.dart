import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui/presentation/pages/search_page/widgets/product_name.dart';

void main() {
  group('ProductName Widget Tests', () {
    testWidgets('ProductName displays the correct product name', (WidgetTester tester) async {
      const String productName = 'Wireless Headphones';

      // Build the ProductName widget
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProductName(name: productName),
          ),
        ),
      );

      // Verify that the product name text is displayed
      expect(find.text(productName), findsOneWidget);

      // Verify the text style
      final Text textWidget = tester.widget(find.text(productName));
      expect(textWidget.style?.fontSize, 16);
      expect(textWidget.style?.fontWeight, FontWeight.bold);
    });

    testWidgets('ProductName truncates overflow text correctly', (WidgetTester tester) async {
      const String longProductName = 'This is a very long product name that should be truncated';

      // Build the ProductName widget within a constrained width
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 100, // Narrow width to force overflow
              child: ProductName(name: longProductName),
            ),
          ),
        ),
      );

      // Verify that the text is displayed with overflow
      final Text textWidget = tester.widget(find.byType(Text));
      expect(textWidget.overflow, TextOverflow.ellipsis);
      expect(textWidget.maxLines, 2);
    });
  });
}
