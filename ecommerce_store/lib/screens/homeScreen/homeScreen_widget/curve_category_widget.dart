import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopgram/core/theme/app_colors.dart';
import 'package:shopgram/core/utils/size_config.dart';
import 'package:shopgram/provider/categories_provider.dart';
import 'package:shopgram/screens/homeScreen/homeScreen_widget/selected_categories_screen.dart';

class CurvedCategoryScroll extends ConsumerStatefulWidget {
  const CurvedCategoryScroll({super.key});

  @override
  ConsumerState<CurvedCategoryScroll> createState() =>
      _CurvedCategoryScrollState();
}

class _CurvedCategoryScrollState extends ConsumerState<CurvedCategoryScroll>
    with WidgetsBindingObserver {
  final PageController _controller = PageController(
    viewportFraction: 0.35,
    initialPage: 1,
  );
  final ValueNotifier<double> _pageNotifier = ValueNotifier<double>(1.0);
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this); // Add lifecycle observer
    _controller.addListener(() {
      if (_controller.hasClients && _controller.position.haveDimensions) {
        _pageNotifier.value = _controller.page ?? 1.0;
      }
    });
    Future.delayed(Duration.zero, () {
      _fetchCategories();
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      _fetchCategories(); // Refresh categories when app resumes
    }
  }

  Future<void> _fetchCategories() async {
    try {
      setState(() {
        isLoading = true;
      });
      final categories = await CategoriesNotifier().loadCategories();
      if (categories.isEmpty) {}
      ref.read(categoriesProvider.notifier).setCategories(categories);
      if (categories.length > 1 && _controller.hasClients) {
        await _controller.animateToPage(
          1,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
        _pageNotifier.value = 1.0;
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to load categories: $e")),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this); // Remove lifecycle observer
    _controller.dispose();
    _pageNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categories = ref.watch(categoriesProvider);
    const double radius = 30.0;

    if (isLoading) {
      return SizedBox(
        height: 15.sh,
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    if (categories.isEmpty) {
      return SizedBox(
        height: 15.sh,
        child: Center(
          child: Text(
            "No categories available",
            style: TextStyle(fontSize: 16, color: Colors.grey.shade800),
          ),
        ),
      );
    }

    return SizedBox(
      height: 15.sh,
      child: Stack(
        children: [
          ValueListenableBuilder<double>(
            valueListenable: _pageNotifier,
            builder: (context, page, child) {
              return PageView.builder(
                controller: _controller,
                itemCount: categories.length,
                scrollDirection: Axis.horizontal,
                clipBehavior: Clip.none,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  return AnimatedBuilder(
                    animation: _pageNotifier,
                    builder: (context, child) {
                      final double pageOffset = page - index;
                      const double curveFactor = 0.3;
                      final double yOffset =
                          -curveFactor * radius * (pageOffset * pageOffset) +
                          (curveFactor * radius * 2.0);
                      return Transform.translate(
                        offset: Offset(0, yOffset),
                        child: Opacity(
                          opacity: (1 - pageOffset.abs() * 0.5).clamp(1.0, 1.0),
                          child: Padding(
                            padding: EdgeInsets.only(left: 2.w, right: 2.w),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) => SelectedCategories(
                                          category: category,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    height: 60,
                                    width: 60,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      border: Border.all(
                                        color: AppColors.primaryOne,
                                      ),
                                    ),
                                    child: CircleAvatar(
                                      radius: 28,
                                      backgroundColor:
                                          AppColors.categoriesLight,
                                      child: Image.network(
                                        category.image,
                                        color: AppColors.primary,
                                        height: 30,
                                        width: 80,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                const Icon(Icons.error),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  category.name,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey.shade800,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
