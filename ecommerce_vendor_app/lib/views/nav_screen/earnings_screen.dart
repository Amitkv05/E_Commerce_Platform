import 'package:e_commerce_vendor_app/controllers/order_controller.dart';
import 'package:e_commerce_vendor_app/provider/order_provider.dart';
import 'package:e_commerce_vendor_app/provider/total_earnings_provider.dart';
import 'package:e_commerce_vendor_app/provider/vendor_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// ✅ Define this globally (outside the widget class)
final ordersFutureProvider = FutureProvider<void>((ref) async {
  final vendor = ref.read(vendorProvider);
  if (vendor == null || vendor.id.isEmpty) return;

  final controller = OrderController();
  final orders = await controller.loadOrders(vendorId: vendor.id);

  ref.read(orderProvider.notifier).setOrders(orders);
  ref.read(totalEarningsProvider.notifier).calculateEarnings(orders);
});

/// ✅ Widget
class EarningsScreen extends ConsumerWidget {
  const EarningsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vendor = ref.watch(vendorProvider);
    final totalEarnings = ref.watch(totalEarningsProvider);
    final ordersFuture = ref.watch(ordersFutureProvider);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.purple,
              child: Text(
                (vendor != null && vendor.fullName.isNotEmpty)
                    ? vendor.fullName[0].toUpperCase()
                    : 'U',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Welcome! ${vendor?.fullName ?? 'Vendor'}',
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),

      /// ✅ Properly handle loading, error, and data states
      body: ordersFuture.when(
        loading: () => const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text(
                "Loading your earnings...",
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
        error: (error, _) => Center(
          child: Text(
            'Failed to load data: $error',
            style: const TextStyle(color: Colors.red),
          ),
        ),
        data: (_) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                elevation: 3,
                margin: const EdgeInsets.all(16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const Text(
                        "Total Orders",
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${totalEarnings['totalOrders']}',
                        style: const TextStyle(
                          fontSize: 36,
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                elevation: 3,
                margin: const EdgeInsets.all(16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const Text(
                        "Total Earnings",
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '₹${totalEarnings['totalEarnings'].toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 36,
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
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
    );
  }
}
