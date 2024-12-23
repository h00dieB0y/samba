import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ui/domain/usecases/get_products_by_category_use_case.dart';
import 'package:ui/domain/usecases/get_products_use_case.dart';
import 'product_provider.dart';

// Provides the Use Case for Getting Products
final getProductsUseCaseProvider = Provider(
  (ref) => GetProductsUseCase(ref.read(productRepositoryProvider)),
);

final getProductsByCategoryUseCaseProvider = Provider(
  (ref) => GetProductsByCategoryUseCase(ref.read(productRepositoryProvider)),
);