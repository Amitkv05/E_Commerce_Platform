import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopgram/provider/auth/auth_service.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  final String email;
  const ForgotPasswordScreen({super.key, required this.email});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  String errorMsg = '';
  @override
  void initState() {
    super.initState();
    emailController.text = widget.email;
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
  }

  void resetPassword() async {
    try {
      final auth = ref.read(authServiceProvider);

      // Step 1: Try sending reset link
      await auth.resetPassword(email: emailController.text.trim());

      setState(() {
        errorMsg = '';
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Reset link sent! Check your inbox")),
      );
    } on FirebaseAuthException catch (e) {
      // Step 2: Catch "user-not-found"
      if (e.code == 'user-not-found') {
        setState(() {
          errorMsg = "No account found for this email.";
        });
      } else {
        setState(() {
          errorMsg = e.message ?? 'Something went wrong';
        });
      }
    } catch (e) {
      setState(() {
        errorMsg = 'Unexpected error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Forgot Password")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Reset Password",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),

              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: "Enter your email",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return "Enter email";
                  if (!value.contains("@")) return "Enter valid email";
                  return null;
                },
              ),
              const SizedBox(height: 10),
              Text(errorMsg, style: TextStyle(color: Colors.red)),
              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    resetPassword();
                  }
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                ),
                child: const Text("Send Reset Link"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
