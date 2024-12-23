import 'package:ui/domain/entities/product_item_entity.dart';

abstract class ProductRepository {
  Future<List<ProductItemEntity>> getProducts({required int page, required int perPage});
  Future<List<ProductItemEntity>> getProductsByCategory({required String category, required int page, required int perPage});
}
