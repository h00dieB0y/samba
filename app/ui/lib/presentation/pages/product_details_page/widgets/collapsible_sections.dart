import 'package:flutter/material.dart';
import 'package:ui/domain/entities/product_details_entity.dart';
import 'reviews_and_q_n_a.dart';

class CollapsibleSections extends StatelessWidget {
  final ProductDetailsEntity product;

  const CollapsibleSections({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
        child: ExpansionPanelList.radio(
      expandedHeaderPadding: const EdgeInsets.symmetric(vertical: 8.0),
      animationDuration: const Duration(milliseconds: 500),
      children: [
        ExpansionPanelRadio(
          canTapOnHeader: true,
          value: 'description',
          headerBuilder: (context, isExpanded) {
            return ListTile(
              leading:
                  Icon(Icons.description, color: theme.colorScheme.primary),
              title: Text(
                'Description',
                style: theme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
            );
          },
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              product.description,
              style: theme.textTheme.bodyMedium,
            ),
          ),
        ),
        ExpansionPanelRadio(
          canTapOnHeader: true,
          value: 'specifications',
          headerBuilder: (context, isExpanded) {
            return ListTile(
              leading: Icon(Icons.list_alt, color: theme.colorScheme.primary),
              title: Text(
                'Specifications',
                style: theme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
            );
          },
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: product.specifications.isNotEmpty
                ? Table(
                    columnWidths: const {
                      0: FlexColumnWidth(2),
                      1: FlexColumnWidth(3),
                    },
                    children: product.specifications.entries.map((entry) {
                      return TableRow(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(
                              entry.key,
                              style: theme.textTheme.titleSmall
                                  ?.copyWith(fontWeight: FontWeight.w600),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(entry.value,
                                style: theme.textTheme.bodyMedium),
                          ),
                        ],
                      );
                    }).toList(),
                  )
                : Text(
                    'No specifications available.',
                    style: theme.textTheme.bodyMedium,
                  ),
          ),
        ),
        ExpansionPanelRadio(
          canTapOnHeader: true,
          value: 'reviews',
          headerBuilder: (context, isExpanded) {
            return ListTile(
              leading:
                  Icon(Icons.rate_review, color: theme.colorScheme.primary),
              title: Text(
                'Reviews & QnA',
                style: theme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
            );
          },
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ReviewsAndQnA(
                reviews: product.reviews, averageRating: product.rating, questions: product.questions),
          ),
        ),
      ],
    ));
  }
}
