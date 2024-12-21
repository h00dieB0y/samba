import 'package:flutter_test/flutter_test.dart';
import 'package:ui/data/models/product_item_model.dart';

void main() {
  group('ProductItemModel', () {
    test('should create a valid ProductItemModel from JSON', () {
      // Arrange
      final json = {
        'id': '123',
        'name': 'Test Product',
        'brand': 'Test Brand',
        'price': 1000,
      };

      // Act
      final model = ProductItemModel.fromJson(json);

      // Assert
      expect(model.id, '123');
      expect(model.name, 'Test Product');
      expect(model.brand, 'Test Brand');
      expect(model.price, 1000);
    });

    test('should convert ProductItemModel to ProductItemEntity', () {
      // Arrange
      final model = ProductItemModel(
        id: '123',
        name: 'Test Product',
        brand: 'Test Brand',
        price: 1000,
      );

      // Act
      final entity = model.toEntity();

      // Assert
      expect(entity.id, '123');
      expect(entity.name, 'Test Product');
      expect(entity.brand, 'Test Brand');
      expect(entity.price, '1,000');
    });
  });

  group('ProductItemModel Equatable', () {
    test('should compare two equal ProductItemModel instances', () {
      // Arrange
      final model1 = ProductItemModel(
        id: '123',
        name: 'Test Product',
        brand: 'Test Brand',
        price: 1000,
      );
      final model2 = ProductItemModel(
        id: '123',
        name: 'Test Product',
        brand: 'Test Brand',
        price: 1000,
      );

      // Act
      final result = model1 == model2;

      // Assert
      expect(result, true);
    });

    test('should compare two different ProductItemModel instances', () {
      // Arrange
      final model1 = ProductItemModel(
        id: '123',
        name: 'Test Product',
        brand: 'Test Brand',
        price: 1000,
      );
      final model2 = ProductItemModel(
        id: '456',
        name: 'Test Product 2',
        brand: 'Test Brand 2',
        price: 2000,
      );

      // Act
      final result = model1 == model2;

      // Assert
      expect(result, false);
    });
  });
}