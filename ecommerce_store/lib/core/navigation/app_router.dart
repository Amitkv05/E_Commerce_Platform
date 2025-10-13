import 'package:flutter/material.dart';
import 'package:shopgram/screens/auth/google_login_screen.dart';
import 'package:shopgram/screens/auth/login_screen.dart';
import 'package:shopgram/screens/auth/signup_screen.dart';
import 'package:shopgram/screens/cart_screen.dart';
import 'package:shopgram/screens/explore_screen.dart';
import 'package:shopgram/screens/favorite_screen.dart';
import 'package:shopgram/screens/homeScreen/home_screen.dart';
import 'package:shopgram/screens/navigation_menu.dart';
import 'package:shopgram/screens/profile/profile_screen.dart';
import 'package:shopgram/splash_screen.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/splashScreen':
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case '/navigationMenu':
        return MaterialPageRoute(builder: (_) => const NavigationMenu());
      case '/home':
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case '/cart':
        return MaterialPageRoute(builder: (_) => const CartScreen());
      case '/favorite':
        return MaterialPageRoute(builder: (_) => const FavoriteScreen());
      case '/profile':
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
      case '/login':
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case '/googleAuth':
        return MaterialPageRoute(builder: (_) => const GoogleLoginWidget());
      case '/signup':
        return MaterialPageRoute(builder: (_) => const SignupScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
