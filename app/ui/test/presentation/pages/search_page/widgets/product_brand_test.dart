import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui/presentation/pages/search_page/widgets/product_brand.dart';

void main() {
  group('ProductBrand Widget Tests', () {
    testWidgets('ProductBrand displays the correct brand name', (WidgetTester tester) async {
      const String brandName = 'SoundMax';

      // Build the ProductBrand widget
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProductBrand(brand: brandName),
          ),
        ),
      );

      // Verify that the brand name text is displayed
      expect(find.text(brandName), findsOneWidget);

      // Verify the text style
      final Text textWidget = tester.widget(find.text(brandName));
      expect(textWidget.style?.fontSize, 12);
      expect(textWidget.style?.color, Colors.blueGrey);
      expect(textWidget.style?.fontWeight, FontWeight.w500);
    });
  });
}
