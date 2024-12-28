import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Use Cases
import 'package:ui/domain/usecases/get_products_use_case.dart';
import 'package:ui/domain/usecases/get_products_by_category_use_case.dart';

// Cubit
import 'package:ui/presentation/cubits/products/products_cubit.dart';
import 'package:ui/presentation/pages/home_page/widgets/home_header.dart';
import 'package:ui/presentation/pages/home_page/widgets/product_grid.dart';
import 'package:ui/presentation/widgets/app_bottom_navigation_bar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        // Create and provide the ProductsCubit
        create: (context) => ProductsCubit(
          context.read<GetProductsUseCase>(),
          context.read<GetProductsByCategoryUseCase>(),
        )..fetchProducts(isInitialLoad: true), // initial product load
        child: SafeArea(
          child: const HomeContent(),
        ),
      ),
      bottomNavigationBar: AppBottomNavigationBar(
        onTap: (index) {
          // Handle navigation on tap
        },
        currentIndex: 0,
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const HomeHeader(),
        Expanded(
          child: ProductGrid(),
        ),
      ],
    );
  }
}
