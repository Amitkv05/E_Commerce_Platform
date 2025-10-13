// // ignore_for_file: use_build_context_synchronously

// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:shopgram/core/constants/app_constants.dart';
// import 'package:shopgram/provider/user_provider.dart';
// import 'package:shopgram/server/manage_http_responses.dart';

// // final providerContainer = ProviderContainer();

// class AuthController {
//   // Future<void> signUpUsers({
//   //   required BuildContext context,
//   //   required String fullName,
//   //   required String email,
//   //   required String password,
//   // }) async {
//   //   try {
//   //     User user = User(
//   //       id: '',
//   //       fullName: fullName,
//   //       email: email,
//   //       state: '',
//   //       city: '',
//   //       locality: '',
//   //       password: password,
//   //       token: '',
//   //     );
//   //     http.Response response = await http.post(
//   //       Uri.parse(AppConstants.signupEndpoint),
//   //       body: user
//   //           .toJson(), //convert the user Object to json for the request body//
//   //       headers: <String, String>{
//   //         //Set the Headers for the request//
//   //         'Content-Type':
//   //             'application/json; charset=UTF-8', // specify the content type as json
//   //       },
//   //     );
//   //     manageHttpResponses(
//   //       response: response,
//   //       context: context,
//   //       onSuccess: () async {
//   //         Navigator.push(
//   //           context,
//   //           MaterialPageRoute(
//   //             builder: (context) {
//   //               return LoginScreen();
//   //             },
//   //           ),
//   //         );
//   //         showSnackBar(context, "Account created successfully");
//   //         // Navigator.of(context).pop();
//   //       },
//   //     );
//   //   } catch (e) {
//   //     showSnackBar(context, e.toString());
//   //   }
//   // }

//   // // signin Users method
//   // Future<void> signInUsers({
//   //   required BuildContext context,
//   //   required String email,
//   //   required String password,
//   //   required WidgetRef ref,
//   // }) async {
//   //   try {
//   //     http.Response response = await http.post(
//   //       Uri.parse(AppConstants.signinEndpoint),
//   //       body: jsonEncode({
//   //         'email': email, // include the email in the request body
//   //         'password': password, //invcude the password in the request body
//   //       }),
//   //       headers: <String, String>{
//   //         //Set the Headers for the request//
//   //         'Content-Type':
//   //             'application/json; charset=UTF-8', // specify the content type as json
//   //       },
//   //     );
//   //     manageHttpResponses(
//   //       response: response,
//   //       context: context,
//   //       onSuccess: () async {
//   //         // access sharedPreferences for token and user data storage..
//   //         SharedPreferences preferences = await SharedPreferences.getInstance();
//   //         // Extract the authentication token from the response body
//   //         String token = jsonDecode(response.body)['token'];
//   //         // store the authenticaiton token securely in the shared preferences
//   //         await preferences.setString('auth_token', token);
//   //         // Encode the user data received from the backend as json
//   //         final userJson = jsonEncode(jsonDecode(response.body)['user']);

//   //         // update the application state wiht the user data using riverpod
//   //         ref.read(userProvider.notifier).setUser(userJson);

//   //         // store the data in sharePreference for future..
//   //         await preferences.setString('user', userJson);

//   //         Navigator.pushAndRemoveUntil(
//   //           context,
//   //           MaterialPageRoute(builder: (context) => HomeScreen()),
//   //           (route) => false,
//   //         );
//   //         showSnackBar(context, "Login successful");
//   //         // Navigator.of(context).pop();
//   //       },
//   //     );
//   //   } catch (e) {
//   //     showSnackBar(context, e.toString());
//   //     print("Error: $e");
//   //   }
//   // }

//   // Future<void> signOutUser({
//   //   required BuildContext context,
//   //   required WidgetRef ref,
//   // }) async {
//   //   try {
//   //     SharedPreferences preferences = await SharedPreferences.getInstance();
//   //     // clear  the token and user from SharedPreferenace
//   //     await preferences.remove('auth_token');
//   //     await preferences.remove('user');
//   //     // clear the user state
//   //     ref.read(userProvider.notifier).signOut();
//   //     ref.read(deliveredOrderCountProvider.notifier).resetCount();
//   //     // navigation the user back to the login screen

//   //     Navigator.pushAndRemoveUntil(
//   //       context,
//   //       MaterialPageRoute(
//   //         builder: (context) {
//   //           return const LoginScreen();
//   //         },
//   //       ),
//   //       (route) => false,
//   //     );

//   //     showSnackBar(context, 'SignOut Successfully');
//   //   } catch (e) {
//   //     showSnackBar(context, 'Error Signing Out');
//   //   }
//   // }

//   // update user's  state, city and locality
//   Future<void> updateUserLocation({
//     required BuildContext context,
//     required String id,
//     required String state,
//     required String city,
//     required String locality,
//     required WidgetRef ref,
//   }) async {
//     try {
//       // Make an HTTP PUT request to update the user's state, city and locality
//       final http.Response response = await http.put(
//         Uri.parse('${AppConstants.updateUserEndpoint}/$id'),
//         // set the header for the request to specify that the content is Json..
//         headers: <String, String>{
//           "Content-Type": 'application/json; charset=UTF-8',
//         },
//         // Encode the update data(state, city adn locality) as Json object
//         body: jsonEncode({'state': state, 'city': city, 'locality': locality}),
//       );

//       manageHttpResponses(
//         response: response,
//         context: context,
//         onSuccess: () async {
//           // Decode the updated user data from the response body
//           // this converts the json String response into Dart Map
//           final updatedUser = jsonDecode(response.body);
//           // Access Shared preference for local data storage
//           // shared preferences allow us to store data persisitently on the device
//           SharedPreferences preferences = await SharedPreferences.getInstance();
//           // Encode the update user data as json String
//           // this prepares the data for storage in shared preferences
//           final userJson = jsonEncode(updatedUser);

//           // update the application state with the updated user data user in riverpod
//           // this ensures the app reflects the most recent user data
//           ref.read(userProvider.notifier).setUser(userJson);

//           // store the updated user data in shared preferences for future user
//           // this allows the app to retrive the user data even after the app restarts
//           await preferences.setString('user', userJson);
//         },
//       );
//     } catch (e) {
//       // catch any error that occure during the process
//       // show an error message to the user if the update fails..
//       showSnackBar(context, 'Error updating Address');
//     }
//   }
// }
