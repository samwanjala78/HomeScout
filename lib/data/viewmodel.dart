import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:location/location.dart';
import 'package:real_estate/network/network_util.dart';
import 'package:real_estate/util/util.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../gen/assets.gen.dart';

class PropertiesViewModel extends ChangeNotifier {
  String? userId;

  Future<void> initApp() async {
    await getCount();
    await getProperties();
    fetchPopular();
    await fetchSavedProperties();
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getString("userId");
    log("startup userId: $userId");
    if (userId != null) {
      await fetchAccount(
        userId: userId!,
      );
    }
  }

  Property uploadProperty = Property(
    features: [],
    imageUrls: [],
    liked: false,
    title: "",
    location: "",
    price: "",
    rating: 4.5,
    bedrooms: "5",
    bathrooms: "5",
    area: "area",
    type: PropertyType.forRent.type,
    views: 0,
    contactEmail: "william.henry.harrison@example-pet-store.com",
    contactNumber: "0712345678",
    contactName: "John Doe",
    lat: 0,
    lng: 0,
  );

  void disposeProperty() {
    uploadProperty = Property(
      features: [],
      imageUrls: [],
      liked: false,
      title: "",
      location: "",
      price: "",
      rating: 0,
      bedrooms: "",
      bathrooms: "",
      area: "area",
      type: PropertyType.forRent.type,
      views: 0,
      contactEmail: "william.henry.harrison@example-pet-store.com",
      contactNumber: "0712345678",
      contactName: "John Doe",
      lat: 0,
      lng: 0,
    );
  }

  LocationData? locationData;
  List<String> locations = [];
  List<Property> displayedSearchProperties = [];
  User? _currentUser;
  XFile? _profilePic;
  int propertyCount = 0;

  XFile? get profilePic => _profilePic;
  List<Property> _properties = [];
  List<Property> _likedProperties = [];
  List<Property> _filteredProperties = [];

  List<Property> get properties =>
      _filteredProperties.isEmpty ? _properties : _filteredProperties;

  List<Property> get likedProperties => _likedProperties;

  User? get currentUser => _currentUser;

  set currentUser(User? value) {
    _currentUser = value;
    notifyListeners();
  }

  set profilePic(XFile? value) {
    _profilePic = value;
    notifyListeners();
  }

  Future<void> getProperties() async {
    log("fetching properties");
    _properties = await NetworkLayer.getProperties();
    sortProperties(SortOptions.rating);
    fetchPopular();
    notifyListeners();
  }

  void sortProperties(SortOptions sortOption) {
    switch (sortOption) {
      case SortOptions.priceLow:
        _properties.sort(
          (a, b) => a.price.convertPriceToInt().compareTo(
            b.price.convertPriceToInt(),
          ),
        );
        notifyListeners();
        break;
      case SortOptions.priceHigh:
        _properties.sort(
          (a, b) => b.price.convertPriceToInt().compareTo(
            a.price.convertPriceToInt(),
          ),
        );
        notifyListeners();
        break;
      case SortOptions.rating:
        _properties.sort((a, b) => b.rating.compareTo(a.rating));
        notifyListeners();
    }
  }

  Future<User?> getUserViaEmail(String email) {
    return NetworkLayer.getUserByEmail(email);
  }

  Future<void> getCount() async {
    propertyCount = await NetworkLayer.getCount();
    notifyListeners();
  }

  void fetchPopular() {
    List<String> popularLocations = const [
      "Westlands",
      "Embakasi",
      "Donholm",
      "Kinoo",
      "Kikuyu",
    ];
    displayedSearchProperties = _properties.where((place) {
      return popularLocations.any(
        (popular) =>
            place.location.toLowerCase().contains(popular.toLowerCase()),
      );
    }).toList();
    log("displayedSearchProperties ${displayedSearchProperties.length}");
  }

  Future<void> fetchAccount({
    required String userId,
  }) async {
    _currentUser = await NetworkLayer.fetchAccount(userId);
    notifyListeners();
  }

  Future<void> search(String query) async {
    log("fetching properties");
    displayedSearchProperties = await NetworkLayer.searchProperties(query);
    notifyListeners();
  }

  Future<void> fetchSavedProperties() async {
    _likedProperties = await NetworkLayer.queryProperties(
      NetworkLayer.savedPropertyQuery,
    );
    notifyListeners();
  }

  Future<User?> updateUser(User user) async {
    return await NetworkLayer.updateUser(
      user,
    );
  }

  Future<void> validateView({
    required String userId,
    required String propertyId,
  }) async {
    await NetworkLayer.validateView(
      userId: userId,
      propertyId: propertyId,
    );
    notifyListeners();
  }

  Future<Property?> updateProperty(Property property) async {
    return await NetworkLayer.updateProperty(property);
  }

  void filterProperties(bool Function(Property) test) {
    _filteredProperties = _properties
        .where((property) => test(property))
        .toList();
    log("${_filteredProperties.length}");
    notifyListeners();
  }

  Future<void> createProperty() async {
    await NetworkLayer.createProperty(uploadProperty);
    await getProperties();
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
  String id;
  int views;
  double lat, lng, rating;
  String title,
      location,
      price,
      bedrooms,
      bathrooms,
      area,
      type,
      description,
      contactName,
      contactNumber,
      contactEmail;
  List<String> features;

  Property({
    this.id = "",
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
    required this.lat,
    required this.lng,
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
    "lat": lat,
    "lng": lng,
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
    lat: json["lat"],
    lng: json["lng"],
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
    double? rating,
    String? bedrooms,
    String? bathrooms,
    String? area,
    String? type,
    int? views,
    String? description,
    String? contactName,
    String? contactNumber,
    String? contactEmail,
    double? lng,
    double? lat,
    List<String>? features,
  }) => Property(
    lng: lng ?? this.lng,
    lat: lat ?? this.lat,
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

class User {
  String firstName, lastName, email, phoneNumber, password, id;
  String? profilePicUrl;
  double? reviews;
  int? saved;
  int? listed;
  int? views;
  List<String>? likedProperties;

  User({
    this.views,
    this.reviews,
    this.saved,
    this.listed,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.password,
    this.profilePicUrl,
    this.likedProperties,
    this.id = "",
  });

  Map<String, dynamic> toJson() => {
    "_id": id,
    "firstName": firstName,
    "lastName": lastName,
    "email": email,
    "phoneNumber": phoneNumber,
    "password": password,
    "profilePicUrl": profilePicUrl,
    "likedProperties": likedProperties,
  };

  static User fromJson(Map<String, dynamic> json) => User(
    id: json["_id"],
    firstName: json["firstName"],
    lastName: json["lastName"],
    email: json["email"],
    phoneNumber: json["phoneNumber"],
    password: json["password"],
    profilePicUrl: json["profilePicUrl"],
    likedProperties: List<String>.from(json["likedProperties"]),
  );

  User copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? email,
    String? phoneNumber,
    String? password,
    String? profilePicUrl,
    List<String>? likedProperties,
  }) => User(
    id: id ?? this.id,
    firstName: firstName ?? this.firstName,
    lastName: lastName ?? this.lastName,
    email: email ?? this.email,
    phoneNumber: phoneNumber ?? this.phoneNumber,
    password: password ?? this.password,
    profilePicUrl: profilePicUrl ?? this.profilePicUrl,
    likedProperties: likedProperties ?? this.likedProperties,
  );
}

enum SortOptions {
  priceLow("Price low"),
  priceHigh("Price high"),
  rating("Rating");
  // newest("Newest first");

  final String option;

  const SortOptions(this.option);
}

enum PropertyType {
  forRent("For rent"),
  forSale("For sale");

  final String type;

  const PropertyType(this.type);
}
