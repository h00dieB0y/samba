import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui/domain/entities/product_item_entity.dart';
import 'package:ui/presentation/pages/home_page/widgets/product_card.dart';

void main() {
  group('ProductCard Widget Tests', () {
    testWidgets('displays correct product data', (WidgetTester tester) async {
      // Arrange: Create a sample product item
      final testProduct = ProductItemEntity(
        id: '1',
        name: 'Test Product',
        brand: 'Test Brand',
        price: '\$9.99',
      );

      // Act: Pump the widget under test
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProductCard(product: testProduct),
          ),
        ),
      );

      // Assert: Check text for brand, name, and price
      expect(find.text('Test Brand'), findsOneWidget);
      expect(find.text('Test Product'), findsOneWidget);
      expect(find.text('\$9.99'), findsOneWidget);

      // Hero image (placeholder)
      final heroFinder = find.byType(Hero);
      expect(heroFinder, findsOneWidget);

      // Under the Hero, there should be an Image widget
      final imageFinder = find.byType(Image);
      expect(imageFinder, findsOneWidget);
    });

    testWidgets('navigates to Placeholder screen on tap', (WidgetTester tester) async {
      // Arrange
      final testProduct = ProductItemEntity(
        id: '2',
        name: 'Another Product',
        brand: 'Another Brand',
        price: '\$19.99',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProductCard(product: testProduct),
          ),
        ),
      );

      // Assert: Initially, no Placeholder in the widget tree
      expect(find.byType(Placeholder), findsNothing);

      // Act: Tap on the ProductCard
      await tester.tap(find.byType(ProductCard));
      await tester.pumpAndSettle();

      // Assert: After tap, we expect a new route (Placeholder) in the widget tree
      expect(find.byType(Placeholder), findsOneWidget);
    });
  });
}