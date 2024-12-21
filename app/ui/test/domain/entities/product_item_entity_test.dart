import 'package:flutter_test/flutter_test.dart';
import 'package:ui/domain/entities/product_item_entity.dart';

void main() {
  group('ProductItemEntity', () {
    test('should create a valid ProductItemEntity', () {
      // Arrange
      const id = '123';
      const name = 'Test Product';
      const brand = 'Test Brand';
      const price = '1,000';

      // Act
      const entity = ProductItemEntity(
        id: id,
        name: name,
        brand: brand,
        price: price,
      );

      // Assert
      expect(entity.id, id);
      expect(entity.name, name);
      expect(entity.brand, brand);
      expect(entity.price, price);
    });

    test('should compare two equal ProductItemEntity instances', () {
      // Arrange
      const entity1 = ProductItemEntity(
        id: '123',
        name: 'Test Product',
        brand: 'Test Brand',
        price: '1,000',
      );
      const entity2 = ProductItemEntity(
        id: '123',
        name: 'Test Product',
        brand: 'Test Brand',
        price: '1,000',
      );

      // Act
      final result = entity1 == entity2;

      // Assert
      expect(result, true);
    });

    test('should compare two different ProductItemEntity instances', () {
      // Arrange
      const entity1 = ProductItemEntity(
        id: '123',
        name: 'Test Product',
        brand: 'Test Brand',
        price: '1,000',
      );
      const entity2 = ProductItemEntity(
        id: '456',
        name: 'Test Product 2',
        brand: 'Test Brand 2',
        price: '2,000',
      );

      // Act
      final result = entity1 == entity2;

      // Assert
      expect(result, false);
    });

    test('should return correct props', () {
      // Arrange
      const entity = ProductItemEntity(
        id: '123',
        name: 'Test Product',
        brand: 'Test Brand',
        price: '1,000',
      );

      // Act
      final props = entity.props;

      // Assert
      expect(props, ['123', 'Test Product', 'Test Brand', '1,000']);
    });
  });
}
