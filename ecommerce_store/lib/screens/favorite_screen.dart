import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:shopgram/core/theme/app_colors.dart';
import 'package:shopgram/provider/cart_provider.dart';
import 'package:shopgram/provider/favorite_provider.dart';
import 'package:shopgram/server/manage_http_responses.dart';

class FavoriteScreen extends ConsumerStatefulWidget {
  const FavoriteScreen({super.key});

  @override
  ConsumerState<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends ConsumerState<FavoriteScreen> {
  @override
  Widget build(BuildContext context) {
    final wishItemsData = ref.watch(FavoriteProvider);
    final wishListProvider = ref.read(FavoriteProvider.notifier);
    final width = MediaQuery.of(context).size.width;
    final cartProviderData = ref.read(cartProvider.notifier);
    final cartData = ref.watch(cartProvider);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.primary,
        centerTitle: true,
        title: const Text(
          "Favorites",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
            fontSize: 22,
          ),
        ),
        actions: [
          Stack(
            children: [
              const Padding(
                padding: EdgeInsets.only(right: 16),
                child: Icon(Icons.favorite, color: Colors.white, size: 28),
              ),
              if (wishItemsData.isNotEmpty)
                Positioned(
                  right: 10,
                  top: 10,
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: Colors.yellow.shade800,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        wishItemsData.length.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),

      body: wishItemsData.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      CupertinoIcons.heart_slash,
                      size: 90,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "No items in your favorites",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Start adding products you love!",
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header bar
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      "You have ${wishItemsData.length} item${wishItemsData.length > 1 ? 's' : ''} in your favorites",
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Improved ListView.builder layout
                  ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: wishItemsData.length,
                    itemBuilder: (context, index) {
                      final favoriteItem = wishItemsData.values.toList()[index];
                      final isInCart = cartData.containsKey(
                        favoriteItem.productId,
                      );

                      return Slidable(
                        key: ValueKey(
                          favoriteItem.productName + index.toString(),
                        ),
                        endActionPane: ActionPane(
                          motion: const StretchMotion(),
                          children: [
                            SlidableAction(
                              onPressed: (context) => wishListProvider
                                  .removeFavoriteItem(favoriteItem.productId),
                              backgroundColor: const Color(0xFFFE4A49),
                              foregroundColor: Colors.white,
                              icon: Icons.delete,
                              label: 'Delete',
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ],
                        ),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Product image
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  favoriteItem.image[0],
                                  height: width * 0.25,
                                  width: width * 0.25,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Container(
                                        height: width * 0.25,
                                        width: width * 0.25,
                                        color: Colors.grey[300],
                                        child: const Icon(
                                          Icons.image_not_supported,
                                        ),
                                      ),
                                ),
                              ),
                              const SizedBox(width: 12),

                              // Product Info
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      favoriteItem.productName,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      favoriteItem.category,
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                        fontSize: 13,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      "₹${favoriteItem.productPrice.toStringAsFixed(2)}",
                                      style: const TextStyle(
                                        color: Colors.pinkAccent,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Delete button
                              IconButton(
                                onPressed: isInCart
                                    ? () {
                                        cartProviderData.removeCartItem(
                                          favoriteItem.productId,
                                        );
                                        showCustomSnackBar(
                                          context,
                                          ref,
                                          'Removed from cart',
                                          favoriteItem.image[0],
                                        );
                                      }
                                    : () {
                                        cartProviderData.addProductToCart(
                                          productName: favoriteItem.productName,
                                          productPrice:
                                              favoriteItem.productPrice,
                                          category: favoriteItem.category,
                                          image: favoriteItem.image,
                                          vendorId: favoriteItem.vendorId,
                                          productQuantity:
                                              favoriteItem.quantity,
                                          quantity: 1,
                                          productId: favoriteItem.productId,
                                          description: favoriteItem.description,
                                          fullName: favoriteItem.fullName,
                                        );
                                        showCustomSnackBar(
                                          context,
                                          ref,
                                          'Added to cart',
                                          favoriteItem.image[0],
                                        );
                                      },

                                icon: isInCart
                                    ? Icon(
                                        Icons.remove_shopping_cart_sharp,
                                        color: Colors.red,
                                      )
                                    : Icon(
                                        Icons.add_shopping_cart_rounded,
                                        color: AppColors.primary,
                                      ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
    );
  }
}
