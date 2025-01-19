import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui/domain/entities/review_entity.dart';
import 'package:intl/intl.dart';
import 'package:ui/presentation/pages/product_details_page/widgets/review_tile.dart';
import 'package:ui/presentation/pages/widgets/star_rating.dart';

void main() {
  group('ReviewTile Widget Tests', () {
    late ReviewEntity review;

    setUp(() {
      review = ReviewEntity(
        username: 'user123',
        rating: 4.5,
        comment: 'This is a great product!',
        isVerifiedPurchase: true,
        date: DateTime(2025, 1, 17),
      );
    });

    testWidgets('ReviewTile displays username', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ReviewTile(review: review),
          ),
        ),
      );

      expect(find.text('user123'), findsOneWidget); // Should display the username
    });

    testWidgets('ReviewTile displays "Verified" badge for verified purchase', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ReviewTile(review: review),
          ),
        ),
      );

      expect(find.text('Verified'), findsOneWidget); // Should display the "Verified" badge
    });

    testWidgets('ReviewTile does not display "Verified" badge if not a verified purchase', (WidgetTester tester) async {
      review = ReviewEntity(
        username: 'user123',
        rating: 4.5,
        comment: 'This is a great product!',
        isVerifiedPurchase: false,
        date: DateTime(2025, 1, 17),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ReviewTile(review: review),
          ),
        ),
      );

      expect(find.text('Verified'), findsNothing); // Should not display the "Verified" badge
    });

    testWidgets('ReviewTile displays the correct star rating', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ReviewTile(review: review),
          ),
        ),
      );

      // You can test the existence of the StarRating widget or its specific behavior
      expect(find.byType(StarRating), findsOneWidget); // Should display the StarRating widget
    });

    testWidgets('ReviewTile displays the review comment', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ReviewTile(review: review),
          ),
        ),
      );

      expect(find.text('This is a great product!'), findsOneWidget); // Should display the comment
    });

    testWidgets('ReviewTile displays the correctly formatted date', (WidgetTester tester) async {
      final formattedDate = DateFormat.yMMMMd().format(review.date.toLocal());

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ReviewTile(review: review),
          ),
        ),
      );

      expect(find.text(formattedDate), findsOneWidget); // Should display the formatted date
    });

    testWidgets('ReviewTile displays correctly styled elements', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ReviewTile(review: review),
          ),
        ),
      );

      final textStyle = Theme.of(tester.element(find.byType(ReviewTile)))
          .textTheme
          .titleMedium;

      // Check if the username text style is applied
      expect(
        tester.widget<Text>(find.text('user123')).style,
        equals(textStyle?.copyWith(
          fontWeight: FontWeight.bold,
          color: Theme.of(tester.element(find.byType(ReviewTile))).colorScheme.primary,
        )),
      );
    });
  });
}