import 'package:flutter/material.dart';
import 'package:ui/domain/entities/product_details_entity.dart';
import 'package:ui/domain/entities/question_entity.dart';
import 'customer_question_tile.dart';

class CustomerQnA extends StatelessWidget {
  final ProductDetailsEntity product;

  const CustomerQnA({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    // Assuming product.questions is a list of QuestionEntity
    final List<QuestionEntity> questions = product.questions;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Q&A Section Title
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Customer Questions & Answers',
              style: Theme.of(context).textTheme.titleLarge,
              semanticsLabel: 'Customer Q&A Section',
            ),
          ),
          SizedBox(height: 16),
          // Ask a Question Button
          ElevatedButton.icon(
            key: const Key('ask_question_button'),
            onPressed: () {
              // Open Ask Question Form
            },
            icon: Icon(Icons.question_answer),
            label: Text('Ask a Question'),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              minimumSize: Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          SizedBox(height: 16),
          // Questions List
          questions.isNotEmpty
              ? ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: questions.length,
                  separatorBuilder: (context, index) => Divider(),
                  itemBuilder: (context, index) {
                    return CustomerQuestionTile(question: questions[index]);
                  },
                )
              : Text(
                  'No questions yet. Be the first to ask!',
                  style: Theme.of(context).textTheme.bodyMedium,
                  semanticsLabel: 'No questions available',
                ),
        ],
      ),
    );
  }
}
