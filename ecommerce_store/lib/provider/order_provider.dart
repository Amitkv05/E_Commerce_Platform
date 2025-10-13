import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopgram/core/constants/app_constants.dart';
import 'package:shopgram/models/order_model.dart';
import 'package:shopgram/server/manage_http_responses.dart';

final orderProvider = StateNotifierProvider<OrderNotifier, List<Order>>((ref) {
  return OrderNotifier();
});

class OrderNotifier extends StateNotifier<List<Order>> {
  OrderNotifier() : super([]);
  Future<void> uploadOrders({
    required String id,
    required String fullName,
    required String email,
    required String state,
    required String city,
    required String locality,
    required String productId,
    required String productName,
    required int productPrice,
    required int quantity,
    required String category,
    required String image,
    required String buyerId,
    required String vendorId,
    required bool processing,
    required bool delivered,
    required String paymentStatus,
    required String paymentIntentId,
    required String paymentMethod,
    required context,
  }) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      // String? token = preferences.getString('auth_token');
      final Order order = Order(
        id: id,
        fullName: fullName,
        email: email,
        state: state,
        city: city,
        locality: locality,
        productId: productId,
        productName: productName,
        productPrice: productPrice,
        quantity: quantity,
        category: category,
        image: image,
        buyerId: buyerId,
        vendorId: vendorId,
        processing: processing,
        delivered: delivered,
        paymentStatus: paymentStatus,
        paymentIntentId: paymentIntentId,
        paymentMethod: paymentMethod,
      );
      http.Response response = await http.post(
        Uri.parse(AppConstants.orderEndpoint),
        body: order.toJson(),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // 'x-auth-token': token!,
        },
      );
      manageHttpResponses(
        response: response,
        context: context,
        onSuccess: () async {
          showSnackBar(context, 'You have placed an order');
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  // Method to get tha orders of the user(buyerId)
  Future<List<Order>> loadOrders({required String buyerId}) async {
    try {
      // GET THE FIREBASE ID TOKEN
      final User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        throw Exception('User not logged in');
      }
      // final String? token = await currentUser.getIdToken();

      // Send an Http Get request to get the orders by the buyerID
      http.Response response = await http.get(
        Uri.parse('${AppConstants.orderEndpoint}/$buyerId'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // USE THE STANDARD 'Authorization' HEADER
          // 'Authorization': 'Bearer $token',
        },
      );
      //Check if the reesponse status code is 200(ok)..
      if (response.statusCode == 200) {
        // Parse the Json response body into dynamic List
        // This convert the json data into a formate that can be further processed in Dart.
        List<dynamic> data = jsonDecode(response.body);
        // Mao the dynamic list to lsit of Orders object using the from json factory method
        // this step converts the raw data into list of the orders instances, which are easier to work with...
        List<Order> orders = data
            .map((order) => Order.fromJson(order))
            .toList();

        return orders;
      } else if (response.statusCode == 404) {
        // return [];
        throw Exception('Orders Not Found');
      } else {
        print('Failed to load orders. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception(
          'Failed to load orders. Server responded with status ${response.statusCode}',
        );
        // return [];
        // throw an execption if the server responded with an error status code..
        // throw Exception('Failed to load orders');
      }
    } catch (e) {
      // return [];
      throw Exception('error Loading Orders');
    }
  }

  // Delete order by Id
  Future<void> deleteOrder({required String id, required context}) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      // String? token = preferences.getString('auth_token');
      // send an http delete request to delete the order by _id
      http.Response response = await http.delete(
        Uri.parse('${AppConstants.orderEndpoint}/$id'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // 'x-auth-token': token!,
        },
      );

      // handle the HTTP Response
      manageHttpResponses(
        response: response,
        context: context,
        onSuccess: () async {
          showSnackBar(context, "Order Deleted Successfully");
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  // Method to count delivered orders
  Future<int> getDeliveredOrderCount({
    required String buyerId,
    required context,
  }) async {
    try {
      List<Order> orders = await loadOrders(buyerId: buyerId);
      // Filter any delivery orders
      int deliveredCount = orders.where((order) => order.delivered).length;

      return deliveredCount;
    } catch (e) {
      showSnackBar(context, e.toString());
      throw Exception("Error counting Delivered Orders");
    }
  }

  Future<Map<String, dynamic>> createPaymentIntent({
    required int amount,
    required String currency,
  }) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      // String? token = preferences.getString('auth_token');

      http.Response response = await http.post(
        Uri.parse(AppConstants.paymentIntentEndpoint),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // 'x-auth-token': token!,
        },
        body: jsonEncode({'amount': amount, 'currency': currency}),
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to create payment intent ${response.body}');
      }
    } catch (e) {
      throw Exception('Error Create Payment Intent: $e');
    }
  }

  Future<Map<String, dynamic>> getPaymentIntentStatus({
    required BuildContext context,
    required String paymentIntentId,
  }) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      // String? token = preferences.getString('auth_token');

      http.Response response = await http.get(
        Uri.parse('${AppConstants.paymentIntentEndpoint}/$paymentIntentId'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // 'x-auth-token': token!,
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to get payment intent status ${response.body}');
      }
    } catch (e) {
      throw Exception('Error Get Payment Intent Status: $e');
    }
  }

  void setOrders(List<Order> orders) {
    state = orders;
  }

  void addOrder(Order order) {
    state = [...state, order];
  }

  void removeOrder(Order order) {
    state = state.where((o) => o.id != order.id).toList();
  }
}
