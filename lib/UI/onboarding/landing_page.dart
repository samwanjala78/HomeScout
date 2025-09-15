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

var _isLoginPressed = false;

class _SignInPageState extends State<SignInPage> {
  @override
  Widget build(BuildContext context) {
    Icon icon = Icon(homeIcon, size: 40.0);
    PropertiesViewModel viewModel = Provider.of<PropertiesViewModel>(context);

    Widget welcomeText = Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "Welcome to Happyhousehunt",
          style: Theme.of(context).textTheme.headlineSmall,
        ),

        FadedText(
          text: "Your one stop shop for all your property needs",
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );

    Widget signInWithButtons = Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: paddingValue,
      children: [
        roundedButton(
          onPressed: () {},
          child: SpacedRow(
            spacing: paddingValue / 4,
            children: [
              Icon(facebookIcon, size: 20),
              Text("Facebook", style: context.bodyMedium),
            ],
          ),
        ),
        roundedButton(
          onPressed: () {
            handleSignIn(); /*todo*/
          },
          child: SpacedRow(
            spacing: paddingValue / 4,
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
      ],
    );

    Widget signupSigninButtons = Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: paddingValue,
      children: [
        AnimatedButton(
          onPressed: () {
            setState(() => _isLoginPressed = false);
          },
          begin: _isLoginPressed ? Colors.blue : Colors.grey,
          end: _isLoginPressed ? Colors.grey : Colors.blue,
          child: Text('Sign up'),
        ),
        AnimatedButton(
          onPressed: () {
            setState(() => _isLoginPressed = true);
          },
          begin: _isLoginPressed ? Colors.grey : Colors.blue,
          end: _isLoginPressed ? Colors.blue : Colors.grey,
          child: Text('Login'),
        ),
      ],
    );

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: SpacedColumn(
            children: <Widget>[
              icon,
              welcomeText,
              FadedText(text: "Sign in with", style: context.bodyLarge),
              signInWithButtons,
              FadedText(
                text: "Or continue with email",
                style: context.bodyLarge,
              ),
              signupSigninButtons,
              _isLoginPressed
                  ? loginForm(const ValueKey('login'))
                  : signupForm(const ValueKey('signup'), context, viewModel),
            ],
          ),
        ),
      ),
    );
  }
}
