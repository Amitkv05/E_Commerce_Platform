import 'dart:convert';

import 'package:e_commerce_vendor_app/constants/app_constants.dart';
import 'package:e_commerce_vendor_app/models/order_model.dart';
import 'package:e_commerce_vendor_app/services/manage_http_responses.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class OrderController {
  // Method to get tha orders of the user(vendorId)
  Future<List<Order>> loadOrders({required String vendorId}) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? token = preferences.getString('auth_token');
      // Send an Http Get request to get the orfers by the buyerID
      http.Response response = await http.get(
        Uri.parse('$appUrl/api/orders/vendor/$vendorId'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token!,
        },
      );
      if (token == null)
        throw Exception("No auth token found. Please log in again.");

      //Check if the reesponse status code is 200(ok)..
      if (response.statusCode == 200 || response.statusCode == 201) {
        // Parse the Json response body into dynamic List
        // This convert the json data into a formate that can be further processed in Dart.
        List<dynamic> data = jsonDecode(response.body);
        // Mao the dynamic list to lsit of Orders object using the from json factory method
        // this step converts the raw data into list of the orders instances, which are easier to work with...
        List<Order> orders =
            data.map((order) => Order.fromJson(order)).toList();

        return orders;
      }
      {
        // throw an execption if the server responded with an error status code..
        throw Exception('Failed to load orders');
      }
    } catch (e) {
      // throw an execption if the server responded with an error status code..
      print("vendor order $e");
      return [];
      // throw Exception('error Loading Orders');
    }
  }

  // Delete order by Id
  Future<void> deleteOrder({required String id, required context}) async {
    try {
      // send an http delete request to delete the order by _id
      http.Response response = await http.delete(
        Uri.parse('$appUrl/api/orders/$id'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      // handle the HTTP Response
      manageHttpResponses(
          response: response,
          context: context,
          onSuccess: () {
            showSnackBar(context, "Order Deleted Successfully");
          });
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  // Update Delivery status
  Future<void> updateDeliveryStatus(
      {required String id, required context}) async {
    try {
      // send an http put request to update the order status by _id
      http.Response response = await http.patch(
        Uri.parse('$appUrl/api/orders/$id/delivered'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'delivered': true,
          'processing': false,
        }),
      );
      // handle the HTTP Response
      manageHttpResponses(
          response: response,
          context: context,
          onSuccess: () {
            showSnackBar(context, "Order Status Updated Successfully");
          });
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  // Cancel Order
  Future<void> cancelOrder({required String id, required context}) async {
    try {
      // send an http put request to update the order status by _id
      http.Response response = await http.patch(
        Uri.parse('$appUrl/api/orders/$id/processing'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'processing': false,
          'delivered': false,
        }),
      );
      // handle the HTTP Response
      manageHttpResponses(
          response: response,
          context: context,
          onSuccess: () {
            showSnackBar(context, "Order Cancelled");
          });
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}
