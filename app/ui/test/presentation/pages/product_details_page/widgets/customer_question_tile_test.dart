import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui/domain/entities/question_entity.dart';
import 'package:ui/presentation/pages/product_details_page/widgets/customer_question_tile.dart';

void main() {
  group('CustomerQuestionTile Widget Tests', () {
    // Sample data with answers
    final questionWithAnswers = QuestionEntity(
      question: 'What is Flutter?',
      answers: [
        AnswerEntity(answer: 'A UI toolkit by Google.', answeredBy: 'Alice'),
        AnswerEntity(
            answer: 'Used for building natively compiled applications.',
            answeredBy: 'Bob'),
      ],
    );

    // Sample data without answers
    final questionWithoutAnswers = QuestionEntity(
      question: 'What is Dart?',
      answers: [],
    );

    testWidgets('Displays the question text correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomerQuestionTile(question: questionWithAnswers),
          ),
        ),
      );

      expect(find.text('What is Flutter?'), findsOneWidget);
    });

    testWidgets('Displays all answers when answers are present', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomerQuestionTile(question: questionWithAnswers),
          ),
        ),
      );

      // Initially, answers are not visible because the tile is collapsed
      expect(find.text('A UI toolkit by Google.'), findsNothing);
      expect(find.text('Used for building natively compiled applications.'), findsNothing);

      // Tap to expand
      await tester.tap(find.byType(ExpansionTile));
      await tester.pumpAndSettle();

      // Now, answers should be visible
      expect(find.text('A UI toolkit by Google.'), findsOneWidget);
      expect(find.text('Answered by Alice'), findsOneWidget);
      expect(find.text('Used for building natively compiled applications.'), findsOneWidget);
      expect(find.text('Answered by Bob'), findsOneWidget);
    });

    testWidgets('Displays "No answers yet." when there are no answers', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomerQuestionTile(question: questionWithoutAnswers),
          ),
        ),
      );

      // Initially, "No answers yet." is not visible because the tile is collapsed
      expect(find.text('No answers yet.'), findsNothing);

      // Tap to expand
      await tester.tap(find.byType(ExpansionTile));
      await tester.pumpAndSettle();

      // "No answers yet." should be visible
      expect(find.text('No answers yet.'), findsOneWidget);
    });

    testWidgets('Applies correct text styles based on theme', (WidgetTester tester) async {
      final testTheme = ThemeData(
        textTheme: TextTheme(
          titleMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          bodyMedium: TextStyle(fontSize: 16),
          bodySmall: TextStyle(fontSize: 12),
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          theme: testTheme,
          home: Scaffold(
            body: CustomerQuestionTile(question: questionWithAnswers),
          ),
        ),
      );

      // Verify the question text style
      final questionText = tester.widget<Text>(find.text('What is Flutter?'));
      expect(questionText.style?.fontWeight, FontWeight.bold);
      expect(questionText.style?.fontSize, 20);

      // Expand to check answer styles
      await tester.tap(find.byType(ExpansionTile));
      await tester.pumpAndSettle();

      final answerText = tester.widget<Text>(find.text('A UI toolkit by Google.'));
      expect(answerText.style?.fontSize, 16);

      final answeredByText = tester.widget<Text>(find.text('Answered by Alice'));
      expect(answeredByText.style?.fontSize, 12);
    });
  });
}