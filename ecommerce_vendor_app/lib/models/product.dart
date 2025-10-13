import 'dart:convert';

class Product {
  final String id;
  final String productName;
  final int productPrice;
  final int quantity;
  final String description;
  final String category;
  final String vendorId;
  final String fullName;
  final String subCategory;
  final List<String> images;

  Product(
      {required this.id,
      required this.productName,
      required this.productPrice,
      required this.quantity,
      required this.description,
      required this.category,
      required this.vendorId,
      required this.fullName,
      required this.subCategory,
      required this.images});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "id": id,
      "productName": productName,
      "productPrice": productPrice,
      "quantity": quantity,
      "description": description,
      "category": category,
      "vendorId": vendorId,
      "fullName": fullName,
      "subCategory": subCategory,
      "images": images,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map["id"],
      productName: map["productName"],
      productPrice: map["productPrice"]?.toInt(),
      quantity: map["quantity"]?.toInt(),
      description: map["description"],
      category: map["category"],
      vendorId: map["vendorId"],
      fullName: map["fullName"],
      subCategory: map["subCategory"],
      images: List<String>.from(map["images"]),
    );
  }

  String toJson() => json.encode(toMap());

  factory Product.fromJson(String source) =>
      Product.fromMap(json.decode(source));
}
