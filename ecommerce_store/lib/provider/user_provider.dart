// import 'package:flutter_riverpod/legacy.dart';
// import 'package:shopgram/models/user.dart';

// class UserProvider extends StateNotifier<User?> {
//   // contructore initializing with default User object
//   // purpose: Manage the state of the User object allowing updates...
//   UserProvider()
//       : super(
//           User(
//             id: '',
//             fullName: '',
//             email: '',
//             state: '',
//             city: '',
//             locality: '',
//             password: '',
//             token: '',
//           ),
//         );
//   // Getter method to extract value from an object
//   User? get user => state;
//   // method to set user state from json
//   // purpose: udates he user sate base on json String respresentation of user Objext

//   void setUser(String userJson) {
//     state = User.fromJson(userJson);
//   }

//   // Method to clear user state
//   void signOut() {
//     state = null;
//   }

//   // Method to Recreate the user state
//   void recreateUserState({
//     required String state,
//     required String city,
//     required String locality,
//   }) {
//     if (this.state != null) {
//       this.state = User(
//           id: this.state!.id,
//           fullName: this.state!.fullName,
//           email: this.state!.email,
//           state: state,
//           city: city,
//           locality: locality,
//           password: this.state!.password,
//           token: this.state!.token);
//     }
//   }
// }

// // make the data accisible within the application
// final userProvider =
//     StateNotifierProvider<UserProvider, User?>((ref) => UserProvider());
