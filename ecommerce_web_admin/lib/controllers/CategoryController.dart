import 'dart:convert';

import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:web_admin_for_fullstack/constants/app_constants.dart';
import 'package:web_admin_for_fullstack/models/category.dart';
import 'package:http/http.dart' as http;
import 'package:web_admin_for_fullstack/services/manage_http_response.dart';

class CategoryController {
  uploadCategory(
      {required dynamic pickedImage,
      required dynamic pickedBanner,
      required String name,
      required context}) async {
    try {
      final cloudinary = CloudinaryPublic("dbpmte8mh", "g59c27df");

      // Upload the image
      CloudinaryResponse imageResponse = await cloudinary.uploadFile(
        CloudinaryFile.fromBytesData(pickedImage,
            identifier: 'pickedImage', folder: 'categoryImages'),
      );
      String image = imageResponse.secureUrl;
      CloudinaryResponse bannerResponse = await cloudinary.uploadFile(
        CloudinaryFile.fromBytesData(pickedBanner,
            identifier: 'pickedBanner', folder: 'categoryImages'),
      );
      String banner = bannerResponse.secureUrl;

      Category category =
          Category(id: "", name: name, image: image, banner: banner);
      http.Response response = await http.post(
          Uri.parse(AppConstants.categoriesEndpoint),
          body: category.toJson(),
          headers: <String, String>{
            "Content-Type": "application/json; charset=UTF-8",
          });
      manageHttpResponses(
          response: response,
          context: context,
          onSuccess: () {
            showSnackBar(context, "Uploaded Category");
          });
    } catch (e) {
      print('Error uploading image to Cloudinary: $e');
    }
  }
  // load the uploaded category

  Future<List<Category>> loadCategories() async {
    try {
      // send an http get Request to load the categories
      http.Response response = await http.get(
          Uri.parse(AppConstants.categoriesEndpoint),
          headers: <String, String>{
            "Content-Type": "application/json; charset=UTF-8",
          });
      print(response.body);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        List<Category> categories =
            data.map((category) => Category.fromJson(category)).toList();

        return categories;
      } else {
        throw Exception("failed to load Categories");
      }
    } catch (e) {
      throw Exception('Error loading categories: $e');
    }
  }
}
