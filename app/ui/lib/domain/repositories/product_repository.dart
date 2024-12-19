import 'package:ui/domain/entities/product_item_entity.dart';

abstract class ProductRepository {
  Future<List<ProductItemEntity>> getProducts();
}
