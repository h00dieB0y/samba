import 'package:equatable/equatable.dart';
import 'package:ui/domain/entities/search_product_item_entity.dart';

abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object> get props => [];
}

/// Initial uninitialized state
/// This state is used to display a search bar
class SearchInitial extends SearchState {}

/// State when the search query is loading
/// This state is used to display a loading indicator
/// while the search query is being processed
/// and the search results are being fetched
/// from the repository
class SearchLoading extends SearchState {}

/// State when the search query has loaded
/// This state is used to display the search results
/// that have been fetched from the repository
/// based on the search query
class SearchLoaded extends SearchState {
  final List<SearchProductItemEntity> products;

  const SearchLoaded(this.products);

  @override
  List<Object> get props => [products];
}

/// State when the search query results is empty
/// This state is used to display a message
/// when the search query has returned no results
/// from the repository based on the search query
/// that has been entered
class SearchEmpty extends SearchState {}

/// Error state
/// This state is used to display an error message
/// when the search query has failed to load
/// the search results from the repository
/// based on the search query
class SearchError extends SearchState {
  final String message;

  const SearchError(this.message);

  @override
  List<Object> get props => [message];
}