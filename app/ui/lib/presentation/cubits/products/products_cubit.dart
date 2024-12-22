import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ui/domain/entities/product_item_entity.dart';
import 'package:ui/domain/enums/category.dart';
import 'package:ui/domain/usecases/get_products_by_category_use_case.dart';
import 'package:ui/domain/usecases/get_products_use_case.dart';
import 'products_state.dart';

class ProductsCubit extends Cubit<ProductsState> {
  final GetProductsUseCase _getProductsUseCase;
  final GetProductsByCategoryUseCase _getProductsByCategoryUseCase;

  // Pagination settings
  static const int _perPage = 10;

  int _currentPage = 0;
  bool _isFetching = false;
  bool _hasMoreData = true;

  // State management variables
  final List<ProductItemEntity> _products = [];
  Category _selectedCategory = Category.all;

  ProductsCubit(
    this._getProductsUseCase,
    this._getProductsByCategoryUseCase,
  ) : super(ProductsInitial());

  Category get selectedCategory => _selectedCategory;

  /// Select a category and fetch relevant products
  Future<void> selectCategory(Category category) async {
    if (_selectedCategory != category) {
      _selectedCategory = category;
      await _resetAndFetchProducts();
    }
  }

  /// Fetch products, using the appropriate use case based on the selected category
  Future<void> fetchProducts({bool isInitialLoad = false}) async {
    if (_isFetching || (!_hasMoreData && !isInitialLoad)) return;

    _isFetching = true;

    try {
      if (isInitialLoad) {
        _prepareForInitialLoad();
      } else {
        emit(ProductsLoadingMore(List.unmodifiable(_products)));
      }

      final newProducts = await _fetchProductDataByCategory();
      _handleNewProducts(newProducts);

    } catch (error, stackTrace) {
      _handleFetchError(error, stackTrace);
    } finally {
      _isFetching = false;
    }
  }

  /// Refresh the product list by fetching from the beginning
  Future<void> refreshProducts() async => await _resetAndFetchProducts();

  // Helper methods

  void _prepareForInitialLoad() {
    _currentPage = 0;
    _products.clear();
    _hasMoreData = true;
    emit(ProductsLoading());
    debugPrint('Starting initial product fetch for category: $_selectedCategory');
  }

  Future<List<ProductItemEntity>> _fetchProductDataByCategory() async {
    if (_selectedCategory == Category.all) {
      debugPrint('Fetching all products for page $_currentPage');
      return await _getProductsUseCase.execute(
        page: _currentPage,
        perPage: _perPage,
      );
    } else {
      debugPrint('Fetching products by category "$_selectedCategory" for page $_currentPage');
      return await _getProductsByCategoryUseCase.execute(
        category: _selectedCategory.name,
        page: _currentPage,
        perPage: _perPage,
      );
    }
  }

  void _handleNewProducts(List<ProductItemEntity> newProducts) {
    if (newProducts.isEmpty) {
      _hasMoreData = false;
      debugPrint('No more products to load for category: $_selectedCategory');
    } else {
      _products.addAll(newProducts);
      _currentPage++;
    }

    emit(ProductsLoaded(List.unmodifiable(_products)));
    debugPrint('Loaded ${_products.length} products for category: $_selectedCategory');
  }

  void _handleFetchError(Object error, StackTrace stackTrace) {
    emit(ProductsError(error.toString()));
    debugPrint('Error fetching products: $error');
    debugPrintStack(stackTrace: stackTrace);
  }

  Future<void> _resetAndFetchProducts() async {
    await fetchProducts(isInitialLoad: true);
  }
}
