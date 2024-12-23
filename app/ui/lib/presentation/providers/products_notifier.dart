import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ui/domain/entities/product_item_entity.dart';
import 'package:ui/domain/usecases/get_products_by_category_use_case.dart';
import 'package:ui/domain/usecases/get_products_use_case.dart';
import 'use_case_provider.dart';

// Riverpod State Notifier for Managing Products State
final productsProvider = StateNotifierProvider<ProductsNotifier, AsyncValue<List<ProductItemEntity>>>(
  (ref) => ProductsNotifier(ref.read(getProductsUseCaseProvider), ref.read(getProductsByCategoryUseCaseProvider)),
);

class ProductsNotifier extends StateNotifier<AsyncValue<List<ProductItemEntity>>> {
  final GetProductsUseCase getProductsUseCase;
  final GetProductsByCategoryUseCase getProductsByCategoryUseCase;

  ProductsNotifier(this.getProductsUseCase, this.getProductsByCategoryUseCase) : super(const AsyncLoading());

  Future<void> fetchProducts({required int page, required int perPage}) async {
    try {
      final products = await getProductsUseCase.execute(page: page, perPage: perPage);
      state = AsyncData(products);
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
    }
  }

  Future<void> fetchProductsByCategory({required String category, required int page, required int perPage}) async {
    try {
      final products = await getProductsByCategoryUseCase.execute(category: category, page: page, perPage: perPage);
      state = AsyncData(products);
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
    }
  }
}