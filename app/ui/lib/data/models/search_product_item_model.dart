import 'package:equatable/equatable.dart';
import 'package:ui/domain/entities/search_product_item_entity.dart';

class SearchProductItemModel extends Equatable {
  final String id;
  final String name;
  final String brand;
  final int price;
  final double rating;
  final int reviewCount;
  final bool isSponsored;
  final bool isBestSeller;

  const SearchProductItemModel({
    required this.id,
    required this.name,
    required this.brand,
    required this.price,
    required this.rating,
    required this.reviewCount,
    required this.isSponsored,
    required this.isBestSeller,
  });

  factory SearchProductItemModel.fromJson(Map<String, dynamic> json) {
    return SearchProductItemModel(
      id: json['id'].toString(),
      name: json['name'],
      brand: json['brand'],
      price: (json['price']).toInt(),
      rating: (json['rating']).toDouble(),
      reviewCount: (json['reviewCount']).toInt(),
      isSponsored: json['isSponsored'],
      isBestSeller: json['isBestSeller'],
    );
  }

  SearchProductItemEntity toEntity() {
    return SearchProductItemEntity(
      id: id,
      name: name,
      brand: brand,
      price: price.toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (Match m) => '${m[1]},',
      ),
      rating: rating,
      reviewCount: reviewCount,
      isSponsored: isSponsored,
      isBestSeller: isBestSeller,
    );
  }

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