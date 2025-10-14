import 'dart:convert';

import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:web_admin_for_fullstack/constants/app_constants.dart';
import 'package:web_admin_for_fullstack/models/banner_model.dart';
import 'package:http/http.dart' as http;
import 'package:web_admin_for_fullstack/services/manage_http_response.dart';

class BannerController {
  uploadBanner({required dynamic pickedImage, required context}) async {
    try {
      final cloudinary = CloudinaryPublic('dbpmte8mh', 'g59c27df');

      CloudinaryResponse imageResponse = await cloudinary.uploadFile(
          CloudinaryFile.fromBytesData(pickedImage,
              identifier: 'pickedImage', folder: 'banners'));

      String image = imageResponse.secureUrl;

      BannerModel bannerModel = BannerModel(id: '', image: image);

      http.Response response = await http.post(
        Uri.parse(AppConstants.bannerEndpoint),
        body: bannerModel.toJson(),
        headers: {
          "Content-Type": "application/json; charset=UTF-8",
        },
      );
      manageHttpResponses(
        response: response,
        context: context,
        onSuccess: () {
          showSnackBar(context, "Banner Uploaded Successfully");
        },
      );
    } catch (e) {
      print(e);
    }
  }

  // fetch Banners
  Future<List<BannerModel>> loadBanners() async {
    try {
      // send an http get request to fetch banners
      http.Response response = await http.get(
        Uri.parse(AppConstants.bannerEndpoint),
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
        },
      );

      print(response.body);

      if (response.statusCode == 200) {
        // ok
        List<dynamic> data = jsonDecode(response.body);
        List<BannerModel> banners =
            data.map((banner) => BannerModel.fromJson(banner)).toList();
        return banners;
      } else {
        // throw an exception if the server response with an error status code....
        throw Exception("Failed to load Banners");
      }
    } catch (e) {
      throw Exception("Error Loading Banners $e");
    }
  }
}
