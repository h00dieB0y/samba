import 'package:flutter/material.dart';
import 'package:ui/domain/entities/question_entity.dart';
import 'package:ui/domain/entities/review_entity.dart';
import 'customer_qn_a.dart';
import 'review_tile.dart';
import '../../widgets/star_rating.dart';

class ReviewsAndQnA extends StatelessWidget {
  final List<ReviewEntity> reviews;
  final List<QuestionEntity> questions;
  final double averageRating;

  const ReviewsAndQnA(
      {super.key,
      required this.reviews,
      required this.questions,
      required this.averageRating});

  @override
  Widget build(BuildContext context) {
    // Sort reviews by rating descending
    List<ReviewEntity> sortedReviews = List.from(reviews)
      ..sort((a, b) => b.rating.compareTo(a.rating));

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Average Rating
          Row(
            children: [
              StarRating(rating: averageRating, size: 24.0),
              const SizedBox(width: 8),
              Text(
                '${averageRating.toStringAsFixed(1)} out of 5',
                style: Theme.of(context).textTheme.titleMedium,
                semanticsLabel:
                    'Average rating: ${averageRating.toStringAsFixed(1)} out of 5',
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Write a Review Button
          ElevatedButton.icon(
            onPressed: () {
              // Open Review Form
            },
            icon: const Icon(Icons.rate_review),
            label: const Text('Write a Review'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              minimumSize: Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Reviews Section Title
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Reviews',
              style: Theme.of(context).textTheme.titleLarge,
              semanticsLabel: 'Reviews Section',
            ),
          ),
          const SizedBox(height: 8),
          // Reviews List
          sortedReviews.isNotEmpty
              ? ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: sortedReviews.length,
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, index) {
                    return ReviewTile(review: sortedReviews[index]);
                  },
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Text(
                    'No reviews yet. Be the first to review!',
                    style: Theme.of(context).textTheme.bodyMedium,
                    semanticsLabel: 'No reviews available',
                  ),
                ),
          // Customer Q&A Section
          const SizedBox(height: 16),
          CustomerQnA(questions: questions, onAskQuestion: () {
            // Open Ask Question Form
          }),
        ],
      ),
    );
  }
}
