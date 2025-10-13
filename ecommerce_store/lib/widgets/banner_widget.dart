import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopgram/provider/banner_provider.dart';

class BannerWidget extends ConsumerStatefulWidget {
  const BannerWidget({super.key});

  @override
  ConsumerState<BannerWidget> createState() => _BannerWidgetState();
}

class _BannerWidgetState extends ConsumerState<BannerWidget> {
  @override
  void initState() {
    super.initState();
    _fetchBanners();
  }

  Future<void> _fetchBanners() async {
    // Implement your banner fetching logic here
    BannerNotifier bannerNotifier = BannerNotifier();
    try {
      final banner = await bannerNotifier.loadBanners();
      ref.read(bannerProvider.notifier).setBanners(banner);
    } catch (e) {
      // Handle error appropriately
    }
  }

  // final List<Map<String, String>> banners = [
  //   {"image": "assets/banner.jpg"},
  //   {"image": "assets/banner.jpg"},
  //   {"image": "assets/banner.jpg"},
  // ];

  @override
  Widget build(BuildContext context) {
    final banners = ref.watch(bannerProvider);
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 170,
      decoration: BoxDecoration(
        color: Color(0xFFF7F7F7),
        borderRadius: BorderRadius.circular(4),
      ),
      child: SizedBox(
        // color: Colors.red,
        height: MediaQuery.of(context).size.height * 0.54,
        child: PageView.builder(
          itemCount: banners.length,
          itemBuilder: (context, index) {
            final banner = banners[index];
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                // child: Image.asset(banner['image']!, fit: BoxFit.cover),
                child: Image.network(banner.image, fit: BoxFit.cover),
              ),
            );
          },
        ),
      ),
    );
  }
}
