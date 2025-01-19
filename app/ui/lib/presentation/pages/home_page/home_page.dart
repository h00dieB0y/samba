import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ui/domain/usecases/get_products_use_case.dart';
import 'package:ui/domain/usecases/get_products_by_category_use_case.dart';
import 'package:ui/presentation/cubits/products/products_cubit.dart';
import 'package:ui/presentation/pages/home_page/widgets/category_list.dart';
import 'package:ui/presentation/pages/home_page/widgets/product_grid.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProductsCubit(
        context.read<GetProductsUseCase>(),
        context.read<GetProductsByCategoryUseCase>(),
      )..fetchProducts(isInitialLoad: true), // initial product load
      child: Container(
        padding: const EdgeInsets.only(top: 10),
        child: Column(
        children: [
          CategoryList(),
          Expanded(
            child: ProductGrid(),
          ),
        ],
      )),
    );
  }
}
