import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shopgram/provider/auth/google_login_provider.dart';

class GoogleLoginWidget extends StatefulWidget {
  const GoogleLoginWidget({super.key});

  @override
  State<GoogleLoginWidget> createState() => _GoogleLoginWidgetState();
}

class _GoogleLoginWidgetState extends State<GoogleLoginWidget> {
  final firebaseService = FirebaseService();

  @override
  void initState() {
    super.initState();
    if (FirebaseAuth.instance.currentUser != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, '/navigationMenu');
      });
    }
    firebaseService.googleSignIn.onCurrentUserChanged.listen((account) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () async {
            bool result = await firebaseService.signInWithGoogle();
            if (result) {
              Navigator.pushReplacementNamed(context, '/navigationMenu');
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Google Sign-In canceled or failed")),
              );
            }
          },
          child: Container(
            padding: EdgeInsets.all(12),
            margin: EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(32),
            ),
            child: Row(
              children: [
                Icon(Icons.login),
                SizedBox(width: 15),
                Text(
                  'Continue with Google',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
