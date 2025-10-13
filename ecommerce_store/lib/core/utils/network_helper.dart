// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'dart:io';

// class NetworkHelper {
//   static Future<bool> get isConnected async {
//     try {
//       final connectivityResult = await Connectivity().checkConnectivity();
//       if (connectivityResult == ConnectivityResult.none) {
//         return false;
//       }
      
//       final socket = await Socket.connect('8.8.8.8', 53);
//       socket.destroy();
//       return true;
//     } catch (e) {
//       return false;
//     }
//   }
  
//   static String get connectionErrorMessage {
//     return 'No internet connection. Please check your connection and try again.';
//   }
// }