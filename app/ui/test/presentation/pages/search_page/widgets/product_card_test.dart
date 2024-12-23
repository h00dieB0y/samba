// test/presentation/pages/search_page/widgets/product_card_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui/domain/entities/search_product_item_entity.dart';
import 'package:ui/presentation/pages/search_page/widgets/product_card.dart';

void main() {
  group('ProductCard Widget Tests', () {
    testWidgets('ProductCard displays all product details correctly', (WidgetTester tester) async {
      final product = SearchProductItemEntity(
        id: '1',
        name: 'Wireless Headphones',
        brand: 'SoundMax',
        price: '\$99.99',
        rating: 4.5,
        reviewCount: 120,
        isSponsored: true,
        isBestSeller: true,
      );

      // Build the ProductCard widget
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProductCard(product: product),
          ),
        ),
      );

      // Verify that the image is displayed
      expect(find.byType(Image), findsOneWidget);

      // Verify that the 'Sponsored' and 'Best Seller' tags are displayed
      expect(find.text('Sponsored'), findsOneWidget);
      expect(find.text('Best Seller'), findsOneWidget);

      // Verify brand name
      expect(find.text(product.brand), findsOneWidget);

      // Verify product name
      expect(find.text(product.name), findsOneWidget);

      // Verify price
      expect(find.text(product.price), findsOneWidget);

      // Verify ratings and reviews
      expect(find.byIcon(Icons.star), findsNWidgets(4));
      expect(find.byIcon(Icons.star_half), findsOneWidget);
      expect(find.byIcon(Icons.star_border), findsNWidgets(0));
      expect(find.text('(${product.reviewCount})'), findsOneWidget);
    });

    testWidgets('ProductCard toggles favorite state correctly', (WidgetTester tester) async {
      final product = SearchProductItemEntity(
        id: '2',
        name: 'Smart Watch',
        brand: 'TimeTech',
        price: '\$199.99',
        rating: 4.0,
        reviewCount: 85,
        isSponsored: false,
        isBestSeller: true,
      );

      // Build the ProductCard widget
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProductCard(
              product: product,
            ),
          ),
        ),
      );

      // Initially, the favorite icon should be border
      expect(find.byIcon(Icons.favorite_border), findsOneWidget);
      expect(find.byIcon(Icons.favorite), findsNothing);

      // Tap the favorite icon
      await tester.tap(find.byIcon(Icons.favorite_border));
      await tester.pump();

      // After tapping, the favorite icon should be filled
      expect(find.byIcon(Icons.favorite), findsOneWidget);
      expect(find.byIcon(Icons.favorite_border), findsNothing);
    });
  });
}
