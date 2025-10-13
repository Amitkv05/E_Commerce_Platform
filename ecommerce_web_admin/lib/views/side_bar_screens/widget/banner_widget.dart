import 'package:flutter/material.dart';
import 'package:web_admin_for_fullstack/controllers/banner_controller.dart';
import 'package:web_admin_for_fullstack/models/banner_model.dart';

class BannerWidget extends StatefulWidget {
  const BannerWidget({super.key});

  @override
  State<BannerWidget> createState() => _BannerWidgetState();
}

class _BannerWidgetState extends State<BannerWidget> {
  // A Future that will hold the list of banners once loaded from the API
  late Future<List<BannerModel>> futureBanners;
  @override
  void initState() {
    //
    super.initState();
    futureBanners = BannerController().loadBanners();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: futureBanners,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error loading banners: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text("No Banners"),
            );
          } else {
            final banners = snapshot.data!;
            return Container(
              color: Colors.red,
              height: MediaQuery.of(context).size.height * 0.54,
              child: GridView.builder(
                  shrinkWrap: true,
                  itemCount: banners.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 6,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8),
                  itemBuilder: (context, index) {
                    final banner = banners[index];
                    return Padding( 
                      padding: const EdgeInsets.all(8.0),
                      child: Image.network(
                        width: 80,
                        height: 80,
                        banner.image,
                      ),
                    );
                  }),
            );
          }
        });
  }
}
