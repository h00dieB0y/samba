import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ui/domain/usecases/get_products_use_case.dart';
import 'package:ui/presentation/cubits/products/products_state.dart';


class ProductsCubit extends Cubit<ProductsState> {
  final GetProductsUseCase _getProductsUseCase;

  ProductsCubit(this._getProductsUseCase) : super(ProductsInitial());

  void getProductList() async {
    emit(ProductsLoading());
    try {
      final products = await _getProductsUseCase.execute();
      emit(ProductsLoaded(products));
    } catch (e) {
      emit(ProductsError(e.toString()));
    }
  }
}