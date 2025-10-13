import 'package:flutter/material.dart';
import 'package:shopgram/models/categories_model.dart';
import 'package:shopgram/models/sub_categories_model.dart'; // Make sure this model exists
import 'package:shopgram/screens/categoryScreen/category_row_item.dart';

class BottomSheetWidget extends StatelessWidget {
  final List<CategoriesModel> categories;
  final Function(CategoriesModel, SubCategoriesModel) onSubCategorySelected;

  const BottomSheetWidget({
    Key? key,
    required this.categories,
    required this.onSubCategorySelected,
  }) : super(key: key);

  /// Helper method to show the bottom sheet
  static void show(
    BuildContext context, {
    required List<CategoriesModel> categories,
    // Update the function signature here as well
    required Function(CategoriesModel, SubCategoriesModel) onSelected,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BottomSheetWidget(
        categories: categories,
        onSubCategorySelected: onSelected,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (_, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Handle, Title, and Close button remain the same
              Container(
                width: 40,
                height: 5,
                margin: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'All Categories',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1, thickness: 1),

              // Category List now uses our new widget
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    // Each item in the list is now a self-contained, stateful widget
                    // that handles its own data fetching.
                    return CategoryRowItem(
                      category: category,
                      onSubCategorySelected: onSubCategorySelected,
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
