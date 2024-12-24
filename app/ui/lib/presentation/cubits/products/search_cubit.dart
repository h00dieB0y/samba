
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ui/domain/usecases/search_products_use_case.dart';
import 'package:ui/presentation/cubits/products/search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final SearchProductsUseCase _searchProductsUseCase;

  SearchCubit(this._searchProductsUseCase) : super(SearchInitial());

  void searchProducts(String query) async {
    emit(SearchLoading());
    try {
      final products = await _searchProductsUseCase.execute(query);
      if (products.isEmpty) {
        emit(SearchEmpty());
      } else {
        emit(SearchLoaded(products));
      }
    } catch (e) {
      emit(SearchError(e.toString()));
    }
  }
}