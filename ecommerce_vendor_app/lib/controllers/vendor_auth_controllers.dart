import 'dart:convert';

import 'package:e_commerce_vendor_app/global_variables.dart';
import 'package:e_commerce_vendor_app/models/vendor.dart';
import 'package:e_commerce_vendor_app/provider/vendor_provider.dart';
import 'package:e_commerce_vendor_app/services/manage_http_responses.dart';
import 'package:e_commerce_vendor_app/views/auth/login_screen.dart';
import 'package:e_commerce_vendor_app/views/main_vendor_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

final providerContainer = ProviderContainer();

class VendorAuthControllers {
  Future<void> signUpVendor(
      {required String fullName,
      required String email,
      required String password,
      required context}) async {
    try {
      Vendor vendor = Vendor(
        id: '',
        fullName: fullName,
        email: email,
        state: '',
        city: '',
        locality: '',
        role: '',
        password: password,
      );

      http.Response response = await http.post(
          Uri.parse("$uri/api/vendor/signup"),
          body: vendor
              .toJson(), //Convert the vendor user object to json fro the request body
          headers: <String, String>{
            // Set the Headers for the request
            "Content-Type": "application/json; charset=UTF-8",
          });

      // managehttp response to handle http response base on the status code
      manageHttpResponses(
          response: response,
          context: context,
          onSuccess: () {
            showSnackBar(context, 'Vendor Account Created');
          });
    } catch (e) {
      showSnackBar(context, e.toString());
      print("Error: $e");
    }
  }

  // function to consume the backend vendor signin api

  Future<void> signInVendor(
      {required String email,
      required String password,
      required context}) async {
    try {
      http.Response response = await http.post(
          Uri.parse('$uri/api/vendor/signin'),
          body: jsonEncode({
            'email': email,
            "password": password
          }), //Convert the vendor user object to json fro the request body
          headers: <String, String>{
            // Set the Headers for the request
            "Content-Type": "application/json; charset=UTF-8",
          });
      manageHttpResponses(
          response: response,
          context: context,
          onSuccess: () async {
            SharedPreferences preferences =
                await SharedPreferences.getInstance();
            // Extract the authentication token from the response body....
            String token = jsonDecode(response.body)['token'];
            // Store the token in the shared preferences
            preferences.setString('auth_token', token);
            // Encode the user data received from the backend as json..
            final vendorJson = jsonEncode(jsonDecode(response.body)['vendor']);

            // update the application state with user data using riverpod..

            providerContainer
                .read(vendorProvider.notifier)
                .setVendor(vendorJson);

            // store the data in sharedPreferences...
            await preferences.setString('vendor', vendorJson);

            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => MainVendorScreen()),
                (route) => false);
            showSnackBar(context, 'Logged in successfully');
          });
    } catch (e) {
      showSnackBar(context, e.toString());
      print("Error: $e");
    }
  }

  Future<void> signOutVendor(
      {required BuildContext context, required WidgetRef ref}) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      // clear  the token and user from SharedPreferenace
      await preferences.remove('auth_token');
      await preferences.remove('vendor');
      // clear the user state
      ref.read(vendorProvider.notifier).signOut();
      // ref.read(deliveredOrderCountProvider.notifier).resetCount();
      // navigation the user back to the login screen

      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (context) {
        return const LoginScreen();
      }), (route) => false);

      showSnackBar(context, 'SignOut Successfully');
    } catch (e) {
      showSnackBar(context, 'Error Signing Out');
    }
  }
}
