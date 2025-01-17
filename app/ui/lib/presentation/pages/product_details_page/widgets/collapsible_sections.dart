import 'package:flutter/material.dart';
import 'package:ui/domain/entities/product_details_entity.dart';
import 'reviews_and_q_n_a.dart';

class CollapsibleSections extends StatefulWidget {
  final ProductDetailsEntity product;

  const CollapsibleSections({super.key, required this.product});

  @override
  _CollapsibleSectionsState createState() => _CollapsibleSectionsState();
}

class _CollapsibleSectionsState extends State<CollapsibleSections> {
  @override
  Widget build(BuildContext context) {
    return ExpansionPanelList.radio(
      expandedHeaderPadding: const EdgeInsets.symmetric(vertical: 8.0),
      animationDuration: const Duration(milliseconds: 500),
      children: [
        ExpansionPanelRadio(
          canTapOnHeader: true,
          value: 'description',
          headerBuilder: (context, isExpanded) {
            return ListTile(
              leading: Icon(Icons.description, color: Theme.of(context).colorScheme.primary),
              title: Text(
                'Description',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
            );
          },
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              widget.product.description,
              style: TextStyle(fontSize: 14.0, height: 1.5),
            ),
          ),
        ),
        ExpansionPanelRadio(
          canTapOnHeader: true,
          value: 'specifications',
          headerBuilder: (context, isExpanded) {
            return ListTile(
              leading: Icon(Icons.list_alt, color: Theme.of(context).colorScheme.primary),
              title: Text(
                'Specifications',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
            );
          },
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: widget.product.specifications.isNotEmpty
                ? Table(
                    columnWidths: const {
                      0: FlexColumnWidth(2),
                      1: FlexColumnWidth(3),
                    },
                    children: widget.product.specifications.entries.map((entry) {
                      return TableRow(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(
                              entry.key,
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(entry.value),
                          ),
                        ],
                      );
                    }).toList(),
                  )
                : Text(
                    'No specifications available.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
          ),
        ),
        ExpansionPanelRadio(
          canTapOnHeader: true,
          value: 'reviews',
          headerBuilder: (context, isExpanded) {
            return ListTile(
              leading: Icon(Icons.rate_review, color: Theme.of(context).colorScheme.primary),
              title: Text(
                'Reviews',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
            );
          },
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ReviewsAndQnA(reviews: widget.product.reviews, averageRating: widget.product.rating),
          ),
        ),
      ],
    );
  }
}