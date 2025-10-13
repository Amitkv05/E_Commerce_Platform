import 'package:e_commerce_vendor_app/controllers/order_controller.dart';
import 'package:e_commerce_vendor_app/models/order_model.dart';
import 'package:e_commerce_vendor_app/provider/order_provider.dart';
import 'package:e_commerce_vendor_app/provider/vendor_provider.dart';
import 'package:e_commerce_vendor_app/views/nav_screen/order_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OrdersScreens extends ConsumerStatefulWidget {
  static const String id = "orders-screens";
  const OrdersScreens({super.key});

  @override
  ConsumerState<OrdersScreens> createState() => _OrdersScreensState();
}

class _OrdersScreensState extends ConsumerState<OrdersScreens> {
  @override
  void initState() {
    super.initState();
    _fetchOrders();
  }

  Future<void> _fetchOrders() async {
    final vendor = ref.read(vendorProvider);
    if (vendor != null) {
      final OrderController orderController = OrderController();
      try {
        setState(() async {
          final orders = await orderController.loadOrders(vendorId: vendor.id);
          ref.read(orderProvider.notifier).setOrders(orders);
        });
      } catch (e) {
        print("Error fetching order: $e");
      }
    }
  }

  Future<void> _deleteOrder(String orderId) async {
    final OrderController orderController = OrderController();
    try {
      await orderController.deleteOrder(id: orderId, context: context);
      // Fetch orders again after deletion
      await _fetchOrders();
    } catch (e) {
      print("Error deleting order: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final orders = ref.watch(orderProvider);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(MediaQuery.of(context).size.height * 0.20),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 110,
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(color: Colors.blue),
          child: Stack(
            children: [
              Positioned(
                // left: 322,
                right: 40,
                top: 55,
                child: Stack(
                  children: [
                    Icon(
                      Icons.message,
                      size: 28,
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        width: 18,
                        height: 18,
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.yellow.shade800,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                            child: Text(
                          orders.length.toString(),
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 8,
                          ),
                        )),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                left: 30,
                top: 55,
                child: Text("My Orders",
                    style: TextStyle(
                      fontSize: 25,
                      letterSpacing: 1,
                      fontWeight: FontWeight.bold,
                    )),
              )
            ],
          ),
        ),
      ),
      body: orders.isEmpty
          ? Center(
              child: Text("No Order Found"),
            )
          : ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final Order order = orders[index];
                return Padding(
                  padding: const EdgeInsets.all(25),
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => OrderDetailScreen(order: order),
                        ),
                      );
                    },
                    child: Container(
                      width: 335,
                      height: 153,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(),
                      child: SizedBox(
                        width: double.infinity,
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Positioned(
                              left: 0,
                              top: 0,
                              child: Container(
                                width: 336,
                                height: 154,
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                    color: Color(0xFFEFF0F2),
                                  ),
                                  borderRadius: BorderRadius.circular(9),
                                ),
                                child: Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    Positioned(
                                      left: 13,
                                      top: 9,
                                      child: Container(
                                        width: 78,
                                        height: 78,
                                        clipBehavior: Clip.antiAlias,
                                        decoration: BoxDecoration(
                                          color: Color(0xFFBCC5FF),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Stack(
                                          clipBehavior: Clip.none,
                                          children: [
                                            Positioned(
                                              left: 10,
                                              top: 5,
                                              child: Image.network(
                                                order.image,
                                                width: 58,
                                                height: 67,
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      left: 101,
                                      top: 14,
                                      child: SizedBox(
                                        width: 216,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: SizedBox(
                                                width: double.infinity,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    SizedBox(
                                                      width: double.infinity,
                                                      child: Text(
                                                        order.productName,
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(height: 4),
                                                    Align(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: Text(
                                                        order.category,
                                                        style: TextStyle(
                                                          color: Color(
                                                              0xFF7F1808C),
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(height: 2),
                                                    Text(
                                                      "₹${order.productPrice.toStringAsFixed(2)}",
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color:
                                                            Color(0xFF0B0C1E),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      left: 12,
                                      top: 113,
                                      child: Container(
                                        width: 90,
                                        height: 25,
                                        clipBehavior: Clip.antiAlias,
                                        decoration: BoxDecoration(
                                          color: order.delivered == true
                                              ? Color(0xFF3C55EF)
                                              : order.processing == true
                                                  ? Colors.purple
                                                  : Colors.red,
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                        child: Stack(
                                          clipBehavior: Clip.none,
                                          children: [
                                            Positioned(
                                              left: 9,
                                              top: 3,
                                              child: Text(
                                                order.delivered == true
                                                    ? "Delivered"
                                                    : order.processing == true
                                                        ? "Processing"
                                                        : "Cancelled",
                                                style: TextStyle(
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.bold,
                                                  letterSpacing: 1.7,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    order.delivered == true
                                        ? Positioned(
                                            right: 8,
                                            bottom: 5,
                                            child: IconButton(
                                              onPressed: () {
                                                _deleteOrder(order.id);
                                              },
                                              icon: Icon(
                                                Icons.delete,
                                                size: 25,
                                                color: Colors.red,
                                              ),
                                            ),
                                          )
                                        : order.processing == true
                                            ? Positioned(
                                                right: 8,
                                                bottom: 5,
                                                child: TextButton(
                                                  onPressed: () {},
                                                  child: Text(
                                                    "New Order",
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.green,
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : SizedBox(),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
