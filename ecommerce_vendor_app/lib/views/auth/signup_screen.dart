import 'package:e_commerce_vendor_app/controllers/vendor_auth_controllers.dart';
import 'package:e_commerce_vendor_app/views/auth/login_screen.dart';
import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TColors = Colors.red;
  bool remember = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final VendorAuthControllers _vendorAuthControllers = VendorAuthControllers();

  late String email;
  late String fullName;
  bool isLoading = false;
  late String password;

  signUpUser() async {
    setState(() {
      isLoading = true;
    });
    await _vendorAuthControllers
        .signUpVendor(
            context: context,
            fullName: fullName,
            email: email,
            password: password)
        .whenComplete(() {
      //reset the fields after submission(email,password)
      // _formKey.currentState!.reset();
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // final String hintText;

    double myHeight = MediaQuery.of(context).size.height;
    // double myWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding:
              EdgeInsets.symmetric(vertical: myHeight * 0.018, horizontal: 22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: "Create Your\n",
                      style: TextStyle(
                        fontSize: myHeight * 0.05,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: "Account",
                      style: TextStyle(
                        fontSize: myHeight * 0.05,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue, // Replace with your desired color
                      ),
                    ),
                  ],
                ),
              ),
              // Form..
              Form(
                key: _formKey,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: myHeight * 0.01),
                  child: Column(
                    children: [
                      // Name...
                      // CustomTextField(
                      //     controller: _nameController,
                      //     hintText: "Name",
                      //     icon: Icons.person),
                      TextFormField(
                        onChanged: (value) => fullName = value,
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                              borderSide: BorderSide(
                                  color: Colors
                                      .blue), // Replace with your desired color
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                              borderSide: BorderSide(color: TColors),
                            ),
                            labelText: "Name",
                            prefixIcon: Icon(
                              Icons.person,
                              color: TColors,
                            )),
                      ),
                      SizedBox(
                        height: myHeight * 0.015,
                      ),
                      // Email...
                      // CustomTextField(
                      //     controller: _emailController,
                      //     hintText: "Email",
                      //     icon: Icons.email_outlined),
                      TextFormField(
                        onChanged: (value) => email = value,
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                              borderSide: BorderSide(color: TColors),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                              borderSide: BorderSide(color: TColors),
                            ),
                            labelText: "Email",
                            prefixIcon: Icon(
                              Icons.email_outlined,
                              color: TColors,
                            )),
                      ),
                      SizedBox(
                        height: myHeight * 0.015,
                      ),
                      TextFormField(
                        onChanged: (value) => password = value,
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                              borderSide: BorderSide(color: TColors),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                              borderSide: BorderSide(color: TColors),
                            ),
                            labelText: "Password",
                            prefixIcon: Icon(
                              Icons.password_rounded,
                              color: TColors,
                            )),
                      ),
                      // CustomTextField(
                      //     controller: _passwordController,
                      //     hintText: "Password",
                      //     icon: Icons.password_rounded),
                      //
                      SizedBox(
                        height: myHeight * 0.01,
                      ),

                      // Remember Me & Forget Password...
                      Row(
                        children: [
                          Checkbox(
                            value: remember,
                            activeColor: TColors,
                            onChanged: (bool? value) {
                              setState(() {
                                remember = value!;
                              });
                            },
                          ),
                          const Text('Remember',
                              style: TextStyle(fontSize: 16)),
                        ],
                      ),
                      SizedBox(
                        height: myHeight * 0.01,
                      ),

                      // Sign In Button...
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              signUpUser();
                            }
                          },
                          child: isLoading
                              ? CircularProgressIndicator()
                              : const Text("Sign Up"),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Divider
              Row(
                children: [
                  Flexible(
                    child: Divider(
                      color: Colors.grey,
                      thickness: 0.5,
                      indent: 60,
                      endIndent: 5,
                    ),
                  ),
                  Text('or continue with',
                      style: Theme.of(context).textTheme.labelMedium),
                  Flexible(
                    child: Divider(
                      color: Colors.grey,
                      thickness: 0.5,
                      indent: 5,
                      endIndent: 60,
                    ),
                  ),
                ],
              ),
              SizedBox(height: myHeight * 0.1),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Already have an account?',
                      style: Theme.of(context).textTheme.labelMedium),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => LoginScreen()));
                    },
                    child: Text(' Sign in',
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: Colors
                                .blue)), // Replace with your desired color
                  ),
                ],
              ),
            ],
          ),
        ),

        // form..
      ),
    );
  }
}
