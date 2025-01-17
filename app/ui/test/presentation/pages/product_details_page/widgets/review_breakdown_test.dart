import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui/presentation/pages/product_details_page/widgets/review_breakdown.dart';

void main() {
  group('ReviewBreakdown Widget Tests', () {
    final reviewBreakdown = {
      5: 50,
      4: 30,
      3: 15,
      2: 5,
    };

    testWidgets('Displays star ratings, progress bar, and percentage correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ReviewBreakdown(rating: 4.5, reviewBreakdown: reviewBreakdown),
          ),
        ),
      );

      // Check if the correct number of stars is displayed for each rating level
      expect(find.byIcon(Icons.star), findsNWidgets(5)); // 5 stars for rating 5

      // Check the progress bars for each rating level
      final progressBars = find.byType(LinearProgressIndicator);
      expect(progressBars, findsNWidgets(4)); // 4 progress bars for 4 rating levels

      // Check if the percentage texts are displayed correctly
      expect(find.text('50%'), findsOneWidget); // For rating 5
      expect(find.text('30%'), findsOneWidget); // For rating 4
      expect(find.text('15%'), findsOneWidget); // For rating 3
      expect(find.text('5%'), findsOneWidget);  // For rating 2
    });

    testWidgets('Displays no stars or progress bars if breakdown is empty', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ReviewBreakdown(rating: 0.0, reviewBreakdown: {}),
          ),
        ),
      );

      // Ensure no stars or progress bars are displayed when the breakdown is empty
      expect(find.byIcon(Icons.star), findsNothing);
      expect(find.byType(LinearProgressIndicator), findsNothing);
      expect(find.text('0%'), findsNothing);  // No percentages should be displayed
    });

    testWidgets('Progress bar reflects correct percentage based on review breakdown', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ReviewBreakdown(rating: 4.5, reviewBreakdown: reviewBreakdown),
          ),
        ),
      );

      // Check that the LinearProgressIndicator for the 5-star rating shows the correct value
      final progressBars = find.byType(LinearProgressIndicator);
      final LinearProgressIndicator progressBar = tester.widget(progressBars.first);
      final expectedProgress = 50 / (50 + 30 + 15 + 5); // 50% of total
      expect(progressBar.value, expectedProgress);
    });
  });
}