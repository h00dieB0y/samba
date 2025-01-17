import 'package:flutter_test/flutter_test.dart';
import 'package:ui/domain/entities/review_entity.dart';

void main() {
  group('ReviewEntity Tests', () {
    test('Two reviews with identical properties should be equal', () {
      final review1 = ReviewEntity(
        username: 'user123',
        rating: 4.5,
        comment: 'Great product!',
        date: DateTime(2025, 1, 17),
      );

      final review2 = ReviewEntity(
        username: 'user123',
        rating: 4.5,
        comment: 'Great product!',
        date: DateTime(2025, 1, 17),
      );

      expect(review1, equals(review2)); // Should be equal
    });

    test('Two reviews with different properties should not be equal', () {
      final review1 = ReviewEntity(
        username: 'user123',
        rating: 4.5,
        comment: 'Great product!',
        date: DateTime(2025, 1, 17),
      );

      final review2 = ReviewEntity(
        username: 'user124',
        rating: 4.0,
        comment: 'Good product.',
        date: DateTime(2025, 1, 18),
      );

      expect(review1, isNot(equals(review2))); // Should not be equal
    });
  });
}