import 'dart:developer';
import 'dart:ui';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:real_estate/UI/main_pages/detail.dart';
import 'package:real_estate/UI/main_pages/home.dart';
import 'package:real_estate/UI/main_pages/profile.dart';
import 'package:real_estate/UI/main_pages/saved.dart';
import 'package:real_estate/UI/main_pages/search.dart';
import 'package:real_estate/UI/onboarding/profile_setup.dart';
import 'package:real_estate/UI/onboarding/reset_password.dart';
import 'package:real_estate/UI/onboarding/reset_password_email.dart';
import 'package:real_estate/UI/ui.dart';
import 'package:real_estate/UI/upload/search_location.dart';
import 'package:real_estate/UI/upload/upload_flow_library.dart';
import 'package:real_estate/constants/ui_constants.dart';
import 'package:real_estate/data/viewmodel.dart';
import 'package:real_estate/util/util.dart';

import 'UI/onboarding/landing_page.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

BuildContext? get globalBuildContext => navigatorKey.currentContext;

const signInPath = '/sign_in_page';
const homePath = '/homepage';
const searchPagePath = '/search_page_path';
const savedPath = '/saved_path';
const detailPath = '/detail_path';
const detailMapPath = '/detail_map_path';
const searchPath = '/search_path';
const basicInfoPath = '/basic_info_path';
const featuresPath = '/features_path';
const uploadPhotosPath = '/upload_photos_path';
const contactInfoPath = '/contact_info_path';
const profileSetupPath = '/profile_setup_path';
const profilePath = '/profile_path';
const emailPath = '/email_path';
const resetPasswordPath = '/reset_password_path';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  PropertiesViewModel propertiesViewModel = PropertiesViewModel();

  bool tokenValid = await isTokenValid();

  runApp(
    ChangeNotifierProvider(
      create: (context) {
        return propertiesViewModel;
      },
      child: MyApp(viewmodel: propertiesViewModel, tokenValid: tokenValid),
    ),
  );
}

class MyApp extends StatelessWidget {
  late final GoRouter router;
  final PropertiesViewModel viewmodel;
  final bool tokenValid;

  MyApp({super.key, required this.viewmodel, required this.tokenValid}) {
    log("app started");
    router = GoRouter(
      initialLocation: tokenValid ? homePath : signInPath,
      routes: [
        GoRoute(
          path: signInPath,
          pageBuilder: (context, state) => MaterialPage(child: SignInPage()),
        ),
        GoRoute(
          path: emailPath,
          pageBuilder: (context, state) => MaterialPage(child: EmailPage()),
        ),
        GoRoute(
          path: resetPasswordPath,
          pageBuilder: (context, state) =>
              MaterialPage(child: ResetPasswordPage()),
        ),
        GoRoute(
          path: profileSetupPath,
          pageBuilder: (context, state) =>
              MaterialPage(child: ProfileSetupPage()),
        ),
        ShellRoute(
          builder: (context, state, child) {
            return MainScaffold(body: child);
          },
          routes: [
            GoRoute(
              path: homePath,
              pageBuilder: (context, state) => MaterialPage(child: HomePage()),
            ),
            GoRoute(
              path: searchPagePath,
              pageBuilder: (context, state) =>
                  MaterialPage(child: SearchPage()),
            ),
            GoRoute(
              path: savedPath,
              pageBuilder: (context, state) => MaterialPage(child: SavedPage()),
            ),
            GoRoute(
              path: profilePath,
              pageBuilder: (context, state) =>
                  MaterialPage(child: ProfilePage()),
            ),
          ],
        ),
        ShellRoute(
          builder: (context, state, child) {
            return UploadPage(body: child);
          },
          routes: [
            GoRoute(
              path: basicInfoPath,
              pageBuilder: (context, state) =>
                  MaterialPage(child: BasicInformation()),
            ),
            GoRoute(
              path: featuresPath,
              pageBuilder: (context, state) =>
                  MaterialPage(child: PropertyFeatures()),
            ),
            GoRoute(
              path: uploadPhotosPath,
              pageBuilder: (context, state) =>
                  MaterialPage(child: UploadPhotos()),
            ),
            GoRoute(
              path: contactInfoPath,
              pageBuilder: (context, state) =>
                  MaterialPage(child: ContactInformation()),
            ),
          ],
        ),
        GoRoute(
          path: detailPath,
          pageBuilder: (context, state) => MaterialPage(child: DetailPage()),
        ),
        GoRoute(
          path: searchPath,
          pageBuilder: (context, state) {
            return MaterialPage(child: SearchLocation());
          },
        ),
      ],
      navigatorKey: navigatorKey,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: ThemeData(
        textTheme: GoogleFonts.latoTextTheme(ThemeData.light().textTheme),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white.withValues(alpha: .8),
        ),
        colorScheme: ColorScheme.light(primary: Colors.blue),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.dark(primary: Colors.blue),
        scaffoldBackgroundColor: Colors.black12,
        textTheme: GoogleFonts.latoTextTheme(ThemeData.dark().textTheme),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.black.withValues(alpha: .8),
          surfaceTintColor: Colors.transparent,
        ),
        cardTheme: CardThemeData(
          color: Colors.black12,
          surfaceTintColor: Colors.white,
        ),
      ),
      themeMode: ThemeMode.system,
      routerConfig: router,
    );
  }
}

class MainScaffold extends StatefulWidget {
  final Widget body;

  const MainScaffold({super.key, required this.body});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

var _index = 0;
var _title = "";
List<bool> _isSelected = List.generate(4, (index) => index == 0);

class _MainScaffoldState extends State<MainScaffold> {
  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();

    if (location.contains(homePath)) {
      _index = 0;
    } else if (location.contains(searchPagePath)) {
      _index = 1;
    } else if (location.contains(savedPath)) {
      _index = 2;
    } else {
      _index = 3;
    }

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: blurredAppBar(
        title: Text(_title),
        actions: [IconButton(icon: Icon(notificationIcon), onPressed: () {})],
      ),
      extendBodyBehindAppBar: true,
      extendBody: true,
      bottomNavigationBar: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Theme(
            data: Theme.of(context).copyWith(
              splashFactory: NoSplash.splashFactory,
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
            ),
            child: BottomNavigationBar(
              elevation: 0,
              backgroundColor: context.getBrightness == Brightness.dark
                  ? Colors.black.withValues(alpha: 0.8)
                  : Colors.white.withValues(alpha: 0.8),
              currentIndex: _index,
              type: BottomNavigationBarType.fixed,
              showUnselectedLabels: true,
              selectedItemColor: context.getBrightness == Brightness.dark
                  ? Colors.blue.shade300
                  : Colors.blue.shade900,
              unselectedItemColor: context.getBrightness == Brightness.dark
                  ? Colors.white
                  : Colors.grey,
              onTap: (index) async {
                if (index == 0) {
                  _isSelected.forEachIndexed((isSelectedIndex, _) {
                    _isSelected[isSelectedIndex] = isSelectedIndex == index;
                  });
                  _title = "";
                  navigateToHomePage(context);
                } else if (index == 1) {
                  _isSelected.forEachIndexed((isSelectedIndex, _) {
                    _isSelected[isSelectedIndex] = isSelectedIndex == index;
                  });
                  context.pushReplacement(searchPagePath);
                  setState(() {
                    _title = "Search";
                  });
                } else if (index == 2) {
                  _isSelected.forEachIndexed((isSelectedIndex, _) {
                    _isSelected[isSelectedIndex] = isSelectedIndex == index;
                  });
                  _title = "Saved";
                  navigateToSavedPage(context);
                } else {
                  _isSelected.forEachIndexed((isSelectedIndex, _) {
                    _isSelected[isSelectedIndex] = isSelectedIndex == index;
                  });
                  _title = "Profile";
                  navigateToProfile(context);
                }
              },
              items: [
                BottomNavigationBarItem(
                  icon: buttonContainer(
                    Icon(homeIcon, fill: 1),
                    context,
                    _isSelected[0] ? null : Colors.transparent,
                  ),
                  label: "Home",
                ),

                BottomNavigationBarItem(
                  icon: buttonContainer(
                    Icon(searchIcon),
                    context,
                    _isSelected[1] ? null : Colors.transparent,
                  ),
                  label: "Search",
                ),

                BottomNavigationBarItem(
                  icon: buttonContainer(
                    Icon(favoriteIcon, fill: 1),
                    context,
                    _isSelected[2] ? null : Colors.transparent,
                  ),
                  label: "Saved",
                ),

                BottomNavigationBarItem(
                  icon: buttonContainer(
                    Icon(personIcon, fill: 1),
                    context,
                    _isSelected[3] ? null : Colors.transparent,
                  ),
                  label: "Profile",
                ),
              ],
            ),
          ),
        ),
      ),
      body: widget.body,
    );
  }
}
