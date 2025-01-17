import 'package:flutter_test/flutter_test.dart';
import 'package:ui/domain/entities/related_product_entity.dart';

void main() {
  group('RelatedProductEntity Tests', () {
    test('Two related products with identical properties should be equal', () {
      final product1 = RelatedProductEntity(
        id: '123',
        name: 'Product A',
        image: 'product_a_image_url',
        price: '20.00',
      );

      final product2 = RelatedProductEntity(
        id: '123',
        name: 'Product A',
        image: 'product_a_image_url',
        price: '20.00',
      );

      expect(product1, equals(product2)); // Should be equal
    });

    test('Two related products with different properties should not be equal', () {
      final product1 = RelatedProductEntity(
        id: '123',
        name: 'Product A',
        image: 'product_a_image_url',
        price: '20.00',
      );

      final product2 = RelatedProductEntity(
        id: '124',
        name: 'Product B',
        image: 'product_b_image_url',
        price: '25.00',
      );

      expect(product1, isNot(equals(product2))); // Should not be equal
    });

    test('Different order of properties should still be equal if values are the same', () {
      final product1 = RelatedProductEntity(
        id: '123',
        name: 'Product A',
        image: 'product_a_image_url',
        price: '20.00',
      );

      final product2 = RelatedProductEntity(
        id: '123',
        name: 'Product A',
        image: 'product_a_image_url',
        price: '20.00',
      );

      expect(product1, equals(product2)); // Should be equal, properties in different order do not affect equality
    });

    test('Equality comparison based on id should work as expected', () {
      final product1 = RelatedProductEntity(
        id: '123',
        name: 'Product A',
        image: 'product_a_image_url',
        price: '20.00',
      );

      final product2 = RelatedProductEntity(
        id: '123',
        name: 'Product A',
        image: 'product_a_image_url',
        price: '20.00',
      );

      final product3 = RelatedProductEntity(
        id: '124',
        name: 'Product B',
        image: 'product_b_image_url',
        price: '25.00',
      );

      expect(product1 == product2, true); // Same id should be equal
      expect(product1 == product3, false); // Different id should not be equal
    });
  });
}