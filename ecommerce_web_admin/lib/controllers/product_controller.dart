import 'dart:io';

import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:http/http.dart' as http;
import 'package:web_admin_for_fullstack/global_variable.dart';
import 'package:web_admin_for_fullstack/models/product.dart';
import 'package:web_admin_for_fullstack/services/manage_http_response.dart';

class ProductController {
  Future<void> uploadProduct({
    required String productName,
    required int productPrice,
    required int quantity,
    required String description,
    required String category,
    required String? vendorId,
    required String? fullName,
    required String subCategory,
    required List<File>? pickedImages,
    required context,
  }) async {
    if (pickedImages != null) {
      final cloudinary = CloudinaryPublic("dbpmte8mh", "g59c27df");
      List<String> images = [];
      // loop through each image in the pickedImages List
      for (var i = 0; i < pickedImages.length; i++) {
        CloudinaryResponse cloudinaryResponse = await cloudinary.uploadFile(
          CloudinaryFile.fromFile(pickedImages[i].path, folder: productName),
        );
        // add the secure Url to the images list...
        images.add(cloudinaryResponse.secureUrl);
      }
      if (category.isNotEmpty && subCategory.isNotEmpty) {
        final Product product = Product(
            id: '',
            productName: productName,
            productPrice: productPrice,
            quantity: quantity,
            description: description,
            category: category,
            vendorId: vendorId ?? '',
            fullName: fullName ?? '',
            subCategory: subCategory,
            images: images);
        http.Response response = await http.post(Uri.parse("$uri/api/products"),
            body: product.toJson(),
            headers: <String, String>{
              "Content-Type": "application/json; charset=UTF-8",
            });
        if (response.statusCode == 200 || response.statusCode == 201) {
          showSnackBar(context, 'Product Uploaded');
        } else {
          print(response.statusCode);
          showSnackBar(context, 'Failed to upload product');
        }
      } else {
        showSnackBar(context, "Select Category");
      }
    } else {
      showSnackBar(context, 'Select Image');
    }
  }
}
