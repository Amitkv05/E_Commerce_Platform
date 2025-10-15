// product_grid_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopgram/models/sub_categories_model.dart';
import 'package:shopgram/provider/products_provider.dart';
import 'package:shopgram/screens/categoryScreen/product/widget/product_card_shimmer.dart';
import 'package:shopgram/screens/product_items_widget.dart';

class ProductGrid extends ConsumerStatefulWidget {
  final SubCategoriesModel selectedSubCategory;

  const ProductGrid({Key? key, required this.selectedSubCategory})
    : super(key: key);

  @override
  ConsumerState<ProductGrid> createState() => _ProductGridState();
}

class _ProductGridState extends ConsumerState<ProductGrid> {
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    // Use a post-frame callback to ensure the widget is built before fetching.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _fetchProductBySubCategory(widget.selectedSubCategory.subCategoryName);
      }
    });
  }

  @override
  void didUpdateWidget(covariant ProductGrid oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Check if the subcategory has actually changed to avoid unnecessary API calls.
    if (widget.selectedSubCategory.subCategoryName !=
        oldWidget.selectedSubCategory.subCategoryName) {
      // If it has changed, fetch the products for the NEW subcategory.
      _fetchProductBySubCategory(widget.selectedSubCategory.subCategoryName);
    }
  }

  Future<void> _fetchProductBySubCategory(String subCategory) async {
    setState(() {
      isLoading = true;
    });

    try {
      final products = await ProductsNotifier().loadProductsBySubCategory(
        subCategory,
      );
      if (mounted) {
        ref.read(productProvider.notifier).setProducts(products);
      }
    } catch (e) {
      if (mounted) {
        ref.read(productProvider.notifier).setProducts([]);
      }
      // Consider logging the error for debugging.
      print('Error loading products for $subCategory: $e');
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final products = ref.watch(productProvider);

    if (isLoading) {
      return const _ProductGridLoadingState();
    }

    if (products.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.search_off_rounded, size: 60, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              'No products found for "${widget.selectedSubCategory.subCategoryName}"',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.65, // Adjust aspect ratio for the new card
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        return ProductItemsWidget(product: products[index]);
      },
    );
  }
}

// A private helper widget for the loading shimmer grid
class _ProductGridLoadingState extends StatelessWidget {
  const _ProductGridLoadingState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.65,
      ),
      itemCount: 8,
      itemBuilder: (context, index) => const ProductCardShimmer(),
    );
  }
}
