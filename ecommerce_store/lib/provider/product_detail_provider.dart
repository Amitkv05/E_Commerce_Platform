// import 'dart:async';
// import 'dart:convert';
// import 'dart:io';

// import 'package:flutter_riverpod/legacy.dart';
// import 'package:http/http.dart' as http;
// import 'package:shopgram/core/constants/app_constants.dart';
// import 'package:shopgram/models/products_model.dart';

// class ProductDetailNotifier extends StateNotifier<List<ProductModel>> {
//   ProductDetailNotifier() : super([]);

//   void setProductDetail(List<ProductModel> products) {
//     state = products;
//   }

//   Future<List<ProductModel>> loadProductDetail(String productId) async {
//     try {
//       Uri url = Uri.parse(
//         '$appUrl/api/related-products-by-subcategory/$productId',
//       );
//       http.Response response = await http.get(
//         url,
//         headers: <String, String>{
//           "Content-Type": "application/json; charset=UTF-8",
//         },
//       );
//       // .timeout(const Duration(seconds: 10));
//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         return data.map((details) => ProductModel.fromJson(details)).toList();
//       } else {
//         return []; // Return empty list instead of throwing
//       }
//     } on SocketException {
//       return [];
//     } on HttpException {
//       return [];
//     } on FormatException {
//       return [];
//     } on TimeoutException {
//       return [];
//     } catch (e) {
//       return [];
//     }
//   }
// }

// final productDetailProvider =
//     StateNotifierProvider<ProductDetailNotifier, List<ProductModel>>(
//       (ref) => ProductDetailNotifier(),
//     );
