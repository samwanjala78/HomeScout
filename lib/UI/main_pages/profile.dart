import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/ui_constants.dart';
import '../../data/viewmodel.dart';
import '../../main.dart';
import '../../util/util.dart';
import '../ui.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {}
    });
  }

  @override
  Widget build(BuildContext context) {
    PropertiesViewModel viewModel = Provider.of<PropertiesViewModel>(context);

    Widget picture = ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: CachedNetworkImage(
        imageUrl: viewModel.currentUser?.profilePicUrl ?? "",
        fit: fit,
        errorWidget: (context, error, stackTrace) {
          return Icon(Icons.person);
        },
      ),
    );

    Widget profilePic = Align(
      alignment: Alignment.topCenter,
      child: SpacedColumn(
        padding: 0,
        children: [
          Container(
            decoration: BoxDecoration(
              color: context.backgroundColor,
              shape: BoxShape.circle,
            ),
            width: 160,
            height: 160,
            child: picture,
          ),
          Text(
            viewModel.currentUser?.firstName ?? "",
            style: context.titleLarge,
          ),
        ],
      ),
    );

    Widget propertyManagement = Card(
      child: Column(
        children: [
          ListTile(
            leading: Icon(addIcon, color: context.fadedIconColor),
            title: Text("List New Property"),
            trailing: Icon(arrowFowardAltIcon, color: context.fadedIconColor),
            onTap: () {
              navigate(path: basicInfoPath);
            },
          ),
          Divider(color: context.backgroundColor),
          ListTile(
            leading: Icon(homeIcon, color: context.fadedIconColor),
            title: Text("My Listings"),
            trailing: Icon(arrowFowardAltIcon, color: context.fadedIconColor),
          ),
          Divider(color: context.backgroundColor),
          ListTile(
            leading: Icon(eyeIcon, color: context.fadedIconColor),
            title: Text("Property Analytics"),
            trailing: Icon(arrowFowardAltIcon, color: context.fadedIconColor),
          ),
        ],
      ),
    );

    Widget accountManagement = Card(
      child: Column(
        children: [
          ListTile(
            leading: Icon(editIcon, color: context.fadedIconColor),
            title: Text("Edit Profile"),
            trailing: Icon(arrowFowardAltIcon, color: context.fadedIconColor),
          ),
          Divider(color: context.backgroundColor),
          ListTile(
            leading: Icon(paymentIcon, color: context.fadedIconColor),
            title: Text("Payment Methods"),
            trailing: Icon(arrowFowardAltIcon, color: context.fadedIconColor),
          ),
          Divider(color: context.backgroundColor),
          ListTile(
            leading: Icon(notificationIcon, color: context.fadedIconColor),
            title: Text("Notifications"),
            trailing: Switch(
              value: true,
              onChanged: (value) {
                setState(() {
                  // isToggled = value;
                });
              },
            ),
          ),
          Divider(color: context.backgroundColor),
          ListTile(
            leading: Icon(shieldIcon, color: context.fadedIconColor),
            title: Text("Privacy and Security"),
            trailing: Icon(arrowFowardAltIcon, color: context.fadedIconColor),
          ),
        ],
      ),
    );

    Widget preferences = Card(
      child: Column(
        children: [
          ListTile(
            leading: Icon(lightModeIcon, color: context.fadedIconColor),
            title: Text("Light Mode"),
            trailing: Switch(
              value: false,
              onChanged: (value) {
                setState(() {
                  // isToggled = value;
                });
              },
            ),
          ),
        ],
      ),
    );

    Widget support = Card(
      child: Column(
        children: [
          ListTile(
            leading: Icon(questionIcon, color: context.fadedIconColor),
            title: Text("Help Center"),
            trailing: Icon(arrowFowardAltIcon, color: context.fadedIconColor),
          ),
          Divider(color: context.backgroundColor),
          ListTile(
            leading: Icon(settingsIcon, color: context.fadedIconColor),
            title: Text("Settings"),
            trailing: Icon(arrowFowardAltIcon, color: context.fadedIconColor),
          ),
        ],
      ),
    );

    Widget logout = Card(
      child: Column(
        children: [
          ListTile(
            leading: Icon(logoutIcon, color: Colors.blue),
            title: Text("Log Out", style: TextStyle(color: Colors.blue)),
            onTap: () async {
              final prefs = await SharedPreferences.getInstance();
              prefs.remove('jwt_token');
              navigate(path: signInPath);
            },
          ),
        ],
      ),
    );

    return SingleChildScrollView(
      child: SpacedColumn(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          topSpacer(context),
          profilePic,
          Text("Property Management", style: context.titleMedium),
          propertyManagement,
          Text("Account Management", style: context.titleMedium),
          accountManagement,
          Text("Preferences", style: context.titleMedium),
          preferences,
          Text("Support", style: context.titleMedium),
          support,
          logout,
        ],
      ),
    );
  }
}

Future<void> navigateToProfile(BuildContext context) async {
  if (context.mounted) {
    context.pushReplacement(profilePath);
  }

  // PropertiesViewModel viewModel = Provider.of<PropertiesViewModel>(
  //   context,
  //   listen: false,
  // );
  //
  // if (viewModel.currentUser == null && viewModel.userId != null) {
  //   await viewModel.fetchAccount(userId: viewModel.userId!);
  // }
}
