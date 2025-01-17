import 'package:flutter/material.dart';
import 'package:ui/domain/entities/question_entity.dart';

class CustomerQuestionTile extends StatelessWidget {
  final QuestionEntity question;

  const CustomerQuestionTile({super.key, required this.question});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(
        question.question,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      children: question.answers.isNotEmpty
          ? question.answers.map((answer) {
              return ListTile(
                title: Text(
                  answer.answer,
                  style: TextStyle(color: Colors.grey[700]),
                ),
                subtitle: Text(
                  'Answered by ${answer.answeredBy}',
                  style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                ),
              );
            }).toList()
          : [
              ListTile(
                title: Text(
                  'No answers yet.',
                  style: TextStyle(color: Colors.grey[700]),
                ),
              ),
            ],
    );
  }
}
