import 'dart:convert';

import 'package:flutter_riverpod/legacy.dart';
import 'package:http/http.dart' as http;
import 'package:shopgram/core/constants/app_constants.dart';
import 'package:shopgram/models/products_model.dart';

class ProductsNotifier extends StateNotifier<List<ProductModel>> {
  ProductsNotifier() : super([]);

  void setProducts(List<ProductModel> products) {
    state = products;
  }

  Future<List<ProductModel>> loadProductByCategory(String category) async {
    try {
      http.Response response = await http.get(
        Uri.parse('$appUrl/api/products-by-category/$category'),
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
        },
      );
      if (response.statusCode == 200) {
        // decode the json response body into a list of dynamic objects
        final List<dynamic> data = json.decode(response.body) as List<dynamic>;
        // map each item in the list to a product model object
        List<ProductModel> products = data
            .map(
              (product) =>
                  ProductModel.fromJson(product as Map<String, dynamic>),
            )
            .toList();
        return products;
      } else if (response.statusCode == 404) {
        return [];
      } else {
        // if status code in not 200, throw an exception indicating failure to load products by category
        throw Exception("Failed to load products by category");
      }
    } catch (e) {
      throw Exception('Error loading products by category: $e');
    }
  }

  Future<List<ProductModel>> loadProductsBySubCategory(
    String subCategory,
  ) async {
    try {
      Uri url = Uri.parse('$appUrl/api/products-by-subcategory/$subCategory');
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
        return data.map((product) => ProductModel.fromJson(product)).toList();
      } else if (response.statusCode == 404) {
        // return [];
        throw Exception("Products Not Found");
      } else {
        // return [];
        throw Exception("failed to load Products");
      }
    } catch (e) {
      // return [];
      throw Exception('Error loading Products: $e');
    }
  }
}

final productProvider =
    StateNotifierProvider<ProductsNotifier, List<ProductModel>>(
      (ref) => ProductsNotifier(),
    );
