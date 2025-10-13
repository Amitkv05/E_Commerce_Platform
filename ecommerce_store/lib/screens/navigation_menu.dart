// ignore_for_file: deprecated_member_use

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:shopgram/screens/cart_screen.dart';
import 'package:shopgram/screens/categoryScreen/category_screen.dart';
import 'package:shopgram/screens/favorite_screen.dart';
import 'package:shopgram/screens/homeScreen/home_screen.dart';
import 'package:shopgram/screens/profile/profile_screen.dart';

final bottomNavIndexProvider = StateProvider<int>((ref) => 0);

class NavigationMenu extends ConsumerStatefulWidget {
  const NavigationMenu({super.key});

  @override
  ConsumerState<NavigationMenu> createState() => _NavigationMenuState();
}

class _NavigationMenuState extends ConsumerState<NavigationMenu> {
  // int currentPage = 0;

  final List<Widget> pages = [
    HomeScreen(),
    FavoriteScreen(),
    CategoriesScreen(),
    CartScreen(),
    ProfileScreen(),
  ];

  final List<IconData> icons = [
    Icons.home_outlined,
    Icons.favorite_border_rounded,
    Icons.category_outlined,
    Icons.shopping_cart_outlined,
    Icons.person_outline,
  ];

  final List<IconData> activeIcons = [
    Icons.home,
    Icons.favorite_sharp,
    Icons.category,
    Icons.shopping_cart,
    Icons.person,
  ];

  @override
  /*************  ✨ Windsurf Command ⭐  *************/
  /// Builds the navigation menu widget, which includes a bottom navigation bar and a body.
  /// The body is an IndexedStack of the pages, and the bottom navigation bar is a
  /// row of icons with a frosted glass blur effect.
  ///
  /// The [currentPage] is the index of the currently visible page, and the
  /// [pages] is the list of pages to be displayed.
  ///
  /// The [icons] is the list of icons for the bottom navigation bar, and the
  /// [activeIcons] is the list of active icons for the bottom navigation bar.
  ///
  /*******  a9248bf9-81df-4fc0-84da-2637bec71d3a  *******/
  Widget build(BuildContext context) {
    final currentPage = ref.watch(bottomNavIndexProvider);

    return Scaffold(
      extendBody: true, //makes body extend behind bottom nav
      body: IndexedStack(index: currentPage, children: pages),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 5,
              sigmaY: 5,
            ), // frosted glass blur
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(
                  0.40,
                ), // semi-transparent background
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.white.withOpacity(0.2)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(icons.length, (index) {
                  bool isSelected = currentPage == index;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        ref.read(bottomNavIndexProvider.notifier).state = index;

                        // currentPage = index;
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 10),
                      padding: EdgeInsets.all(isSelected ? 12 : 8),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.white : Colors.transparent,
                        shape: BoxShape.circle,
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.25),
                                  blurRadius: 10,
                                  offset: const Offset(0, 6),
                                ),
                              ]
                            : [],
                      ),
                      child: Transform.scale(
                        scale: isSelected ? 1.3 : 1.0,
                        child: Icon(
                          isSelected ? activeIcons[index] : icons[index],
                          color: isSelected ? Colors.black : Colors.white,
                          size: 26,
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
