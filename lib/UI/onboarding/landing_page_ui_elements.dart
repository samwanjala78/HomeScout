import 'package:flutter/material.dart';
import 'package:flutter_intl_phone_field/countries.dart';
import 'package:flutter_intl_phone_field/flutter_intl_phone_field.dart';
import 'package:real_estate/UI/ui.dart';
import 'package:real_estate/constants/ui_constants.dart';
import 'package:real_estate/main.dart';
import 'package:real_estate/util/util.dart';

import '../../data/viewmodel.dart';

Widget loginForm(Key? key) {
  final logInFormKey = GlobalKey<FormState>();
  return Form(
    key: logInFormKey,
    child: SpacedColumn(
      key: key,
      padding: 0,
      children: [
        PlainTextField(
          hint: Text("Email"),
          validator: (value) {
            final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
            if (!emailRegex.hasMatch(value!)) {
              return "Enter a valid email address";
            }
            return null;
          },
        ),
        PlainTextField(hint: Text("Password")),
        roundedButton(
          onPressed: () {
            logInFormKey.currentState?.validate();
          },
          child: Text("Login"),
        ),
      ],
    ),
  );
}

Widget signupForm(Key? key, BuildContext context, PropertiesViewModel viewmodel) {
  final signUpFormKey = GlobalKey<FormState>();
  User currentUser = User(firstName: "firstName", lastName: "lastName", email: "email", phoneNumber: "phoneNumber", password: "password");
  return Form(
    key: signUpFormKey,
    child: SpacedColumn(
      key: key,
      padding: 0,
      children: [
        Row(
          spacing: paddingValue / 4,
          children: [
            Expanded(
              child: PlainTextField(
                hint: Text("First name"),
                autofillHints: const [AutofillHints.namePrefix],
                onChanged: (firstName){
                  currentUser.firstName = firstName;
                },
              ),
            ),
            Expanded(
              child: PlainTextField(
                hint: Text("Last name"),
                autofillHints: const [AutofillHints.nameSuffix],
                onChanged: (lastName){
                  currentUser.lastName = lastName;
                },
              ),
            ),
          ],
        ),
        PlainTextField(
          hint: Text("Email"),
          autofillHints: const [AutofillHints.email],
          validator: (value) {
            final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
            if (!emailRegex.hasMatch(value!)) {
              return "Enter a valid email address";
            }
            return null;
          },
          onChanged: (email){
            currentUser.email = email;
          },
        ),
        IntlPhoneField(
          disableLengthCheck: true,
          showDropdownIcon: false,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(radius),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blue, width: 2),
              borderRadius: BorderRadius.circular(radius),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red, width: 1.5),
              borderRadius: BorderRadius.circular(radius),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red, width: 2),
              borderRadius: BorderRadius.circular(radius),
            ),
            hint: Text("Phone number"),
            hintStyle: TextStyle(
              color: context.brightness == Brightness.dark
                  ? Colors.black
                  : Colors.white,
            ),
            filled: true,
            fillColor: context.brightness == Brightness.dark
                ? Colors.grey.shade800
                : Colors.grey.shade300,
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
          hint: Text("Password"),
          autofillHints: const [AutofillHints.password],
          obscureText: true,
          onChanged: (password){
            currentUser.password = password;
          },
          suffixIcon: IconButton(onPressed: (){

          }, icon: Icon(Icons.remove_red_eye_outlined)),
        ),
        roundedButton(
          onPressed: () {
            viewmodel.currentUser = currentUser;
            if(signUpFormKey.currentState!.validate()){
              WidgetsBinding.instance.addPostFrameCallback((_) {
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
