import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:web_admin_for_fullstack/controllers/CategoryController.dart';
import 'package:web_admin_for_fullstack/controllers/subcategory_controller.dart';
import 'package:web_admin_for_fullstack/models/category.dart';
import 'package:web_admin_for_fullstack/views/side_bar_screens/widget/subcategory_widget.dart';

class SubcategoryScreen extends StatefulWidget {
  static const String id = 'subCategoryScreen';
  const SubcategoryScreen({super.key});

  @override
  State<SubcategoryScreen> createState() => _SubcategoryScreenState();
}

class _SubcategoryScreenState extends State<SubcategoryScreen> {
  final SubcategoryController subcategoryController = SubcategoryController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late Future<List<Category>> futureCategories;
  Category? selectedCategory;
  late String name;
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    futureCategories = CategoryController().loadCategories();
  }

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
                  "Subcategoires",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 36,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Divider(
                color: Colors.grey,
              ),
            ),
            FutureBuilder(
                future: futureCategories,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Error ${snapshot.error}"));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text("No Category"));
                  } else {
                    return DropdownButton(
                        value: selectedCategory,
                        hint: Text("Select Category"),
                        items: snapshot.data!.map((Category category) {
                          return DropdownMenuItem(
                            value: category,
                            child: Text(category.name),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedCategory = value;
                          });
                          print(selectedCategory!.name);
                        });
                  }
                }),
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
                            'Subcategory Image',
                          ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                      width: 250,
                      child: TextFormField(
                        autofocus: false,
                        focusNode: FocusNode(),
                        onChanged: (value) {
                          try {
                            setState(() {
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
                            return "Please Enter Subcategory Name";
                          }
                        },
                        decoration: InputDecoration(
                          labelText: "Enter Subcategory Name",
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
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      // try {
                      await subcategoryController.uploadSubcategory(
                          categoryId: selectedCategory!.id,
                          categoryName: selectedCategory!.name,
                          pickedImage: _image,
                          subCategoryName: name,
                          context: context);
                      //     debugPrint("Category uploaded successfully");
                      //   } catch (e) {
                      //     debugPrint("Error uploading category: $e");
                      //     debugPrintStack();
                      //   }
                      setState(() {
                        _formKey.currentState!.reset();
                        _image = null;
                      });
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Divider(
                color: Colors.grey,
              ),
            ),
            SubcategoryWidget(),
          ],
        ),
      ),
    );
  }
}
