
import 'package:ui/domain/entities/product_item_entity.dart';

class ProductItemModel {
  final String id;
  final String name;
  final String brand;
  // Price of the product in cents
  final int price;

  ProductItemModel({
    required this.id,
    required this.name,
    required this.brand,
    required this.price,
  });

  factory ProductItemModel.fromJson(Map<String, dynamic> json) {
    return ProductItemModel(
      id: json['id'].toString(),
      name: json['name'],
      brand: json['brand'],
      price: (json['price']).toInt(),
    );
  }

  ProductItemEntity toEntity() {
    return ProductItemEntity(
      id: id,
      name: name,
      brand: brand,
      price: price.toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (Match m) => '${m[1]},',
      ),
    );
  }

}