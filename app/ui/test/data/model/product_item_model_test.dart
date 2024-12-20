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
}