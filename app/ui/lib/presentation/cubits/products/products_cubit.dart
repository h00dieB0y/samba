import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ui/domain/entities/product_item_entity.dart';
import 'package:ui/domain/usecases/get_products_use_case.dart';

import 'products_state.dart';

class ProductsCubit extends Cubit<ProductsState> {
  final GetProductsUseCase _getProductsUseCase;

  int _currentPage = 0;
  final int _perPage = 10;
  bool _isFetching = false;
  bool _hasMoreData = true;

  // Internal list of products
  final List<ProductItemEntity> _products = [];

  ProductsCubit(this._getProductsUseCase) : super(ProductsInitial());

  /// Initial fetch or refresh
  Future<void> fetchProducts({bool isInitialLoad = false}) async {
    if (_isFetching || (!_hasMoreData && !isInitialLoad)) return;

    _isFetching = true;

    if (isInitialLoad) {
      _currentPage = 0;
      _products.clear();
      _hasMoreData = true;
      emit(ProductsLoading());
      print('Fetching initial products...');
    } else {
      emit(ProductsLoadingMore(List<ProductItemEntity>.from(_products)));
      print('Fetching more products...');
    }

    try {
      final newProducts = await _getProductsUseCase.execute(
        page: _currentPage,
        perPage: _perPage,
      );
      print('Fetched ${newProducts.length} products');

      _products.addAll(newProducts);
      _currentPage++;

      if (newProducts.length < _perPage) {
        _hasMoreData = false;
        print('No more products to fetch');
      }

      emit(ProductsLoaded(List<ProductItemEntity>.from(_products)));
      print('Emitted ProductsLoaded with ${_products.length} products');
    } catch (error) {
      emit(ProductsError(error.toString()));
      print('Error fetching products: $error');
    } finally {
      _isFetching = false;
    }
  }

  /// A convenience method to pull-to-refresh or completely restart the list
Future<void> refreshProducts() async {
  await fetchProducts(isInitialLoad: true);
}
}