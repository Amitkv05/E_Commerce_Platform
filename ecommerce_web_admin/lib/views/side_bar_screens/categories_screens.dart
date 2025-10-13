// import 'package:flutter/material.dart';

// class CategoriesScreens extends StatefulWidget {
//   static const String id = "categories-screens";
//   const CategoriesScreens({super.key});

//   @override
//   State<CategoriesScreens> createState() => _CategoriesScreensState();
// }

// class _CategoriesScreensState extends State<CategoriesScreens> {
//   @override
//   Widget build(BuildContext context) {
//     return Text("CategoriesScreens");
//   }
// }
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:web_admin_for_fullstack/controllers/CategoryController.dart';
import 'package:web_admin_for_fullstack/views/side_bar_screens/widget/category_widget.dart';

class CategoriesScreens extends StatefulWidget {
  static const String id = "categories-screens";
  const CategoriesScreens({super.key});

  @override
  State<CategoriesScreens> createState() => _CategoriesScreensState();
}

class _CategoriesScreensState extends State<CategoriesScreens> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final CategoryController _categoryController = CategoryController();
  // final TextEditingController _categoryNameController = TextEditingController();
  late String name;
  dynamic _bannerImage;
  dynamic _image;

  pickImage() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );

      if (result != null) {
        setState(() {
          _image = result.files.first.bytes;
        });
      }
    } catch (e) {
      debugPrint("Error picking image: $e");
      debugPrintStack();
    }
  }

  pickBannerImage() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );

      if (result != null) {
        setState(() {
          _bannerImage = result.files.first.bytes;
        });
      }
    } catch (e) {
      debugPrint("Error picking banner image: $e");
      debugPrintStack();
    }
  }

  // @override
  // void dispose() {
  //   _categoryNameController.dispose();
  //   _categoryNameFocusNode.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                alignment: Alignment.topLeft,
                child: Text(
                  'Categories',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Divider(
                color: Colors.grey,
              ),
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
                        : Text(
                            'Category Image',
                          ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                      width: 250,
                      child: TextFormField(
                        onChanged: (value) {
                          try {
                            setState(() {
                              // No need to update categoryName directly
                              name = value;
                            });
                          } catch (e) {
                            debugPrint("Error during onChanged: $e");
                            debugPrintStack();
                          }
                        },
                        validator: (value) {
                          if (value != null && value.isNotEmpty) {
                            return null;
                          } else {
                            return "Please Enter Category Name";
                          }
                        },
                        decoration: InputDecoration(
                          labelText: "Enter Category Name",
                        ),
                      )),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      try {
                        _categoryController.uploadCategory(
                          pickedImage: _image,
                          pickedBanner: _bannerImage,
                          name: name,
                          context: context,
                        );
                        debugPrint("Category uploaded successfully");
                      } catch (e) {
                        debugPrint("Error uploading category: $e");
                        debugPrintStack();
                      }
                    } else {
                      debugPrint("Form validation failed");
                      debugPrintStack();
                    }
                  },
                  child: Text(
                    "Save",
                    style: TextStyle(color: Colors.white),
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
                child: Text("Pick Image"),
              ),
            ),
            Divider(
              color: Colors.grey,
            ),
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Center(
                child: _bannerImage != null
                    ? Image.memory(_bannerImage)
                    : Text(
                        'Category Banner',
                        style: TextStyle(color: Colors.white),
                      ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  pickBannerImage();
                },
                child: Text("Pick Image"),
              ),
            ),
            Divider(
              color: Colors.grey,
            ),
            CategoryWidget(),
          ],
        ),
      ),
    );
  }
}
