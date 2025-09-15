import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:real_estate/network/network_util.dart';
import '../gen/assets.gen.dart';

class PropertiesViewModel extends ChangeNotifier {
  PropertiesViewModel() {
    fetchProperties();
    fetchLikedProperties();
  }

  User? _currentUser;
  XFile? _profilePic;

  User? get currentUser => _currentUser;

  set currentUser(User value) {
    _currentUser = value;
    notifyListeners();
  }

  XFile? get profilePic => _profilePic;

  set profilePic(XFile? value) {
    _profilePic = value;
    notifyListeners();
  }

  List<Property> _properties = [];

  List<Property> _liked = [];

  List<Property> _filteredProperties = [];

  List<Property> get properties =>
      _filteredProperties.isEmpty ? _properties : _filteredProperties;

  List<Property> get likedProperties => _liked;

  Future<void> fetchProperties() async {
    _properties = await getProperties();
    notifyListeners();
  }

  Future<void> fetchLikedProperties() async {
    _liked = await queryProperties("${Queries.liked.name}=true");
    notifyListeners();
  }

  Future<void> updateProperties(Property property) async {
    await updateProperty(property);
  }

  void filterProperties(bool Function(Property) test) {
    _filteredProperties = _properties
        .where((property) => test(property))
        .toList();
    notifyListeners();
  }

  Future<void> addProperties(Property property) async {
    await createProperty(property);
    await fetchProperties();
    notifyListeners();
  }

  void resetProperties() {
    _filteredProperties.clear();
    notifyListeners();
  }
}

class Property {
  List<String> imageUrls;
  bool liked;
  String? id;
  String title,
      location,
      price,
      rating,
      bedrooms,
      bathrooms,
      area,
      type,
      views,
      description,
      contactName,
      contactNumber,
      contactEmail;
  List<String> features;

  Property({
    this.id,
    required this.contactEmail,
    required this.contactNumber,
    required this.contactName,
    required this.features,
    required this.imageUrls,
    required this.liked,
    required this.title,
    required this.location,
    required this.price,
    required this.rating,
    required this.bedrooms,
    required this.bathrooms,
    required this.area,
    required this.type,
    required this.views,
    this.description =
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.",
  });

  Map<String, dynamic> toJson() => {
    "contactEmail": contactEmail,
    "contactNumber": contactNumber,
    "contactName": contactName,
    "features": features,
    "imageUrls": imageUrls,
    "liked": liked,
    "title": title,
    "location": location,
    "price": price,
    "rating": rating,
    "bedrooms": bedrooms,
    "bathrooms": bathrooms,
    "area": area,
    "type": type,
    "views": views,
    "description": description,
  };

  static Property fromJson(Map<String, dynamic> json) => Property(
    id: json["_id"] ?? "",
    contactEmail: json["contactEmail"],
    contactNumber: json["contactNumber"],
    contactName: json["contactName"],
    features: List<String>.from(json["features"]),
    imageUrls: List<String>.from(json["imageUrls"]),
    liked: json["liked"],
    title: json["title"],
    location: json["location"],
    price: json["price"],
    rating: json["rating"],
    bedrooms: json["bedrooms"],
    bathrooms: json["bathrooms"],
    area: json["area"],
    type: json["type"],
    views: json["views"],
    description: json["description"],
  );

  Property copyWith({
    List<String>? imageUrls,
    bool? liked,
    String? id,
    String? title,
    String? location,
    String? price,
    String? rating,
    String? bedrooms,
    String? bathrooms,
    String? area,
    String? type,
    String? views,
    String? description,
    String? contactName,
    String? contactNumber,
    String? contactEmail,
    List<String>? features,
  }) => Property(
    imageUrls: imageUrls ?? this.imageUrls,
    liked: liked ?? this.liked,
    id: id ?? this.id,
    title: title ?? this.title,
    location: location ?? this.location,
    price: price ?? this.price,
    rating: rating ?? this.rating,
    bedrooms: bedrooms ?? this.bedrooms,
    bathrooms: bathrooms ?? this.bathrooms,
    area: area ?? this.area,
    type: type ?? this.type,
    views: views ?? this.views,
    description: description ?? this.description,
    contactName: contactName ?? this.contactName,
    contactNumber: contactNumber ?? this.contactNumber,
    contactEmail: contactEmail ?? this.contactEmail,
    features: features ?? this.features,
  );
}

class User {
  String firstName, lastName, email, phoneNumber, password;
  String? profilePicUrl;
  List<String>? likedProperties;

  User({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.password,
    this.profilePicUrl,
    this.likedProperties,
  });

  Map<String, dynamic> toJson() => {
    "firstName": firstName,
    "lastName": lastName,
    "email": email,
    "phoneNumber": phoneNumber,
    "password": password,
    "profilePicUrl": profilePicUrl,
    "likedProperties": likedProperties,
  };

  static User fromJson(Map<String, dynamic> json) => User(
    firstName: json["firstName"],
    lastName: json["lastName"],
    email: json["email"],
    phoneNumber: json["phoneNumber"],
    password: json["password"],
    profilePicUrl: json["profilePicUrl"],
    likedProperties: json["likedProperties"],
  );

  User copyWith({
    String? firstName,
    String? lastName,
    String? email,
    String? phoneNumber,
    String? password,
    String? profilePicUrl,
    List<String>? likedProperties,
  }) => User(
    firstName: firstName ?? this.firstName,
    lastName: lastName ?? this.lastName,
    email: email ?? this.email,
    phoneNumber: phoneNumber ?? this.phoneNumber,
    password: password ?? this.password,
    profilePicUrl: profilePicUrl ?? this.profilePicUrl,
    likedProperties: likedProperties ?? this.likedProperties,
  );
}

class Feature {
  final String label;
  final dynamic icon;

  const Feature(this.label, this.icon);

  static final gym = Feature("Gym", Assets.icons.dumbbellSolidFull);
  static final wifi = Feature("Wi-Fi", Icons.wifi);
  static final pool = Feature("Pool", Icons.pool);
  static final generator = Feature("Generator", Icons.battery_full);
  static final cityView = Feature("City view", Icons.location_city);
  static final greenery = Feature("Greenery", Icons.park);
  static final ampleParking = Feature(
    "Ample parking",
    Assets.icons.squareParkingSolidFull,
  );
  static final gatedCommunity = Feature("Gated community", Icons.security);
  static final spacious = Feature("Spacious", Icons.crop_square);

  static final values = {
    "gym": gym,
    "wifi": wifi,
    "pool": pool,
    "generator": generator,
    "cityView": cityView,
    "greenery": greenery,
    "ampleParking": ampleParking,
    "gatedCommunity": gatedCommunity,
    "spacious": spacious,
  };
}

enum PropertyType {
  forRent("For rent"),
  forSale("For sale");

  final String type;

  const PropertyType(this.type);
}
