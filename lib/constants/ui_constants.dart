import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../UI/ui.dart';

NumberFormat currencyFormat = NumberFormat.simpleCurrency(
  locale: 'en_KE',
  name: 'Ksh ',
);

const double _maxWidth = 700,
    _maxHeight = 1080,
    textPlaceholderHeight = 14,
    paddingValue = 8.0,
    radiusValue = 8.0,
    spacingValue = 16.0;
const Size imageRes = Size(200, 200);
const int pageTransitionDuration = 300;
const paddingValueAll = EdgeInsets.all(paddingValue);
const paddingValueHorizontal = EdgeInsets.symmetric(horizontal: paddingValue);
const fit = BoxFit.cover;

double getTopCardWidth(double screenWidth) => 0.29 * screenWidth;

double getTopCardHeight(double screenHeight) => 0.2 * screenHeight;

double getTopIconWidth(double screenWidth) => screenWidth * 0.1;

extension CustomHelpers on BuildContext {
  Brightness get getBrightness => Theme.of(this).brightness;

  Color get backgroundOverlay => Colors.blue;

  Color get backgroundColor => Color(0xFF121212);

  Color get tintedBackgroundColor =>
      blendColors(backgroundColor, backgroundOverlay);

  Color get highlightColor => Colors.blue.shade900;

  double get alpha => Theme.of(this).brightness == Brightness.dark ? 0.1 : 0.3;

  double get getMaxWidth => screenWidth > _maxWidth ? _maxWidth : screenWidth;

  Color? get fadedIconColor =>
      Theme.of(this).textTheme.bodyMedium?.color?.withValues(alpha: 0.6);

  String get localeString => Localizations.localeOf(this).toString();

  double get screenWidth => MediaQuery.of(this).size.width;

  double get screenHeight => MediaQuery.of(this).size.height;

  TextStyle? get bodyMedium => Theme.of(this).textTheme.bodyMedium;

  TextStyle? get bodyLarge => Theme.of(this).textTheme.bodyLarge;

  TextStyle? get bodySmall => Theme.of(this).textTheme.bodySmall;

  TextStyle? get titleMedium => Theme.of(this).textTheme.titleMedium;

  TextStyle? get titleSmall => Theme.of(this).textTheme.titleSmall;

  TextStyle? get titleLarge => Theme.of(this).textTheme.titleLarge;

  double? get getBottomIconSize => IconTheme.of(this).size;

  double get getTopIconHeight => screenHeight > _maxHeight ? 60 : 30;

  double get getTopIconWidth => screenWidth > _maxWidth ? 60 : 30;

  double get getImageHeight => screenHeight > _maxHeight ? 600 : 200;

  Color get getSurfaceColor => Theme.of(this).colorScheme.surface;
}

const IconData filterIcon = Symbols.tune_rounded,
    apartmentIcon = Symbols.apartment_rounded,
    editIcon = Symbols.edit_rounded,
    lightModeIcon = Symbols.light_mode_rounded,
    questionIcon = Symbols.question_mark_rounded,
    settingsIcon = Symbols.settings_rounded,
    logoutIcon = Symbols.logout_rounded,
    shieldIcon = Symbols.shield_rounded,
    paymentIcon = Symbols.payment_rounded,
    cancelIcon = Symbols.cancel_rounded,
    addIcon = Symbols.add_rounded,
    myLocation = Symbols.my_location_rounded,
    notificationIcon = Symbols.notifications_rounded,
    homeIcon = Symbols.home_rounded,
    sortIcon = Symbols.sort_rounded,
    searchIcon = Symbols.search_rounded,
    favoriteIcon = Symbols.favorite_rounded,
    personIcon = Symbols.person_outline_rounded,
    moneyIcon = Symbols.attach_money_rounded,
    facebookIcon = Icons.facebook_outlined,
    arrowBack = Symbols.arrow_back_rounded,
    doneIcon = Symbols.done_rounded,
    arrowFowardIcon = Symbols.arrow_forward_rounded,
    arrowBackAltIcon = Symbols.arrow_back_ios_rounded,
    arrowFowardAltIcon = Symbols.arrow_forward_ios,
    bedIcon = Symbols.bed_rounded,
    listIcon = Symbols.list,
    mapsIcon = Symbols.map_rounded,
    starIcon = Symbols.star_rounded,
    locationIcon = Symbols.location_on_rounded,
    eyeIcon = Symbols.remove_red_eye_rounded,
    bathIcon = Symbols.bathtub_rounded,
    areaIcon = Symbols.square_foot_rounded,
    securityIcon = Symbols.security_rounded,
    wifiIcon = Symbols.wifi_rounded,
    poolIcon = Symbols.pool_rounded,
    batteryIcon = Symbols.battery_charging_full_rounded,
    cityIcon = Symbols.location_city_rounded,
    forestIcon = Symbols.forest_rounded,
    cameraIcon = Symbols.camera_alt_rounded,
    galleryIcon = Symbols.image_rounded,
    imageMissingIcon = Symbols.image_not_supported_rounded;
