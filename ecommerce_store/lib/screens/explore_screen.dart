// import 'package:flutter/material.dart';
// import '../core/utils/responsive.dart';
// import '../core/theme/app_colors.dart';
// import '../widgets/custom_app_bar.dart';
// import '../widgets/search_bar.dart';
// import '../widgets/filter_chip.dart';
// import '../widgets/product_card.dart';

// class ExploreScreen extends StatefulWidget {
//   const ExploreScreen({super.key});

//   @override
//   State<ExploreScreen> createState() => _ExploreScreenState();
// }

// class _ExploreScreenState extends State<ExploreScreen> {
//   final List<String> _filters = [
//     'All Products',
//     'New Arrivals',
//     'Best Sellers',
//     'On Sale',
//     'Featured',
//   ];

//   int _selectedFilter = 0;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.background,
//       appBar: const CustomAppBar(title: 'Explore'),
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Search Section
//             Padding(
//               padding: Responsive.padding(context),
//               child: const SearchBarWidget(),
//             ),
//             const SizedBox(height: 24),

//             // Filters
//             SizedBox(
//               height: 50,
//               child: ListView.builder(
//                 padding: Responsive.padding(context),
//                 scrollDirection: Axis.horizontal,
//                 itemCount: _filters.length,
//                 itemBuilder: (context, index) {
//                   return Padding(
//                     padding: EdgeInsets.only(
//                       right: Responsive.horizontalPadding(context),
//                     ),
//                     child: FilterChipWidget(
//                       label: _filters[index],
//                       isSelected: _selectedFilter == index,
//                       onTap: () => setState(() => _selectedFilter = index),
//                     ),
//                   );
//                 },
//               ),
//             ),

//             const SizedBox(height: 24),

//             // Products Section
//             Padding(
//               padding: Responsive.padding(context),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     'Discover More',
//                     style: Theme.of(context).textTheme.titleLarge?.copyWith(
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   TextButton(
//                     onPressed: () {},
//                     child: Text(
//                       'View All',
//                       style: TextStyle(
//                         color: AppColors.primary,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//             // Products Grid
//             Padding(
//               padding: EdgeInsets.symmetric(
//                 horizontal: Responsive.horizontalPadding(context),
//               ),
//               child: GridView.builder(
//                 shrinkWrap: true,
//                 physics: const NeverScrollableScrollPhysics(),
//                 padding: const EdgeInsets.only(bottom: 100),
//                 gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: Responsive.isMobile(context) ? 2 : 3,
//                   childAspectRatio: 0.75,
//                   crossAxisSpacing: 16,
//                   mainAxisSpacing: 16,
//                 ),
//                 itemCount: 12,
//                 itemBuilder: (context, index) {
//                   return ProductCard(
//                     title: 'Explore Product ${index + 1}',
//                     price: 39.99 + index,
//                     image: 'assets/product.jpg',
//                     rating: 4.0 + (index % 2),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
