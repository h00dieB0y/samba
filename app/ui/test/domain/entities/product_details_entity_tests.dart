import 'package:flutter_test/flutter_test.dart';
import 'package:ui/domain/entities/product_details_entity.dart';
import 'package:ui/domain/entities/review_entity.dart';
import 'package:ui/domain/entities/related_product_entity.dart';
import 'package:ui/domain/entities/question_entity.dart';

void main() {
  group('ProductDetailsEntity Tests', () {
    late ReviewEntity review1, review2;
    late RelatedProductEntity relatedProduct1, relatedProduct2;
    late QuestionEntity question1, question2;
    late ProductDetailsEntity product1, product2, product3;

    setUp(() {
      review1 = ReviewEntity(
        username: 'user1',
        rating: 4.5,
        comment: 'Great product!',
        date: DateTime(2025, 1, 17),
      );

      review2 = ReviewEntity(
        username: 'user2',
        rating: 3.5,
        comment: 'Decent quality.',
        date: DateTime(2025, 1, 18),
      );

      relatedProduct1 = RelatedProductEntity(
        id: 'R123',
        name: 'Related Product 1',
        image: 'image_url_1',
        price: '15.00',
      );

      relatedProduct2 = RelatedProductEntity(
        id: 'R124',
        name: 'Related Product 2',
        image: 'image_url_2',
        price: '25.00',
      );

      question1 = QuestionEntity(
        question: 'Is this product durable?',
        answers: [
          AnswerEntity(answer: 'Yes', answeredBy: 'user1'),
        ],
      );

      question2 = QuestionEntity(
        question: 'Does this product come in other colors?',
        answers: [
          AnswerEntity(answer: 'No', answeredBy: 'user2'),
        ],
      );

      product1 = ProductDetailsEntity(
        id: 'P123',
        name: 'Product 1',
        brand: 'Brand A',
        price: '20.00',
        stockStatus: 'In Stock',
        shippingLabel: 'Free Shipping',
        cartCount: 5,
        images: ['image_1', 'image_2'],
        description: 'A sample product description.',
        specifications: {'Color': 'Red', 'Weight': '1kg'},
        reviews: [review1, review2],
        relatedProducts: [relatedProduct1, relatedProduct2],
        questions: [question1, question2],
      );

      product2 = ProductDetailsEntity(
        id: 'P123',
        name: 'Product 1',
        brand: 'Brand A',
        price: '20.00',
        stockStatus: 'In Stock',
        shippingLabel: 'Free Shipping',
        cartCount: 5,
        images: ['image_1', 'image_2'],
        description: 'A sample product description.',
        specifications: {'Color': 'Red', 'Weight': '1kg'},
        reviews: [review1, review2],
        relatedProducts: [relatedProduct1, relatedProduct2],
        questions: [question1, question2],
      );

      product3 = ProductDetailsEntity(
        id: 'P124',
        name: 'Product 2',
        brand: 'Brand B',
        price: '25.00',
        stockStatus: 'Out of Stock',
        shippingLabel: 'Paid Shipping',
        cartCount: 0,
        images: ['image_3'],
        description: 'Another product description.',
        specifications: {'Color': 'Blue', 'Weight': '2kg'},
        reviews: [review1],
        relatedProducts: [relatedProduct1],
        questions: [question1],
      );
    });

    test('Two products with identical properties should be equal', () {
      expect(product1, equals(product2)); // Should be equal
    });

    test('Two products with different properties should not be equal', () {
      expect(product1, isNot(equals(product3))); // Should not be equal
    });

    test('Product rating is calculated correctly', () {
      expect(product1.rating, 4.0); // (4.5 + 3.5) / 2 = 4.0
    });

    test('Product review count is calculated correctly', () {
      expect(product1.reviewCount, 2); // Two reviews
    });

    test('Product rating with no reviews should return 0.0', () {
      final productWithoutReviews = ProductDetailsEntity(
        id: 'P125',
        name: 'Product 3',
        brand: 'Brand C',
        price: '30.00',
        stockStatus: 'In Stock',
        shippingLabel: 'Free Shipping',
        cartCount: 0,
        images: ['image_4'],
        description: 'No reviews yet.',
        specifications: {},
        reviews: [],
        relatedProducts: [],
        questions: [],
      );

      expect(productWithoutReviews.rating, 0.0); // No reviews
    });

    test('Product review count with no reviews should return 0', () {
      final productWithoutReviews = ProductDetailsEntity(
        id: 'P125',
        name: 'Product 3',
        brand: 'Brand C',
        price: '30.00',
        stockStatus: 'In Stock',
        shippingLabel: 'Free Shipping',
        cartCount: 0,
        images: ['image_4'],
        description: 'No reviews yet.',
        specifications: {},
        reviews: [],
        relatedProducts: [],
        questions: [],
      );

      expect(productWithoutReviews.reviewCount, 0); // No reviews
    });
  });
}