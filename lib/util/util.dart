import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart'
    hide PermissionStatus;
import 'package:real_estate/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/ui_constants.dart';
import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

final storage = FlutterSecureStorage();

Future<List<XFile?>> compressImage(List<File> files) async {
  List<XFile?> results = [];

  for (var file in files) {
    final dir = await getTemporaryDirectory();
    final targetPath = "${dir.path}/${basename(file.path)}_compressed.jpg";

    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: 70,
    );

    results.add(result);
  }

  return results;
}

Future<User?> handleSignIn() async {
  if (GoogleSignIn.instance.supportsAuthenticate()) {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn.instance;

      await googleSignIn.initialize(
        serverClientId:
            "35080383076-enbv125vkao2bqrs7e3l6bal4vjo48gf.apps.googleusercontent.com",
      );

      final GoogleSignInAccount googleSignInAccount = await googleSignIn
          .authenticate();

      final credential = GoogleAuthProvider.credential(
        idToken: googleSignInAccount.authentication.idToken,
      );

      final UserCredential userCredential = await FirebaseAuth.instance
          .signInWithCredential(credential);

      Fluttertoast.showToast(
        msg: "Sign in success!",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0,
      );

      return userCredential.user;
    } catch (error) {
      Fluttertoast.showToast(
        msg: "Google sign-in error: $error",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return null;
    }
  } else {
    return null;
  }
}

SvgPicture loadSVG(
  String path, {
  Color? color,
  double? width,
  double? height,
  bool lightDarkIcon = true,
  required BuildContext context,
}) {
  return lightDarkIcon
      ? SvgPicture.asset(
          path,
          width: width ?? context.getBottomIconSize,
          height: height ?? context.getBottomIconSize,
          colorFilter: ColorFilter.mode(
            color ??
                (context.getBrightness == Brightness.dark
                    ? Colors.white
                    : Colors.black),
            BlendMode.srcIn,
          ),
        )
      : SvgPicture.asset(
          path,
          width: width ?? context.getBottomIconSize,
          height: height ?? context.getBottomIconSize,
        );
}

void navigate({required String path, dynamic extra}) {
  globalBuildContext?.push(path, extra: extra);
}

final ImagePicker _picker = ImagePicker();

Future<XFile?> pickImageFromCamera() async {
  return await _picker.pickImage(source: ImageSource.camera);
}

Future<XFile?> pickImageFromGallery() async {
  return await _picker.pickImage(source: ImageSource.gallery);
}

Future<List<XFile>> pickImagesFromGallery() async {
  return await _picker.pickMultiImage(limit: 10);
}

Future<void> requestCameraPermission({required Function isGranted}) async {
  var status = await Permission.camera.status;

  if (status.isDenied) {
    status = await Permission.camera.request();
  }

  if (status.isGranted) {
    isGranted();
  } else if (status.isPermanentlyDenied) {
    openAppSettings();
  }
}

class CurrencyInputFormatter extends TextInputFormatter {
  final NumberFormat _formatter;

  // final NumberFormat _formatter = NumberFormat.currency(
  //   locale: localeString,
  //   symbol: currencyFormat.currencySymbol,
  //   decimalDigits: 0,
  // );

  CurrencyInputFormatter(this._formatter);

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    }

    final digitsOnly = newValue.text.replaceAll(RegExp('[^0-9]'), '');

    final number = double.tryParse(digitsOnly) ?? 0;

    final newText = _formatter.format(number);

    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}

Future<File> copyAssetToFile(String assetPath, String filename) async {
  final byteData = await rootBundle.load(assetPath);

  final dir = await getApplicationDocumentsDirectory();

  final file = File('${dir.path}/$filename');

  await file.writeAsBytes(
    byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes),
  );

  return file;
}

Future<bool> isTokenValid() async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('jwt_token');
  if (token == null) return false;
  return true;

  // return await validateToken(token, onError: onError);

  // if (JwtDecoder.isExpired(token)) return false;

  // final resp = await http.get(Uri.parse('https://api.example.com/verify'),
  //     headers: {'Authorization': 'Bearer $token'});
  // return resp.statusCode == 200;
}

Future<LocationData?> getCurrentLocation() async {
  Location location = Location();

  bool serviceEnabled = await location.serviceEnabled();
  if (!serviceEnabled) {
    serviceEnabled = await location.requestService();
    if (!serviceEnabled) {
      log("User refused to enable location.");
      return null;
    }
  }

  PermissionStatus permissionGranted = await location.hasPermission();
  if (permissionGranted == PermissionStatus.denied) {
    permissionGranted = await location.requestPermission();
    if (permissionGranted != PermissionStatus.granted) {
      log("User denied location permission.");
      return null;
    }
  }

  LocationData currentLocation = await location.getLocation();
  return currentLocation;
}

Future<void> openMapAtMarker(double lat, double lng, {String? label}) async {
  final encodedLabel = Uri.encodeComponent(label ?? 'Location');

  if (Platform.isIOS) {
    final appleUrl = Uri.parse(
      'https://maps.apple.com/?q=$encodedLabel&ll=$lat,$lng',
    );
    await launchUrl(appleUrl, mode: LaunchMode.externalApplication);
  } else {
    final googleUrl = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$lat,$lng',
    );
    await launchUrl(googleUrl, mode: LaunchMode.externalApplication);
  }
}

extension CurrencyParsing on String {
  int convertPriceToInt() {
    String numericString = replaceAll(RegExp('[^0-9]'), '');

    return int.parse(numericString);
  }
}


