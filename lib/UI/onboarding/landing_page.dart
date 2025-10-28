import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:real_estate/UI/ui.dart';
import 'package:real_estate/constants/ui_constants.dart';
import 'package:real_estate/gen/assets.gen.dart';
import 'package:real_estate/util/util.dart';
import '../../data/viewmodel.dart';
import 'landing_page_ui_elements.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

var _isLoginPressed = true;
var _obscurePass = true;
var _registeringUser = false;
String? _emailErrorText;
String? _passErrorText;

class _SignInPageState extends State<SignInPage> {
  @override
  Widget build(BuildContext context) {
    Icon icon = Icon(homeIcon, size: 40.0, color: Colors.blue);
    PropertiesViewModel viewModel = Provider.of<PropertiesViewModel>(context);

    Widget welcomeText = Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "Welcome to Happyhousehunt",
          style: Theme.of(context).textTheme.headlineSmall,
        ),

        FadedText(
          "Your one stop shop for all your property needs",
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );

    Widget signInWithGoogle = SizedBox(
      width: 300,
      child: roundedButton(
        onPressed: () {
          handleSignIn(); /*todo*/
        },
        child: SpacedRow(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: spacingValue / 4,
          children: [
            loadSVG(
              Assets.icons.google,
              lightDarkIcon: false,
              height: 20,
              width: 20,
              context: context,
            ),
            Text("Google", style: context.bodyMedium),
          ],
        ),
      ),
    );

    Color blue = Colors.blue;
    Color grey = context.getBrightness == Brightness.dark
        ? Colors.grey.shade800
        : Colors.grey.shade300;

    Widget signupSigninButtons = Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: spacingValue,
      children: [
        AnimatedButton(
          key: ValueKey("Login"),
          onPressed: () {
            setState(() {
              _isLoginPressed = true;
              _emailErrorText = null;
              _passErrorText = null;
            });
          },
          begin: _isLoginPressed ? grey : blue,
          end: _isLoginPressed ? blue : grey,
          child: Text('Login'),
        ),
        AnimatedButton(
          key: ValueKey("Signup"),
          onPressed: () {
            setState(() {
              _isLoginPressed = false;
              _emailErrorText = null;
              _passErrorText = null;
            });
          },
          begin: _isLoginPressed ? blue : grey,
          end: _isLoginPressed ? grey : blue,
          child: Text('Sign up'),
        ),
      ],
    );

    Widget login = loginForm(
      context: context,
      viewmodel: viewModel,
      onError: (response) {
        Map<String, dynamic> errorBody = jsonDecode(response.body);
        if (response.statusCode == 400) {
          setState(() {
            if (errorBody.containsKey("emailError")) {
              _emailErrorText = errorBody["emailError"];
            } else {
              _passErrorText = errorBody["passError"];
            }
          });
        } else if (response.statusCode == 500) {
          toast(errorBody["error"]);
        }
      },
      passErrorText: _passErrorText,
      loginBegin: () {
        setState(() {
          _registeringUser = true;
        });
      },
      loginEnd: () {
        _registeringUser = false;
      },
      obscurePass: _obscurePass,
      onShowPassPress: () {
        setState(() {
          _obscurePass = !_obscurePass;
        });
      },
      emailErrorText: _emailErrorText,
    );

    Widget signUp = signupForm(
      context: context,
      viewmodel: viewModel,
      obscurePass: _obscurePass,
      emailErrorText: _emailErrorText,
      onShowPassPress: () {
        setState(() {
          _obscurePass = !_obscurePass;
        });
      },
      onError: (response) {
        String error = jsonDecode(response.body)["error"];
        if (response.statusCode == 400) {
          setState(() {
            _emailErrorText = error;
          });
        } else if (response.statusCode == 500) {
          toast(error);
        }
      },
      registerBegin: () {
        setState(() {
          _registeringUser = true;
        });
      },
      registerEnd: () {
        _registeringUser = false;
      },
    );

    Widget body = IndexedStack(
      index: _isLoginPressed ? 0 : 1,
      children: [login, signUp],
    );

    Widget landingPage = SingleChildScrollView(
      key: ValueKey("LandingScrollview"),
      child: SpacedColumn(
        key: ValueKey("LandingColumn"),
        children: <Widget>[
          icon,
          welcomeText,
          FadedText("Sign in with", style: context.bodyLarge),
          signInWithGoogle,
          FadedText("Or continue with email", style: context.bodyLarge),
          signupSigninButtons,
          SizedBox(width: context.getMaxWidth, child: body),
        ],
      ),
    );

    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [landingPage, _registeringUser ? loadingIcon : Container()],
        ),
      ),
    );
  }
}
