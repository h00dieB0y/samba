
import 'package:ui/domain/entities/product_item_entity.dart';

class SearchProductItemEntity extends ProductItemEntity {
  final double rating; // e.g., 4.5
  final int reviewCount; // e.g., 120
  final bool isSponsored; // Optional: true if sponsored
  final bool isBestSeller;

  const SearchProductItemEntity({
    required super.id,
    required super.name,
    required super.brand,
    required super.price,
    required this.rating,
    required this.reviewCount,
    required this.isSponsored,
    required this.isBestSeller,
  });

  @override
  List<Object?> get props => [
        ...super.props,
        rating,
        reviewCount,
        isSponsored,
        isBestSeller,
      ];
}
