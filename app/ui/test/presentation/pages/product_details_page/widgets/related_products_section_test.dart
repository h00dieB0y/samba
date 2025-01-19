import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui/domain/entities/related_product_entity.dart';
import 'package:ui/presentation/pages/product_details_page/widgets/related_product_card.dart';
import 'package:ui/presentation/pages/product_details_page/widgets/related_products_section.dart';

void main() {
  group('RelatedProductsSection Widget Tests', () {
    final relatedProduct1 = RelatedProductEntity(
      id: '123',
      name: 'Product 1',
      image: 'https://example.com/image1.jpg',
      price: '19.99',
    );

    final relatedProduct2 = RelatedProductEntity(
      id: '124',
      name: 'Product 2',
      image: 'https://example.com/image2.jpg',
      price: '29.99',
    );

    testWidgets('Displays nothing when relatedProducts is empty', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RelatedProductsSection(relatedProducts: []),
          ),
        ),
      );

      // Check that nothing is rendered (SizedBox.shrink)
      expect(find.byType(RelatedProductsSection), findsOneWidget);
      expect(find.byType(RelatedProductCard), findsNothing); // No related product cards should be found
    });

    testWidgets('Displays related products when the list is not empty', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RelatedProductsSection(relatedProducts: [relatedProduct1, relatedProduct2]),
          ),
        ),
      );

      // Check that the related products are displayed
      expect(find.byType(RelatedProductCard), findsNWidgets(2)); // Expect two cards
      expect(find.text('Product 1'), findsOneWidget); // First product name should be displayed
      expect(find.text('Product 2'), findsOneWidget); // Second product name should be displayed
    });

    testWidgets('Displays "Related Products" label', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RelatedProductsSection(relatedProducts: [relatedProduct1]),
          ),
        ),
      );

      // Check that the label "Related Products" is displayed
      expect(find.text('Related Products'), findsOneWidget);
    });
  });
}