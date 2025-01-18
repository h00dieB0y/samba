import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui/domain/entities/product_details_entity.dart';
import 'package:ui/domain/entities/question_entity.dart';
import 'package:ui/domain/entities/related_product_entity.dart';
import 'package:ui/domain/entities/review_entity.dart';
import 'package:ui/presentation/pages/product_details_page/widgets/customer_qn_a.dart';
import 'package:ui/presentation/pages/product_details_page/widgets/customer_question_tile.dart';


ProductDetailsEntity createTestProductDetails({
  List<QuestionEntity>? questions,
}) {
  return ProductDetailsEntity(
    id: '1',
    name: 'Test Product',
    brand: 'Test Brand',
    price: '\$99.99',
    oldPrice: '\$119.99',
    discount: '20%',
    stockStatus: 'In Stock',
    shippingLabel: 'Free Shipping',
    offerEndTime: DateTime.now().add(Duration(days: 5)),
    cartCount: 0,
    images: ['https://example.com/image1.png', 'https://example.com/image2.png'],
    description: 'This is a test product description.',
    specifications: {
      'Weight': '1kg',
      'Color': 'Red',
      'Material': 'Plastic',
    },
    reviews: [
      ReviewEntity(
        username: 'Alice',
        rating: 4.5,
        comment: 'Great product!',
        date: DateTime.now().subtract(Duration(days: 2)),
      ),
    ],
    relatedProducts: [
      RelatedProductEntity(
        id: '2',
        name: 'Related Product 1',
        price: '\$59.99',
        image: 'https://example.com/related1.png',
      ),
    ],
    questions: questions ?? [],
  );
}

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
    final productWithQuestions = createTestProductDetails(
      questions: createTestQuestions(),
    );

    // Sample data without questions
    final productWithoutQuestions = createTestProductDetails(
      questions: [],
    );

    testWidgets('Displays the Q&A section title correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomerQnA(
              product: productWithQuestions,
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
              product: productWithQuestions,
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
              product: productWithQuestions,
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
              product: productWithQuestions,
            ),
          ),
        ),
      );

      // Verify that the correct number of CustomerQuestionTile widgets are rendered
      expect(find.byType(CustomerQuestionTile), findsNWidgets(productWithQuestions.questions.length));

      // Optionally, verify specific question texts
      for (var question in productWithQuestions.questions) {
        expect(find.text(question.question), findsWidgets);
      }
    });

    testWidgets('Displays placeholder text when no questions are available', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomerQnA(
              product: productWithoutQuestions,
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