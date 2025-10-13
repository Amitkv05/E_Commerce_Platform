class SubCategoriesModel {
  SubCategoriesModel({
    required this.id,
    required this.categoryName,
    required this.categoryId,
    required this.image,
    required this.subCategoryName,
    required this.v,
  });

  final String id;
  final String categoryName;
  final String categoryId;
  final String image;
  final String subCategoryName;
  final int v;

  SubCategoriesModel copyWith({
    String? id,
    String? categoryName,
    String? categoryId,
    String? image,
    String? subCategoryName,
    int? v,
  }) {
    return SubCategoriesModel(
      id: id ?? this.id,
      categoryName: categoryName ?? this.categoryName,
      categoryId: categoryId ?? this.categoryId,
      image: image ?? this.image,
      subCategoryName: subCategoryName ?? this.subCategoryName,
      v: v ?? this.v,
    );
  }

  factory SubCategoriesModel.fromJson(Map<String, dynamic> json) {
    return SubCategoriesModel(
      id: json["_id"] ?? "",
      categoryName: json["categoryName"] ?? "",
      categoryId: json["categoryId"] ?? "",
      image: json["image"] ?? "",
      subCategoryName: json["subCategoryName"] ?? "",
      v: json["__v"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    "_id": id,
    "categoryName": categoryName,
    "categoryId": categoryId,
    "image": image,
    "subCategoryName": subCategoryName,
    "__v": v,
  };

  @override
  String toString() {
    return "$id, $categoryName, $categoryId, $image, $subCategoryName, $v, ";
  }
}
