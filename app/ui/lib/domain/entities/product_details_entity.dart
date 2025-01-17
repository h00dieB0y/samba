import 'related_product_entity.dart';
import 'question_entity.dart';
import 'review_entity.dart';

class ProductDetailsEntity {
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

  ProductDetailsEntity({
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
}

