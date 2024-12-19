import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ui/domain/entities/product_item_entity.dart';
import 'package:ui/domain/usecases/get_products_use_case.dart';
import 'use_case_provider.dart';

// Riverpod State Notifier for Managing Products State
final productsProvider = StateNotifierProvider<ProductsNotifier, AsyncValue<List<ProductItemEntity>>>(
  (ref) => ProductsNotifier(ref.read(getProductsUseCaseProvider)),
);

class ProductsNotifier extends StateNotifier<AsyncValue<List<ProductItemEntity>>> {
  final GetProductsUseCase getProductsUseCase;

  ProductsNotifier(this.getProductsUseCase) : super(const AsyncLoading());

  Future<void> fetchProducts() async {
    try {
      final products = await getProductsUseCase.execute();
      state = AsyncData(products);
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
    }
  }
}