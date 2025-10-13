import 'dart:convert';

import 'package:web_admin_for_fullstack/global_variable.dart';
import 'package:web_admin_for_fullstack/models/vendor.dart';
import 'package:http/http.dart' as http;

class VendorController {
  Future<List<Vendor>> loadVendors() async {
    try {
      // send an http get request to fetch vendors
      http.Response response = await http.get(
        Uri.parse("$uri/api/vendors"),
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
        },
      );

      if (response.statusCode == 200) {
        // Decode the response body
        Map<String, dynamic> data = jsonDecode(response.body);

        // Access the list of vendors from the 'vendors' key
        List<dynamic> vendorList = data['vendors'] as List<dynamic>;

        // Map the list to a list of Vendor objects
        List<Vendor> vendors =
            vendorList.map((vendor) => Vendor.fromMap(vendor)).toList();
        return vendors;
      } else {
        // throw an exception if the server response with an error status code....
        throw Exception("Failed to load Vendor");
      }
    } catch (e) {
      throw Exception("Error Loading Vendor $e");
    }
  }
  // Future<List<Vendor>> loadVendors() async {
  //   try {
  //     // send an http get request to fetch banners
  //     http.Response response = await http.get(
  //       Uri.parse("$uri/api/vendors"),
  //       headers: <String, String>{
  //         "Content-Type": "application/json; charset=UTF-8",
  //       },
  //     );

  //     // print(response.body);

  //     if (response.statusCode == 200) {
  //       // ok
  //       List<dynamic> data = jsonDecode(response.body);
  //       List<Vendor> vendors =
  //           data.map((vendor) => Vendor.fromMap(vendor)).toList();
  //       return vendors;
  //     } else {
  //       // throw an exception if the server response with an error status code....
  //       throw Exception("Failed to load Vendor");
  //     }
  //   } catch (e) {
  //     throw Exception("Error Loading Vendor $e");
  //   }
  // }
}
