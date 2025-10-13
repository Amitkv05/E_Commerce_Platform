import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:shopgram/core/theme/app_colors.dart';
import 'package:shopgram/models/cart_model.dart';
import 'package:shopgram/provider/cart_provider.dart';
import 'package:shopgram/screens/checkout_screen.dart';

class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  @override
  Widget build(BuildContext context) {
    final cartMap = ref.watch(cartProvider);
    final _cartItems = cartMap.values.toList();
    final _cartProvider = ref.read(cartProvider.notifier);
    final totalAmount = ref.read(cartProvider.notifier).calculateTotalAmount();
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: _buildAppBar(),
      body: Column(
        children: [
          (_cartItems.isEmpty)
              ? Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.search_off_rounded,
                          size: 60,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No Items in Cart',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          padding: const EdgeInsets.all(16.0),
                          itemCount: _cartItems.length,
                          itemBuilder: (context, index) {
                            final item = _cartItems[index];
                            return _buildCartItem(item, index, _cartProvider);
                          },
                        ),
                        // _buildPromoCodeField(),
                        if (_cartItems.isNotEmpty)
                          _buildSummarySection(_cartProvider, totalAmount),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
          if (_cartItems.isNotEmpty)
            _buildBuySection(_cartProvider, totalAmount),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.primary,
      elevation: 0,
      centerTitle: true,
      // leading: Padding(
      //   padding: const EdgeInsets.all(8.0),
      //   child: CircleAvatar(
      //     backgroundColor: Colors.white,
      //     child: IconButton(
      //       icon: const Icon(Icons.arrow_back, color: Colors.black),
      //       onPressed: () => Navigator.of(context).pop(),
      //     ),
      //   ),
      // ),
      title: const Text(
        'Cart',
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: CircleAvatar(
            backgroundColor: Colors.black,
            child: IconButton(
              icon: const Icon(
                Icons.shopping_bag_outlined,
                color: Colors.white,
              ),
              onPressed: () {},
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCartItem(Cart item, int index, CartNotifier _cartProvider) {
    return Slidable(
      key: ValueKey(item.productName + index.toString()),
      endActionPane: ActionPane(
        motion: const StretchMotion(),
        children: [
          SlidableAction(
            onPressed: (context) =>
                _cartProvider.removeCartItem(item.productId),
            backgroundColor: const Color(0xFFFE4A49),
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
            borderRadius: BorderRadius.circular(12),
          ),
        ],
      ),
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              // Image
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  item.image[0],
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 16),
              // Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 200,
                          child: Text(
                            item.productName,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        // Text(
                        //   'Size: ${item.}',
                        //   style: TextStyle(color: Colors.grey[600]),
                        // ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '\$${item.productPrice.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        _buildQuantityControl(index, _cartProvider, item),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuantityControl(
    int index,
    CartNotifier _cartProvider,
    Cart _cartItems,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.remove, size: 16),
            onPressed: () =>
                _cartProvider.decrementCartItem(_cartItems.productId),
            splashRadius: 20,
            constraints: const BoxConstraints(),
          ),
          Text(
            _cartItems.quantity.toString(),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          IconButton(
            icon: const Icon(Icons.add, size: 16, color: Colors.white),
            onPressed: () =>
                _cartProvider.incrementCartItem(_cartItems.productId),
            style: IconButton.styleFrom(
              backgroundColor: Colors.black,
              shape: const CircleBorder(),
            ),
            splashRadius: 20,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  Widget _buildSummarySection(CartNotifier _cartProvider, double totalAmount) {
    final double taxAmount = 10.00;
    final double grandTotal = totalAmount + taxAmount;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // _buildPromoCodeField(),
          // const SizedBox(height: 10),
          _buildSummaryRow('Order Amount', totalAmount),
          const SizedBox(height: 4),
          _buildSubSummaryRow('Tax', taxAmount),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 2.0),
            child: Divider(
              // In a real app, you might use a custom painter or a package for the dashed line
              thickness: 1,
              color: Colors.black12,
            ),
          ),
          _buildSummaryRow(
            'Total Payment',
            grandTotal,
            // '\$${totalAmount.toStringAsFixed(2)}',
            itemCount: _cartProvider.getTotalItems(),
          ),
        ],
      ),
    );
  }

  Widget _buildBuySection(CartNotifier _cartProvider, double totalAmount) {
    final double taxAmount = 10.00;
    final double grandTotal = totalAmount + taxAmount;
    final isTotal = totalAmount != 0 ? true : false;
    return Container(
      margin: EdgeInsets.only(bottom: 50),
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 15,
            offset: Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        // mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Total Payment',
                style: TextStyle(
                  color: isTotal ? Colors.black : Colors.grey[600],
                  fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
                  fontSize: isTotal ? 17 : 15,
                ),
              ),
              Text(
                '\$${grandTotal.toStringAsFixed(2)}',
                style: TextStyle(
                  color: isTotal ? Colors.black : Colors.grey[600],
                  fontWeight: FontWeight.bold,
                  fontSize: isTotal ? 20 : 18,
                ),
              ),
            ],
          ),
          // const SizedBox(height: 24),
          SizedBox(
            width: 100,
            child: ElevatedButton(
              onPressed: totalAmount == 0.0
                  ? null
                  : () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => CheckoutScreen()),
                      );
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black87,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                'Place Order',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPromoCodeField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          const Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Promo Code',
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(left: 20),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black87,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
            ),
            child: const Text('Apply', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String title, double amount, {int? itemCount}) {
    final isTotal = amount != 0 ? true : false;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(
              title,
              style: TextStyle(
                color: isTotal ? Colors.black : Colors.grey[600],
                fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
                fontSize: isTotal ? 18 : 16,
              ),
            ),
            if (itemCount != null)
              Text(
                '  ($itemCount Items)',
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
          ],
        ),
        Text(
          '\$${amount.toStringAsFixed(2)}',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: isTotal ? 22 : 18,
          ),
        ),
      ],
    );
  }

  Widget _buildSubSummaryRow(String title, double amount, {int? itemCount}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(
              title,
              style: TextStyle(
                color: Colors.grey[600],
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            if (itemCount != null)
              Text(
                '  ($itemCount Items)',
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
          ],
        ),
        Text(
          '+ \$${amount.toStringAsFixed(2)}',
          style: TextStyle(
            color: Colors.grey[600],
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}
