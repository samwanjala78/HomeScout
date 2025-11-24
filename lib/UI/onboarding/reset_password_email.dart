import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:real_estate/UI/ui.dart';
import 'package:real_estate/util/util.dart';
import '../../data/viewmodel.dart';
import '../../main.dart';

class EmailPage extends StatefulWidget {
  const EmailPage({super.key});

  @override
  State<EmailPage> createState() => _EmailPageState();
}

class _EmailPageState extends State<EmailPage> {
  String? errorText;
  String emailValue = "";
  final _emailFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    PropertiesViewModel viewModel = Provider.of<PropertiesViewModel>(context);
    return SafeArea(
      child: Scaffold(
        body: SpacedColumn(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            FadedText("Enter your email", textAlign: TextAlign.start),
            Form(
              key: _emailFormKey,
              child: PlainTextField(
                key: ValueKey("Email"),
                hint: Text("Email"),
                autofillHints: const [AutofillHints.email],
                errorText: errorText,
                validator: (value) {
                  final emailRegex = RegExp(
                    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                  );
                  if (!emailRegex.hasMatch(value!)) {
                    return "Enter a valid email address";
                  }
                  return null;
                },
                onChanged: (email) {
                  emailValue = email;
                },
              ),
            ),
            roundedButton(
              context: context,
              key: ValueKey("confirm"),
              onPressed: () async {
                if (_emailFormKey.currentState!.validate()) {
                  viewModel.currentUser = await viewModel.getUserViaEmail(
                    emailValue,
                  );
                  if (viewModel.currentUser == null) {
                    errorText = "User not found";
                  } else {
                    errorText = null;
                    navigate(path: resetPasswordPath);
                  }
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
