import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_admin_for_fullstack/models/order.dart';

class OrderProvider extends StateNotifier<List<Order>> {
  OrderProvider() : super([]);

  // sets the list of Orders
  void setOrders(List<Order> orders) {
    state = orders; // This will notify listeners
  }

  void addOrder(Order order) {
    state = [...state, order]; // This will notify listeners
  }

//   void removeOrder(String orderId) {
//     state = state
//         .where((order) => order.id != orderId)
//         .toList(); // This will notify listeners
//   }
}

final orderProvider = StateNotifierProvider<OrderProvider, List<Order>>((ref) {
  return OrderProvider();
});
