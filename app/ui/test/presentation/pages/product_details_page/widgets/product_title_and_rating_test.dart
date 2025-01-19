import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui/presentation/pages/product_details_page/widgets/product_title_and_rating.dart';
import 'package:ui/presentation/pages/product_details_page/widgets/review_breakdown.dart';
import 'package:ui/presentation/pages/widgets/star_rating.dart';

void main() {
  group('ProductTitleAndRating Widget Tests', () {
    const String productName = 'Test Product';
    const String brandName = 'Test Brand';
    const double rating = 4.5;
    const int reviewCount = 120;
    final reviewBreakdown = {
      5: 50,
      4: 30,
      3: 15,
      2: 5,
    };

    testWidgets('Displays product name, brand name, rating, and review count', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProductTitleAndRating(
              productName: productName,
              brandName: brandName,
              rating: rating,
              reviewCount: reviewCount,
              reviewBreakdown: reviewBreakdown,
            ),
          ),
        ),
      );

      // Check if brand name is displayed
      expect(find.text(brandName), findsOneWidget);

      // Check if product name is displayed
      expect(find.text(productName), findsOneWidget);

      // Check if rating stars are displayed
      expect(find.byType(StarRating), findsOneWidget);

      // Check if review count is displayed in the text
      expect(find.text('($reviewCount reviews)'), findsOneWidget);
    });

    testWidgets('Displays review breakdown correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProductTitleAndRating(
              productName: productName,
              brandName: brandName,
              rating: rating,
              reviewCount: reviewCount,
              reviewBreakdown: reviewBreakdown,
            ),
          ),
        ),
      );

      // Check if the ReviewBreakdown widget is displayed
      expect(find.byType(ReviewBreakdown), findsOneWidget);

      // Check if review breakdown percentages are displayed correctly
      expect(find.text('50%'), findsOneWidget); // For rating 5
      expect(find.text('30%'), findsOneWidget); // For rating 4
      expect(find.text('15%'), findsOneWidget); // For rating 3
      expect(find.text('5%'), findsOneWidget);  // For rating 2
    });

    testWidgets('Displays product name and brand name with correct styling', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProductTitleAndRating(
              productName: productName,
              brandName: brandName,
              rating: rating,
              reviewCount: reviewCount,
              reviewBreakdown: reviewBreakdown,
            ),
          ),
        ),
      );

      // Check if the brand name has correct opacity and styling
      final brandText = tester.widget<Text>(find.text(brandName));
      expect(brandText.style?.color?.opacity, 0.6); // Check opacity

      // Check if the product name has correct bold styling
      final productText = tester.widget<Text>(find.text(productName));
      expect(productText.style?.fontWeight, FontWeight.bold); // Check bold styling
    });

    testWidgets('Tap on review count text', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProductTitleAndRating(
              productName: productName,
              brandName: brandName,
              rating: rating,
              reviewCount: reviewCount,
              reviewBreakdown: reviewBreakdown,
            ),
          ),
        ),
      );

      // Simulate tap on review count text
      await tester.tap(find.text('($reviewCount reviews)'));
      await tester.pump();

      // Add a check for expected behavior after tap (scroll, navigation, etc.)
      // Since there's no actual navigation in this example, we would add relevant checks based on app behavior.
    });
  });
}