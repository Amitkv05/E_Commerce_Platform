import 'package:flutter/material.dart';
import 'package:shopgram/core/theme/app_colors.dart';
import 'package:shopgram/core/utils/responsive.dart';
import 'package:shopgram/core/utils/size_config.dart';
import 'package:shopgram/screens/homeScreen/homeScreen_widget/curve_category_widget.dart';
import 'package:shopgram/screens/homeScreen/homeScreen_widget/search_product_screen.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.white),
      borderRadius: BorderRadius.circular(16),
    );
    return Stack(
      children: [
        ClipPath(
          clipper: HeaderClipper(),
          child: Container(
            height: 250,
            decoration: const BoxDecoration(color: AppColors.primary),
          ),
        ),

        Container(
          decoration: const BoxDecoration(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  left: Responsive.horizontalPadding(context),
                  right: Responsive.horizontalPadding(context),
                  top: Responsive.verticalPadding(context) * 4.5,
                  bottom: Responsive.verticalPadding(context) * 0.2,
                  // vertical: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Search Bar
                    SizedBox(
                      height: 50,
                      // width: 270,
                      child: TextField(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => SearchProductScreen(),
                            ),
                          );
                        },
                        decoration: InputDecoration(
                          // fillColor: Colors.grey.shade300,
                          fillColor: Colors.white,
                          filled: true,
                          prefixIcon: const Icon(Icons.search),
                          // prefixIconColor: Colors.white,
                          prefixIconColor: AppColors.primary,
                          hintText: 'search',
                          hintStyle: TextStyle(
                            // color: Colors.white,
                            color: AppColors.primary,
                          ),
                          border: border,
                          enabledBorder: border,
                          focusedBorder: border,
                          // suffixIcon: const Icon(Icons.tune),
                        ),
                      ),
                    ),
                    // Container(
                    //   height: 50,
                    //   decoration: BoxDecoration(
                    //     color: AppColors.white,
                    //     borderRadius: BorderRadius.circular(25),
                    //     boxShadow: [
                    //       BoxShadow(
                    //         color: Colors.black,
                    //         spreadRadius: 1,
                    //         blurRadius: 5,
                    //         offset: const Offset(0, 2),
                    //       ),
                    //     ],
                    //   ),
                    // child: Row(
                    //   children: [
                    //     const SizedBox(width: 12),
                    //     const Icon(
                    //       Icons.search,
                    //       color: AppColors.primary,
                    //       size: 20,
                    //     ),
                    //     const SizedBox(width: 8),
                    //     Expanded(
                    //       child: Text(
                    //         "Search for products, categories...",
                    //         style: TextStyle(
                    //           color: AppColors.grey,
                    //           fontSize: 16,
                    //         ),
                    //       ),
                    //     ),
                    //     // IconButton(
                    //     //   icon: const Icon(
                    //     //     Icons.shopping_cart,
                    //     //     color: AppColors.primary,
                    //     //     size: 20,
                    //     //   ),
                    //     //   onPressed: () {},
                    //     //   padding: EdgeInsets.zero,
                    //     // ),
                    //     const SizedBox(width: 12),
                    //   ],
                    // ),
                    // ),
                    SizedBox(height: 2.sh),
                    // Location
                    Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Current Location",
                            style: TextStyle(
                              color: Colors.grey.shade100,
                              fontSize: Responsive.isMobile(context) ? 14 : 16,
                            ),
                          ),
                          SizedBox(height: 0.6.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Delhi, India",
                                style: TextStyle(
                                  color: AppColors.white,
                                  fontSize: Responsive.isMobile(context)
                                      ? 22
                                      : 24,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              SizedBox(width: 1.w),
                              const Icon(
                                Icons.send_rounded,
                                color: AppColors.white,
                                size: 16,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              CurvedCategoryScroll(),
            ],
          ),
        ),
      ],
    );
  }
}

class HeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 50);
    path.quadraticBezierTo(
      size.width / 2,
      size.height,
      size.width,
      size.height - 50,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
