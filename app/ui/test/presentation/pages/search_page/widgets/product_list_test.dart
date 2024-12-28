import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui/domain/entities/search_product_item_entity.dart';
import 'package:ui/presentation/pages/search_page/widgets/product_list.dart';
import 'package:ui/presentation/pages/search_page/widgets/product_card.dart';

void main() {
  group('ProductList Widget Tests', () {
    // Define mock products
    final List<SearchProductItemEntity> mockProducts = [
      SearchProductItemEntity(
        id: '1',
        name: 'Product 1',
        brand: 'Brand A',
        price: '1,999',
        rating: 4.5,
        reviewCount: 100,
        isSponsored: false,
        isBestSeller: false,
      ),
      SearchProductItemEntity(
        id: '2',
        name: 'Product 2',
        brand: 'Brand B',
        price: '3,499',
        rating: 4.2,
        reviewCount: 50,
        isSponsored: true,
        isBestSeller: true,
      ),
    ];

    // Helper function to build the widget
    Widget createWidgetUnderTest({required List<SearchProductItemEntity> products}) {
      return MaterialApp(
        home: Scaffold(
          body: ProductList(products: products),
        ),
      );
    }

    testWidgets('renders ProductList with given products',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(createWidgetUnderTest(products: mockProducts));

      // Act
      // No action needed for rendering test

      // Assert
      // Check that ListView is present with correct key
      expect(find.byKey(const Key('product_list_view')), findsOneWidget);

      // Check that ProductCard widgets are present
      expect(find.byType(ProductCard), findsNWidgets(mockProducts.length));
    });

    testWidgets('renders empty ProductList when products list is empty',
        (WidgetTester tester) async {
      // Arrange
      final emptyProducts = <SearchProductItemEntity>[];

      await tester.pumpWidget(createWidgetUnderTest(products: emptyProducts));

      // Act
      // No action needed

      // Assert
      // ListView is present
      expect(find.byKey(const Key('product_list_view')), findsOneWidget);

      // No ProductCard widgets should be present
      expect(find.byType(ProductCard), findsNothing);
    });

    testWidgets('renders ProductList correctly when product data changes',
        (WidgetTester tester) async {
      // Arrange
      final List<SearchProductItemEntity> initialProducts = [
        SearchProductItemEntity(
          id: '1',
          name: 'Initial Product',
          brand: 'Initial Brand',
          price: '1,999',
          rating: 4.0,
          reviewCount: 100,
          isSponsored: false,
          isBestSeller: false,
        ),
      ];

      await tester.pumpWidget(createWidgetUnderTest(products: initialProducts));

      // Act
      // Rebuild the widget with new products
      final List<SearchProductItemEntity> updatedProducts = [
        SearchProductItemEntity(
          id: '2',
          name: 'Updated Product',
          brand: 'Updated Brand',
          price: '2,999',
          rating: 4.5,
          reviewCount: 200,
          isSponsored: true,
          isBestSeller: true,
        ),
        SearchProductItemEntity(
          id: '3',
          name: 'Another Product',
          brand: 'Brand C',
          price: '3,999',
          rating: 4.7,
          reviewCount: 300,
          isSponsored: false,
          isBestSeller: false,
        ),
      ];

      await tester.pumpWidget(createWidgetUnderTest(products: updatedProducts));

      // Allow widget tree to rebuild
      await tester.pumpAndSettle();

      // Assert
      // Old product should not be found
      expect(find.text('Initial Product'), findsNothing);

      // New products should be present
      expect(find.text('Updated Product'), findsOneWidget);
      expect(find.text('Another Product'), findsOneWidget);
      expect(find.text('Updated Brand'), findsOneWidget);
      expect(find.text('Brand C'), findsOneWidget);
      expect(find.text('2,999'), findsOneWidget);
      expect(find.text('3,999'), findsOneWidget);
    });
  });
}
