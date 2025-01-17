import 'package:equatable/equatable.dart';

class ReviewEntity extends Equatable {
  final String username;
  final double rating;
  final String comment;
  final bool isVerifiedPurchase;
  final DateTime date;

  ReviewEntity({
    required this.username,
    required this.rating,
    required this.comment,
    this.isVerifiedPurchase = false,
    required this.date,
  });

  @override
  List<Object?> get props => [username, rating, comment, date, isVerifiedPurchase];
}