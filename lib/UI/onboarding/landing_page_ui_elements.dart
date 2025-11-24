import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_intl_phone_field/countries.dart';
import 'package:flutter_intl_phone_field/flutter_intl_phone_field.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart';
import 'package:real_estate/UI/ui.dart';
import 'package:real_estate/constants/ui_constants.dart';
import 'package:real_estate/main.dart';
import 'package:real_estate/network/network_util.dart';
import 'package:real_estate/util/util.dart';

import '../../data/viewmodel.dart';

final _logInFormKey = GlobalKey<FormState>();

String userEmail = "";
String userPassword = "";

Widget loginForm({
  Key? key,
  required PropertiesViewModel viewmodel,
  required Function(Response response) onError,
  required Function loginBegin,
  required Function loginEnd,
  required bool obscurePass,
  String? emailErrorText,
  String? passErrorText,
  required Function onShowPassPress,
  required BuildContext context,
}) {
  return Form(
    key: _logInFormKey,
    child: SpacedColumn(
      key: key,
      padding: 0,
      children: [
        PlainTextField(
          key: ValueKey("Email"),
          autofillHints: const [AutofillHints.email],
          errorText: emailErrorText,
          hint: Text("Email"),
          onChanged: (email) {
            userEmail = email;
          },
          validator: (value) {
            final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
            if (!emailRegex.hasMatch(value!)) {
              return "Enter a valid email address";
            }
            return null;
          },
        ),
        PlainTextField(
          key: ValueKey("Password"),
          hint: Text("Password"),
          autofillHints: const [AutofillHints.password],
          obscureText: obscurePass,
          errorText: passErrorText,
          onChanged: (password) {
            userPassword = password;
          },
          suffixIcon: IconButton(
            onPressed: () {
              onShowPassPress();
            },
            icon: Icon(Icons.remove_red_eye_outlined),
          ),
        ),
        roundedButton(
          context: context,
          key: ValueKey("login"),
          onPressed: () async {
            loginBegin();
            log(userEmail);
            viewmodel.currentUser = await NetworkLayer.signIn(
              userEmail: userEmail,
              userPassword: userPassword,
            );
            loginEnd();
            if (_logInFormKey.currentState!.validate() &&
                viewmodel.currentUser != null) {
              WidgetsBinding.instance.addPostFrameCallback((_) async {
                context.go(homePath);
              });
            }
          },
          child: Text("Login"),
        ),

        roundedButton(
          context: context,
          key: ValueKey("forgotPassword"),
          onPressed: () async {
            navigate(path: emailPath);
          },
          child: Text("Forgot password"),
        ),
      ],
    ),
  );
}

User currentUser = User(
  firstName: "firstName",
  lastName: "lastName",
  email: "email",
  phoneNumber: "phoneNumber",
  password: "password",
);

final _signUpFormKey = GlobalKey<FormState>();

Widget signupForm({
  Key? key,
  required BuildContext context,
  required PropertiesViewModel viewmodel,
  required bool obscurePass,
  String? emailErrorText,
  required Function(Response response) onError,
  required Function onShowPassPress,
  required Function registerBegin,
  required Function registerEnd,
}) {
  return Form(
    key: _signUpFormKey,
    child: SpacedColumn(
      key: key,
      padding: 0,
      children: [
        Row(
          spacing: spacingValue / 4,
          children: [
            Expanded(
              child: PlainTextField(
                key: ValueKey("First name"),
                hint: Text("First name"),
                autofillHints: const [AutofillHints.namePrefix],
                onChanged: (firstName) {
                  log(firstName);
                  currentUser.firstName = firstName;
                },
              ),
            ),
            Expanded(
              child: PlainTextField(
                key: ValueKey("Last name"),
                hint: Text("Last name"),
                autofillHints: const [AutofillHints.nameSuffix],
                onChanged: (lastName) {
                  currentUser.lastName = lastName;
                },
              ),
            ),
          ],
        ),
        PlainTextField(
          key: ValueKey("Email"),
          hint: Text("Email"),
          autofillHints: const [AutofillHints.email],
          errorText: emailErrorText,
          validator: (value) {
            final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
            if (!emailRegex.hasMatch(value!)) {
              return "Enter a valid email address";
            }
            return null;
          },
          onChanged: (email) {
            currentUser.email = email;
          },
        ),
        IntlPhoneField(
          key: ValueKey("Phone number"),
          disableLengthCheck: true,
          showDropdownIcon: false,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(999),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blue, width: 2),
              borderRadius: BorderRadius.circular(999),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red, width: 1.5),
              borderRadius: BorderRadius.circular(999),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red, width: 2),
              borderRadius: BorderRadius.circular(999),
            ),
            hint: Text("Phone number"),
            filled: true,
            fillColor: context.backgroundColor,
          ),
          initialCountryCode: 'KE',
          countries: countries
              .where(
                (country) =>
                    country.name == "Kenya" ||
                    country.name == "Uganda" ||
                    country.name == "Tanzania, United Republic of Tanzania",
              )
              .toList(),
          onChanged: (phoneNumber) {
            currentUser.phoneNumber = phoneNumber.completeNumber;
          },
        ),
        PlainTextField(
          key: ValueKey("Password"),
          hint: Text("Password"),
          autofillHints: const [AutofillHints.newPassword],
          obscureText: obscurePass,
          onChanged: (password) {
            currentUser.password = password;
          },
          suffixIcon: IconButton(
            onPressed: () {
              onShowPassPress();
            },
            icon: Icon(Icons.remove_red_eye_outlined),
          ),
        ),
        roundedButton(
          context: context,
          key: ValueKey("Signup_button"),
          onPressed: () async {
            registerBegin();
            viewmodel.currentUser = await NetworkLayer.signUp(currentUser);
            registerEnd();
            if (_signUpFormKey.currentState!.validate() &&
                viewmodel.currentUser != null) {
              WidgetsBinding.instance.addPostFrameCallback((_) async {
                navigate(path: profileSetupPath);
              });
            }
          },
          child: Text("Sign up", style: context.bodyMedium),
        ),
      ],
    ),
  );
}
