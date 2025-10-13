import 'dart:convert';

import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:e_commerce_vendor_app/global_variables.dart';
import 'package:e_commerce_vendor_app/models/subcategory.dart';
import 'package:e_commerce_vendor_app/services/manage_http_responses.dart';
import 'package:http/http.dart' as http;

class SubcategoryController {
  uploadSubcategory({
    required String categoryId,
    required String categoryName,
    required dynamic pickedImage,
    required String subCategoryName,
    required context,
  }) async {
    try {
      final cloudinary = CloudinaryPublic("dbpmte8mh", "g59c27df");

      // Upload the image
      CloudinaryResponse imageResponse = await cloudinary.uploadFile(
        CloudinaryFile.fromBytesData(pickedImage,
            identifier: 'pickedImage', folder: 'subcategoryImages'),
      );
      String image = imageResponse.secureUrl;
      Subcategory subcategory = Subcategory(
          id: '',
          categoryId: categoryId,
          categoryName: categoryName,
          image: image,
          subCategoryName: subCategoryName);

      http.Response response = await http.post(
          Uri.parse("$uri/api/subcategories"),
          body: subcategory.toJson(),
          headers: <String, String>{
            "Content-Type": "application/json; charset=UTF-8",
          });
      manageHttpResponses(
          response: response,
          context: context,
          onSuccess: () {
            showSnackBar(context, "Subcategory Uploaded ");
          });
    } catch (e) {
      print('Error uploading Subcategory to Cloudinary: $e');
    }
  }
  // load the uploaded Subcategory

  Future<List<Subcategory>> loadSubcategories() async {
    try {
      // send an http get Request to load the categories
      http.Response response = await http
          .get(Uri.parse('$uri/api/subcategories'), headers: <String, String>{
        "Content-Type": "application/json; charset=UTF-8",
      });
      print(response.body);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        List<Subcategory> subcategories = data
            .map((subcategory) => Subcategory.fromJson(subcategory))
            .toList();

        return subcategories;
      } else {
        throw Exception("failed to load Subcategories");
      }
    } catch (e) {
      throw Exception('Error loading Subcategories: $e');
    }
  }

  // for adding products..
  Future<List<Subcategory>> getSubCategoriesByCategoryName(
      String categoryName) async {
    try {
      // send an http get Request to load the categories
      http.Response response = await http.get(
          Uri.parse('$uri/api/category/$categoryName/subcategories'),
          headers: <String, String>{
            "Content-Type": "application/json; charset=UTF-8",
          });
      print(response.body);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        if (data.isNotEmpty) {
          return data
              .map((subcategory) => Subcategory.fromJson(subcategory))
              .toList();
        } else {
          print("Subcategories Not Found");
          return [];
        }
      } else if (response.statusCode == 404) {
        print("Subcategories Not Found");
        return [];
        // throw Exception("Subcategories Not Found");
      } else {
        print("failed to load Subcategories");
        return [];
        // throw Exception("failed to load Subcategories");
      }
    } catch (e) {
      print('Error loading Subcategories: $e');
      return [];
      // throw Exception('Error loading Subcategories: $e');
    }
  }
}
