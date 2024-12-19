import 'package:ui/domain/entities/product_item_entity.dart';
import 'package:ui/domain/repositories/product_repository.dart';

class GetProductsUseCase {
  final ProductRepository _productRepository;

  GetProductsUseCase(this._productRepository);

  Future<List<ProductItemEntity>> execute() {
    return _productRepository.getProducts();
  }
}
