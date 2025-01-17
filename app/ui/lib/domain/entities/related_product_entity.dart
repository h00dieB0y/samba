import 'package:equatable/equatable.dart';

class RelatedProductEntity extends Equatable {
  final String id;
  final String name;
  final String image;
  final String price;

  const RelatedProductEntity({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
  });

  @override
  List<Object?> get props => [id, name, image, price];
}
