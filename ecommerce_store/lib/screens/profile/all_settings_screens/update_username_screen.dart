import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopgram/provider/auth/auth_service.dart';

class UpdateUsernameScreen extends ConsumerStatefulWidget {
  const UpdateUsernameScreen({super.key});

  @override
  ConsumerState<UpdateUsernameScreen> createState() =>
      _UpdateUsernameScreenState();
}

class _UpdateUsernameScreenState extends ConsumerState<UpdateUsernameScreen> {
  final _formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  String errorMsg = '';

  @override
  void dispose() {
    usernameController.dispose();
    super.dispose();
  }

  Future<void> updateUsername() async {
    final auth = ref.read(authServiceProvider);

    try {
      if (usernameController.text.trim().isEmpty) {
        setState(() {
          errorMsg = "Please enter a username";
        });
        return;
      }

      await auth.updateUsername(username: usernameController.text.trim());

      setState(() {
        errorMsg = '';
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Username updated successfully")),
      );

      Navigator.pop(context); // go back after update
    } catch (e) {
      setState(() {
        errorMsg = "Error: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Update Username")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Update Your Username",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),

              TextFormField(
                controller: usernameController,
                decoration: const InputDecoration(
                  labelText: "Enter new username",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return "Enter username";
                  return null;
                },
              ),
              const SizedBox(height: 10),
              Text(errorMsg, style: const TextStyle(color: Colors.red)),
              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    updateUsername();
                  }
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                ),
                child: const Text("Update"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
