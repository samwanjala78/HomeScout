import 'dart:io';

import 'package:collection/collection.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:real_estate/main.dart';

import '../../data/viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:real_estate/UI/ui.dart';
import 'package:real_estate/constants/ui_constants.dart';

import '../../network/network_util.dart';
import '../../util/util.dart';

part 'contact_information.dart';

part 'basic_information.dart';

part 'property_features.dart';

part 'upload_flow.dart';

part 'upload_photos.dart';

List<bool> isFeatureSelected = List.generate(
  Feature.values.length,
  (_) => false,
);
