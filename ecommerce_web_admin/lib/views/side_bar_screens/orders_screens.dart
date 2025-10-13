import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_admin_for_fullstack/views/side_bar_screens/widget/order_widget.dart';

class OrdersScreens extends ConsumerStatefulWidget {
  static const String id = "orders-screens";
  const OrdersScreens({super.key});

  @override
  ConsumerState<OrdersScreens> createState() => _OrdersScreensState();
}

class _OrdersScreensState extends ConsumerState<OrdersScreens> {
  @override
  Widget build(BuildContext context) {
    Widget rowHeader(int flex, String text) {
      return Expanded(
        flex: flex,
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade700),
            color: Color(0xFF3c55EF),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              text,
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      );
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              alignment: Alignment.topLeft,
              child: Text(
                "Manage Orders",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                rowHeader(2, "Product Image"),
                rowHeader(3, "Product Name"),
                rowHeader(2, "Product Price"),
                rowHeader(2, "Product Category"),
                rowHeader(3, "Buyer Name"),
                rowHeader(2, "Buyer Email"),
                rowHeader(2, "Buyer Address"),
                rowHeader(1, "Delete"),
              ],
            ),
            OrderWidget(),
          ],
        ),
      ),
    );
  }
}
