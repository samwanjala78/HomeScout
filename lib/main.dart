import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:real_estate/UI/main_pages/detail.dart';
import 'package:real_estate/UI/main_pages/home.dart';
import 'package:real_estate/UI/main_pages/saved.dart';
import 'package:real_estate/UI/main_pages/search.dart';
import 'package:real_estate/UI/onboarding/profile_setup.dart';
import 'package:real_estate/UI/upload/upload_flow_library.dart';
import 'package:real_estate/constants/ui_constants.dart';
import 'package:real_estate/data/viewmodel.dart';

import 'UI/onboarding/landing_page.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

BuildContext? get globalBuildContext => navigatorKey.currentContext;

const signInPath = '/sign_in_page';
const homePath = '/homepage';
const searchPath = '/search_path';
const savedPath = '/saved_path';
const detailPath = '/detail_path';
const basicInfoPath = '/basic_info_path';
const featuresPath = '/features_path';
const uploadPhotosPath = '/upload_photos_path';
const contactInfoPath = '/contact_info_path';
const profileSetupPath = '/profile_setup_path';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    ChangeNotifierProvider(
      create: (context) {
        return PropertiesViewModel();
      },
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final router = GoRouter(
    initialLocation: signInPath,
    routes: [
      GoRoute(
        path: signInPath,
        pageBuilder: (context, state) => MaterialPage(child: SignInPage()),
      ),
      GoRoute(
        path: profileSetupPath,
        pageBuilder: (context, state) => MaterialPage(child: ProfileSetupPage()),
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
            path: searchPath,
            pageBuilder: (context, state) => MaterialPage(child: SearchPage()),
          ),
          GoRoute(
            path: savedPath,
            pageBuilder: (context, state) => MaterialPage(child: SavedPage()),
          ),
        ],
      ),
      GoRoute(
        path: detailPath,
        pageBuilder: (context, state) => MaterialPage(child: DetailPage()),
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
    ],
    navigatorKey: navigatorKey,
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: ThemeData(
        textTheme: GoogleFonts.latoTextTheme(ThemeData.light().textTheme),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        textTheme: GoogleFonts.latoTextTheme(ThemeData.dark().textTheme),
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

class _MainScaffoldState extends State<MainScaffold> {
  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();

    if (location.contains(homePath)) {
      _index = 0;
    } else if (location.contains(searchPath)) {
      _index = 1;
    } else if (location.contains(savedPath)) {
      _index = 2;
    }

    Color scaffoldBackground = Theme.of(context).scaffoldBackgroundColor;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text("Real Estate App"),
        backgroundColor: scaffoldBackground.withValues(alpha: 0.4),
        actions: [IconButton(icon: Icon(notificationIcon), onPressed: () {})],
        flexibleSpace: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(color: Colors.transparent),
          ),
        ),
      ),
      extendBodyBehindAppBar: true,
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          splashFactory: NoSplash.splashFactory,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: BottomNavigationBar(
          currentIndex: _index,
          type: BottomNavigationBarType.fixed,
          showUnselectedLabels: true,
          selectedItemColor: context.brightness == Brightness.dark
              ? Colors.white
              : Colors.black,
          unselectedItemColor: Colors.grey,
          onTap: (index) {
            if (index == 0) {
              context.pushReplacement(homePath);
            } else if (index == 1) {
              context.pushReplacement(searchPath);
            } else if (index == 2) {
              context.pushReplacement(savedPath);
            }
          },
          items: [
            BottomNavigationBarItem(icon: Icon(homeIcon), label: "Home"),

            BottomNavigationBarItem(icon: Icon(searchIcon), label: "Search"),

            BottomNavigationBarItem(icon: Icon(favoriteIcon), label: "Saved"),

            BottomNavigationBarItem(icon: Icon(personIcon), label: "Profile"),
          ],
        ),
      ),
      body: widget.body,
    );
  }
}
