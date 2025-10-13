import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopgram/models/categories_model.dart';
import 'package:shopgram/models/sub_categories_model.dart';
import 'package:shopgram/provider/categories_provider.dart';
import 'package:shopgram/screens/categoryScreen/bottom_sheet_widget.dart';
import 'package:shopgram/screens/categoryScreen/product/product_screen.dart';
import 'package:shopgram/provider/sub_categories_provider.dart';

class CategoriesScreen extends ConsumerStatefulWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends ConsumerState<CategoriesScreen> {
  SubCategoriesModel? _selectedSubCategory;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      _initializeScreen();
    });
  }

  Future<void> _initializeScreen() async {
    setState(() {
      isLoading = true;
    });

    try {
      print("--- Initializing Screen ---");
      final categories = await ref
          .read(categoriesProvider.notifier)
          .loadCategories();
      print("Fetched ${categories.length} main categories.");

      if (categories.isNotEmpty) {
        // Loop through the main categories to find the first one with subcategories
        for (final category in categories) {
          print("2. Trying to find subcategories for: '${category.name}'");
          try {
            final subCategories = await SubCategoriesNotifier()
                .loadSubCategories(category.name);

            if (subCategories.isNotEmpty) {
              print(
                "3. SUCCESS: Found ${subCategories.length} sub-categories for '${category.name}'.",
              );
              setState(() {
                _selectedSubCategory = subCategories.first;
                print(
                  "4. Set initial sub-category to: '${_selectedSubCategory!.subCategoryName}'",
                );
              });
              // IMPORTANT: We found one, so we can exit the loop.
              break;
            } else {
              print(
                "--> No subcategories found for '${category.name}'. Trying next one.",
              );
            }
          } catch (e) {
            // This catch block handles the 404 for a single category and allows the loop to continue.
            print(
              "--> Could not load subcategories for '${category.name}': $e. Trying next one.",
            );
            continue; // Go to the next iteration of the loop
          }
        }

        // After the loop, if _selectedSubCategory is STILL null, it means NONE of them had subcategories.
        if (_selectedSubCategory == null) {
          print(
            "!! WARNING: Looped through all categories, but none had any subcategories.",
          );
        }
      } else {
        print("!! WARNING: No main categories were found.");
      }
    } catch (e) {
      // This outer catch handles a failure to load the MAIN categories.
      print("!! FATAL ERROR in _initializeScreen: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to load category list: $e")),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
        print("--- Initialization Finished ---");
      }
    }
  }

  void _openCategoryPicker(List<CategoriesModel> categories) {
    if (categories.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Categories not loaded yet.")),
      );
      return;
    }

    BottomSheetWidget.show(
      context,
      categories: categories,
      onSelected: (parentCategory, selectedSubCategory) {
        // When a new subcategory is selected from the sheet, update our state
        setState(() {
          _selectedSubCategory = selectedSubCategory;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final categories = ref.watch(categoriesProvider);

    if (isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text("Loading Categories...")),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_selectedSubCategory == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("No Categories Found")),
        body: const Center(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "Could not find any categories or sub-categories to display. Please check your network connection or try again later.",
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      // extendBody: false,
      appBar: AppBar(
        title: Text(_selectedSubCategory!.subCategoryName),
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: Stack(
        children: [
          // ProductItemsWidget(product: _selectedSubCategory),
          ProductGrid(selectedSubCategory: _selectedSubCategory!),
          _buildCategorySelectorBar(categories),
        ],
      ),
    );
  }

  Widget _buildCategorySelectorBar(List<CategoriesModel> categories) {
    if (_selectedSubCategory == null) {
      return const SizedBox.shrink();
    }

    return Positioned(
      bottom: 55,
      left: 0,
      right: 0,
      child: GestureDetector(
        onTap: () => _openCategoryPicker(categories),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 10,
                offset: const Offset(0, -3),
              ),
            ],
            border: Border(top: BorderSide(color: Colors.grey[300]!)),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'SELECTED CATEGORY',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _selectedSubCategory!.subCategoryName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const Icon(
                Icons.keyboard_arrow_up_rounded,
                color: Colors.blue,
                size: 28,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
