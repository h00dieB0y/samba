// category_list.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ui/domain/enums/category.dart';
import 'package:ui/presentation/cubits/products/products_cubit.dart';
import 'package:ui/presentation/cubits/products/products_state.dart';

import 'package:ui/presentation/pages/home_page/widgets/category_item.dart';

class CategoryList extends StatelessWidget {
  const CategoryList({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: BlocBuilder<ProductsCubit, ProductsState>(
        buildWhen: (previous, current) {
          // Rebuild only when relevant states change
          return current is ProductsLoaded ||
              current is ProductsLoading ||
              current is ProductsLoadingMore ||
              current is ProductsError;
        },
        builder: (context, state) {
          // Retrieve the selected category from the Cubit
          final selectedCategory = context.read<ProductsCubit>().selectedCategory;

          // Define your categories. Ideally, fetch this dynamically if possible.
          const List<Category> categories = Category.values;

          return ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: categories.length,
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final category = categories[index];
              final isSelected = category == selectedCategory;

              return CategoryItem(
                title: category.name,
                isSelected: isSelected,
                onTap: () {
                  if (!isSelected) {
                    // Trigger category selection in Cubit
                    context.read<ProductsCubit>().selectCategory(category);
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}
