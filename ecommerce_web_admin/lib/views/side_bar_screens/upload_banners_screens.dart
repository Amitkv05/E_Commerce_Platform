import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:web_admin_for_fullstack/controllers/banner_controller.dart';
import 'package:web_admin_for_fullstack/views/side_bar_screens/widget/banner_widget.dart';

class UploadBannersScreens extends StatefulWidget {
  static const String id = "banner-screens";
  const UploadBannersScreens({super.key});

  @override
  State<UploadBannersScreens> createState() => _UploadBannersScreensState();
}

class _UploadBannersScreensState extends State<UploadBannersScreens> {
  final BannerController _bannerController = BannerController();
  dynamic _image;
  pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );
    if (result != null) {
      setState(() {
        _image = result.files.first.bytes;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              alignment: Alignment.topLeft,
              child: Text(
                "Banners",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 36,
                ),
              ),
            ),
          ),
          Divider(
            color: Colors.grey,
            thickness: 2,
          ),
          Row(
            children: [
              Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Center(
                  child: _image != null
                      ? Image.memory(_image)
                      : const Text("Category Image"),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () async {
                    await _bannerController.uploadBanner(
                        pickedImage: _image, context: context);
                  },
                  child: const Text("Save"),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                pickImage();
              },
              child: const Text("Upload Image "),
            ),
          ),
          Divider(
            color: Colors.grey,
            thickness: 2,
          ),
          BannerWidget(),
        ],
      ),
    );
  }
}
