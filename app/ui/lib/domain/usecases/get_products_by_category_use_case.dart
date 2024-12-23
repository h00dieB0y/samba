
import 'package:ui/domain/entities/product_item_entity.dart';
import 'package:ui/domain/repositories/product_repository.dart';

class GetProductsByCategoryUseCase {
  final ProductRepository _productRepository;

  GetProductsByCategoryUseCase(this._productRepository);

  Future<List<ProductItemEntity>> execute(
      {required String category, required int page, required int perPage}) {
    return _productRepository.getProductsByCategory(
      category: category,
      page: page,
      perPage: perPage,
    );
  }
}
