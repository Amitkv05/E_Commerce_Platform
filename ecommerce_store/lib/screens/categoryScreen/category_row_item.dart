import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopgram/models/categories_model.dart';
import 'package:shopgram/models/sub_categories_model.dart'; // Make sure this model exists and is imported
import 'package:shopgram/provider/sub_categories_provider.dart'; // We need the Notifier class for its fetch logic

class CategoryRowItem extends ConsumerStatefulWidget {
  final CategoriesModel category;
  // IMPORTANT: The callback now passes BOTH the parent category and the selected subcategory
  final Function(CategoriesModel, SubCategoriesModel) onSubCategorySelected;

  const CategoryRowItem({
    Key? key,
    required this.category,
    required this.onSubCategorySelected,
  }) : super(key: key);

  @override
  ConsumerState<CategoryRowItem> createState() => _CategoryRowItemState();
}

class _CategoryRowItemState extends ConsumerState<CategoryRowItem> {
  bool _isLoading = true;
  List<SubCategoriesModel> _subCategories = [];

  @override
  void initState() {
    super.initState();
    _fetchSubCategories();
  }

  Future<void> _fetchSubCategories() async {
    // This logic reuses the fetching method from your existing provider notifier
    try {
      final fetchedSubCategories = await SubCategoriesNotifier()
          .loadSubCategories(widget.category.name);
      if (mounted) {
        // Check if the widget is still in the tree
        setState(() {
          _subCategories = fetchedSubCategories;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _subCategories = [];
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Main Category Title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              children: [
                // Display the category image, not its URL as text
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    widget.category.image,
                    width: 32,
                    height: 32,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        const Icon(Icons.category, size: 24),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  widget.category.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          // Horizontal Subcategory List
          SizedBox(
            height: 120,
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _subCategories.isEmpty
                ? const Center(child: Text("No sub-categories"))
                : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _subCategories.length,
                    itemBuilder: (context, subIndex) {
                      final subCategory = _subCategories[subIndex];
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                          setState(() {
                            widget.onSubCategorySelected(
                              widget.category,
                              subCategory,
                            );
                          });
                        },
                        child: Container(
                          width: 100,
                          margin: const EdgeInsets.only(right: 12),
                          child: Column(
                            children: [
                              Container(
                                height: 80,
                                width: 80,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.grey[100],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(
                                    subCategory
                                        .image, // Assuming SubCategoriesModel has an 'image' field
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => const Icon(
                                      Icons.image_not_supported_outlined,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                subCategory
                                    .subCategoryName, // Assuming SubCategoriesModel has a 'subCategoryName' field
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 12),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
