part of "upload_flow_library.dart";

class ContactInformation extends StatefulWidget {
  const ContactInformation({super.key});

  @override
  State<ContactInformation> createState() => _ContactInformationState();
}

String _fullName = "";
String _number = "";
String _emailAddress = "";

bool _isPropertyUploading = false;

class _ContactInformationState extends State<ContactInformation> {
  final _contactInfoFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    PropertiesViewModel viewmodel = Provider.of<PropertiesViewModel>(context);

    setState(() {
      pageNumber = 4;
    });

    Widget contactInfoForms = Form(
      key: _contactInfoFormKey,
      child: uploadFlow(
        context,
        children: [
          Text("Contact information", style: context.titleLarge),
          FadedText(
            padding: 0,
            "How should interested buyers contact you?",
            style: context.titleSmall,
          ),
          PlainTextField(
            initialText: "John Doe",
            hint: Text("Full name"),
            onChanged: (fullName) {
              _fullName = fullName;
            },
          ),
          PlainTextField(
            initialText: "0712345678",
            hint: Text("Phone number"),
            onChanged: (number) {
              _number = number;
            },
          ),
          PlainTextField(
            initialText: "william.henry.harrison@example-pet-store.com",
            hint: Text("Email address"),
            onChanged: (emailAddress) {
              _emailAddress = emailAddress;
            },
          ),
          Text("Preview", style: context.titleLarge),
          Center(
            child: homeCard(
              viewmodel: viewmodel,
              property: viewmodel.uploadProperty,
              onTap: () {
                navigate(path: detailPath, extra: viewmodel.properties.length);
              },
              context: context,
              iconButton: IconButton(
                onPressed: () async {},
                icon: Icon(cancelIcon, color: Colors.red),
              ),
            ),
          ),
        ],
        bottomWidget: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: customButton(
                context: context,
                onPressed: () {
                  globalBuildContext?.pop();
                },
                children: [
                  Icon(arrowBack),
                  Text("Previous", style: context.bodyMedium),
                ],
                alignment: Alignment.bottomLeft,
              ),
            ),
            Expanded(
              child: customButton(
                context: context,
                onPressed: () {
                  if (_contactInfoFormKey.currentState!.validate()) {
                    submitListing(
                      viewmodel,
                      onStart: () {
                        setState(() {
                          _isPropertyUploading = true;
                        });
                      },
                      onEnd: () {
                        setState(() {
                          _isPropertyUploading = false;
                        });
                      },
                    );
                  }
                },
                children: [Text("Submit listing", style: context.bodyMedium)],
              ),
            ),
          ],
        ),
      ),
    );

    return Scaffold(
      body: Stack(
        children: [
          contactInfoForms,
          _isPropertyUploading ? loadingIcon : Container(),
        ],
      ),
    );
  }
}

void populateContactInfo(PropertiesViewModel viewmodel) {
  viewmodel.uploadProperty.contactName = _fullName;
  viewmodel.uploadProperty.contactNumber = _number;
  viewmodel.uploadProperty.contactEmail = _emailAddress;
}

Future<void> submitListing(
  PropertiesViewModel propertiesViewModel, {
  required Function onStart,
  required Function onEnd,
}) async {
  onStart();
  await propertiesViewModel.createProperty();
  onEnd();
  globalBuildContext?.go(homePath);
}
