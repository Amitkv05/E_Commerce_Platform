import 'package:e_commerce_vendor_app/controllers/order_controller.dart';
import 'package:e_commerce_vendor_app/models/order_model.dart';
import 'package:e_commerce_vendor_app/provider/order_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OrderDetailScreen extends ConsumerStatefulWidget {
  final Order order;
  OrderDetailScreen({super.key, required this.order});

  @override
  ConsumerState<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends ConsumerState<OrderDetailScreen> {
  final OrderController _orderController = OrderController();

  @override
  Widget build(BuildContext context) {
    // Watch the list of orders to trigger automatic Ui rebuilds...
    final orders = ref.watch(orderProvider);
    // FInd the updated order in the list..
    final updatedOrder = orders.firstWhere((o) => o.id == widget.order.id,
        orElse: () => widget
            .order); // This will return the updated order if it exists in the list, otherwise it will return the original order...
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.order.productName,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
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
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Positioned(
                                    left: 10,
                                    top: 5,
                                    child: Image.network(
                                      widget.order.image,
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
                                            MainAxisAlignment.spaceBetween,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          SizedBox(
                                            width: double.infinity,
                                            child: Text(
                                              widget.order.productName,
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 4),
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              widget.order.category,
                                              style: TextStyle(
                                                color: Color(0xFF7F1808C),
                                                fontWeight: FontWeight.w600,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 2),
                                          Text(
                                            "₹${widget.order.productPrice.toStringAsFixed(2)}",
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF0B0C1E),
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
                                color: updatedOrder.delivered == true
                                    ? Color(0xFF3C55EF)
                                    : widget.order.processing == true
                                        ? Colors.purple
                                        : Colors.red,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Positioned(
                                    left: 9,
                                    top: 3,
                                    child: Text(
                                      updatedOrder.delivered == true
                                          ? "Delivered"
                                          : updatedOrder.processing == true
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
                          Positioned(
                            right: 8,
                            bottom: 5,
                            child: IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.delete,
                                size: 25,
                                color: Colors.red,
                              ),
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

          // Address container..
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Container(
              width: 336,
              height: 170,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: Color(0xFFEFF0F2),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          'Delivery Address',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.7,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "${widget.order.state}, ${widget.order.city}, ${widget.order.locality}",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            letterSpacing: 1.5,
                          ),
                        ),
                        Text(
                          "To : ${widget.order.fullName}",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Order ID : ${widget.order.id}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: updatedOrder.delivered == true
                            ? null
                            : updatedOrder.processing == false
                                ? null
                                : () async {
                                    await _orderController
                                        .updateDeliveryStatus(
                                      id: widget.order.id,
                                      context: context,
                                    )
                                        .whenComplete(() {
                                      ref
                                          .read(orderProvider.notifier)
                                          .updateOrderStatus(
                                            widget.order.id,
                                            delivered: true,
                                          );
                                    });
                                  },
                        child: Text(
                          updatedOrder.delivered == true
                              ? "Delivered"
                              : updatedOrder.processing == false
                                  ? "Order Cancelled"
                                  : "Mark as Delivered?",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: updatedOrder.processing == false
                            ? null
                            : () async {
                                await _orderController
                                    .cancelOrder(
                                  id: widget.order.id,
                                  context: context,
                                )
                                    .whenComplete(() {
                                  ref
                                      .read(orderProvider.notifier)
                                      .updateOrderStatus(
                                        widget.order.id,
                                        processing: false,
                                      );
                                });
                              },
                        child: updatedOrder.processing == false
                            ? SizedBox()
                            : Text(
                                "Cancel Order",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                ),
                              ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
