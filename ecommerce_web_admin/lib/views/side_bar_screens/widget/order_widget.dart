import 'package:flutter/material.dart';
import 'package:web_admin_for_fullstack/controllers/buyer_controller.dart';
import 'package:web_admin_for_fullstack/controllers/order_controller.dart';
import 'package:web_admin_for_fullstack/models/buyer.dart';
import 'package:web_admin_for_fullstack/models/order.dart';

class OrderWidget extends StatefulWidget {
  const OrderWidget({super.key});

  @override
  State<OrderWidget> createState() => _OrderWidgetState();
}

class _OrderWidgetState extends State<OrderWidget> {
  // A Future that will hold the list of orders once loaded from the API
  late Future<List<Order>> futureOrders;
  @override
  void initState() {
    //
    super.initState();
    futureOrders = OrderController().loadOrders();
  }

  @override
  Widget build(BuildContext context) {
    Widget orderData(int flex, Widget widget) {
      return Expanded(
        flex: flex,
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade700),
            // color: Color(0xFF3c55EF),
          ),
          child: Padding(padding: const EdgeInsets.all(8.0), child: widget),
        ),
      );
    }

    return FutureBuilder(
        future: futureOrders,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error loading banners: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text("No Banners"),
            );
          } else {
            final orders = snapshot.data!;
            return Container(
              height: MediaQuery.of(context).size.height * 0.54,
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    final order = orders[index];
                    return Row(
                      children: [
                        orderData(
                          2,
                          Image.network(
                            order.image,
                            width: 50,
                            height: 50,
                          ),
                        ),
                        orderData(
                          3,
                          Text(
                            order.productName,
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        orderData(
                          2,
                          Text(
                            "₹${order.productPrice.toStringAsFixed(2)}",
                            style: TextStyle(
                              fontSize: 17,
                              color: Colors.purple,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        orderData(
                          2,
                          Text(
                            order.category,
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        orderData(
                          3,
                          Text(
                            order.fullName,
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        orderData(
                          2,
                          Text(
                            order.email,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        orderData(
                          2,
                          Text(
                            order.locality,
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        orderData(
                          1,
                          Text(
                            order.delivered == true
                                ? "Delivered"
                                : order.processing == true
                                    ? "Processing"
                                    : "Canceled",
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
            );
          }
        });
  }
}
