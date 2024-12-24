import 'package:flutter_test/flutter_test.dart';
import 'package:ui/domain/entities/search_product_item_entity.dart';

void main() {
  group("SearchProductItemEntity", () {
    test('should create a valid SearchProductItemEntity', () {
      // Arrange
      const id = '123';
      const name = 'Test Product';
      const brand = 'Test Brand';
      const price = '1,000';

      // Act
      const entity = SearchProductItemEntity(
        id: id,
        name: name,
        brand: brand,
        price: price,
        rating: 4.5,
        reviewCount: 100,
        isSponsored: false,
        isBestSeller: false,
      );

      // Assert
      expect(entity.id, id);
      expect(entity.name, name);
      expect(entity.brand, brand);
      expect(entity.price, price);
      expect(entity.rating, 4.5);
      expect(entity.reviewCount, 100);
      expect(entity.isSponsored, false);
      expect(entity.isBestSeller, false);
    });

    test('should compare two equal SearchProductItemEntity instances', () {
      // Arrange
      const entity1 = SearchProductItemEntity(
        id: '123',
        name: 'Test Product',
        brand: 'Test Brand',
        price: '1,000',
        rating: 4.5,
        reviewCount: 100,
        isSponsored: false,
        isBestSeller: false,
      );
      const entity2 = SearchProductItemEntity(
        id: '123',
        name: 'Test Product',
        brand: 'Test Brand',
        price: '1,000',
        rating: 4.5,
        reviewCount: 100,
        isSponsored: false,
        isBestSeller: false,
      );

      // Act
      final result = entity1 == entity2;

      // Assert
      expect(result, true);
    });

    test('should compare two different SearchProductItemEntity instances', () {
      // Arrange
      const entity1 = SearchProductItemEntity(
        id: '123',
        name: 'Test Product',
        brand: 'Test Brand',
        price: '1,000',
        rating: 4.5,
        reviewCount: 100,
        isSponsored: false,
        isBestSeller: false,
      );
      const entity2 = SearchProductItemEntity(
        id: '456',
        name: 'Test Product 2',
        brand: 'Test Brand 2',
        price: '2,000',
        rating: 4.0,
        reviewCount: 50,
        isSponsored: true,
        isBestSeller: true,
      );

      // Act
      final result = entity1 == entity2;

      // Assert
      expect(result, false);
    });
  });
}
