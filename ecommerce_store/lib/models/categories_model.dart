class CategoriesModel {
  CategoriesModel({
    required this.id,
    required this.name,
    required this.image,
    required this.banner,
  });

  final String id;
  final String name;
  final String image;
  final String banner;
  

  CategoriesModel copyWith({
    String? id,
    String? name,
    String? image,
    String? banner,
  }) {
    return CategoriesModel(
      id: id ?? this.id,
      name: name ?? this.name,
      image: image ?? this.image,
      banner: banner ?? this.banner,
    );
  }

  factory CategoriesModel.fromJson(Map<String, dynamic> json) {
    return CategoriesModel(
      id: json["_id"] ?? "",
      name: json["name"] ?? "",
      image: json["image"] ?? "",
      banner: json["banner"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "image": image,
    "banner": banner,
  };

  @override
  String toString() {
    return "$id, $name, $image, $banner, ";
  }
}
