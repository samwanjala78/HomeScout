import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:retry/retry.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../UI/ui.dart';
import '../data/viewmodel.dart';
import '../util/util.dart';

enum Queries { liked, location, title }

enum Method { get, post, put, delete }

final String _baseUrl = "https://propertiesbackend.onrender.com";

class _NetworkLayer {
  final String _propertiesUrl = "$_baseUrl/properties";
  final String _searchProperties = "$_baseUrl/search?q=";
  final String _registerUrl = "$_baseUrl/register";
  final String _loginUrl = "$_baseUrl/login";
  final String _userUrl = "$_baseUrl/user";
  final String _validateTokenUrl = "$_baseUrl/validate";
  final String _viewsUrl = "$_baseUrl/views";
  final String _accountLookUpUrl = "$_baseUrl/userAcc";
  final String _countUrl = "$_baseUrl/properties/count";

  final String savedPropertyQuery = "${Queries.liked.name}=true";

  final _client = http.Client();
  final _retryOptions = const RetryOptions(
    maxAttempts: 3,
    delayFactor: Duration(seconds: 2),
  );

  Future<dynamic> request(
    String url, {
    required Method method,
    Map<String, String> headers = const {'Content-Type': 'application/json'},
    Map<String, dynamic>? body,
  }) async {
    try {
      final response = await _retryOptions.retry(() async {
        late http.Response res;

        final uri = Uri.parse(url);

        switch (method) {
          case Method.post:
            res = await _client
                .post(uri, headers: headers, body: jsonEncode(body))
                .timeout(const Duration(seconds: 10));
            break;
          case Method.put:
            res = await _client
                .put(uri, headers: headers, body: jsonEncode(body))
                .timeout(const Duration(seconds: 10));
            break;
          case Method.delete:
            res = await _client
                .delete(uri, headers: headers)
                .timeout(const Duration(seconds: 10));
            break;
          default:
            res = await _client
                .get(uri, headers: headers)
                .timeout(const Duration(seconds: 10));
        }

        if (res.statusCode >= 200 && res.statusCode < 300) {
          return res;
        } else {
          throw HttpException('Bad status code: ${res.statusCode}');
        }
      });

      if (response.body.isEmpty) return null;
      return jsonDecode(response.body);
    } on SocketException {
      log('No internet connection.');
      return {'error': 'No internet connection'};
    } on TimeoutException {
      log('Request timed out.');
      return {'error': 'Request timed out'};
    } on HttpException catch (e) {
      log('Server error: $e');
      return {'error': e.message};
    } catch (e) {
      log('Unexpected error: $e');
      return {'error': e.toString()};
    }
  }

  Future<List<String>?> uploadImageToCloudinary(List<File> imageFiles) async {
    List<String> urls = [];

    List<XFile?> compressedImage = await compressImage(imageFiles);

    for (var imageFile in compressedImage) {
      final request = http.MultipartRequest(
        "POST",
        Uri.parse("$_baseUrl/upload"),
      );

      request.files.add(
        await http.MultipartFile.fromPath(
          "image",
          imageFile!.path,
          filename: basename(imageFile.path),
        ),
      );

      http.StreamedResponse? response;

      try {
        response = await _retryOptions.retry(
          () async => await request.send(),
          retryIf: (e) =>
              e is http.ClientException ||
              e is TimeoutException ||
              e is SocketException,
        );
      } on TimeoutException catch (e) {
        log('Request timed out: $e');
        toast('Request timed out');
      } on SocketException catch (e) {
        log('Network error: $e');
        toast('Network error');
      } on http.ClientException catch (e) {
        log('HTTP client error: $e');
        toast('HTTP client error');
      } catch (e) {
        log('Unexpected error: $e');
        toast('Unexpected error');
      }

      if (response?.statusCode == 200) {
        final responseData = await http.Response.fromStream(response!);
        final data = jsonDecode(responseData.body);
        log(responseData.body);
        final url = data['url'];
        urls.add(url);
      }

      log("upload image response: ${response?.statusCode}");
    }

    return urls;
  }

  Future<Property?> createProperty(Property property) async {
    final body = await request(
      _propertiesUrl,
      body: property.toJson(),
      method: Method.post,
    );

    return Property.fromJson(body);
  }

  Future<List<Property>> getProperties() async {
    List<dynamic> body = await request(_propertiesUrl, method: Method.get);
    return body.map((property) => Property.fromJson(property)).toList();
  }

  Future<int> getCount() async {
    Map<String, dynamic> body = await request(_countUrl, method: Method.get);
    return body["count"];
  }

  Future<List<Property>> searchProperties(String query) async {
    List<dynamic> body = await request(
      _searchProperties + query,
      method: Method.get,
    );
    return body.map((property) => Property.fromJson(property)).toList();
  }

  Future<List<Property>> queryProperties(String queries) async {
    List<dynamic> body = await request(
      "$_propertiesUrl?$queries",
      method: Method.get,
    );
    return body.map((property) => Property.fromJson(property)).toList();
  }

  Future<Property?> updateProperty(Property property) async {
    Map<String, dynamic> body = await request(
      "$_propertiesUrl/${property.id}",
      body: property.toJson(),
      method: Method.put,
    );

    return Property.fromJson(body);
  }

  Future<void> deleteProperty(String id) async {
    await request("$_propertiesUrl/$id", method: Method.delete);
  }

  Future<User?> signUp(User user) async {
    Map<String, dynamic> body = await request(
      _registerUrl,
      body: user.toJson(),
      method: Method.post,
    );

    final String token = body["token"];

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('jwt_token', token);

    Map<String, dynamic> userJson = body['user'];

    User responseUser = User.fromJson(userJson);

    await prefs.setString("userId", responseUser.id);

    return user;
  }

  Future<User?> signIn({
    required String userEmail,
    required String userPassword,
  }) async {
    Map<String, dynamic> body = await request(
      _loginUrl,
      body: {"email": userEmail, "password": userPassword},
      method: Method.post,
    );

    final String token = body['token'];

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('jwt_token', token);

    Map<String, dynamic> userJson = body['user'];

    User user = User.fromJson(userJson);

    await prefs.setString("userId", user.id);

    return user;
  }

  Future<User?> updateUser(User user) async {
    Map<String, dynamic> body = await request(
      "$_userUrl/${user.id}",
      body: user.toJson(),
      method: Method.put,
    );

    return User.fromJson(body);
  }

  Future<User?> getUserByEmail(String email) async {
    Map<String, dynamic> body = await request(
      "$_userUrl/${email.trim().toLowerCase()}",
      method: Method.get,
    );

    return User.fromJson(body);
  }

  Future<Property?> validateView({
    required String userId,
    required String propertyId,
  }) async {
    Map<String, dynamic> body = await request(
      _viewsUrl,
      body: {"userId": userId, "propertyId": propertyId},
      method: Method.post,
    );

    return Property.fromJson(body);
  }

  Future<String?> validateToken(String token) async {
    Map<String, dynamic> body = await request(
      _validateTokenUrl,
      headers: {"Authorization": "Bearer $token"},
      method: Method.get,
    );

    return body["userId"];
  }

  Future<String?> getNeighborhoodName({
    required double lat,
    required double lng,
  }) async {
    final url =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=AIzaSyDKK4M85kgFAlesaUhxrmdRBht8IQcV_xk';

    Map<String, dynamic> body = await request(url, method: Method.get);

    if (body['status'] == 'OK') {
      List results = body['results'];

      for (var result in results) {
        String locationType = result['geometry']['location_type'];
        if (locationType == "APPROXIMATE") {
          return result['formatted_address'];
        }
      }
    }
    return null;
  }

  Future<User?> fetchAccount(String userId) async {
    log("userId: $userId");
    Map<String, dynamic> body = await request(
      _accountLookUpUrl,
      body: {"userId": userId},
      method: Method.post,
    );

    log("body: $body");

    return User.fromJson(body["user"]);
  }
}

final NetworkLayer = _NetworkLayer();
