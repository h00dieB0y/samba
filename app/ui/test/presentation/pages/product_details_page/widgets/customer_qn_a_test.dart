import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui/domain/entities/product_details_entity.dart';
import 'package:ui/domain/entities/question_entity.dart';
import 'package:ui/domain/entities/related_product_entity.dart';
import 'package:ui/domain/entities/review_entity.dart';
import 'package:ui/presentation/pages/product_details_page/widgets/customer_qn_a.dart';
import 'package:ui/presentation/pages/product_details_page/widgets/customer_question_tile.dart';

List<QuestionEntity> createTestQuestions() {
  return [
    QuestionEntity(
      question: 'What is Flutter?',
      answers: [
        AnswerEntity(answer: 'A UI toolkit by Google.', answeredBy: 'Alice'),
        AnswerEntity(
          answer: 'Used for building natively compiled applications.',
          answeredBy: 'Bob',
        ),
      ],
    ),
    QuestionEntity(
      question: 'How to manage state in Flutter?',
      answers: [
        AnswerEntity(answer: 'Using Provider package.', answeredBy: 'Charlie'),
      ],
    ),
  ];
}

void main() {
  group('CustomerQnA Widget Tests', () {
    // Sample data with questions
    final emptyQuestions = <QuestionEntity>[];

    final sampleQuestions = createTestQuestions();

    testWidgets('Displays the Q&A section title correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomerQnA(
              questions: sampleQuestions,
              onAskQuestion: () {},
            ),
          ),
        ),
      );

      expect(find.text('Customer Questions & Answers'), findsOneWidget);
      expect(find.bySemanticsLabel('Customer Q&A Section'), findsOneWidget);
    });

    testWidgets('Displays "Ask a Question" button correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomerQnA(
              questions: sampleQuestions,
              onAskQuestion: () {},
            ),
          ),
        ),
      );
      expect(find.byKey(const Key('ask_question_button')), findsOneWidget);
      expect(find.text('Ask a Question'), findsOneWidget);
      expect(find.byIcon(Icons.question_answer), findsOneWidget);
    });

    testWidgets('"Ask a Question" button is tappable', (WidgetTester tester) async {
      bool wasTapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomerQnA(
              questions: sampleQuestions,
              onAskQuestion: () {
                wasTapped = true;
              },
            ),
          ),
        ),
      );

      final askButtonFinder = find.byKey(const Key('ask_question_button'));
      expect(askButtonFinder, findsOneWidget);

      await tester.tap(askButtonFinder);
      await tester.pump();

      expect(wasTapped, isTrue);
    });

    testWidgets('Displays a list of CustomerQuestionTile when questions are present', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomerQnA(
              questions: sampleQuestions,
              onAskQuestion: () {},
            ),
          ),
        ),
      );

      // Verify that the correct number of CustomerQuestionTile widgets are rendered
      expect(find.byType(CustomerQuestionTile), findsNWidgets(sampleQuestions.length));

      // Optionally, verify specific question texts
      for (var question in sampleQuestions) {
        expect(find.text(question.question), findsWidgets);
      }
    });

    testWidgets('Displays placeholder text when no questions are available', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomerQnA(
              questions: emptyQuestions,
              onAskQuestion: () {},
            ),
          ),
        ),
      );

      expect(find.text('No questions yet. Be the first to ask!'), findsOneWidget);
      expect(find.bySemanticsLabel('No questions available'), findsOneWidget);
      expect(find.byType(CustomerQuestionTile), findsNothing);
    });
  });
}