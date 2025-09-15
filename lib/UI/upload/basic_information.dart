part of 'upload_flow_library.dart';

class BasicInformation extends StatefulWidget {
  const BasicInformation({super.key});

  @override
  State<BasicInformation> createState() => _BasicInformationPageState();
}

class _BasicInformationPageState extends State<BasicInformation> {
  // _BasicInformationData basicInformationData = _BasicInformationData();

  final _basicInfoFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    setState(() {
      pageNumber = 1;
    });

    final NumberFormat _formatter = NumberFormat.currency(
      locale: context.localeString,
      symbol: currencyFormat.currencySymbol,
      decimalDigits: 0,
    );

    return Form(
      key: _basicInfoFormKey,
      child: uploadFlow(
        children: [
          Text(
            "Basic information",
            style: context.titleLarge,
            textAlign: TextAlign.start,
          ),
          PlainTextField(
            initialText: "Spacious house",
            hint: Text("Property Title"),
            onChanged: (title) {
              // basicInformationData.titleString = title;
            },
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Type"),
              VerticalSpacer(height: paddingValue / 2),
              DropdownMenu<String>(
                initialSelection: PropertyType.forRent.type,
                onSelected: (type) {
                  // basicInformationData.typeString = type!;
                },
                menuStyle: MenuStyle(
                  maximumSize: WidgetStateProperty.all(
                    Size.fromWidth(double.infinity),
                  ),
                ),
                hintText: "e.g., for rent",
                textStyle: TextStyle(
                  color: context.brightness == Brightness.dark
                      ? Colors.black
                      : Colors.white,
                ),
                inputDecorationTheme: InputDecorationTheme(
                  filled: true,
                  fillColor: context.brightness == Brightness.dark
                      ? Colors.grey.shade800
                      : Colors.grey.shade300,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                ),
                width: double.infinity,
                dropdownMenuEntries: [
                  DropdownMenuEntry(
                    value: PropertyType.forRent.type,
                    label: PropertyType.forRent.type,
                  ),
                  DropdownMenuEntry(
                    value: PropertyType.forSale.type,
                    label: PropertyType.forSale.type,
                  ),
                ],
              ),
            ],
          ),
          PlainTextField(
            initialText: "Ksh. 20,000",
            hint: Text("Price"),
            onChanged: (price) {
              // basicInformationData.priceString = price;
            },
            textInputType: TextInputType.number,
            textInputFormatter: [
              FilteringTextInputFormatter.digitsOnly,
              CurrencyInputFormatter(_formatter),
            ],
          ),
          PlainTextField(
            initialText: "Westlands",
            hint: Text("Location"),
            onChanged: (location) {
              // basicInformationData.locationString = location;
            },
          ),
          PlainTextField(
            hint: Text("Description"),
            onChanged: (description) {
              // basicInformationData.descriptionString = description;
            },
          ),
          Row(
            spacing: paddingValue,
            children: [
              Expanded(
                child: PlainTextField(
                  initialText: "5",
                  hint: Text("Bedrooms"),
                  onChanged: (bedrooms) {
                    // basicInformationData.bedroomsString = bedrooms;
                  },
                  textInputType: TextInputType.number,
                ),
              ),
              Expanded(
                child: PlainTextField(
                  initialText: "5",
                  hint: Text("Bathrooms"),
                  onChanged: (bathrooms) {
                    // basicInformationData.bathroomsString = bathrooms;
                  },
                  textInputType: TextInputType.number,
                ),
              ),
            ],
          ),
        ],
        bottomWidget: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: IntrinsicWidth(
                child: customButton(
                  onPressed: () {
                    globalBuildContext?.pushReplacement(homePath);
                  },
                  alignment: Alignment.centerLeft,
                  children: [
                    Icon(arrowBack),
                    Text("Previous", style: context.bodyMedium),
                  ],
                ),
              ),
            ),
            Expanded(
              child: IntrinsicWidth(
                child: customButton(
                  onPressed: () {
                    if (_basicInfoFormKey.currentState!.validate()) {
                      // _navigateToPropertyFeatures(
                      //   // basicInformationData: basicInformationData,
                      // );
                      navigate(path: featuresPath);
                    }
                  },
                  children: [
                    Text("Next", style: context.bodyMedium),
                    Icon(arrowFoward),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BasicInformationData {
  String titleString,
      typeString,
      priceString,
      locationString,
      descriptionString,
      bedroomsString,
      bathroomsString;

  _BasicInformationData({
    this.titleString = "",
    this.typeString = "",
    this.priceString = "",
    this.locationString = "",
    this.descriptionString = "",
    this.bedroomsString = "",
    this.bathroomsString = "",
  });
}

void _navigateToPropertyFeatures({
  required _BasicInformationData basicInformationData,
}) {
  bufferPropertyObject.title = basicInformationData.titleString;
  bufferPropertyObject.type = basicInformationData.typeString;
  bufferPropertyObject.price = basicInformationData.priceString;
  bufferPropertyObject.location = basicInformationData.locationString;
  bufferPropertyObject.description = basicInformationData.descriptionString;
  bufferPropertyObject.bedrooms = basicInformationData.bedroomsString;
  bufferPropertyObject.bathrooms = basicInformationData.bathroomsString;

  globalBuildContext?.push(featuresPath);
}
