import 'package:equatable/equatable.dart';
import 'package:ui/domain/entities/product_item_entity.dart';

abstract class ProductsState extends Equatable {
  const ProductsState();

  @override
  List<Object> get props => [];
}

/// Initial uninitialized state
class ProductsInitial extends ProductsState {}

/// State when the first batch of data is loading
class ProductsLoading extends ProductsState {}

/// State when the first (or refreshed) batch of data has loaded
class ProductsLoaded extends ProductsState {
  final List<ProductItemEntity> products;

  const ProductsLoaded(this.products);

  @override
  List<Object> get props => [products];
}

/// State when loading additional (paginated) data
class ProductsLoadingMore extends ProductsState {
  final List<ProductItemEntity> products;

  const ProductsLoadingMore(this.products);

  @override
  List<Object> get props => [products];
}

/// Error state
class ProductsError extends ProductsState {
  final String message;

  const ProductsError(this.message);

  @override
  List<Object> get props => [message];
}