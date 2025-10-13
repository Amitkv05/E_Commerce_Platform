// A Class that extends StateNotifier to manage the state of total earnings

import 'package:e_commerce_vendor_app/models/order_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TotalEarningsNotifier extends StateNotifier<Map<String, dynamic>> {
  // constructor to initializes the state with 0.0(starting total earnings...)
  TotalEarningsNotifier() : super({'totalEarnings': 0.0, "totalOrders": 0});

  // Method to calculate the total earnings base on the delivered status

  void calculateEarnings(List<Order> orders) {
    // initialize a local variable to accumulate earnings
    double earnings = 0.0;
    int orderCount = 0;

    // loop through each orders in the list of orders
    for (Order order in orders) {
      // check if the orders has been delivered
      if (order.delivered) {
        orderCount++;
        earnings += order.productPrice * order.quantity;
      }
    }
    // update the state with the calculated earnings, which will notifier listeners of this state..
    state = {
      'totalEarnings': earnings,
      'totalOrders': orderCount,
    };
  }
}

final totalEarningsProvider =
    StateNotifierProvider<TotalEarningsNotifier, Map<String, dynamic>>((ref) {
  return TotalEarningsNotifier();
});
