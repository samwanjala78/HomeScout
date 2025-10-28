import 'package:bcrypt/bcrypt.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:real_estate/UI/ui.dart';
import 'package:real_estate/main.dart';
import '../../data/viewmodel.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  bool obscurePass = true;
  bool obscureConfirmPass = true;
  String userPassword = "";
  String confirmUserPassword = "";
  String? errorText;

  @override
  Widget build(BuildContext context) {
    PropertiesViewModel viewModel = Provider.of<PropertiesViewModel>(context);
    return SafeArea(
      child: Scaffold(
        body: SpacedColumn(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            PlainTextField(
              key: ValueKey("Password"),
              hint: Text("Password"),
              autofillHints: const [AutofillHints.password],
              obscureText: obscurePass,
              onChanged: (password) {
                userPassword = password;
              },
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    obscurePass = !obscurePass;
                  });
                },
                icon: Icon(Icons.remove_red_eye_outlined),
              ),
            ),
            PlainTextField(
              key: ValueKey("Confirm Password"),
              hint: Text("Confirm password"),
              autofillHints: const [AutofillHints.password],
              obscureText: obscurePass,
              errorText: errorText,
              onChanged: (password) {
                confirmUserPassword = password;
              },
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    obscureConfirmPass = !obscureConfirmPass;
                  });
                },
                icon: Icon(Icons.remove_red_eye_outlined),
              ),
            ),
            roundedButton(
              key: ValueKey("Confirm"),
              onPressed: () async {
                if (userPassword != confirmUserPassword) {
                  errorText = "Passwords do not match";
                } else {
                  errorText = null;
                  String hashedPassword = BCrypt.hashpw(
                    userPassword,
                    BCrypt.gensalt(logRounds: 10),
                  );
                  await viewModel.updateUser(
                    viewModel.currentUser!.copyWith(password: hashedPassword),
                  );
                  if (context.mounted) {
                    context.pushReplacement(signInPath);
                  }
                  toast("Password changed", toastLength: Toast.LENGTH_LONG);
                }
              },
              child: Text("Confirm"),
            ),
          ],
        ),
      ),
    );
  }
}
