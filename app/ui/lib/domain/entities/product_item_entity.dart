import 'package:equatable/equatable.dart';

class ProductItemEntity extends Equatable {
  final String id;
  final String name;
  final String brand;
  final String price;

  const ProductItemEntity({
    required this.id,
    required this.name,
    required this.brand,
    required this.price,
  });

  @override
  List<Object?> get props => [id, name, brand, price];
}
