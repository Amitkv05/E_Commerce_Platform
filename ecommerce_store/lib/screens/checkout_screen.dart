import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:shopgram/provider/auth/auth_service.dart';
import 'package:shopgram/provider/cart_provider.dart';
import 'package:shopgram/provider/order_provider.dart';
import 'package:shopgram/screens/navigation_menu.dart';
import 'package:shopgram/server/manage_http_responses.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  String selectedPaymentMethod = 'stripe';
  bool isLoading = false;

  Future<void> handleStripePayment(BuildContext context) async {
    final orderController = ref.read(orderProvider.notifier);
    // fetch the cart data from riverpod provider
    final cartData = ref.read(cartProvider);
    // fetch the user data from riverpod provider
    final user = ref.read(authServiceProvider).currentUser;
    // check if cart is empty
    if (cartData.isEmpty) {
      showSnackBar(context, 'Your cart is empty');
      return;
    }
    // check if user is null

    if (user == null) {
      showSnackBar(context, 'Please login to checkout');
      return;
    }
    try {
      setState(() {
        isLoading = true;
      });
      // calculate the total amount for all item in cart
      final totalAmount = cartData.values.fold(
        0.0,
        (sum, item) => sum + (item.quantity * item.productPrice),
      );

      // Check if the totalAmount is a valid amount
      if (totalAmount <= 0) {
        showSnackBar(context, 'Invalid total amount');
        return;
      }
      // create a payment intent with the calculated amount and currency
      final paymentIntent = await orderController.createPaymentIntent(
        amount: (totalAmount * 100).toInt(),
        currency: 'usd',
      );

      // initialize the stripe payment sheet with the payment intent details
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntent['client_secret'],
          merchantDisplayName: 'E_commerce Store..',
        ),
      );

      // present the payment sheet to the user
      await Stripe.instance.presentPaymentSheet();

      // step 4: verify payment intent status

      final paymentIntentStatus = await orderController.getPaymentIntentStatus(
        context: context,
        paymentIntentId: paymentIntent['id'],
      );

      // upload each cart item as an order to the server
      if (paymentIntentStatus['status'] == 'succeeded') {
        for (final entry in cartData.entries) {
          final item = entry.value;

          await orderController.uploadOrders(
            id: '',
            fullName: user.displayName ?? '',
            email: user.email ?? '',
            // state: "New Delhi",
            // city: "Delhi",
            // locality: "India",
            state: '',
            city: '',
            locality: '',
            // state: ref.read(userProvider)!.state,
            // city: ref.read(userProvider)!.city,
            // locality: ref.read(userProvider)!.locality,
            productId: item.productId,
            productName: item.productName,
            productPrice: item.productPrice,
            quantity: item.quantity,
            category: item.category,
            image: item.image[0],
            buyerId: user.uid,
            vendorId: item.vendorId,
            // vendorId: "admin",
            processing: true,
            delivered: false,
            context: context,
            paymentStatus: paymentIntentStatus['status'],
            paymentIntentId: paymentIntentStatus['id'],
            paymentMethod: 'card',
          );
        }
      }
    } catch (e) {
      showSnackBar(context, 'Payment Failed: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartData = ref.read(cartProvider);
    final _cartProvider = ref.read(cartProvider.notifier);
    final orderController = ref.read(orderProvider.notifier);
    final user = ref.read(authServiceProvider).currentUser;

    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  // Navigator.of(context).push(
                  //   MaterialPageRoute(builder: (_) => ShippingAddressScreen()),
                  // );
                },
                child: SizedBox(
                  width: 335,
                  height: 74,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Positioned(
                        left: 0,
                        top: 0,
                        child: Container(
                          width: 335,
                          height: 74,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: const Color(0xFFEFF0F2)),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 70,
                        top: 17,
                        child: SizedBox(
                          width: 215,
                          height: 41,
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Positioned(
                                top: -1,
                                left: -1,
                                child: SizedBox(
                                  width: 219,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: SizedBox(
                                          width: 114,
                                          child: Text(
                                            'Add Address',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              height: 1.1,
                                            ),
                                          ),
                                          // child: user!.state.isNotEmpty
                                          //     ? Text(
                                          //         'Address',
                                          //         style: TextStyle(
                                          //           fontSize: 14,
                                          //           fontWeight: FontWeight.bold,
                                          //           height: 1.1,
                                          //         ),
                                          //       )
                                          //     : Text(
                                          //         'Add Address',
                                          //         style: TextStyle(
                                          //           fontSize: 14,
                                          //           fontWeight: FontWeight.bold,
                                          //           height: 1.1,
                                          //         ),
                                          //       ),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          'India',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 1.3,
                                          ),
                                        ),
                                        // child: user.state.isNotEmpty
                                        //     ? Text(
                                        //         user.state,
                                        //         style: TextStyle(
                                        //           fontSize: 14,
                                        //           fontWeight: FontWeight.bold,
                                        //           letterSpacing: 1.3,
                                        //         ),
                                        //       )
                                        //     : Text(
                                        //         'United state',
                                        //         style: TextStyle(
                                        //           fontSize: 14,
                                        //           fontWeight: FontWeight.bold,
                                        //           letterSpacing: 1.3,
                                        //         ),
                                        //       ),
                                      ),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          'Enter city',
                                          style: TextStyle(
                                            color: const Color(0xFF7F808C),
                                            fontWeight: FontWeight.w500,
                                            fontSize: 12,
                                          ),
                                        ),
                                        // child: user.city.isNotEmpty
                                        //     ? Text(
                                        //         user.city,
                                        //         style: TextStyle(
                                        //           color: const Color(
                                        //             0xFF7F808C,
                                        //           ),
                                        //           fontWeight: FontWeight.w500,
                                        //           fontSize: 12,
                                        //         ),
                                        //       )
                                        //     : Text(
                                        //         'Enter city',
                                        //         style: TextStyle(
                                        //           color: const Color(
                                        //             0xFF7F808C,
                                        //           ),
                                        //           fontWeight: FontWeight.w500,
                                        //           fontSize: 12,
                                        //         ),
                                        //       ),
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
                        left: 16,
                        top: 16,
                        child: SizedBox.square(
                          dimension: 42,
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Positioned(
                                left: 0,
                                top: 0,
                                child: Container(
                                  width: 43,
                                  height: 43,
                                  clipBehavior: Clip.hardEdge,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFBF7F5),
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  child: Stack(
                                    clipBehavior: Clip.hardEdge,
                                    children: [
                                      Positioned(
                                        left: 11,
                                        top: 11,
                                        child: Image.network(
                                          height: 26,
                                          width: 26,
                                          'https://storage.googleapis.com/codeless-dev.appspot.com/uploads%2Fimages%2Fnn2Ldqjoc2Xp89Y7Wfzf%2F2ee3a5ce3b02828d0e2806584a6baa88.png',
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
                        left: 305,
                        top: 25,
                        child: Image.network(
                          width: 20,
                          height: 20,
                          'https://firebasestorage.googleapis.com/v0/b/codeless-app.appspot.com/o/projects%2Fnn2Ldqjoc2Xp89Y7Wfzf%2F6ce18a0efc6e889de2f2878027c689c9caa53feeedit%201.png?alt=media&token=a3a8a999-80d5-4a2e-a9b7-a43a7fa8789a',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Your Item',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Flexible(
                child: ListView.builder(
                  itemCount: cartData.length,
                  itemBuilder: (context, index) {
                    final cartItem = cartData.values.toList()[index];
                    return InkWell(
                      onTap: () {},
                      child: Container(
                        width: 336,
                        height: 91,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Color(0xFFEFF0F2)),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Positioned(
                              left: 6,
                              top: 6,
                              child: SizedBox(
                                width: 331,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: 78,
                                      height: 78,
                                      clipBehavior: Clip.hardEdge,
                                      decoration: BoxDecoration(
                                        color: Color(0xFFBCC5FF),
                                      ),
                                      child: Image.network(cartItem.image[0]),
                                    ),
                                    SizedBox(width: 11),
                                    Expanded(
                                      child: Container(
                                        width: 78,
                                        alignment: Alignment(0, -0.51),
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
                                                  cartItem.productName,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    letterSpacing: 1.3,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 4),
                                              Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  cartItem.category,
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 16),
                                    Text(
                                      "₹${cartItem.productPrice.toStringAsFixed(2)}",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.pink,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 10),
              Text(
                "Choose a payment method",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              RadioListTile<String>(
                title: Text(
                  'Stripe',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                value: 'stripe',
                groupValue: selectedPaymentMethod,
                onChanged: (String? value) {
                  setState(() {
                    selectedPaymentMethod = value!;
                  });
                },
              ),
              RadioListTile<String>(
                title: Text(
                  'Cash On Delivery',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                value: 'cashOnDelivery',
                groupValue: selectedPaymentMethod,
                onChanged: (String? value) {
                  setState(() {
                    selectedPaymentMethod = value!;
                  });
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, top: 8, bottom: 20),
        // child: user.state.isEmpty
        //     ? TextButton(
        //         onPressed: () {
        //           // Navigator.of(context).push(
        //           //   MaterialPageRoute(builder: (_) => ShippingAddressScreen()),
        //           // );
        //         },
        //         child: Text("Please Enter Shipping Address"),
        //       )
        child: InkWell(
          onTap: () async {
            if (selectedPaymentMethod == 'stripe') {
              // pay with stripe to place the order
              handleStripePayment(context);
            } else {
              await Future.forEach(_cartProvider.getCartItems.entries, (entry) {
                var item = entry.value;
                // Add the order to the order provider
                orderController.uploadOrders(
                  id: '',
                  fullName: user!.displayName ?? '',
                  email: user.email ?? '',

                  state: "New Delhi",
                  city: "Delhi",
                  locality: "India",
                  // state: ref.read(userProvider)!.state,
                  // city: ref.read(userProvider)!.city,
                  // locality: ref.read(userProvider)!.locality,
                  productId: item.productId,
                  productName: item.productName,
                  productPrice: item.productPrice,
                  quantity: item.quantity,
                  category: item.category,
                  image: item.image[0],
                  buyerId: user.uid,
                  vendorId: item.vendorId,
                  // vendorId: "admin",
                  processing: true,
                  delivered: false,
                  context: context,
                  paymentStatus: "pending",
                  paymentIntentId: 'cod',
                  paymentMethod: 'cod',
                );
              }).then((value) {
                // Clear the cart after placing the order
                _cartProvider.clearCart();
                showSnackBar(context, "Order Placed Successfully");
                Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (_) => NavigationMenu()));
              });
            }
          },
          child: Container(
            width: 338,
            height: 58,
            decoration: BoxDecoration(
              color: Color(0xFF3854EE),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Center(
              child: isLoading
                  ? Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    )
                  : Text(
                      selectedPaymentMethod == 'stripe'
                          ? "Pay Now"
                          : "Place Order",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
