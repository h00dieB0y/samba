import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ui/domain/usecases/search_products_use_case.dart';
import 'package:ui/presentation/cubits/products/search_cubit.dart';
import 'package:ui/presentation/cubits/products/search_state.dart';
import 'package:ui/presentation/pages/widgets/app_bottom_navigation_bar.dart';
import 'package:ui/presentation/pages/widgets/search_bar_input.dart';
import 'widgets/product_list.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Extract the passed-in query (String)
    final String? initialQuery =
        ModalRoute.of(context)?.settings.arguments as String?;

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
  late final TextEditingController _searchController;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _searchController =
        TextEditingController(text: widget.initialQuery ?? '');
    _focusNode = FocusNode();

    // If we have an initial query, perform the search immediately
    if (widget.initialQuery != null && widget.initialQuery!.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<SearchCubit>().searchProducts(widget.initialQuery!);
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onSearch(String query) {
    if (query.isEmpty) {
      context.read<SearchCubit>().reset();
    } else {
      context.read<SearchCubit>().searchProducts(query);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // SearchBarInput without debounce
            SearchBarInput(
              hintText: 'Search on Somba.com',
              onSearch: _onSearch,
              controller: _searchController,
              focusNode: _focusNode,
            ),
            const SizedBox(height: 10),
            // Display results from the SearchCubit
            Expanded(
              child: BlocBuilder<SearchCubit, SearchState>(
                builder: (context, state) {
                  if (state is SearchInitial) {
                    return const Center(
                        child: Text('Type something to search.'));
                  } else if (state is SearchLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is SearchEmpty) {
                    return const Center(child: Text('No results found.'));
                  } else if (state is SearchLoaded) {
                    final products = state.products;
                    return ProductList(products: products);
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
        currentIndex: 0,
      ),
    );
  }
}
