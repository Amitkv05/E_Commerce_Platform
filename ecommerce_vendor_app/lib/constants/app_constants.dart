const String appUrl = 'https://e-commerce-platform-fvxy.onrender.com';

class AppConstants {
  // App Info
  static const String appName = 'ShopGram Vendor App';
  static const String appVersion = '1.0.0';
  static const String appPackageName = 'com.example.ecommerce';

  // API Endpoints
  static const String baseUrl = appUrl;
  static const String signupEndpoint = '$baseUrl/api/vendor/signup';
  static const String signinEndpoint = '$baseUrl/api/vendor/signin';
  // static const String loginEndpoint = '$baseUrl/api/signin';
  // static const String updateUserEndpoint = '$baseUrl/api/users';
  // static const String orderEndpoint = '$baseUrl/api/orders';
  // static const String paymentIntentEndpoint = '$baseUrl/api/payment-intent';
  static const String productsEndpoint = '$baseUrl/api/products';
  // static const String bannerEndpoint = '$baseUrl/api/banner';
  static const String categoriesEndpoint = '$baseUrl/api/categories';
  // static const String productReviewEndpoint = '$baseUrl/api/product-reviews';
  static const String subCategoriesEndpoint = '$baseUrl/api/subcategories';
  // static const String authEndpoint = '$baseUrl/auth';

  // Storage Keys
  static const String userTokenKey = 'user_token';
  static const String userDataKey = 'user_data';
  static const String cartItemsKey = 'cart_items';
  static const String appLanguageKey = 'app_language';

  // Error Messages
  static const String genericError = 'Something went wrong. Please try again.';
  static const String networkError =
      'No internet connection. Please check your connection.';
  static const String authError = 'Authentication failed. Please try again.';

  // Success Messages
  static const String loginSuccess = 'Welcome back!';
  static const String registerSuccess = 'Account created successfully!';
  static const String addToCartSuccess = 'Item added to cart!';
  static const String orderSuccess = 'Order placed successfully!';

  // Time Constants
  static const Duration pageTransitionDuration = Duration(milliseconds: 300);
  static const Duration buttonAnimationDuration = Duration(milliseconds: 200);

  // Pagination
  static const int pageSize = 20;
  static const int initialPage = 1;
}
