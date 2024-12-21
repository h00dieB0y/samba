import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ui/domain/usecases/get_products_use_case.dart';
import 'package:ui/presentation/cubits/products/products_cubit.dart';
import 'package:ui/presentation/pages/home_page/widgets/home_header.dart';
import 'package:ui/presentation/pages/home_page/widgets/product_grid.dart';
import 'package:ui/presentation/widgets/app_bottom_navigation_bar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RepositoryProvider(
        create: (context) => GetProductsUseCase(context.read()),
        child: BlocProvider(
          create: (context) => ProductsCubit(context.read<GetProductsUseCase>())..fetchProducts(isInitialLoad: true),
          child: SafeArea(
            child: HomeContent(),
          ),
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
        HomeHeader(),
        Expanded(
          child: ProductGrid(),
        ),
      ],
    );
  }
}