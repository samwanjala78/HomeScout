import 'dart:developer';
import 'dart:ui';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:real_estate/util/util.dart';
import 'UI/main_pages/detail.dart';
import 'UI/main_pages/home.dart';
import 'UI/main_pages/profile.dart';
import 'UI/main_pages/saved.dart';
import 'UI/main_pages/search.dart';
import 'UI/onboarding/landing_page.dart';
import 'UI/onboarding/profile_setup.dart';
import 'UI/onboarding/reset_password.dart';
import 'UI/onboarding/reset_password_email.dart';
import 'UI/ui.dart';
import 'UI/upload/search_location.dart';
import 'UI/upload/upload_flow_library.dart';
import 'constants/ui_constants.dart';
import 'data/viewmodel.dart';

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
          pageBuilder: (context, state) => CustomTransitionPage(
            transitionDuration: const Duration(
              milliseconds: pageTransitionDuration,
            ),
            child: SignInPage(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  final offsetAnimation = Tween<Offset>(
                    begin: const Offset(0, 1),
                    end: Offset.zero,
                  ).animate(animation);

                  return SlideTransition(
                    position: offsetAnimation,
                    child: child,
                  );
                },
          ),
        ),
        GoRoute(
          path: emailPath,
          pageBuilder: (context, state) => CustomTransitionPage(
            transitionDuration: const Duration(
              milliseconds: pageTransitionDuration,
            ),
            child: EmailPage(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  final offsetAnimation = Tween<Offset>(
                    begin: const Offset(0, 1),
                    end: Offset.zero,
                  ).animate(animation);

                  return SlideTransition(
                    position: offsetAnimation,
                    child: child,
                  );
                },
          ),
        ),
        GoRoute(
          path: resetPasswordPath,
          pageBuilder: (context, state) => CustomTransitionPage(
            transitionDuration: const Duration(
              milliseconds: pageTransitionDuration,
            ),
            child: ResetPasswordPage(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  final offsetAnimation = Tween<Offset>(
                    begin: const Offset(0, 1),
                    end: Offset.zero,
                  ).animate(animation);

                  return SlideTransition(
                    position: offsetAnimation,
                    child: child,
                  );
                },
          ),
        ),
        GoRoute(
          path: profileSetupPath,
          pageBuilder: (context, state) => CustomTransitionPage(
            transitionDuration: const Duration(
              milliseconds: pageTransitionDuration,
            ),
            child: ProfileSetupPage(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  final offsetAnimation = Tween<Offset>(
                    begin: const Offset(0, 1),
                    end: Offset.zero,
                  ).animate(animation);

                  return SlideTransition(
                    position: offsetAnimation,
                    child: child,
                  );
                },
          ),
        ),
        ShellRoute(
          builder: (context, state, child) {
            return MainScaffold(body: child);
          },
          routes: [
            GoRoute(
              path: homePath,
              pageBuilder: (context, state) => CustomTransitionPage(
                transitionDuration: const Duration(
                  milliseconds: pageTransitionDuration,
                ),
                child: HomePage(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                      final offsetAnimation = Tween<Offset>(
                        begin: const Offset(0, 1),
                        end: Offset.zero,
                      ).animate(animation);

                      return SlideTransition(
                        position: offsetAnimation,
                        child: child,
                      );
                    },
              ),
            ),
            GoRoute(
              path: searchPagePath,
              pageBuilder: (context, state) => CustomTransitionPage(
                transitionDuration: const Duration(
                  milliseconds: pageTransitionDuration,
                ),
                child: SearchPage(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                      final offsetAnimation = Tween<Offset>(
                        begin: const Offset(0, 1),
                        end: Offset.zero,
                      ).animate(animation);

                      return SlideTransition(
                        position: offsetAnimation,
                        child: child,
                      );
                    },
              ),
            ),
            GoRoute(
              path: savedPath,
              pageBuilder: (context, state) => CustomTransitionPage(
                transitionDuration: const Duration(
                  milliseconds: pageTransitionDuration,
                ),
                child: SavedPage(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                      final offsetAnimation = Tween<Offset>(
                        begin: const Offset(0, 1),
                        end: Offset.zero,
                      ).animate(animation);

                      return SlideTransition(
                        position: offsetAnimation,
                        child: child,
                      );
                    },
              ),
            ),
            GoRoute(
              path: profilePath,
              pageBuilder: (context, state) => CustomTransitionPage(
                transitionDuration: const Duration(
                  milliseconds: pageTransitionDuration,
                ),
                child: ProfilePage(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                      final offsetAnimation = Tween<Offset>(
                        begin: const Offset(0, 1),
                        end: Offset.zero,
                      ).animate(animation);

                      return SlideTransition(
                        position: offsetAnimation,
                        child: child,
                      );
                    },
              ),
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
              pageBuilder: (context, state) => CustomTransitionPage(
                transitionDuration: const Duration(
                  milliseconds: pageTransitionDuration,
                ),
                child: BasicInformation(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                      final offsetAnimation = Tween<Offset>(
                        begin: const Offset(0, 1),
                        end: Offset.zero,
                      ).animate(animation);

                      return SlideTransition(
                        position: offsetAnimation,
                        child: child,
                      );
                    },
              ),
            ),
            GoRoute(
              path: featuresPath,
              pageBuilder: (context, state) => CustomTransitionPage(
                transitionDuration: const Duration(
                  milliseconds: pageTransitionDuration,
                ),
                child: PropertyFeatures(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                      final offsetAnimation = Tween<Offset>(
                        begin: const Offset(0, 1),
                        end: Offset.zero,
                      ).animate(animation);

                      return SlideTransition(
                        position: offsetAnimation,
                        child: child,
                      );
                    },
              ),
            ),
            GoRoute(
              path: uploadPhotosPath,
              pageBuilder: (context, state) => CustomTransitionPage(
                transitionDuration: const Duration(
                  milliseconds: pageTransitionDuration,
                ),
                child: UploadPhotos(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                      final offsetAnimation = Tween<Offset>(
                        begin: const Offset(0, 1),
                        end: Offset.zero,
                      ).animate(animation);

                      return SlideTransition(
                        position: offsetAnimation,
                        child: child,
                      );
                    },
              ),
            ),
            GoRoute(
              path: contactInfoPath,
              pageBuilder: (context, state) => CustomTransitionPage(
                transitionDuration: const Duration(
                  milliseconds: pageTransitionDuration,
                ),
                child: ContactInformation(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                      final offsetAnimation = Tween<Offset>(
                        begin: const Offset(0, 1),
                        end: Offset.zero,
                      ).animate(animation);

                      return SlideTransition(
                        position: offsetAnimation,
                        child: child,
                      );
                    },
              ),
            ),
          ],
        ),
        GoRoute(
          path: detailPath,
          pageBuilder: (context, state) => CustomTransitionPage(
            transitionDuration: const Duration(
              milliseconds: pageTransitionDuration,
            ),
            child: DetailPage(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  final offsetAnimation = Tween<Offset>(
                    begin: const Offset(0, 1),
                    end: Offset.zero,
                  ).animate(animation);

                  return SlideTransition(
                    position: offsetAnimation,
                    child: child,
                  );
                },
          ),
        ),
        GoRoute(
          path: searchPath,
          pageBuilder: (context, state) => CustomTransitionPage(
            transitionDuration: const Duration(
              milliseconds: pageTransitionDuration,
            ),
            child: SearchLocation(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  final offsetAnimation = Tween<Offset>(
                    begin: const Offset(0, 1),
                    end: Offset.zero,
                  ).animate(animation);

                  return SlideTransition(
                    position: offsetAnimation,
                    child: child,
                  );
                },
          ),
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
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
        ),
        cardTheme: CardThemeData(
          color: Colors.white,
          surfaceTintColor: Colors.blue,
          elevation: 8,
        ),
        colorScheme: ColorScheme.light(primary: Colors.blue),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.dark(primary: Colors.blue),
        scaffoldBackgroundColor: Color(0xFF121212),
        textTheme: GoogleFonts.latoTextTheme(ThemeData.dark().textTheme),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
        ),
        cardTheme: CardThemeData(
          color: context.backgroundColor,
          surfaceTintColor: Colors.blue,
          elevation: 8,
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
List<bool> _isSelected = List.generate(4, (index) => index == 0);

class _MainScaffoldState extends State<MainScaffold> {
  @override
  Widget build(BuildContext context) {
    PropertiesViewModel viewModel = Provider.of<PropertiesViewModel>(context);
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
        leadingWidth: 150,
        leading: Padding(
          padding: EdgeInsets.all(4),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              roundedImage(
                context: context,
                imageUrl: viewModel.currentUser?.profilePicUrl ?? "",
                width: 40,
                height: 40,
              ),
              FadedText(
                viewModel.currentUser?.firstName != null
                    ? "Hello, ${viewModel.currentUser?.firstName}"
                    : "",
                style: context.titleMedium,
              ),
            ],
          ),
        ),
        actions: [IconButton(icon: Icon(notificationIcon), onPressed: () {})],
        context: context,
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
              elevation: 8,
              currentIndex: _index,
              type: BottomNavigationBarType.fixed,
              backgroundColor: context.getBrightness == Brightness.dark
                  ? Color(0xFF121212).withValues(alpha: 0.8)
                  : Colors.white.withValues(alpha: 0.8),
              showUnselectedLabels: true,
              selectedItemColor: context.getBrightness == Brightness.dark
                  ? Colors.blue.shade300
                  : Colors.blue.shade900,
              unselectedItemColor: context.getBrightness == Brightness.dark
                  ? Colors.grey.shade600
                  : Colors.grey.shade300,
              onTap: (index) async {
                if (index == 0) {
                  _isSelected.forEachIndexed((isSelectedIndex, _) {
                    _isSelected[isSelectedIndex] = isSelectedIndex == index;
                  });
                  navigateToHomePage(context);
                } else if (index == 1) {
                  _isSelected.forEachIndexed((isSelectedIndex, _) {
                    _isSelected[isSelectedIndex] = isSelectedIndex == index;
                  });
                  context.pushReplacement(searchPagePath);
                  setState(() {});
                } else if (index == 2) {
                  _isSelected.forEachIndexed((isSelectedIndex, _) {
                    _isSelected[isSelectedIndex] = isSelectedIndex == index;
                  });
                  navigateToSavedPage(context);
                } else {
                  _isSelected.forEachIndexed((isSelectedIndex, _) {
                    _isSelected[isSelectedIndex] = isSelectedIndex == index;
                  });
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
      body: Padding(
        padding: EdgeInsetsGeometry.only(top: 8),
        child: widget.body,
      ),
    );
  }
}
