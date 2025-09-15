import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:real_estate/UI/ui.dart';
import 'package:real_estate/constants/ui_constants.dart';
import 'package:real_estate/main.dart';
import 'package:real_estate/util/util.dart';
import '../../data/viewmodel.dart';
import '../../network/network_util.dart';

class ProfileSetupPage extends StatefulWidget {
  const ProfileSetupPage({super.key});

  @override
  State<ProfileSetupPage> createState() => _ProfileSetupPageState();
}

bool _isProfileUploading = false;

class _ProfileSetupPageState extends State<ProfileSetupPage> {
  @override
  Widget build(BuildContext context) {
    log("message");
    PropertiesViewModel viewModel = Provider.of<PropertiesViewModel>(context);
    Widget picture = ClipOval(
      child: Image.file(
        File(viewModel.profilePic?.path ?? ""),
        fit: fit,
        errorBuilder: (context, error, stackTrace) {
          return Icon(Icons.error);
        },
      ),
    );

    Widget profilePic = Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade500,
        shape: BoxShape.circle,
      ),
      width: context.screenWidth / 4,
      height: context.screenWidth / 4,
      child: viewModel.profilePic != null
          ? picture
          : Icon(Icons.person_outline_rounded),
    );

    Widget contents = SingleChildScrollView(
      child: SpacedColumn(
        padding: 0,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          profilePic,
          Text(
            "Add a profile picture",
            style: context.titleMedium,
            textAlign: TextAlign.center,
          ),
          FadedText(
            text:
                "Help others recognize you by adding a profile picture. You can always change this later.",
            style: context.titleSmall,
            textAlign: TextAlign.center,
          ),
          VerticalSpacer(),
          customButton(
            children: [Icon(camera), Text("Take Photo")],
            onPressed: () {
              requestCameraPermission(
                isGranted: () async {
                  viewModel.profilePic = await pickImageFromCamera();
                },
              );
            },
            mainAxisSize: MainAxisSize.max,
            innerPadding: paddingValue,
          ),
          customButton(
            children: [Icon(gallery), Text("Choose from gallery")],
            onPressed: () {
              requestCameraPermission(
                isGranted: () async {
                  viewModel.profilePic = await pickImageFromGallery();
                },
              );
            },
            mainAxisSize: MainAxisSize.max,
            innerPadding: paddingValue,
          ),
        ],
      ),
    );

    Widget header = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("Set profile picture", style: context.titleLarge),
        customButton(
          children: [Text("Skip")],
          onPressed: () async {
            viewModel.currentUser?.profilePicUrl = null;
            if (viewModel.currentUser != null) {
              setState(() {
                _isProfileUploading = true;
              });
              viewModel.currentUser = await signUp(viewModel.currentUser!);
              setState(() {
                _isProfileUploading = false;
              });
            }
          },
        ),
      ],
    );

    Widget bottomWidget = customButton(
      alignment: Alignment.bottomRight,
      onPressed: () async {
        final profilePic = viewModel.profilePic;
        if (profilePic != null) {
          setState(() {
            _isProfileUploading = true;
          });
          List<String>? profPicUrl = await uploadImageToCloudinary([
            File(profilePic.path),
          ]);
          if (profPicUrl != null) {
            viewModel.currentUser?.profilePicUrl = profPicUrl[0];
          }
          if (viewModel.currentUser != null) {
            viewModel.currentUser = await signUp(viewModel.currentUser!);
          }
          setState(() {
            _isProfileUploading = false;
          });
          WidgetsBinding.instance.addPostFrameCallback((_) {
            navigate(path: homePath);
          });
        } else {
          Fluttertoast.showToast(
            msg: "Error uploading image!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0,
          );
        }
      },
      children: [Text("Continue"), Icon(arrowFoward)],
    );

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: paddingValueAll,
          child: Stack(
            children: [
              Column(children: [header, VerticalSpacer(), contents]),
              bottomWidget,
              _isProfileUploading ? loadingIcon : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
