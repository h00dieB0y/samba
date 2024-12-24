
import 'package:ui/data/datasources/remote/product_remote_data_source.dart';
import 'package:ui/data/models/search_product_item_model.dart';
import 'package:ui/domain/entities/product_item_entity.dart';
import 'package:ui/domain/entities/search_product_item_entity.dart';
import 'package:ui/domain/repositories/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource _productRemoteDataSource;

  ProductRepositoryImpl(this._productRemoteDataSource);

  @override
  Future<List<ProductItemEntity>> getProducts(
      {required int page, required int perPage}) async {
    final productModels = await _productRemoteDataSource.getProducts(
      page: page,
      perPage: perPage,
    );

    return productModels
        .map((productModel) => productModel.toEntity())
        .toList();
  }

  @override
  Future<List<ProductItemEntity>> getProductsByCategory(
      {required String category, required int page, required int perPage}) async {
    final productModels = await _productRemoteDataSource.getProductsByCategory(
      category: category,
      page: page,
      perPage: perPage,
    );

    return productModels
        .map((productModel) => productModel.toEntity())
        .toList();
  }

  @override
  Future<List<SearchProductItemEntity>> searchProducts(String query) async {
    return _productRemoteDataSource.searchProducts(query)
        .then((productModels) => productModels
        .map((productModel) => productModel.toEntity())
        .toList());
  }

}