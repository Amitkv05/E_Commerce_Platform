import 'dart:convert';

class Buyer {
  // Define the properties of the Buyer class(Define Fields).....
  final String id;
  final String fullName;
  final String email;
  final String state;
  final String city;
  final String locality;
  final String password;
  final String token;

  Buyer({
    required this.id,
    required this.fullName,
    required this.email,
    required this.state,
    required this.city,
    required this.locality,
    required this.password,
    required this.token,
  });

  // serialization : Convert Buyer object to a Map
  // Map: A Map is a collection of key-value pairs, where each key is unique.
  //Why: Converting to a map is an intermediate step that makes it easier to serialize..
  // the objext to formates like json for storage or transmission.

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'fullName': fullName,
      'email': email,
      'state': state,
      'city': city,
      'locality': locality,
      'password': password,
      'token': token,
    };
  }

  // serialization : Convert a Map to json String
  // this method directly excodes the datafrom the Map into a json String

  // the json.encode() function converts a Dart object(such as Map or List) into a JSON string representation,
  // making it suitable for communivation between different system(like:- Dart application and a server).

  String toJson() => json.encode(toMap());

  // deserialization: Convert a Map to Buyer object
  // purpose - Manipulation and Buyer : Once the data is converted a to a Buyer object
  /// it can be easily manipulated and use within the application.
  /// for example, we might want to display the Buyer's fullName , email etc on the Ui or we might want to save the data locally....

  // the factory contructor takes a Map (Usually obtained from a json object)
  /// and convert it into a Buyer object.If a field is not presend in the , it defaults to an empty string.

  // fromMap: this contructor take a Map<String, dynamic> and converts into a Buyer object
  // .its usefull when you already have the data in map format
  factory Buyer.fromMap(Map<String, dynamic> map) {
    return Buyer(
      id: map['_id'] as String? ?? '',
      fullName: map['fullName'] as String? ?? '',
      email: map['email'] as String? ?? '',
      state: map['state'] as String? ?? '',
      city: map['city'] as String? ?? '',
      locality: map['locality'] as String? ?? '',
      password: map['password'] as String? ?? '',
      token: map['token'] as String? ?? '',
    );
  }
}
