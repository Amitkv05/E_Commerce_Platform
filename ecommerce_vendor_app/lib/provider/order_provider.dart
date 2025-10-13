import 'package:e_commerce_vendor_app/models/order_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OrderProvider extends StateNotifier<List<Order>> {
  OrderProvider() : super([]);

  // sets the list of Orders
  void setOrders(List<Order> orders) {
    state = orders; // This will notify listeners
  }

  void updateOrderStatus(String orderId, {bool? processing, bool? delivered}) {
    // update the state of the provider with a new list of orders
    state = [
      // iterate through the existing orders
      for (final order in state)
        // if the order id matches the id of the order to be updated
        if (order.id == orderId)
          // create new order object with the updated status
          Order(
            id: order.id,
            fullName: order.fullName,
            email: order.email,
            state: order.state,
            city: order.city,
            locality: order.locality,
            productName: order.productName,
            productPrice: order.productPrice,
            quantity: order.quantity,
            category: order.category,
            image: order.image,
            buyerId: order.buyerId,
            vendorId: order.vendorId,
            //  Use the new processing status if provided, otherwise keep the current status
            processing: processing ?? order.processing,
            //  Use the new delivered status if provided, otherwise keep the current status
            delivered: delivered ?? order.delivered,
          )
        // if the current order id does not match t, keep the order unchanged...
        else
          order,
    ];
  }
}

final orderProvider = StateNotifierProvider<OrderProvider, List<Order>>((ref) {
  return OrderProvider();
});
