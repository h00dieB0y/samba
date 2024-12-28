
import 'package:equatable/equatable.dart';

class SearchProductItemEntity extends Equatable {

  const SearchProductItemEntity({
    required this.id,
    required this.name,
    required this.brand,
    required this.price,
    required this.rating,
    required this.reviewCount,
    required this.isSponsored,
    required this.isBestSeller,
  });

  final String id;
  final String name;
  final String brand;
  final String price;
  final double rating;
  final int reviewCount;
  final bool isSponsored;
  final bool isBestSeller;

  @override
  List<Object?> get props => [
    id,
    name,
    brand,
    price,
    rating,
    reviewCount,
    isSponsored,
    isBestSeller,
  ];
}
