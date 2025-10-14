import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:web_admin_for_fullstack/constants/app_constants.dart';
import 'package:web_admin_for_fullstack/models/order.dart';
import 'package:web_admin_for_fullstack/services/manage_http_response.dart';

class OrderController {
  // Method to get tha orders of the user(vendorId)
  Future<List<Order>> loadOrders() async {
    try {
      // send an http get request to get the orders
      http.Response response = await http.get(
        Uri.parse(AppConstants.orderEndpoint),
        // set headers to specify content type as json, ensuring proper encoding and communication with the server
        // Why: the server expects requests to specify the data formate, and in this, we are using json formate
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      //Check if the reesponse status code is 200(ok)..
      if (response.statusCode == 200) {
        // Parse the Json response body into dynamic List
        // This convert the json data into a formate that can be further processed in Dart.
        List<dynamic> data = jsonDecode(response.body);
        // Mao the dynamic list to lsit of Orders object using the from json factory method
        // this step converts the raw data into list of the orders instances, which are easier to work with...
        List<Order> orders =
            data.map((order) => Order.fromJson(order)).toList();

        return orders;
      } else {
        // throw an execption if the server responded with an error status code..
        throw Exception('Failed to load orders');
      }
    } catch (e) {
      throw Exception('error Loading Orders');
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
}
