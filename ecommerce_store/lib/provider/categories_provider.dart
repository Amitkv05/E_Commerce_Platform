import 'dart:async';
import 'dart:convert';
import 'package:flutter_riverpod/legacy.dart';
import 'package:shopgram/core/constants/app_constants.dart';
import 'package:http/http.dart' as http;
import 'package:shopgram/models/categories_model.dart';

class CategoriesNotifier extends StateNotifier<List<CategoriesModel>> {
  CategoriesNotifier() : super([]);

  void setCategories(List<CategoriesModel> categories) {
    state = categories;
  }

  Future<List<CategoriesModel>> loadCategories() async {
    try {
      final Uri url = Uri.parse(AppConstants.categoriesEndpoint);
      http.Response response = await http
          .get(
            url,
            headers: {"Content-Type": "application/json; charset=UTF-8"},
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        // if (data.isEmpty) {
        //   state = []; // Also update state to be empty
        //   return [];
        // }

        final parsedCategories = data
            .map((category) => CategoriesModel.fromJson(category))
            .toList();

        // --- THIS IS THE FIX ---
        // Update the state of this provider so that any widget watching it will rebuild.
        state = parsedCategories;

        // Return the parsed data for immediate use (like in _initializeScreen)
        return parsedCategories;
      } else {
        state = []; // On failure, clear the state
        return [];
      }
    } catch (e) {
      state = []; // On error, also clear the state
      return [];
    }
  }
}

// Use the modern provider definition
final categoriesProvider =
    StateNotifierProvider<CategoriesNotifier, List<CategoriesModel>>(
      (ref) => CategoriesNotifier(),
    );
