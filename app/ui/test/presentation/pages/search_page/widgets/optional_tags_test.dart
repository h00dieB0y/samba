import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui/domain/entities/search_product_item_entity.dart';
import 'package:ui/presentation/pages/search_page/widgets/optional_tags.dart';

void main() {
  group('OptionalTags Widget Tests', () {
    testWidgets('OptionalTags displays Sponsored tag when isSponsored is true', (WidgetTester tester) async {
      final product = SearchProductItemEntity(
        id: '1',
        name: 'Wireless Headphones',
        brand: 'SoundMax',
        price: '\$99.99',
        rating: 4.5,
        reviewCount: 120,
        isSponsored: true,
        isBestSeller: false,
      );

      // Build the OptionalTags widget
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: OptionalTags(product: product),
          ),
        ),
      );

      // Verify that the 'Sponsored' tag is displayed
      expect(find.text('Sponsored'), findsOneWidget);

      // Verify that the 'Best Seller' tag is not displayed
      expect(find.text('Best Seller'), findsNothing);
    });

    testWidgets('OptionalTags displays Best Seller tag when isBestSeller is true', (WidgetTester tester) async {
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

      // Build the OptionalTags widget
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: OptionalTags(product: product),
          ),
        ),
      );

      // Verify that the 'Best Seller' tag is displayed
      expect(find.text('Best Seller'), findsOneWidget);

      // Verify that the 'Sponsored' tag is not displayed
      expect(find.text('Sponsored'), findsNothing);
    });

    testWidgets('OptionalTags displays both Sponsored and Best Seller tags when both are true', (WidgetTester tester) async {
      final product = SearchProductItemEntity(
        id: '3',
        name: 'Bluetooth Speaker',
        brand: 'SoundWave',
        price: '\$49.99',
        rating: 4.2,
        reviewCount: 200,
        isSponsored: true,
        isBestSeller: true,
      );

      // Build the OptionalTags widget
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: OptionalTags(product: product),
          ),
        ),
      );

      // Verify that both 'Sponsored' and 'Best Seller' tags are displayed
      expect(find.text('Sponsored'), findsOneWidget);
      expect(find.text('Best Seller'), findsOneWidget);
    });

    testWidgets('OptionalTags displays no tags when both isSponsored and isBestSeller are false', (WidgetTester tester) async {
      final product = SearchProductItemEntity(
        id: '4',
        name: 'USB-C Cable',
        brand: 'CableTech',
        price: '\$9.99',
        rating: 3.8,
        reviewCount: 50,
        isSponsored: false,
        isBestSeller: false,
      );

      // Build the OptionalTags widget
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: OptionalTags(product: product),
          ),
        ),
      );

      // Verify that neither 'Sponsored' nor 'Best Seller' tags are displayed
      expect(find.text('Sponsored'), findsNothing);
      expect(find.text('Best Seller'), findsNothing);
    });
  });
}
