import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void manageHttpResponses({
  required http.Response response, // the http response from the request
  required BuildContext context, // the context is to show snackbar
  required VoidCallback onSuccess,
  // the callback to excute on a asuccessfull response
}) {
  // Switch statement to handle different Http status codes
  switch (response.statusCode) {
    case 200: //status code 200 indicates a successfull request
      { 
        onSuccess();
      }
      break;
    case 400: // for a bad request
      {
        showSnackBar(context, json.decode(response.body)['msg']);
      }
      break;
    case 500: // for a server error
      {
        showSnackBar(context, json.decode(response.body)['error']);
      }
      break;
    case 201: // for a created request
      {
        onSuccess();
      }
      break;
    default:
      showSnackBar(context, response.body);
  }
}

// void showSnackBar(BuildContext context, String title) {
//   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(title)));
// }
void showSnackBar(BuildContext context, String text) {
  if (context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
      ),
    );
  }
}
