import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopgram/splash_screen.dart';
import 'core/theme/app_theme.dart';
import 'core/constants/app_constants.dart';
import 'core/utils/size_config.dart';
import 'core/navigation/app_router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(ProviderScope(child: const MyApp()));
  // runApp(
  //   ChangeNotifierProvider(
  //     create: (context) => BottomNavController(),
  //     child: const MyApp(),
  //   ),
  // );
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});
  Future<void> _checkTokenAndSetUser(WidgetRef ref) async {
    // obtain an instace of sharedPreference for local data storage..
    SharedPreferences preferences = await SharedPreferences.getInstance();
    //   // Retrive the authentication token and user data stored locally..

    //   String? token = preferences.getString('auth_token');
    //   String? userJson = preferences.getString('user');
    //   // If both token and user data is available, set the user data in the provider..(update the user state)
    //   if (token != null && userJson != null) {
    //     ref.read(authServiceProvider).currentUser;
    //     print('token found');
    //   } else {
    //     print('No token found');
    //     ref.read(authServiceProvider).signOut();
    //   }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Builder(
      builder: (context) {
        SizeConfig().init(context);

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: AppConstants.appName,
          theme: AppTheme.lightTheme,
          onGenerateRoute: AppRouter.generateRoute,
          navigatorKey: navigatorKey,
          home: FutureBuilder(
            future: _checkTokenAndSetUser(ref),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              return SplashScreen();
              // final user = ref.watch(userProvider);
              // return user != null ? NavigationMenu() : LoginScreen();
              // return user != null ? NavigationMenu() : NavigationMenu();
            },
          ),
          // home: const MainScreen(),
        );
      },
    );
  }
}
