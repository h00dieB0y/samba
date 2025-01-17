class QuestionEntity {
  final String question;
  final List<AnswerEntity> answers;

  QuestionEntity({
    required this.question,
    required this.answers,
  });
}

class AnswerEntity {
  final String answer;
  final String answeredBy;

  AnswerEntity({
    required this.answer,
    required this.answeredBy,
  });
}
