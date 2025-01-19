import 'package:equatable/equatable.dart';

class QuestionEntity extends Equatable {
  final String question;
  final List<AnswerEntity> answers;

  const QuestionEntity({
    required this.question,
    required this.answers,
  });

  @override
  List<Object?> get props => [question, answers];
}

class AnswerEntity extends Equatable {
  final String answer;
  final String answeredBy;

  const AnswerEntity({
    required this.answer,
    required this.answeredBy,
  });

  @override
  List<Object?> get props => [answer, answeredBy];
}
