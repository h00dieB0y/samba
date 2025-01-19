import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui/domain/entities/related_product_entity.dart';
import 'package:ui/presentation/pages/product_details_page/widgets/related_product_card.dart';

void main() {
  group('RelatedProductCard Widget Tests', () {
    final product = RelatedProductEntity(
      id: '123',
      name: 'Test Product',
      image: 'https://example.com/image.jpg',
      price: '19.99',
    );

    testWidgets('Displays product name, price, and image correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RelatedProductCard(product: product),
          ),
        ),
      );

      // Check if product name is displayed
      expect(find.text('Test Product'), findsOneWidget);

      // Check if product price is displayed
      expect(find.text('\$19.99'), findsOneWidget);

      // Check if product image is displayed
      expect(find.byType(Image), findsOneWidget);
    });
    
    testWidgets('Displays error icon when image fails to load', (WidgetTester tester) async {
      // Use an invalid URL to trigger an error
      final invalidProduct = RelatedProductEntity(
        id: '124',
        name: 'Invalid Product',
        image: 'https://example.com/invalid-image.jpg', // Invalid URL
        price: '29.99',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RelatedProductCard(product: invalidProduct),
          ),
        ),
      );

      // Wait for the image loading to fail
      await tester.pumpAndSettle();

      // Check if the error icon is displayed
      expect(find.byIcon(Icons.broken_image), findsOneWidget);
    });
  });
}