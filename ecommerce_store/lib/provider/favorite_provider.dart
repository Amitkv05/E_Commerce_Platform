import 'dart:convert';

import 'package:flutter_riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopgram/models/cart_model.dart';

final FavoriteProvider =
    StateNotifierProvider<FavoriteNotifier, Map<String, Cart>>(
      (ref) => FavoriteNotifier(),
    );

class FavoriteNotifier extends StateNotifier<Map<String, Cart>> {
  FavoriteNotifier() : super({}) {
    _loadFavorites();
  }
  Future<void> _loadFavorites() async {
    // retrieving the sharepreferences instance to store data
    final prefs = await SharedPreferences.getInstance();
    // fetch the json string of the favorite items from sharedPreferences under the key "favorites"
    final favoriteString = prefs.getString('favorites');

    if (favoriteString != null) {
      // decoding the json string to a map of dynamic data
      final Map<String, dynamic> favoriteMap = jsonDecode(favoriteString);
      // convert the dynamic map into a map of Favorite Object using the "fromJson" factory method
      final favorites = favoriteMap.map(
        (key, value) => MapEntry(key, Cart.fromJson(value)),
      );

      // updating the state of the provider with the loaded favorite items
      state = favorites;
    }
  }

  // A private method that saves the current list of favorite items to sharedPreferences
  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    // encoding the current state(map of favorite items) to json String
    final favoriteString = jsonEncode(state);
    // saving the json string to sharedPreferences  with the key "favorites"
    await prefs.setString("favorites", favoriteString);
  }

  void addProductToFavorite({
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
    state[productId] = Cart(
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
    );
    // notify listeners the state has changed
    state = {...state};
    _saveFavorites();
  }

  void removeFavoriteItem(String productId) {
    state.remove(productId);
    // Notify Listerners that the state has changed.
    state = {...state};
    _saveFavorites();
  }

  Map<String, Cart> get getFavoriteItems => state;

  bool isFavorite(String productId) => state.containsKey(productId);

  int getQuantity(String productId) => state[productId]?.quantity ?? 0;

  int getTotalItems() => state.values.fold(
    0,
    (previousValue, element) => previousValue + element.quantity,
  );
}
