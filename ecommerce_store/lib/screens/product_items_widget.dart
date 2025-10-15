import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopgram/core/theme/app_colors.dart';
import 'package:shopgram/core/utils/size_config.dart';
import 'package:shopgram/models/products_model.dart';
import 'package:shopgram/provider/cart_provider.dart';
import 'package:shopgram/provider/favorite_provider.dart';
import 'package:shopgram/screens/product_detail_screen.dart';
import 'package:shopgram/server/manage_http_responses.dart';

class ProductItemsWidget extends ConsumerStatefulWidget {
  final ProductModel product;
  const ProductItemsWidget({super.key, required this.product});

  @override
  ConsumerState<ProductItemsWidget> createState() => _ProductItemsWidgetState();
}

class _ProductItemsWidgetState extends ConsumerState<ProductItemsWidget> {
  @override
  Widget build(BuildContext context) {
    final cartProviderData = ref.read(cartProvider.notifier);
    final cartData = ref.watch(cartProvider);
    final isInCart = cartData.containsKey(widget.product.id);

    final favoriteProviderData = ref.read(FavoriteProvider.notifier);
    // real time changes...
    ref.watch(FavoriteProvider);
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(product: widget.product),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.only(left: 6),
        color: Colors.white,
        width: 170,
        margin: EdgeInsets.symmetric(horizontal: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 38.2.h,
              decoration: BoxDecoration(
                // color: Color(0xffF2F2F2),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Stack(
                children: [
                  Image.network(
                    widget.product.images[0],
                    height: 140,
                    width: 170,
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    top: 2,
                    right: 5,
                    child: InkWell(
                      onTap: () {
                        favoriteProviderData.addProductToFavorite(
                          productName: widget.product.productName,
                          productPrice: widget.product.productPrice,
                          category: widget.product.category,
                          image: widget.product.images,
                          vendorId: widget.product.vendorId,
                          productQuantity: widget.product.quantity,
                          quantity: 1,
                          productId: widget.product.id,
                          description: widget.product.description,
                          fullName: widget.product.fullName,
                        );
                        showSnackBar(
                          context,
                          "added ${widget.product.productName}",
                        );
                      },
                      child:
                          favoriteProviderData.getFavoriteItems.containsKey(
                            widget.product.id,
                          )
                          ? Icon(Icons.favorite, color: AppColors.primary)
                          : Icon(
                              Icons.favorite_border,
                              color: AppColors.primary,
                            ),
                    ),
                  ),
                  // Positioned(
                  //   bottom: 5,
                  //   right: 5,
                  //   child: InkWell(
                  //     onTap: isInCart
                  //         ? null
                  //         : () {
                  //             cartProviderData.addProductToCart(
                  //               productName: widget.product.productName,
                  //               productPrice: widget.product.productPrice,
                  //               category: widget.product.category,
                  //               image: widget.product.images,
                  //               vendorId: widget.product.vendorId,
                  //               productQuantity: widget.product.quantity,
                  //               quantity: 1,
                  //               productId: widget.product.id,
                  //               description: widget.product.description,
                  //               fullName: widget.product.fullName,
                  //             );
                  //             showSnackBar(context, widget.product.productName);
                  //           },
                  //     child: Icon(Icons.shopping_cart_outlined),
                  // ),
                  // ),
                ],
              ),
            ),
            // SizedBox(height: 8),
            Text(
              widget.product.productName,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 14,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            widget.product.averageRating == 0
                ? SizedBox()
                : Row(
                    children: [
                      Icon(Icons.star, color: Colors.yellow, size: 16),
                      SizedBox(width: 4),
                      Text(
                        widget.product.averageRating.toStringAsFixed(1),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
            // SizedBox(height: 4),
            Text(
              widget.product.category,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Color(0xff868D94),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "₹${widget.product.productPrice.toStringAsFixed(2)}",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.greyLight,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),

                      // bottomRight: Radius.circular(16),
                    ),
                  ),
                  child: Container(
                    margin: EdgeInsets.only(left: 8, top: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: AppColors.primary),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12),
                        bottomRight: Radius.circular(16),
                      ),
                    ),
                    child: SizedBox(
                      width: 32,
                      height: 30,
                      child: Center(
                        child: InkWell(
                          onTap: isInCart
                              ? null
                              : () {
                                  cartProviderData.addProductToCart(
                                    productName: widget.product.productName,
                                    productPrice: widget.product.productPrice,
                                    category: widget.product.category,
                                    image: widget.product.images,
                                    vendorId: widget.product.vendorId,
                                    productQuantity: widget.product.quantity,
                                    quantity: 1,
                                    productId: widget.product.id,
                                    description: widget.product.description,
                                    fullName: widget.product.fullName,
                                  );
                                  showSnackBar(
                                    context,
                                    widget.product.productName,
                                  );
                                },
                          // child: Icon(Icons.add, color: AppColors.primary),
                          child: isInCart
                              ? Icon(
                                  Icons.check_outlined,
                                  color: AppColors.primary,
                                )
                              : Icon(Icons.add, color: AppColors.primary),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
