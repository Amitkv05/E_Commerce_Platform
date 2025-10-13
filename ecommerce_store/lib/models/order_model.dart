import 'dart:convert';

class Order {
  final String id;
  final String fullName;
  final String email;
  final String state;
  final String city;
  final String locality;
  final String productId;
  final String productName;
  final int productPrice;
  final int quantity;
  final String category;
  final String image;
  final String buyerId;
  final String vendorId;
  final bool processing;
  final bool delivered;
  final String paymentStatus;
  final String paymentIntentId;
  final String paymentMethod;

  Order({
    required this.id,
    required this.fullName,
    required this.email,
    required this.state,
    required this.city,
    required this.locality,
    required this.productId,
    required this.productName,
    required this.productPrice,
    required this.quantity,
    required this.category,
    required this.image,
    required this.buyerId,
    required this.vendorId,
    required this.processing,
    required this.delivered,
    required this.paymentStatus,
    required this.paymentIntentId,
    required this.paymentMethod,
  });
  // final DateTime createdAt;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "id": id,
      "fullName": fullName,
      "email": email,
      "state": state,
      "city": city,
      "locality": locality,
      "productId": productId,
      "productName": productName,
      "productPrice": productPrice,
      "quantity": quantity,
      "category": category,
      "image": image,
      "buyerId": buyerId,
      "vendorId": vendorId,
      "processing": processing,
      "delivered": delivered,
      "paymentStatus": paymentStatus,
      "paymentIntentId": paymentIntentId,
      "paymentMethod": paymentMethod,
    };
  }

  String toJson() => json.encode(toMap());

  factory Order.fromJson(Map<String, dynamic> map) {
    return Order(
      id: map["_id"],
      fullName: map["fullName"],
      email: map["email"],
      state: map["state"],
      city: map["city"],
      locality: map["locality"],
      productId: map["productId"],
      productName: map["productName"],
      productPrice: map["productPrice"]?.toInt(),
      quantity: map["quantity"]?.toInt(),
      category: map["category"],
      image: map["image"],
      buyerId: map["buyerId"],
      vendorId: map["vendorId"],
      processing: map["processing"],
      delivered: map["delivered"],
      paymentStatus: map["paymentStatus"],
      paymentIntentId: map["paymentIntentId"],
      paymentMethod: map["paymentMethod"],
    );
  }
}
