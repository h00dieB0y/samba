import 'package:equatable/equatable.dart';

import 'related_product_entity.dart';
import 'question_entity.dart';
import 'review_entity.dart';

class ProductDetailsEntity extends Equatable {
  final String id;
  final String name;
  final String brand;
  final String price;
  final String? oldPrice;
  final String? discount;
  final String stockStatus;
  final String shippingLabel;
  final DateTime? offerEndTime;
  final int cartCount;
  final List<String> images;
  final String description;
  final Map<String, String> specifications;
  final List<ReviewEntity> reviews;
  final List<RelatedProductEntity> relatedProducts;
  final List<QuestionEntity> questions;

  const ProductDetailsEntity({
    required this.id,
    required this.name,
    required this.brand,
    required this.price,
    this.oldPrice,
    this.discount,
    required this.stockStatus,
    required this.shippingLabel,
    this.offerEndTime,
    required this.cartCount,
    required this.images,
    required this.description,
    required this.specifications,
    required this.reviews,
    required this.relatedProducts,
    required this.questions,
  });

  double get rating => reviews.fold(0.0, (previousValue, element) => previousValue + element.rating) / reviews.length;

  int get reviewCount => reviews.length;

  Map<int, int> get ratingDistribution {
    final distribution = {5:0, 4:0, 3:0, 2:0, 1:0};
    for (final review in reviews) {
      final rating = review.rating.toInt();
      if (distribution.containsKey(rating)) {
        distribution[rating] = distribution[rating]! + 1;
      }
    }
    return distribution;
  }

  @override
  List<Object?> get props => [
        id,
        name,
        brand,
        price,
        oldPrice,
        discount,
        stockStatus,
        shippingLabel,
        offerEndTime,
        cartCount,
        images,
        description,
        specifications,
        reviews,
        relatedProducts,
        questions,
      ];
}

