import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ui/domain/usecases/search_products_use_case.dart';
import 'package:ui/presentation/cubits/products/search_cubit.dart';
import 'package:ui/presentation/cubits/products/search_state.dart';
import 'package:ui/presentation/pages/search_page/widgets/product_card.dart';
import 'package:ui/presentation/widgets/app_bottom_navigation_bar.dart';
import 'package:ui/presentation/widgets/search_bar_input.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Extract the passed-in query (String)
    final String? initialQuery = ModalRoute.of(context)!.settings.arguments as String?;

    return BlocProvider(
      create: (context) => SearchCubit(
        context.read<SearchProductsUseCase>(),
      ),
      child: SearchPageContent(initialQuery: initialQuery),
    );
  }
}

class SearchPageContent extends StatefulWidget {
  final String? initialQuery;

  const SearchPageContent({super.key, this.initialQuery});

  @override
  State<SearchPageContent> createState() => _SearchPageContentState();
}

class _SearchPageContentState extends State<SearchPageContent> {
  @override
  void initState() {
    super.initState();

    // If we have an initial query, perform the search immediately
    if (widget.initialQuery != null && widget.initialQuery!.isNotEmpty) {
      context.read<SearchCubit>().searchProducts(widget.initialQuery!);
    }
  }

  void _onSearch(String query) {
    if (query.isEmpty) return;
    context.read<SearchCubit>().searchProducts(query);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Reuse the same search bar, calling _onSearch
            SearchBarInput(
              hintText: 'Search on Somba.com',
              onSearch: _onSearch,
              initialValue: widget.initialQuery ?? '',
            ),
            const SizedBox(height: 10),

            // Display results from the SearchCubit
            Expanded(
              child: BlocBuilder<SearchCubit, SearchState>(
                builder: (context, state) {
                  if (state is SearchInitial) {
                    return const Center(child: Text('Type something to search.'));
                  } else if (state is SearchLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is SearchEmpty) {
                    return const Center(child: Text('No results found.'));
                  } else if (state is SearchLoaded) {
                    final products = state.products;
                    return ListView.builder(
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return ProductCard(product: product);
                      },
                    );
                  } else if (state is SearchError) {
                    return Center(child: Text('Error: ${state.message}'));
                  }

                  // Fallback
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: AppBottomNavigationBar(
        onTap: (index) {
          // Example: navigate back to Home if index == 0
          if (index == 0) {
            Navigator.pop(context);
          }
        },
        currentIndex: 1,
      ),
    );
  }
}
