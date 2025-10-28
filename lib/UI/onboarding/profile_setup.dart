import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
    Widget picture = ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: Image.file(
        File(viewModel.profilePic?.path ?? ""),
        fit: fit,
        errorBuilder: (context, error, stackTrace) {
          return Icon(Icons.person_outline_rounded);
        },
      ),
    );

    Widget profilePic = Container(
      decoration: BoxDecoration(
        color: context.backgroundColor,
        shape: BoxShape.circle,
      ),
      width: 160,
      height: 160,
      child: picture,
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
            "Help others recognize you by adding a profile picture. You can always change this later.",
            style: context.titleSmall,
            textAlign: TextAlign.center,
          ),
          VerticalSpacer(),
          SizedBox(
            width: context.getMaxWidth,
            child: customButton(
              children: [Icon(cameraIcon), Text("Take Photo")],
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
          ),
          SizedBox(
            width: context.getMaxWidth,
            child: customButton(
              children: [Icon(galleryIcon), Text("Choose from gallery")],
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
          ),
        ],
      ),
    );

    Widget bottomWidget = customButton(
      alignment: Alignment.bottomRight,
      onPressed: () async {
        final profilePic = viewModel.profilePic;
        if (profilePic != null) {
          setState(() {
            _isProfileUploading = true;
          });
          List<String>? profPicUrl = await NetworkLayer.uploadImageToCloudinary(
            [File(profilePic.path)],
          );
          if (profPicUrl != null) {
            viewModel.currentUser?.profilePicUrl = profPicUrl[0];
          }
          if (viewModel.currentUser != null) {
            viewModel.currentUser = await NetworkLayer.updateUser(
              viewModel.currentUser!,
            );
          }
          setState(() {
            _isProfileUploading = false;
          });
          if (viewModel.currentUser != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              context.go(homePath);
            });
          } else {
            toast("Something went wrong");
          }
        } else {
          toast("set profile photo");
        }
      },
      children: [Text("Continue"), Icon(arrowFowardIcon)],
    );

    Widget skipButton = customButton(
      children: [Text("Skip")],
      onPressed: () async {
        context.go(homePath);
      },
    );

    return Scaffold(
      appBar: AppBar(title: Text("Set profile picture"), actions: [skipButton]),
      persistentFooterAlignment: AlignmentDirectional.bottomEnd,
      persistentFooterButtons: [bottomWidget],
      body: SafeArea(
        child: Padding(
          padding: paddingValueAll,
          child: Stack(
            children: [
              contents,
              _isProfileUploading ? loadingIcon : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
