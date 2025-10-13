// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/legacy.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:shopgram/core/constants/app_constants.dart';
// import 'package:shopgram/models/order_model.dart';
// import 'package:shopgram/server/manage_http_responses.dart';

// final orderProvider = StateNotifierProvider<OrderNotifier, List<Order>>((ref) {
//   return OrderNotifier();
// });

// class OrderNotifier extends StateNotifier<List<Order>> {
//   OrderNotifier() : super([]);
//   Future<void> uploadOrders({
//     required String id,
//     required String fullName,
//     required String email,
//     required String state,
//     required String city,
//     required String locality,
//     required String productId,
//     required String productName,
//     required int productPrice,
//     required int quantity,
//     required String category,
//     required String image,
//     required String buyerId,
//     required String vendorId,
//     required bool processing,
//     required bool delivered,
//     required String paymentStatus,
//     required String paymentIntentId,
//     required String paymentMethod,
//     required context,
//   }) async {
//     try {
//       SharedPreferences preferences = await SharedPreferences.getInstance();
//       // String? token = preferences.getString('auth_token');
//       final Order order = Order(
//         id: id,
//         fullName: fullName,
//         email: email,
//         state: state,
//         city: city,
//         locality: locality,
//         productId: productId,
//         productName: productName,
//         productPrice: productPrice,
//         quantity: quantity,
//         category: category,
//         image: image,
//         buyerId: buyerId,
//         vendorId: vendorId,
//         processing: processing,
//         delivered: delivered,
//         paymentStatus: paymentStatus,
//         paymentIntentId: paymentIntentId,
//         paymentMethod: paymentMethod,
//       );
//       http.Response response = await http.post(
//         Uri.parse(AppConstants.orderEndpoint),
//         body: order.toJson(),
//         headers: <String, String>{
//           'Content-Type': 'application/json; charset=UTF-8',
//           // 'x-auth-token': token!,
//         },
//       );
//       manageHttpResponses(
//         response: response,
//         context: context,
//         onSuccess: () async {
//           showSnackBar(context, 'You have placed an order');
//         },
//       );
//     } catch (e) {
//       showSnackBar(context, e.toString());
//     }
//   }

//   // Method to get tha orders of the user(buyerId)
//   Future<List<Order>> loadOrders({required String buyerId}) async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final token = prefs.getString('auth_token');
//       if (token == null) throw Exception('No auth token found');
//       if (token != null) debugPrint('auth token found');

//       final url = Uri.parse('${AppConstants.orderEndpoint}/$buyerId');
//       debugPrint('Fetching orders from: $url');

//       final response = await http.get(
//         url,
//         headers: {
//           'Content-Type': 'application/json; charset=UTF-8',
//           'x-auth-token': token,
//         },
//       );

//       debugPrint('Response status: ${response.statusCode}');
//       debugPrint('Response body: ${response.body}');

//       if (response.statusCode == 200) {
//         final List<dynamic> data = jsonDecode(response.body);
//         return data.map((e) => Order.fromJson(e)).toList();
//       } else if (response.statusCode == 404) {
//         return [];
//       } else {
//         throw Exception('Failed to load orders: ${response.body}');
//       }
//     } catch (e) {
//       debugPrint('Error in loadOrders: $e');
//       rethrow;
//     }
//   }

//   // Delete order by Id
//   Future<void> deleteOrder({required String id, required context}) async {
//     try {
//       SharedPreferences preferences = await SharedPreferences.getInstance();
//       // String? token = preferences.getString('auth_token');
//       // send an http delete request to delete the order by _id
//       http.Response response = await http.delete(
//         Uri.parse('${AppConstants.orderEndpoint}/$id'),
//         headers: <String, String>{
//           'Content-Type': 'application/json; charset=UTF-8',
//           // 'x-auth-token': token!,
//         },
//       );

//       // handle the HTTP Response
//       manageHttpResponses(
//         response: response,
//         context: context,
//         onSuccess: () async {
//           showSnackBar(context, "Order Deleted Successfully");
//         },
//       );
//     } catch (e) {
//       showSnackBar(context, e.toString());
//     }
//   }

//   // Method to count delivered orders
//   Future<int> getDeliveredOrderCount({
//     required String buyerId,
//     required context,
//   }) async {
//     try {
//       List<Order> orders = await loadOrders(buyerId: buyerId);
//       // Filter any delivery orders
//       int deliveredCount = orders.where((order) => order.delivered).length;

//       return deliveredCount;
//     } catch (e) {
//       showSnackBar(context, e.toString());
//       throw Exception("Error counting Delivered Orders");
//     }
//   }

//   /*************  ✨ Windsurf Command ⭐  *************/
//   /// Create a payment intent with the given amount and currency.
//   ///
//   /// If the request is successful, return the payment intent as a Map.
//   /// If the request fails, throw an exception with an error message.
//   ///
//   /// Amount: The amount of the payment intent.
//   /// Currency: The currency of the payment intent.
//   ///
//   /// Throws an [Exception] if the request fails.
//   /*******  fc763eb0-11fa-4382-ab66-60e886662087  *******/
//   Future<Map<String, dynamic>> createPaymentIntent({
//     required int amount,
//     required String currency,
//   }) async {
//     try {
//       SharedPreferences preferences = await SharedPreferences.getInstance();
//       // String? token = preferences.getString('auth_token');

//       http.Response response = await http.post(
//         Uri.parse(AppConstants.paymentIntentEndpoint),
//         headers: <String, String>{
//           'Content-Type': 'application/json; charset=UTF-8',
//           // 'x-auth-token': token!,
//         },
//         body: jsonEncode({'amount': amount, 'currency': currency}),
//       );
//       if (response.statusCode == 200) {
//         return jsonDecode(response.body);
//       } else {
//         throw Exception('Failed to create payment intent ${response.body}');
//       }
//     } catch (e) {
//       throw Exception('Error Create Payment Intent: $e');
//     }
//   }

//   Future<Map<String, dynamic>> getPaymentIntentStatus({
//     required BuildContext context,
//     required String paymentIntentId,
//   }) async {
//     try {
//       SharedPreferences preferences = await SharedPreferences.getInstance();
//       // String? token = preferences.getString('auth_token');

//       http.Response response = await http.get(
//         Uri.parse('${AppConstants.paymentIntentEndpoint}/$paymentIntentId'),
//         headers: <String, String>{
//           'Content-Type': 'application/json; charset=UTF-8',
//           // 'x-auth-token': token!,
//         },
//       );

//       if (response.statusCode == 200) {
//         return jsonDecode(response.body);
//       } else {
//         throw Exception('Failed to get payment intent status ${response.body}');
//       }
//     } catch (e) {
//       throw Exception('Error Get Payment Intent Status: $e');
//     }
//   }

//   void setOrders(List<Order> orders) {
//     state = orders;
//   }

//   void addOrder(Order order) {
//     state = [...state, order];
//   }

//   void removeOrder(Order order) {
//     state = state.where((o) => o.id != order.id).toList();
//   }
// }
