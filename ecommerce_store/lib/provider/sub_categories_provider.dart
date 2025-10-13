import 'dart:convert';

import 'package:flutter_riverpod/legacy.dart';
import 'package:http/http.dart' as http;
import 'package:shopgram/core/constants/app_constants.dart';
import 'package:shopgram/models/sub_categories_model.dart';

class SubCategoriesNotifier extends StateNotifier<List<SubCategoriesModel>> {
  SubCategoriesNotifier() : super([]);

  void setsubCategories(List<SubCategoriesModel> subCategories) {
    state = subCategories;
  }

  // This method is perfect. It correctly throws errors on failure.
  Future<List<SubCategoriesModel>> loadSubCategories(
    String categoryName,
  ) async {
    try {
      Uri url = Uri.parse(
        '$appUrl/api/category/$categoryName/subcategories',
      ); // Make sure appUrl is defined
      http.Response response = await http
          .get(
            url,
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        final parsedSubCategories = data
            .map((subCategories) => SubCategoriesModel.fromJson(subCategories))
            .toList();

        // Good Practice: update state when this specific provider is used
        state = parsedSubCategories;
        return parsedSubCategories;
      } else if (response.statusCode == 404) {
        state = [];
        throw Exception("Subcategories Not Found");
      } else {
        state = [];
        throw Exception("failed to load Subcategories");
      }
    } catch (e) {
      state = [];
      throw Exception('Error loading Subcategories: $e');
    }
  }
}

final subCategoriesProvider =
    StateNotifierProvider<SubCategoriesNotifier, List<SubCategoriesModel>>(
      (ref) => SubCategoriesNotifier(),
    );
