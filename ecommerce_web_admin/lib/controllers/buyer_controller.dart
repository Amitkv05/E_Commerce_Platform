import 'dart:convert';

import 'package:web_admin_for_fullstack/constants/app_constants.dart';
import 'package:web_admin_for_fullstack/models/buyer.dart';
import 'package:http/http.dart' as http;

class BuyerController {
  // fetch Buyers
  Future<List<Buyer>> loadBuyers() async {
    try {
      // send an http get request to fetch banners
      http.Response response = await http.get(
        Uri.parse(AppConstants.buyersEndpoint),
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
        },
      );

      // print(response.body); 

      if (response.statusCode == 200) {
        // ok
        List<dynamic> data = jsonDecode(response.body);
        List<Buyer> buyers = data.map((buyer) => Buyer.fromMap(buyer)).toList();
        return buyers;
      } else {
        // throw an exception if the server response with an error status code....
        throw Exception("Failed to load Buyers");
      }
    } catch (e) {
      throw Exception("Error Loading Buyers $e");
    }
  }
}
