import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:web_admin_for_fullstack/controllers/CategoryController.dart';
import 'package:web_admin_for_fullstack/controllers/product_controller.dart';
import 'package:web_admin_for_fullstack/controllers/subcategory_controller.dart';
import 'package:web_admin_for_fullstack/models/category.dart';
import 'package:web_admin_for_fullstack/models/subcategory.dart';

class ProductsScreens extends ConsumerStatefulWidget {
//   // StatefullWidget => ConsumerStatefullWidget consumer is used for riverpod......
  static const String id = "\products-screens";
  const ProductsScreens({super.key});

  @override
  _ProductsScreensState createState() => _ProductsScreensState();
}

class _ProductsScreensState extends ConsumerState<ProductsScreens> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final ProductController _productController = ProductController();
  late Future<List<Category>> futureCategories;
  Future<List<Subcategory>>? futureSubcategories;
  Category? selectedCategory;
  Subcategory? selectedSubcategory;
  late String productName;
  late int productPrice;
  late int quantity;
  late String description;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    futureCategories = CategoryController().loadCategories();
  }

  // create an instance of imagePicker to handle image selection...
  final ImagePicker picker = ImagePicker();

  // initialize an empty list to store the selected images...
  List<File> images = [];

  // Define a function to choose images from the gallery or camera...
  chooseImage() async {
    // Use the picker to select an image from the gallery..
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    // check if no image picked
    if (pickedFile == null) {
      print('No image picked');
    } else {
      // if an image was picked, update the state and add the image to the list....
      setState(() {
        images.add(File(pickedFile.path));
      });
    }
  }

  getSubCategoryByCategory(value) {
    // fetch subcategories base om the selected category...
    futureSubcategories =
        SubcategoryController().getSubCategoriesByCategoryName(value.name);
    // reset the  selected subcategory to null...
    selectedSubcategory = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product'),
      ),
      body: Form(
        key: _formkey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 150,
              width: 400,
              child: GridView.builder(
                  itemCount: images.length + 1,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 4,
                    mainAxisSpacing: 4,
                    childAspectRatio: 1,
                  ),
                  itemBuilder: (context, index) {
                    // if the index is 0, display an iconButton to add a new image..
                    return index == 0
                        ? Center(
                            child: ElevatedButton.icon(
                            onPressed: chooseImage,
                            label: Text("Add Images"),
                            icon: Icon(Icons.add),
                          ))
                        : SizedBox(
                            width: 50,
                            height: 40,
                            child: Image.network(images[index - 1].path),
                            // child: Image.file(images[index - 1]),
                          );
                  }),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  SizedBox(
                    width: 600,
                    child: TextFormField(
                      onChanged: (value) {
                        productName = value;
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter Product Name";
                        } else {
                          return null;
                        }
                      },
                      decoration: InputDecoration(
                          labelText: "Enter Product Name",
                          hintText: "Enter Product Name",
                          border: OutlineInputBorder()),
                    ),
                  ),
                  SizedBox(height: 10),
                  SizedBox(
                    width: 200,
                    child: TextFormField(
                      // keyboardType:TextInputType.number,
                      onChanged: (value) {
                        productPrice = int.parse(value);
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter Product price";
                        } else {
                          return null;
                        }
                      },
                      decoration: InputDecoration(
                          labelText: "Enter Product Price",
                          hintText: "Enter Product Price",
                          border: OutlineInputBorder()),
                    ),
                  ),
                  SizedBox(height: 10),
                  SizedBox(
                    width: 200,
                    child: TextFormField(
                      // keyboardType:TextInputType.number,
                      onChanged: (value) {
                        quantity = int.parse(value);
                      },
                      decoration: InputDecoration(
                          labelText: "Enter Product Quantity",
                          hintText: "Enter Product Quantity",
                          border: OutlineInputBorder()),
                    ),
                  ),
                  SizedBox(height: 10),
                  SizedBox(
                    width: 200,
                    child: FutureBuilder<List<Category>>(
                        future: futureCategories,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(
                                child: Text("Error ${snapshot.error}"));
                          } else if (!snapshot.hasData ||
                              snapshot.data!.isEmpty) {
                            return Center(child: Text("No Category"));
                          } else {
                            return DropdownButton<Category>(
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
                                  getSubCategoryByCategory(selectedCategory);
                                  print(selectedCategory!.name);
                                });
                          }
                        }),
                  ),
                  SizedBox(
                    width: 200,
                    child: FutureBuilder<List<Subcategory>>(
                        future: futureSubcategories,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(
                                child: Text("Error ${snapshot.error}"));
                          } else if (!snapshot.hasData ||
                              snapshot.data!.isEmpty) {
                            return Center(child: Text("No SubCategory"));
                          } else {
                            return DropdownButton<Subcategory>(
                                value: selectedSubcategory,
                                hint: Text("Select SubCategory"),
                                items: snapshot.data!
                                    .map((Subcategory subcategory) {
                                  return DropdownMenuItem(
                                    value: subcategory,
                                    child: Text(subcategory.subCategoryName),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    selectedSubcategory = value;
                                  });
                                });
                          }
                        }),
                  ),
                  SizedBox(height: 10),
                  SizedBox(
                    width: 200,
                    child: TextFormField(
                      onChanged: (value) {
                        description = value;
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter Product Description";
                        } else {
                          return null;
                        }
                      },
                      maxLines: 3,
                      maxLength: 500,
                      decoration: InputDecoration(
                          labelText: "Enter Product Description",
                          hintText: "Enter Product Description",
                          border: OutlineInputBorder()),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: InkWell(
                onTap: () async {
                  // final fullName - ref.read(vendorProvider)!.fullName;
                  // final vendorId - ref.read(vendorProvider)!.id;
                  if (_formkey.currentState!.validate()) {
                    setState(() {
                      isLoading = true;
                    });
                    await _productController
                        .uploadProduct(
                            productName: productName,
                            productPrice: productPrice,
                            quantity: quantity,
                            description: description,
                            category: selectedCategory!.name,
                            vendorId: '',
                            fullName: '',
                            subCategory: selectedSubcategory!.subCategoryName,
                            pickedImages: images,
                            context: context)
                        .whenComplete(() {
                      setState(() {
                        isLoading = false;
                      });
                      selectedCategory = null;
                      selectedSubcategory = null;
                      images.clear();
                    });
                  } else {
                    print("Please enter all the fields");
                  }
                },
                child: Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.blue.shade900,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Center(
                    child: isLoading
                        ? Center(child: CircularProgressIndicator())
                        : Text(
                            'Upload Product',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.7,
                            ),
                          ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
