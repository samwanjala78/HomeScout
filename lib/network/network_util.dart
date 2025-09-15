import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

import '../data/viewmodel.dart';
import '../util/util.dart';

const String _baseUrl = "http://192.168.100.4:3000/properties";
const String _signUpUrl = "http://192.168.100.4:3000/register";
const String _signInUrl = "http://192.168.100.4:3000/login";

Future<List<String>?> uploadImageToCloudinary(List<File> imageFiles) async {
  List<String> urls = [];

  List<XFile?> compressedImage = await compressImage(imageFiles);

  for (var imageFile in compressedImage) {
    final request = http.MultipartRequest(
      "POST",
      Uri.parse("http://192.168.100.4:3000/upload"),
    );

    request.files.add(
      await http.MultipartFile.fromPath(
        "image",
        imageFile!.path,
        filename: basename(imageFile.path),
      ),
    );

    final response = await request.send();
    if (response.statusCode == 200) {
      log("message");
      final responseData = await http.Response.fromStream(response);
      final data = jsonDecode(responseData.body);
      log(responseData.body);
      final url = data['url'];
      urls.add(url);
    } else {
      Fluttertoast.showToast(
        msg: "Error uploading image(s)!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );

      return null;
    }
  }

  return urls;
}

Future<Property?> createProperty(Property property) async {
  final response = await http.post(
    Uri.parse(_baseUrl),
    headers: {"Content-Type": "application/json"},
    body: jsonEncode(property.toJson()),
  );

  if (response.statusCode == 201) {
    return Property.fromJson(jsonDecode(response.body));
  }
  log("Create failed: ${response.body}");
  return null;
}

Future<List<Property>> getProperties() async {
  try {
    final response = await http.get(Uri.parse(_baseUrl));
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((property) => Property.fromJson(property)).toList();
    }
    throw Exception("Failed to load properties");
  } on SocketException {
    return [];
  } catch (e) {
    return [];
  }
}

Future<List<Property>> queryProperties(String queries) async {
  final response = await http.get(Uri.parse("$_baseUrl?$queries"));
  if (response.statusCode == 200) {
    final List data = jsonDecode(response.body);
    return data.map((property) => Property.fromJson(property)).toList();
  }
  throw Exception("Failed to load properties");
}

Future<Property?> updateProperty(Property property) async {
  final response = await http.put(
    Uri.parse("$_baseUrl/${property.id}"),
    headers: {"Content-Type": "application/json"},
    body: jsonEncode(property.toJson()),
  );

  if (response.statusCode == 200) {
    return Property.fromJson(jsonDecode(response.body));
  }
  log("Update failed: ${response.body}");

  return null;
}

Future<bool> deleteProperty(String id) async {
  final response = await http.delete(Uri.parse("$_baseUrl/$id"));
  return response.statusCode == 204;
}

enum Queries { liked, location, title }

Future<User> signUp(User user) async {
  final response = await http.post(
    Uri.parse(_signUpUrl),
    headers: {"Content-Type": "application/json"},
    body: jsonEncode(user.toJson()),
  );

  return User.fromJson(jsonDecode(response.body));
}

Future<User> signIn(User user) async {
  final response = await http.post(
    Uri.parse(_signInUrl),
    headers: {"Content-Type": "application/json"},
    body: jsonEncode(user.toJson()),
  );

  return User.fromJson(jsonDecode(response.body));
}
