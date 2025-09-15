import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../data/viewmodel.dart';



final fadeFactor = 0.6;

extension TextThemeHelpers on BuildContext {
  Color? get fadedIconColor => Theme.of(this).textTheme.bodyMedium?.color?.withValues(alpha: fadeFactor);
  String get localeString => Localizations.localeOf(this).toString();
  Brightness get brightness => Theme.of(this).brightness;
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;
  TextStyle? get bodyMedium => Theme.of(this).textTheme.bodyMedium;
  TextStyle? get bodyLarge => Theme.of(this).textTheme.bodyLarge;
  TextStyle? get bodySmall => Theme.of(this).textTheme.bodySmall;
  TextStyle? get titleMedium => Theme.of(this).textTheme.titleMedium;
  TextStyle? get titleSmall => Theme.of(this).textTheme.titleSmall;
  TextStyle? get titleLarge => Theme.of(this).textTheme.titleLarge;
  double? get getBottomIconSize =>  IconTheme.of(this).size;
}

final currencyFormat = NumberFormat.simpleCurrency(
  locale: 'en_KE',
  name: 'Ksh ',
);
double getTopCardWidth(double screenWidth) => 0.29 * screenWidth;
double getTopCardHeight(double screenHeight) => 0.2 * screenHeight;
double getImageHeight(double screenWidth, double screenHeight) =>
    screenWidth >= screenHeight ? screenWidth * 0.3 : screenHeight * 0.3;
double getTopIconHeight(double screenHeight) => screenHeight * 0.05;
double getTopIconWidth(double screenWidth) => screenWidth * 0.1;
final Size imageRes = Size(200, 200);

const globalPadding = EdgeInsets.symmetric(
  vertical: 50.0,
  horizontal: paddingValue,
);
const elevation = 10.0;
const paddingValue = 16.0, radius = 16.0;
const paddingValueAll = EdgeInsets.all(paddingValue);
const animationDuration = 400;
final surfaceColor = Colors.grey.withValues(alpha: 0.2);
final cardColor = Colors.lightBlue[10]?.withValues(alpha: 0.5);
final iconColor = Colors.black;
final fit = BoxFit.cover;
final filterQualityHigh = FilterQuality.high;
final seedColor = Colors.blue.shade100;

final filterIcon = Icons.filter_alt_outlined;
final notificationIcon = Icons.notifications_outlined;
final homeIcon = Icons.home_filled;
final searchIcon = Icons.search_outlined;
final favoriteIcon = Icons.favorite_outlined;
final personIcon = Icons.person_outlined;
final moneyIcon = Icons.money_off_csred_outlined;
final facebookIcon = Icons.facebook_outlined;
final arrowBack = Icons.arrow_back_outlined;
final done = Icons.done_outlined;
final arrowFoward = Icons.arrow_forward_outlined;
final arrowBackAlt = Icons.arrow_back_ios_new_outlined;
final arrowFowardAlt = Icons.arrow_forward_ios_outlined;
final bed = Icons.bed_outlined;
final filter = Icons.filter_alt_outlined;
final grid = Icons.grid_on_outlined;
final maps = Icons.map_outlined;
final star = Icons.star;
final location = Icons.location_on_outlined;
final eye = Icons.remove_red_eye_outlined;
final bath = Icons.bathtub_outlined;
final area = Icons.crop_square_rounded;
final security = Icons.security;
final wifi = Icons.wifi_outlined;
final pool = Icons.pool_outlined;
final battery = Icons.battery_charging_full_outlined;
final city = Icons.location_city_outlined;
final forest = Icons.forest_outlined;
final camera = Icons.camera_alt_outlined;
final gallery = Icons.image_outlined;
final imageMissing = Icons.image_not_supported_outlined;
