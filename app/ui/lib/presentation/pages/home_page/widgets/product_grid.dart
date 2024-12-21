import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ui/domain/entities/product_item_entity.dart';
import 'package:ui/presentation/cubits/products/products_cubit.dart';
import 'package:ui/presentation/cubits/products/products_state.dart';
import 'package:ui/presentation/pages/home_page/widgets/product_card.dart';

class ProductGrid extends StatefulWidget {
  const ProductGrid({super.key});

  @override
  State<ProductGrid> createState() => _ProductGridState();
}

class _ProductGridState extends State<ProductGrid> {
  final ScrollController _scrollController = ScrollController();
  bool _isSnackbarActive = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom && !_isSnackbarActive) {
      context.read<ProductsCubit>().fetchProducts();
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    return currentScroll >= (maxScroll * 0.9);
  }

  Future<void> _onRefresh() async {
    await context.read<ProductsCubit>().refreshProducts();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProductsCubit, ProductsState>(
      listener: (context, state) {
        if (state is ProductsError && !_isSnackbarActive) {
          _isSnackbarActive = true;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          ).closed.then((_) {
            _isSnackbarActive = false;
          });
        }
      },
      builder: (context, state) {
        if (state is ProductsLoading && state is! ProductsLoadingMore) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ProductsLoaded || state is ProductsLoadingMore) {
          final products = (state as dynamic).products as List<ProductItemEntity>;
          final isLoadingMore = state is ProductsLoadingMore;

          return RefreshIndicator(
            onRefresh: _onRefresh,
            child: GridView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.75,
              ),
              itemCount: isLoadingMore ? products.length + 1 : products.length,
              itemBuilder: (context, index) {
                if (index < products.length) {
                  return ProductCard(product: products[index]);
                } else {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
              },
            ),
          );
        } else if (state is ProductsError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    state.message,
                    style: const TextStyle(color: Colors.red, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      context.read<ProductsCubit>().fetchProducts(isInitialLoad: true);
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }
}
