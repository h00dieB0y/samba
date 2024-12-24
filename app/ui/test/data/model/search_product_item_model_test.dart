import 'package:flutter_test/flutter_test.dart';
import 'package:ui/data/models/search_product_item_model.dart';
import 'package:ui/domain/entities/search_product_item_entity.dart';

void main() {
  group('SearchProductItemModel', () {
    const mockJson = {
      'id': 123,
      'name': 'Product Name',
      'brand': 'Brand Name',
      'price': 1299,
      'rating': 4.5,
      'reviewCount': 100,
      'isSponsored': true,
      'isBestSeller': false,
    };

    test('fromJson should parse JSON correctly', () {
      // Act
      final model = SearchProductItemModel.fromJson(mockJson);

      // Assert
      expect(model.id, '123'); // Because of .toString() in fromJson
      expect(model.name, 'Product Name');
      expect(model.brand, 'Brand Name');
      expect(model.price, 1299);
      expect(model.rating, 4.5);
      expect(model.reviewCount, 100);
      expect(model.isSponsored, true);
      expect(model.isBestSeller, false);
    });

    test('toEntity should convert model to SearchProductItemEntity correctly', () {
      // Arrange
      final model = SearchProductItemModel(
        id: '123',
        name: 'Product Name',
        brand: 'Brand Name',
        price: 1299,
        rating: 4.5,
        reviewCount: 100,
        isSponsored: true,
        isBestSeller: false,
      );

      // Act
      final entity = model.toEntity();

      // Assert
      expect(entity, isA<SearchProductItemEntity>());
      expect(entity.id, '123');
      expect(entity.name, 'Product Name');
      expect(entity.brand, 'Brand Name');
      // The price should be formatted with commas, e.g. "1,299"
      expect(entity.price, '1,299');
      expect(entity.rating, 4.5);
      expect(entity.reviewCount, 100);
      expect(entity.isSponsored, true);
      expect(entity.isBestSeller, false);
    });

    test('should compare two equal SearchProductItemModel instances', () {
      // Arrange
      final model1 = SearchProductItemModel(
        id: '123',
        name: 'Product Name',
        brand: 'Brand Name',
        price: 1299,
        rating: 4.5,
        reviewCount: 100,
        isSponsored: true,
        isBestSeller: false,
      );
      final model2 = SearchProductItemModel(
        id: '123',
        name: 'Product Name',
        brand: 'Brand Name',
        price: 1299,
        rating: 4.5,
        reviewCount: 100,
        isSponsored: true,
        isBestSeller: false,
      );

      // Act & Assert
      // Since both models have identical props, they should be equal.
      expect(model1, equals(model2));
      expect(model1.props, equals(model2.props));
    });
  });
}
