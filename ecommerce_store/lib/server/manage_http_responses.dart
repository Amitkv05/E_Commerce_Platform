import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopgram/screens/navigation_menu.dart';

/// Handles HTTP responses and displays appropriate SnackBar messages based on status codes.
///
/// [response] is the HTTP response from the request.
/// [context] is used to show SnackBars.
/// [onSuccess] is a callback executed for successful responses (200 or 201).
Future<void> manageHttpResponses({
  required http.Response response,
  required BuildContext context,
  required Future<void> Function() onSuccess,
}) async {
  if (response.body.isEmpty &&
      response.statusCode != 200 &&
      response.statusCode != 201) {
    debugPrint('Empty response for status code: ${response.statusCode}');
    showSnackBar(
      context,
      'Empty response from server.',
      backgroundColor: Colors.redAccent,
    );
    return;
  }

  switch (response.statusCode) {
    case 200: // OK
    case 201: // Created
      await onSuccess();
      break;
    case 400: // Bad Request
    case 500: // Server Error
      debugPrint('HTTP ${response.statusCode}: ${response.body}');
      showSnackBar(
        context,
        getErrorMessage(response),
        backgroundColor: Colors.redAccent,
      );
      break;
    case 401: // Unauthorized
      debugPrint('HTTP ${response.statusCode}: ${response.body}');
      showSnackBar(
        context,
        'Unauthorized: Please log in again.',
        backgroundColor: Colors.redAccent,
      );
      break;
    case 403: // Forbidden
      debugPrint('HTTP ${response.statusCode}: ${response.body}');
      showSnackBar(
        context,
        'Forbidden: You do not have access.',
        backgroundColor: Colors.redAccent,
      );
      break;
    case 404: // Not Found
      debugPrint('HTTP ${response.statusCode}: ${response.body}');
      showSnackBar(
        context,
        'Resource not found.',
        backgroundColor: Colors.redAccent,
      );
      break;
    case 429: // Too Many Requests
      debugPrint('HTTP ${response.statusCode}: ${response.body}');
      showSnackBar(
        context,
        'Too many requests. Please try again later.',
        backgroundColor: Colors.redAccent,
      );
      break;
    default:
      debugPrint('HTTP ${response.statusCode}: ${response.body}');
      showSnackBar(
        context,
        'Unexpected error: ${response.statusCode}',
        backgroundColor: Colors.redAccent,
      );
  }
}

/// Extracts an error message from the HTTP response body.
/// Returns a fallback message if JSON decoding fails or expected keys are missing.
String getErrorMessage(http.Response response) {
  try {
    final decoded = json.decode(response.body);
    if (response.statusCode == 400 && decoded['msg'] != null) {
      return decoded['msg'].toString();
    } else if (response.statusCode == 500 && decoded['error'] != null) {
      return decoded['error'].toString();
    }
  } catch (e) {
    debugPrint('Error decoding response: $e');
  }
  return response.body.isNotEmpty ? response.body : 'Unknown error';
}

/// Displays a SnackBar with the given [text] and customizable [backgroundColor] and [duration].
///
/// The SnackBar is only shown if [context] is mounted.
void showSnackBar(
  BuildContext context,
  String text, {
  Color backgroundColor = Colors.grey,
  Duration duration = const Duration(seconds: 3),
}) {
  if (context.mounted) {
    final messenger = ScaffoldMessenger.of(context);
    messenger
      ..hideCurrentSnackBar() // 👈 Immediately hide the previous one
      ..showSnackBar(
        SnackBar(
          margin: const EdgeInsets.all(15),
          behavior: SnackBarBehavior.floating,
          backgroundColor: backgroundColor,
          duration: duration,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: Text(text, style: const TextStyle(color: Colors.white)),
        ),
      );
  }
}

void showCustomSnackBar(
  BuildContext context,
  WidgetRef ref,
  String text,
  String image, {
  Duration duration = const Duration(seconds: 3),
}) {
  final overlay = Overlay.of(context);
  late OverlayEntry overlayEntry;

  overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      bottom: 50,
      left: 40,
      right: 40,
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.black87,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(radius: 18, backgroundImage: NetworkImage(image)),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  text,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              InkWell(
                onTap: () {
                  overlayEntry.remove();
                  // ✅ Switch bottom nav tab to Cart
                  ref.read(bottomNavIndexProvider.notifier).state =
                      3; // Cart tab index
                },
                child: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );

  overlay.insert(overlayEntry);
  Future.delayed(duration, () {
    if (overlayEntry.mounted) overlayEntry.remove();
  });
}
