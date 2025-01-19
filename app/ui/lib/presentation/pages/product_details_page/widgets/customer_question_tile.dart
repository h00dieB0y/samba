import 'package:flutter/material.dart';
import 'package:ui/domain/entities/question_entity.dart';

class CustomerQuestionTile extends StatelessWidget {
  final QuestionEntity question;

  const CustomerQuestionTile({Key? key, required this.question}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: ExpansionTile(
        title: Text(
          question.question,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        children: question.answers.isNotEmpty
            ? question.answers.map((answer) {
                return ListTile(
                  title: Text(
                    answer.answer,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  subtitle: Text(
                    'Answered by ${answer.answeredBy}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                );
              }).toList()
            : [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'No answers yet.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
      ),
    );
  }
}