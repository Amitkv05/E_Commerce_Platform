import 'package:e_commerce_vendor_app/constants/app_constants.dart';
import 'package:e_commerce_vendor_app/provider/vendor_provider.dart';
import 'package:e_commerce_vendor_app/views/auth/login_screen.dart';
// import 'package:e_commerce_vendor_app/views/auth/signup_screen.dart';
import 'package:e_commerce_vendor_app/views/main_vendor_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(ProviderScope(child: const MainApp()));
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  // this widget is the root of your application.

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future<void> checkTokenAndSetUser(WidgetRef ref) async {
      // Obtain an instance of SharedPreferences
      SharedPreferences preferences = await SharedPreferences.getInstance();
      // retrive the authentication token and user data stored locally..
      String? token = preferences.getString('auth_token');
      String? vendorJson = preferences.getString('vendor');
      // if both the token and data are available, update the vendor state...
      if (token != null && vendorJson != null) {
        ref.read(vendorProvider.notifier).setVendor(vendorJson);
      } else {
        ref.read(vendorProvider.notifier).signOut();
      }
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppConstants.appName,
      home: FutureBuilder(
          future: checkTokenAndSetUser(ref),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            final vendor = ref.watch(vendorProvider);
            return vendor != null ? MainVendorScreen() : LoginScreen();
          }),
    );
  }
}
