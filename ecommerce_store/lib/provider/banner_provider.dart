import 'dart:async';
import 'dart:convert';
import 'package:flutter_riverpod/legacy.dart';
import 'package:http/http.dart' as http;
import 'package:shopgram/core/constants/app_constants.dart';
import 'package:shopgram/models/banner_model.dart';

final bannerProvider = StateNotifierProvider<BannerNotifier, List<BannerModel>>(
  (ref) {
    return BannerNotifier();
  },
);

class BannerNotifier extends StateNotifier<List<BannerModel>> {
  BannerNotifier() : super([]) {
    loadBanners();
  }
  void setBanners(List<BannerModel> banners) {
    state = banners;
  }

  Future<List<BannerModel>> loadBanners() async {
    try {
      // send an http get request to fetch banners
      http.Response response = await http.get(
        Uri.parse(AppConstants.bannerEndpoint),
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
        },
      );

      if (response.statusCode == 200) {
        // ok
        List<dynamic> data = jsonDecode(response.body);
        List<BannerModel> banners = data
            .map((banner) => BannerModel.fromJson(banner))
            .toList();
        return banners;
      } else if (response.statusCode == 404) {
        // return [];
        throw Exception("Banner Not Found");
      } else {
        // return [];
        // throw an exception if the server response with an error status code....
        throw Exception("Failed to load Banners");
      }
    } catch (e) {
      // return [];
      throw Exception("Error Loading Banners $e");
    }
  }
}
