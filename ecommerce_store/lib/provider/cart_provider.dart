import 'dart:convert';

import 'package:flutter_riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopgram/models/cart_model.dart';

final cartProvider = StateNotifierProvider<CartNotifier, Map<String, Cart>>(
  (ref) => CartNotifier(),
);

class CartNotifier extends StateNotifier<Map<String, Cart>> {
  CartNotifier() : super({}) {
    _loadCartItems();
  }

  // method to load favorite items from shared preferences
  Future<void> _loadCartItems() async {
    // retrieving the sharepreferences instance to store data
    final prefs = await SharedPreferences.getInstance();
    // fetch the json sstring of the favorite items from sharedPreferences under the key "favorites"
    final cartString = prefs.getString('cart_items');
    // Checking if the String is not null, meaning there is saved data to load
    if (cartString != null) {
      // decoding the json string to a map of dynamic data..
      final Map<String, dynamic> cartMap = jsonDecode(cartString);
      // convert the dynamic map into a map of Favorite Object using the "fromJson" factory method..
      final cartItems = cartMap.map(
        (key, value) => MapEntry(key, Cart.fromJson(value)),
      );
      // updating the state of the provider with the loaded favorite items
      state = cartItems;
    }
  }

  Future<void> _saveCartItems() async {
    // retrieving the sharepreferences instance to store data
    final prefs = await SharedPreferences.getInstance();
    // encode the map of favorite items into a json string
    final cartString = jsonEncode(state);
    // save the json string under the key "favorites"
    await prefs.setString('cart_items', cartString);
  }

  void addProductToCart({
    required String productName,
    required int productPrice,
    required String category,
    required List<String> image,
    required String vendorId,
    required int productQuantity,
    required int quantity,
    required String productId,
    required String description,
    required String fullName,
  }) {
    // checking if the product is already in the cart
    if (state.containsKey(productId)) {
      // if the product is already in the cart, increment the quantity
      state = {
        ...state,
        productId: Cart(
          productName: productName,
          productPrice: productPrice,
          category: category,
          image: image,
          vendorId: vendorId,
          productQuantity: productQuantity,
          quantity: quantity,
          productId: productId,
          description: description,
          fullName: fullName,
        ),
      };
      _saveCartItems();
    } else {
      // if the product is not in the cart, add it
      state = {
        ...state,
        productId: Cart(
          productName: productName,
          productPrice: productPrice,
          category: category,
          image: image,
          vendorId: vendorId,
          productQuantity: productQuantity,
          quantity: quantity,
          productId: productId,
          description: description,
          fullName: fullName,
        ),
      };
      _saveCartItems();
    }
  }

  // method to increment the quantity of a product in the cart
  void incrementCartItem(String productId) {
    if (state.containsKey(productId)) {
      // state = {
      //   ...state,
      //   productId: Cart(
      //     productName: state[productId]!.productName,
      //     productPrice: state[productId]!.productPrice,
      //     category: state[productId]!.category,
      //     image: state[productId]!.image,
      //     vendorId: state[productId]!.vendorId,
      //     productQuantity: state[productId]!.productQuantity,
      //     quantity: state[productId]!.quantity + 1,
      //     productId: state[productId]!.productId,
      //     description: state[productId]!.description,
      //     fullName: state[productId]!.fullName,
      //   ),
      // };
      // or
      final existingItem = state[productId];
      if (existingItem != null) {
        existingItem.quantity++; //state[productId]!.quantity++;
        // other came same so that's why we use the spread operator(...state)
        state = {...state};
        _saveCartItems();
      }
    }
  }

  // method to decrement the quantity of a product in the cart
  void decrementCartItem(String productId) {
    if (state.containsKey(productId) && state[productId]!.quantity > 1) {
      final existingItem = state[productId];
      if (existingItem != null && existingItem.quantity > 1) {
        existingItem.quantity--;
        state = {...state};
        _saveCartItems();
      }
    }
  }

  // method to remove a product from the cart
  void removeCartItem(String productId) {
    state.remove(productId);
    state = {...state};
    _saveCartItems();
  }

  void clearCart() {
    state = {};
    _saveCartItems();
  }

  // method to check if a product is in the cart
  bool isProductInCart(String productId) => state.containsKey(productId);

  // method to get the quantity of a product in the cart
  int getQuantity(String productId) => state[productId]?.quantity ?? 0;

  // method to get the total price of all products in the cart
  int getTotalPrice() => state.values.fold(
    0,
    (previousValue, element) => previousValue + element.productPrice,
  );

  // method to get the total quantity of all products in the cart
  double calculateTotalAmount() {
    double totalAmount = 0.0;
    state.forEach((productId, cartItem) {
      final price = cartItem.productPrice;
      final qty = cartItem.quantity;
      totalAmount += (price * qty);
    });
    return totalAmount;
  }

  // // method to get the list of products in the cart
  Map<String, Cart> get getCartItems => state;
  // // method to get the list of products in the cart
  // List<Cart> getCartItems() => state.values.toList();

  // method to get the total number of products in the cart
  int getTotalItems() => state.length;

  // // method to get the list of product ids in the cart
  // List<String> getCartProductIds() => state.keys.toList();

  // method to get the list of product names in the cart
  List<String> getCartProductNames() =>
      state.values.map((e) => e.productName).toList();

  // method to get the list of product prices in the cart
  List<int> getCartProductPrices() =>
      state.values.map((e) => e.productPrice).toList();

  // method to get the list of product quantities in the cart
  List<int> getCartProductQuantities() =>
      state.values.map((e) => e.quantity).toList();

  // // method to get the list of product images in the cart
  // List<List<String>> getCartProductImages() => state.values.map((e) => e.image).toList();

  // method to get the list of product categories in the cart
  List<String> getCartProductCategories() =>
      state.values.map((e) => e.category).toList();

  // method to get the list of product descriptions in the cart
  List<String> getCartProductDescriptions() =>
      state.values.map((e) => e.description).toList();
}
