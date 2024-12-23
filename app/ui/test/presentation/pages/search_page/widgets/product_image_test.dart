// test/presentation/pages/search_page/widgets/product_image_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui/domain/entities/search_product_item_entity.dart';
import 'package:ui/presentation/pages/search_page/widgets/product_image.dart';

void main() {
  group('ProductImage Widget Tests', () {
    testWidgets('ProductImage displays image correctly', (WidgetTester tester) async {
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

      bool favoriteToggled = false;

      // Build the ProductImage widget
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProductImage(
              product: product,
              isFavorite: false,
              onFavoriteToggle: () {
                favoriteToggled = true;
              },
            ),
          ),
        ),
      );

      // Verify that the image is displayed
      expect(find.byType(Image), findsOneWidget);

      // Tap the favorites icon
      await tester.tap(find.byIcon(Icons.favorite_border));
      await tester.pump();

      // Verify that the callback was triggered
      expect(favoriteToggled, isTrue);
    });

    testWidgets('ProductImage shows favorite icon correctly', (WidgetTester tester) async {
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

      // Build the ProductImage widget with isFavorite = true
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProductImage(
              product: product,
              isFavorite: true,
              onFavoriteToggle: () {},
            ),
          ),
        ),
      );

      // Verify that the favorite icon is displayed
      expect(find.byIcon(Icons.favorite), findsOneWidget);

      // Rebuild with isFavorite = false
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProductImage(
              product: product,
              isFavorite: false,
              onFavoriteToggle: () {},
            ),
          ),
        ),
      );

      // Verify that the favorite_border icon is displayed
      expect(find.byIcon(Icons.favorite_border), findsOneWidget);
    });
  });
}
