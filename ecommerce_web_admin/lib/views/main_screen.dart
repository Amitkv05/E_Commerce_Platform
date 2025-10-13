import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:web_admin_for_fullstack/views/side_bar_screens/buyer_screens.dart';
import 'package:web_admin_for_fullstack/views/side_bar_screens/categories_screens.dart';
import 'package:web_admin_for_fullstack/views/side_bar_screens/orders_screens.dart';
import 'package:web_admin_for_fullstack/views/side_bar_screens/product_screen.dart';
import 'package:web_admin_for_fullstack/views/side_bar_screens/subcategory_screen.dart';
import 'package:web_admin_for_fullstack/views/side_bar_screens/upload_banners_screens.dart';
import 'package:web_admin_for_fullstack/views/side_bar_screens/vendors_screens.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Widget _selectedScreen = VendorsScreens();
  // Widget _selectedScreen = CategoriesScreens();
  // Widget _selectedScreen = ProductsScreens();

  screenSelector(item) {
    switch (item.route) {
      case VendorsScreens.id:
        setState(() {
          _selectedScreen = VendorsScreens();
        });
        break;
      case BuyersScreens.id:
        setState(() {
          _selectedScreen = BuyersScreens();
        });
        break;
      case OrdersScreens.id:
        setState(() {
          _selectedScreen = OrdersScreens();
        });
        break;
      case CategoriesScreens.id:
        setState(() {
          _selectedScreen = CategoriesScreens();
        });
        break;
      case SubcategoryScreen.id:
        setState(() {
          _selectedScreen = SubcategoryScreen();
        });
        break;
      case UploadBannersScreens.id:
        setState(() {
          _selectedScreen = UploadBannersScreens();
        });
        break;
      case ProductsScreens.id:
        setState(() {
          _selectedScreen = ProductsScreens();
        });
        break;
      default:
        return VendorsScreens();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text('Management'),
      ),
      body: _selectedScreen,
      sideBar: SideBar(
        header: Container(
          height: 50,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.amber,
          ),
          child: Center(
            child: Text(
              "Multi Vendor Admin",
              style: TextStyle(
                fontSize: 16,
                letterSpacing: 1.7,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        items: [
          AdminMenuItem(
            title: "Vendors",
            route: VendorsScreens.id,
            icon: CupertinoIcons.person_3,
          ),
          AdminMenuItem(
            title: "Buyers",
            route: BuyersScreens.id,
            icon: CupertinoIcons.person,
          ),
          AdminMenuItem(
            title: "Orders",
            route: OrdersScreens.id,
            icon: CupertinoIcons.shopping_cart,
          ),
          AdminMenuItem(
            title: "Categories",
            route: CategoriesScreens.id,
            icon: Icons.category,
          ),
          AdminMenuItem(
            title: "Subcategories",
            route: SubcategoryScreen.id,
            icon: Icons.category_outlined,
          ),
          AdminMenuItem(
            title: "Upload Banners",
            route: UploadBannersScreens.id,
            icon: Icons.upload,
          ),
          AdminMenuItem(
            title: "Products",
            route: ProductsScreens.id,
            icon: Icons.store,
          ),
        ],
        selectedRoute: VendorsScreens.id,
        onSelected: (item) {
          screenSelector(item);
        },
      ),
    );
  }
}
