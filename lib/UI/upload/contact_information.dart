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
        children: [
          Text("Contact information", style: context.titleLarge),
          FadedText(
            padding: 0,
            text: "How should interested buyers contact you?",
            style: context.titleSmall,
          ),
          labeledTextField(
            initialText: "John Doe",
            label: Text("Full name"),
            onChanged: (fullName) {
              _fullName = fullName;
            },
          ),
          labeledTextField(
            initialText: "0712345678",
            label: Text("Phone number"),
            onChanged: (number) {
              _number = number;
            },
          ),
          labeledTextField(
            initialText: "william.henry.harrison@example-pet-store.com",
            label: Text("Email address"),
            onChanged: (emailAddress) {
              _emailAddress = emailAddress;
            },
          ),
          Text("Preview", style: context.titleLarge),
          Center(
            child: mainCard(
              property: bufferPropertyObject,
              onTap: () {
                navigate(path: detailPath, index: viewmodel.properties.length);
              },
              context: context,
              onLiked: () {},
            ),
          ),
        ],
        bottomWidget: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: customButton(
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

    return Stack(
      children: [
        contactInfoForms,
        _isPropertyUploading ? loadingIcon : Container(),
      ],
    );
  }
}

void populateContactInfo() {
  bufferPropertyObject.contactName = _fullName;
  bufferPropertyObject.contactNumber = _number;
  bufferPropertyObject.contactEmail = _emailAddress;
}

Future<void> submitListing(
  PropertiesViewModel propertiesViewModel, {
  required Function onStart,
  required Function onEnd,
}) async {
  onStart();
  await propertiesViewModel.addProperties(bufferPropertyObject);
  onEnd();
  globalBuildContext?.go(homePath);
}
