// // StateNotifier for delivered order count

// import 'package:flutter_riverpod/legacy.dart';
// import 'package:shopgram/provider/order_controller.dart';
// import 'package:shopgram/server/manage_http_responses.dart';

// class DeliveredOrderCountProvider extends StateNotifier<int> {
//   DeliveredOrderCountProvider() : super(0);

//   // Method to fetch Delivered Orders count
//   Future<void> fetchDeliveredOrderCount(String buyerId, context) async {
//     try {
//       OrderController orderController = OrderController();
//       int count = await orderController.getDeliveredOrderCount(
//           buyerId: buyerId, context: context);
//       state = count;
//     } catch (e) {
//       showSnackBar(context, "Error Fetching Delivered Order: $e");
//     }
//   }

//   // method to reset the count
//   void resetCount() {
//     state = 0;
//   }
// }

// final deliveredOrderCountProvider =
//     StateNotifierProvider<DeliveredOrderCountProvider, int>((ref) {
//   return DeliveredOrderCountProvider();
// });
