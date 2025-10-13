import 'package:flutter/material.dart';
import 'package:shopgram/core/theme/app_colors.dart';
import 'package:shopgram/core/utils/responsive.dart';
import 'package:shopgram/core/utils/size_config.dart';
import 'package:shopgram/screens/homeScreen/homeScreen_widget/curve_category_widget.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipPath(
          clipper: HeaderClipper(),
          child: Container(
            height: 250,
            decoration: const BoxDecoration(color: AppColors.primaryOne),
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
                    Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black,
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          const SizedBox(width: 12),
                          const Icon(
                            Icons.search,
                            color: AppColors.grey,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              "Search for 'Grocery'",
                              style: TextStyle(
                                color: AppColors.grey,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.shopping_cart,
                              color: AppColors.grey,
                              size: 20,
                            ),
                            onPressed: () {},
                            padding: EdgeInsets.zero,
                          ),
                          const SizedBox(width: 12),
                        ],
                      ),
                    ),
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
