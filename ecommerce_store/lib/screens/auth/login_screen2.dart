// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:shopgram/provider/auth/auth_provider.dart';
// import 'package:shopgram/screens/auth/google_login_screen.dart';
// import 'package:shopgram/screens/auth/signup_screen.dart';

// class LoginScreen extends ConsumerStatefulWidget {
//   const LoginScreen({super.key});

//   @override
//   ConsumerState<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends ConsumerState<LoginScreen> {
//   bool remember = false;
//   final GlobalKey<FormState> _signInFormKey = GlobalKey<FormState>();
//   final AuthController _authController = AuthController();

//   late String email;
//   late String password;
//   bool isLoading = false;

//   loginUser() async {
//     setState(() {
//       isLoading = true;
//     });
//     await _authController
//         .signInUsers(
//           context: context,
//           email: email,
//           password: password,
//           ref: ref,
//         )
//         .whenComplete(() {
//           _signInFormKey.currentState!
//               .reset(); //reset the form after submission
//           setState(() {
//             isLoading = false;
//           });
//         });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 12),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text.rich(
//                 TextSpan(
//                   text: "Account",
//                   style: TextStyle(
//                     fontSize: 26,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.red,
//                   ),
//                 ),
//               ),

//               Text.rich(
//                 TextSpan(
//                   children: [
//                     TextSpan(
//                       text: "Login to your\n",
//                       style: TextStyle(
//                         fontSize: 36,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     TextSpan(
//                       text: "Account",
//                       style: TextStyle(
//                         fontSize: 36,
//                         fontWeight: FontWeight.bold,
//                         // color: TColors.primary,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               // Form..
//               Form(
//                 key: _signInFormKey,
//                 child: Padding(
//                   padding: EdgeInsets.symmetric(vertical: 22),
//                   child: Column(
//                     children: [
//                       // Email...
//                       Container(
//                         child: TextFormField(
//                           onChanged: (value) => email = value,
//                           decoration: InputDecoration(
//                             contentPadding: EdgeInsets.symmetric(vertical: 13),
//                             enabledBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(18),
//                               borderSide: BorderSide(color: Colors.red),
//                             ),
//                             focusedBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(18),
//                               borderSide: BorderSide(color: Colors.redAccent),
//                             ),
//                             labelText: "Email",
//                             prefixIcon: Icon(
//                               Icons.email_outlined,
//                               color: Colors.red,
//                             ),
//                           ),
//                         ),
//                       ),
//                       SizedBox(height: 12),
//                       TextFormField(
//                         onChanged: (value) => password = value,
//                         obscureText: true,
//                         decoration: InputDecoration(
//                           contentPadding: EdgeInsets.symmetric(vertical: 13),
//                           enabledBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(18),
//                             borderSide: BorderSide(color: Colors.red),
//                           ),
//                           focusedBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(18),
//                             borderSide: BorderSide(color: Colors.red),
//                           ),
//                           labelText: "Password",
//                           prefixIcon: Icon(
//                             Icons.password_rounded,
//                             color: Colors.red,
//                           ),
//                           suffixIcon: IconButton(
//                             onPressed: () {},
//                             icon: const Icon(Icons.remove_red_eye_sharp),
//                             color: Colors.red,
//                           ),
//                         ),
//                       ),
//                       SizedBox(height: 2),

//                       // Remember Me & Forget Password...
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Row(
//                             children: [
//                               Checkbox(
//                                 value: remember,
//                                 activeColor: Colors.red,
//                                 onChanged: (bool? value) {
//                                   setState(() {
//                                     remember = value!;
//                                   });
//                                 },
//                               ),
//                               const Text(
//                                 'Remember',
//                                 style: TextStyle(fontSize: 16),
//                               ),
//                             ],
//                           ),
//                           TextButton(
//                             onPressed: () {
//                               // Navigator.of(context).push(
//                               //   MaterialPageRoute(
//                               //     builder: (_) =>
//                               //         const ForgotPasswordScreen(),
//                               //   ),
//                               // );
//                             },
//                             child: Text(
//                               'Forget Password?',
//                               style: TextStyle(
//                                 fontSize: 12,
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.red,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       SizedBox(height: 2),

//                       // Sign In Button...
//                       SizedBox(
//                         // height: myHeight * 0.088,
//                         width: double.infinity,
//                         child: ElevatedButton(
//                           onPressed: () async {
//                             if (_signInFormKey.currentState!.validate()) {
//                               loginUser();
//                             } else {
//                             }
//                           },
//                           child: isLoading
//                               ? const CircularProgressIndicator()
//                               : const Text("Sign In"),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               // Divider
//               Row(
//                 children: [
//                   Flexible(
//                     child: Divider(
//                       color: Colors.grey,
//                       thickness: 0.5,
//                       indent: 60,
//                       endIndent: 5,
//                     ),
//                   ),
//                   Text(
//                     'or continue with',
//                     style: Theme.of(context).textTheme.labelMedium,
//                   ),
//                   Flexible(
//                     child: Divider(
//                       color: Colors.grey,
//                       thickness: 0.5,
//                       indent: 5,
//                       endIndent: 60,
//                     ),
//                   ),
//                 ],
//               ),

//               GoogleLoginWidget(),

//               // Footer
//               // Row(
//               //   mainAxisAlignment: MainAxisAlignment.center,
//               //   children: [
//               //     Container(
//               //       decoration: BoxDecoration(
//               //           border: Border.all(color: Colors.red),
//               //           borderRadius: BorderRadius.circular(100)),
//               //       child: IconButton(
//               //         onPressed: () {},
//               //         icon: Image(
//               //           width: 6,
//               //           image: const AssetImage('assets/icons/auth/google.png'),
//               //         ),
//               //       ),
//               //     ),
//               //     SizedBox(width: 3),
//               //     Container(
//               //       decoration: BoxDecoration(
//               //           border: Border.all(color: Colors.red),
//               //           borderRadius: BorderRadius.circular(100)),
//               //       child: IconButton(
//               //         onPressed: () {},
//               //         icon: Image(
//               //           width: 3,
//               //           image:
//               //               const AssetImage('assets/icons/auth/facebook.png'),
//               //         ),
//               //       ),
//               //     ),
//               //     SizedBox(width: 3),
//               //     Container(
//               //       decoration: BoxDecoration(
//               //           border: Border.all(color: Colors.red),
//               //           borderRadius: BorderRadius.circular(100)),
//               //       child: IconButton(
//               //         onPressed: () {},
//               //         icon: Image(
//               //           width: 6,
//               //           // height: myHeight * 0.01,
//               //           image: const AssetImage('assets/icons/auth/apple.png'),
//               //         ),
//               //       ),
//               //     ),
//               //   ],
//               // ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     "Don't have an account?",
//                     style: Theme.of(context).textTheme.labelMedium,
//                   ),
//                   GestureDetector(
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (_) => const SignupScreen()),
//                       );
//                     },
//                     child: Text(
//                       ' Sign up',
//                       style: Theme.of(
//                         context,
//                       ).textTheme.bodyLarge!.copyWith(color: Colors.red),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),

//         // form..
//       ),
//     );
//   }
// }
