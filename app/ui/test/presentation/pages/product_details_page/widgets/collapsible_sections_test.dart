import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui/domain/entities/product_details_entity.dart';
import 'package:ui/domain/entities/review_entity.dart';

void main() {
  group('CollapsibleSections Widget Tests', () {
    late ProductDetailsEntity productWithSpecs;
    late ProductDetailsEntity productWithoutSpecs;

    setUp(() {
      productWithSpecs = ProductDetailsEntity(
        description: 'This is a sample product description.',
        specifications: {
          'Weight': '1kg',
          'Color': 'Red',
        },
        reviews: [
          // Assuming Review is a valid class
          ReviewEntity(user: 'User1', comment: 'Great product!', rating: 5),
          Review(user: 'User2', comment: 'Good value for money.', rating: 4),
        ],
        rating: 4.5,
      );

      productWithoutSpecs = ProductDetailsEntity(
        description: 'This is another product description.',
        specifications: {},
        reviews: [],
        rating: 0.0,
      );
    });

    Widget createWidgetUnderTest(ProductDetailsEntity product) {
      return MaterialApp(
        home: Scaffold(
          body: CollapsibleSections(product: product),
        ),
      );
    }

    testWidgets('Displays all three sections', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest(productWithSpecs));

      expect(find.text('Description'), findsOneWidget);
      expect(find.text('Specifications'), findsOneWidget);
      expect(find.text('Reviews'), findsOneWidget);
    });

    testWidgets('Expands and displays description content', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest(productWithSpecs));

      // Initially, description content should not be visible
      expect(find.text(productWithSpecs.description), findsNothing);

      // Tap on the Description header
      await tester.tap(find.text('Description'));
      await tester.pumpAndSettle();

      // Now, the description content should be visible
      expect(find.text(productWithSpecs.description), findsOneWidget);
    });

    testWidgets('Displays specifications table when specifications are available', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest(productWithSpecs));

      // Expand Specifications section
      await tester.tap(find.text('Specifications'));
      await tester.pumpAndSettle();

      // Check for specification keys and values
      productWithSpecs.specifications.forEach((key, value) {
        expect(find.text(key), findsOneWidget);
        expect(find.text(value), findsOneWidget);
      });
    });

    testWidgets('Displays "No specifications available." when specifications are empty', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest(productWithoutSpecs));

      // Expand Specifications section
      await tester.tap(find.text('Specifications'));
      await tester.pumpAndSettle();

      expect(find.text('No specifications available.'), findsOneWidget);
    });

    testWidgets('Expands and displays reviews content', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest(productWithSpecs));

      // Expand Reviews section
      await tester.tap(find.text('Reviews'));
      await tester.pumpAndSettle();

      // Verify that ReviewsAndQnA widget is displayed with correct parameters
      final reviewsAndQnAFinder = find.byType(ReviewsAndQnA);
      expect(reviewsAndQnAFinder, findsOneWidget);

      final ReviewsAndQnA reviewsAndQnAWidget =
          tester.widget<ReviewsAndQnA>(reviewsAndQnAFinder);
      expect(reviewsAndQnAWidget.reviews, productWithSpecs.reviews);
      expect(reviewsAndQnAWidget.averageRating, productWithSpecs.rating);
    });

    testWidgets('Only one panel can be expanded at a time', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest(productWithSpecs));

      // Expand Description section
      await tester.tap(find.text('Description'));
      await tester.pumpAndSettle();
      expect(find.text(productWithSpecs.description), findsOneWidget);

      // Expand Reviews section
      await tester.tap(find.text('Reviews'));
      await tester.pumpAndSettle();
      expect(find.text(productWithSpecs.description), findsNothing);
      expect(find.byType(ReviewsAndQnA), findsOneWidget);
    });

    testWidgets('Displays ReviewsAndQnA with empty reviews and zero rating', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest(productWithoutSpecs));

      // Expand Reviews section
      await tester.tap(find.text('Reviews'));
      await tester.pumpAndSettle();

      // Verify that ReviewsAndQnA widget is displayed with empty reviews and zero rating
      final reviewsAndQnAFinder = find.byType(ReviewsAndQnA);
      expect(reviewsAndQnAFinder, findsOneWidget);

      final ReviewsAndQnA reviewsAndQnAWidget =
          tester.widget<ReviewsAndQnA>(reviewsAndQnAFinder);
      expect(reviewsAndQnAWidget.reviews, isEmpty);
      expect(reviewsAndQnAWidget.averageRating, 0.0);
    });
  });
}