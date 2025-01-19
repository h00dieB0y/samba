import 'package:flutter_test/flutter_test.dart';
import 'package:ui/domain/entities/question_entity.dart';

void main() {
  group('AnswerEntity Tests', () {
    test('Two answers with identical properties should be equal', () {
      final answer1 = AnswerEntity(
        answer: 'Yes',
        answeredBy: 'User1',
      );

      final answer2 = AnswerEntity(
        answer: 'Yes',
        answeredBy: 'User1',
      );

      expect(answer1, equals(answer2)); // Should be equal
    });

    test('Two answers with different properties should not be equal', () {
      final answer1 = AnswerEntity(
        answer: 'Yes',
        answeredBy: 'User1',
      );

      final answer2 = AnswerEntity(
        answer: 'No',
        answeredBy: 'User2',
      );

      expect(answer1, isNot(equals(answer2))); // Should not be equal
    });
  });

  group('QuestionEntity Tests', () {
    test('Two questions with identical properties should be equal', () {
      final answer1 = AnswerEntity(answer: 'Yes', answeredBy: 'User1');
      final answer2 = AnswerEntity(answer: 'No', answeredBy: 'User2');

      final question1 = QuestionEntity(
        question: 'Is Flutter awesome?',
        answers: [answer1, answer2],
      );

      final question2 = QuestionEntity(
        question: 'Is Flutter awesome?',
        answers: [answer1, answer2],
      );

      expect(question1, equals(question2)); // Should be equal
    });

    test('Two questions with different properties should not be equal', () {
      final answer1 = AnswerEntity(answer: 'Yes', answeredBy: 'User1');
      final answer2 = AnswerEntity(answer: 'No', answeredBy: 'User2');

      final question1 = QuestionEntity(
        question: 'Is Flutter awesome?',
        answers: [answer1],
      );

      final question2 = QuestionEntity(
        question: 'Is Dart awesome?',
        answers: [answer2],
      );

      expect(question1, isNot(equals(question2))); // Should not be equal
    });

    test('Questions with different answers should not be equal', () {
      final answer1 = AnswerEntity(answer: 'Yes', answeredBy: 'User1');
      final answer2 = AnswerEntity(answer: 'No', answeredBy: 'User2');
      final answer3 = AnswerEntity(answer: 'Maybe', answeredBy: 'User3');

      final question1 = QuestionEntity(
        question: 'Is Flutter awesome?',
        answers: [answer1, answer2],
      );

      final question2 = QuestionEntity(
        question: 'Is Flutter awesome?',
        answers: [answer1, answer3],
      );

      expect(question1, isNot(equals(question2))); // Should not be equal due to different answers
    });
  });
}
