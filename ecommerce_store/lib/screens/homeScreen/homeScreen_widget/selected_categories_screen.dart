// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopgram/core/theme/app_colors.dart';
import 'package:shopgram/core/utils/responsive.dart';
import 'package:shopgram/core/utils/size_config.dart';
import 'package:shopgram/models/categories_model.dart';
import 'package:shopgram/models/products_model.dart';
import 'package:shopgram/provider/products_provider.dart';
import 'package:shopgram/provider/sub_categories_provider.dart';
import 'package:shopgram/screens/product_detail_screen.dart';
import 'package:shopgram/screens/product_items_widget.dart';

class SelectedCategories extends ConsumerStatefulWidget {
  final CategoriesModel category;
  const SelectedCategories({super.key, required this.category});

  @override
  ConsumerState<SelectedCategories> createState() => _SelectedCategoriesState();
}

class _SelectedCategoriesState extends ConsumerState<SelectedCategories> {
  int _selectedSubCategoryIndex = -1; // Track selected subcategory
  String _selectedSubCategory = ''; // Store selected subcategory name
  bool isLoading = true; // loading state
  bool issmallLoading = true; // loading state

  @override
  void initState() {
    super.initState();
    // Fetch subcategories and products
    _fetchSubCategories();
    // Fetch all products initially for 'All' category
    Future.delayed(Duration.zero, () {
      _fetchProductBySubCategory(
        _selectedSubCategory,
      ); // Fetch all products for the category
    });
  }

  Future<void> _fetchSubCategories() async {
    try {
      setState(() {
        isLoading = true; // Set loading to true when fetching data
      });
      final subCategories = await SubCategoriesNotifier().loadSubCategories(
        widget.category.name,
      );
      ref.read(subCategoriesProvider.notifier).setsubCategories(subCategories);
    } catch (e) {
      ref.read(subCategoriesProvider.notifier).setsubCategories([]);
    } finally {
      setState(() {
        isLoading = false; // Set loading to false once fetching is complete
      });
    }
  }

  Future<void> _fetchProductBySubCategory(String subCategory) async {
    if (subCategory.isEmpty) {
      if (_selectedSubCategoryIndex == -1) {
        setState(() {
          issmallLoading = true;
        });
        // Fetch all products in the category when "All" is selected
        final products = await ProductsNotifier().loadProductByCategory(
          widget.category.name,
        );
        ref.read(productProvider.notifier).setProducts(products);
      }
      setState(() {
        isLoading = false;
        issmallLoading = false;
      });
      return;
    }

    try {
      setState(() {
        issmallLoading = true;
      });
      final products = await ProductsNotifier().loadProductsBySubCategory(
        subCategory,
      );
      ref.read(productProvider.notifier).setProducts(products);
    } catch (e) {
      // Handle error gracefully if no products found or error occurs
      ref.read(productProvider.notifier).setProducts([]);
    } finally {
      setState(() {
        isLoading = false;
        issmallLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final subCategories = ref.watch(subCategoriesProvider);
    final subCategoriesProduct = ref.watch(productProvider);
    // final screenWidth = MediaQuery.of(context).size.width;

    // set the number of colume in grid base on the screen width
    // if the screen with is less than 600pixels(w.g.. a phone), use columns
    // if the screen is 600 pixels or more(e.g.. a tablet), use 4 column
    final crossAxisCount = Responsive.screenWidth(context) < 600 ? 2 : 4;

    // set the aspect ratio ( width-to-height ration) of each grid item base on the screen width
    // for smaller screen(<600 pixels) use a ration of 3.4(taller items)
    // for larger screen(>=600 pixels), use a ration of 4.5(more square-shaped items)

    final childAspectRation = Responsive.screenWidth(context) < 600
        ? 6.6 / 8
        : 5 / 9;

    return Scaffold(
      backgroundColor: AppColors.greyLight,
      appBar: AppBar(title: Text('${widget.category.name} Category')),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            ) // Show loading indicator while data is fetching
          : Column(
              children: [
                SizedBox(
                  height: 50.h,
                  width: double.infinity,
                  child: Image.network(
                    widget.category.banner,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.error),
                  ),
                ),
                SizedBox(height: 1.h),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 4,
                    ),
                    child: Row(
                      children: [
                        subCategories.isEmpty
                            ? const Center(
                                child: Text('No subcategories available.'),
                              )
                            : Padding(
                                padding: _selectedSubCategoryIndex == -1
                                    ? EdgeInsets.only(
                                        right: 16,
                                        top: 2,
                                        bottom: 2,
                                      )
                                    : EdgeInsets.only(
                                        // right: 2,
                                        top: 2,
                                        bottom: 2,
                                        left: 6,
                                      ),
                                child: Container(
                                  padding: EdgeInsets.only(
                                    right: 16,
                                    top: 2,
                                    bottom: 2,
                                    left: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: _selectedSubCategoryIndex == -1
                                            ? Colors.black.withOpacity(0.2)
                                            : Colors.white,
                                        spreadRadius: 2,
                                        blurRadius: 5,
                                        offset: Offset(0, 3), // Shadow position
                                      ),
                                    ],
                                    color: _selectedSubCategoryIndex == -1
                                        ? Colors.black
                                        : Colors.transparent,
                                    border: _selectedSubCategoryIndex == -1
                                        ? Border.all(
                                            color: AppColors.black,
                                            width: 1.5,
                                          )
                                        : null,
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _selectedSubCategoryIndex = -1;
                                            _selectedSubCategory =
                                                ''; // Reset to 'All'
                                          });
                                          _fetchProductBySubCategory(
                                            _selectedSubCategory,
                                          ); // Fetch all products for the category
                                        },

                                        // default 'All' category
                                        child: Container(
                                          width: _selectedSubCategoryIndex == -1
                                              ? 45
                                              : 50,
                                          height:
                                              _selectedSubCategoryIndex == -1
                                              ? 45
                                              : 50,

                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              50,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withOpacity(
                                                  0.2,
                                                ),
                                                spreadRadius: 2,
                                                blurRadius: 5,
                                                offset: Offset(
                                                  0,
                                                  3,
                                                ), // Shadow position
                                              ),
                                            ],
                                            border: Border.all(
                                              color: Colors.white,
                                            ),
                                          ),
                                          padding:
                                              _selectedSubCategoryIndex == -1
                                              ? EdgeInsets.all(4)
                                              : null,
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              50,
                                            ),
                                            child: Image.asset(
                                              'assets/banner.jpg',
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Visibility(
                                        visible:
                                            _selectedSubCategoryIndex == -1,
                                        child: SizedBox(
                                          // width: 30,
                                          child: Text(
                                            'All',
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w900,
                                              fontSize: 14,
                                              color:
                                                  _selectedSubCategoryIndex ==
                                                      -1
                                                  ? Colors.white
                                                  : Colors.black,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                        // Other subcategories
                        ...List.generate(
                          subCategories.length,
                          (index) => GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedSubCategoryIndex = index;
                                _selectedSubCategory =
                                    subCategories[index].subCategoryName;
                              });
                              _fetchProductBySubCategory(_selectedSubCategory);
                            },
                            child: SubcategoryTileWidget(
                              image: subCategories[index].image,
                              title: subCategories[index].subCategoryName,
                              isSelected: _selectedSubCategoryIndex == index,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 0.5.h),
                // Show the data below the selected subcategory
                _selectedSubCategoryIndex == -1
                    ? Expanded(
                        child: issmallLoading
                            ? Center(
                                child: CircularProgressIndicator(),
                              ) // Show loading indicator while data is fetching
                            : subCategoriesProduct.isEmpty
                            ? Center(
                                child: Text(
                                  'No products available for this SubCategory.',
                                ),
                              )
                            : GridView.builder(
                                itemCount: subCategoriesProduct.length,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: crossAxisCount,
                                      childAspectRatio: childAspectRation,
                                      mainAxisSpacing: 10,
                                      crossAxisSpacing: 10,
                                    ),
                                itemBuilder: (context, index) {
                                  final product = subCategoriesProduct[index];
                                  return ProductItemsWidget(product: product);
                                },
                              ),
                      )
                    : issmallLoading
                    ? Expanded(
                        child: Center(child: CircularProgressIndicator()),
                      ) // Show loading indicator while data is fetching
                    : subCategoriesProduct.isEmpty
                    ? Expanded(
                        child: Center(
                          child: Text(
                            'No products available for this SubCategory.',
                          ),
                        ),
                      )
                    : Expanded(
                        child: GridView.builder(
                          itemCount: subCategoriesProduct.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: crossAxisCount,
                                childAspectRatio: childAspectRation,
                                mainAxisSpacing: 8,
                                crossAxisSpacing: 8,
                              ),
                          itemBuilder: (context, index) {
                            final product = subCategoriesProduct[index];
                            return ProductItemsWidget(product: product);
                          },
                        ),
                      ),
              ],
            ),
    );
  }
}

class SubcategoryTileWidget extends StatelessWidget {
  final String image;
  final String title;
  final bool isSelected;
  const SubcategoryTileWidget({
    super.key,
    required this.image,
    required this.title,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: isSelected
          ? EdgeInsets.only(right: 16, top: 2, bottom: 2)
          : EdgeInsets.only(right: 2, top: 2, bottom: 2, left: 8),
      child: Container(
        padding: EdgeInsets.only(right: 16, top: 2, bottom: 2),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: isSelected ? Colors.black.withOpacity(0.2) : Colors.white,
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3), // Shadow position
            ),
          ],
          color: isSelected ? Colors.black : Colors.transparent,
          border: isSelected
              ? Border.all(color: AppColors.black, width: 1.5)
              : null,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Row(
          children: [
            Container(
              width: isSelected ? 45 : 50,
              height: isSelected ? 45 : 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3), // Shadow position
                  ),
                ],
                border: Border.all(color: Colors.white),
              ),
              padding: isSelected ? EdgeInsets.all(2) : null,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Image.network(image, fit: BoxFit.fill),
              ),
            ),
            SizedBox(width: 8),
            Visibility(
              visible: isSelected,
              child: SizedBox(
                child: Text(
                  title,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 12,
                    color: isSelected ? Colors.white : Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

