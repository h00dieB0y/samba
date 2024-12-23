import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui/presentation/pages/search_page/widgets/ratings_and_reviews.dart';

void main() {
  group('RatingsAndReviews Widget Tests', () {
    testWidgets('RatingsAndReviews displays correct star ratings and review count', (WidgetTester tester) async {
      const double rating = 4.5;
      const int reviewCount = 120;

      // Build the RatingsAndReviews widget
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RatingsAndReviews(rating: rating, reviewCount: reviewCount),
          ),
        ),
      );

      // Verify that the correct number of stars are displayed
      // 4 full stars, 1 half star
      expect(find.byIcon(Icons.star), findsNWidgets(4));
      expect(find.byIcon(Icons.star_half), findsOneWidget);
      expect(find.byIcon(Icons.star_border), findsNWidgets(0));

      // Verify that the review count is displayed
      expect(find.text('($reviewCount)'), findsOneWidget);

      // Verify the text style
      final Text reviewText = tester.widget(find.text('($reviewCount)'));
      expect(reviewText.style?.fontSize, 12);
      expect(reviewText.style?.color, Colors.blueGrey);
    });

    testWidgets('RatingsAndReviews displays empty stars correctly', (WidgetTester tester) async {
      const double rating = 0.0;
      const int reviewCount = 0;

      // Build the RatingsAndReviews widget
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RatingsAndReviews(rating: rating, reviewCount: reviewCount),
          ),
        ),
      );

      // Verify that all stars are outlined
      expect(find.byIcon(Icons.star), findsNWidgets(0));
      expect(find.byIcon(Icons.star_half), findsNWidgets(0));
      expect(find.byIcon(Icons.star_border), findsNWidgets(5));

      // Verify that the review count is displayed
      expect(find.text('($reviewCount)'), findsOneWidget);
    });

    testWidgets('RatingsAndReviews displays full stars correctly', (WidgetTester tester) async {
      const double rating = 5.0;
      const int reviewCount = 200;

      // Build the RatingsAndReviews widget
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RatingsAndReviews(rating: rating, reviewCount: reviewCount),
          ),
        ),
      );

      // Verify that all stars are full
      expect(find.byIcon(Icons.star), findsNWidgets(5));
      expect(find.byIcon(Icons.star_half), findsNWidgets(0));
      expect(find.byIcon(Icons.star_border), findsNWidgets(0));

      // Verify that the review count is displayed
      expect(find.text('($reviewCount)'), findsOneWidget);
    });
  });
}
