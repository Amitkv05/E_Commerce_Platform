class ProductModel {
  ProductModel({
    required this.id,
    required this.productName,
    required this.productPrice,
    required this.quantity,
    required this.description,
    required this.category,
    required this.vendorId,
    required this.fullName,
    required this.subCategory,
    required this.images,
    required this.popular,
    required this.recommend,
    required this.averageRating,
    required this.totalRatings,
    required this.v,
  });

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
  final bool popular;
  final bool recommend;
  final int averageRating;
  final int totalRatings;
  final int v;

  ProductModel copyWith({
    String? id,
    String? productName,
    int? productPrice,
    int? quantity,
    String? description,
    String? category,
    String? vendorId,
    String? fullName,
    String? subCategory,
    List<String>? images,
    bool? popular,
    bool? recommend,
    int? averageRating,
    int? totalRatings,
    int? v,
  }) {
    return ProductModel(
      id: id ?? this.id,
      productName: productName ?? this.productName,
      productPrice: productPrice ?? this.productPrice,
      quantity: quantity ?? this.quantity,
      description: description ?? this.description,
      category: category ?? this.category,
      vendorId: vendorId ?? this.vendorId,
      fullName: fullName ?? this.fullName,
      subCategory: subCategory ?? this.subCategory,
      images: images ?? this.images,
      popular: popular ?? this.popular,
      recommend: recommend ?? this.recommend,
      averageRating: averageRating ?? this.averageRating,
      totalRatings: totalRatings ?? this.totalRatings,
      v: v ?? this.v,
    );
  }

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json["_id"] ?? "",
      productName: json["productName"] ?? "",
      productPrice: json["productPrice"] ?? 0,
      quantity: json["quantity"] ?? 0,
      description: json["description"] ?? "",
      category: json["category"] ?? "",
      vendorId: json["vendorId"] ?? "",
      fullName: json["fullName"] ?? "",
      subCategory: json["subCategory"] ?? "",
      images: json["images"] == null
          ? []
          : List<String>.from(json["images"]!.map((x) => x)),
      popular: json["popular"] ?? false,
      recommend: json["recommend"] ?? false,
      averageRating: json["averageRating"] ?? 0,
      totalRatings: json["totalRatings"] ?? 0,
      v: json["__v"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    "_id": id,
    "productName": productName,
    "productPrice": productPrice,
    "quantity": quantity,
    "description": description,
    "category": category,
    "vendorId": vendorId,
    "fullName": fullName,
    "subCategory": subCategory,
    "images": images.map((x) => x).toList(),
    "popular": popular,
    "recommend": recommend,
    "averageRating": averageRating,
    "totalRatings": totalRatings,
    "__v": v,
  };

  @override
  String toString() {
    return "$id, $productName, $productPrice, $quantity, $description, $category, $vendorId, $fullName, $subCategory, $images, $popular, $recommend, $averageRating, $totalRatings, $v, ";
  }
}
