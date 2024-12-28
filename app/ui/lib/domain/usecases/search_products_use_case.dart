import 'package:ui/domain/entities/search_product_item_entity.dart';
import 'package:ui/domain/repositories/product_repository.dart';

class SearchProductsUseCase {
  final ProductRepository _productRepository;

  SearchProductsUseCase(this._productRepository);

  Future<List<SearchProductItemEntity>> execute(String query) async {
    return await _productRepository.searchProducts(query);
  }
}