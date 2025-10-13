import 'package:e_commerce_vendor_app/controllers/order_controller.dart';
import 'package:e_commerce_vendor_app/provider/order_provider.dart';
import 'package:e_commerce_vendor_app/provider/total_earnings_provider.dart';
import 'package:e_commerce_vendor_app/provider/vendor_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EarningsScreen extends ConsumerStatefulWidget {
  const EarningsScreen({super.key});

  @override
  ConsumerState<EarningsScreen> createState() => _EarningsScreenState();
}

class _EarningsScreenState extends ConsumerState<EarningsScreen> {
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
          ref.read(totalEarningsProvider.notifier).calculateEarnings(orders);
        });
      } catch (e) {
        print("Error fetching order: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final vendor = ref.watch(vendorProvider);
    final totalEarnings = ref.watch(totalEarningsProvider);
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.purple,
              child: Text(
                vendor!.fullName.isNotEmpty
                    ? vendor.fullName[0].toUpperCase()
                    : 'U',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(width: 10),
            SizedBox(
              width: 200,
              child: Text(
                'Welcome! ${vendor.fullName}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Text(
              "Total Orders",
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 8),
            Text(
              '${totalEarnings['totalOrders']}',
              style: TextStyle(
                fontSize: 36,
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Text(
              "Total Earnings",
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 8),
            Text(
              '₹${totalEarnings['totalEarnings'].toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 36,
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
