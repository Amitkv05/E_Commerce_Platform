import 'package:flutter/material.dart';
import 'package:shopgram/core/utils/reusable_text_widget.dart';
import 'package:shopgram/core/utils/size_config.dart';
import 'package:shopgram/screens/homeScreen/homeScreen_widget/popular_product_widget.dart';
import 'package:shopgram/widgets/banner_widget.dart';
import 'package:shopgram/screens/homeScreen/homeScreen_widget/header_widget.dart';
import '../../core/utils/responsive.dart';
import '../../core/theme/app_colors.dart';
import '../../widgets/product_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      // appBar: const CustomAppBar(title: 'ShopGram', showBackButton: false),
      body: SingleChildScrollView(
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeaderWidget(),
            BannerWidget(),
            SizedBox(height: 2.h),

            // Featured Products
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.sv),
              // padding: Responsive.padding(context),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ReusableTextWidget(
                    title1: "Popular",
                    title2: "Products",
                    subtitle: "",
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'See All',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            PopularProductWidget(),

            // Products Grid
            // Padding(
            //   padding: EdgeInsets.symmetric(
            //     horizontal: Responsive.horizontalPadding(context),
            //   ),
            //   child: GridView.builder(
            //     shrinkWrap: true,
            //     physics: const NeverScrollableScrollPhysics(),
            //     padding: const EdgeInsets.only(bottom: 100),
            //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            //       crossAxisCount: Responsive.isMobile(context) ? 2 : 3,
            //       childAspectRatio: 0.75,
            //       crossAxisSpacing: 16,
            //       mainAxisSpacing: 20,
            //     ),
            //     itemCount: 8,
            //     itemBuilder: (context, index) {
            //       return ProductCard(
            //         title: 'Product ${index + 1}',
            //         price: 29.99 + index,
            //         image: 'assets/product.jpg',
            //         rating: 4.5,
            //       );
            //     },
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
