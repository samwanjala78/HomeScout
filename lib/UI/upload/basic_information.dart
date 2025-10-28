part of 'upload_flow_library.dart';

class BasicInformation extends StatefulWidget {
  const BasicInformation({super.key});

  @override
  State<BasicInformation> createState() => _BasicInformationPageState();
}

class _BasicInformationPageState extends State<BasicInformation> {
  final _basicInfoFormKey = GlobalKey<FormState>();

  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    PropertiesViewModel viewModel = Provider.of<PropertiesViewModel>(context);

    setState(() {
      pageNumber = 1;
    });

    final NumberFormat formatter = NumberFormat.currency(
      locale: context.localeString,
      symbol: currencyFormat.currencySymbol,
      decimalDigits: 0,
    );

    return Scaffold(
      body: Form(
        key: _basicInfoFormKey,
        child: uploadFlow(
          context,
          children: [
            Text(
              "Basic information",
              style: context.titleLarge,
              textAlign: TextAlign.start,
            ),
            PlainTextField(
              hint: Text("Property title"),
              onChanged: (title) {
                viewModel.uploadProperty.title = title;
              },
            ),
            Hero(
              tag: "Searchbar",
              child: PlainTextField(
                controller: controller,
                hint: Text("Add location"),
                onTap: () async {
                  await context.push<bool>(searchPath);

                  controller.text = viewModel.uploadProperty.location;
                },
              ),
            ),
            DropdownMenu<String>(
              initialSelection: PropertyType.forRent.type,
              onSelected: (type) {
                viewModel.uploadProperty.type = type!;
              },
              menuStyle: MenuStyle(
                maximumSize: WidgetStateProperty.all(
                  Size.fromWidth(double.infinity),
                ),
              ),
              hintText: "e.g., for rent",
              inputDecorationTheme: InputDecorationTheme(
                filled: true,
                fillColor: context.backgroundColor,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(999),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue, width: 1),
                  borderRadius: BorderRadius.circular(999),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red, width: 1),
                  borderRadius: BorderRadius.circular(999),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red, width: 1),
                  borderRadius: BorderRadius.circular(999),
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
            PlainTextField(
              hint: Text("Price"),
              onChanged: (price) {
                viewModel.uploadProperty.price = price;
              },
              textInputType: TextInputType.number,
              textInputFormatter: [
                FilteringTextInputFormatter.digitsOnly,
                CurrencyInputFormatter(formatter),
              ],
            ),
            PlainTextField(
              hint: Text("Description"),
              onChanged: (description) {
                viewModel.uploadProperty.description = description;
              },
              validator: (description) => null,
            ),
            Row(
              spacing: spacingValue,
              children: [
                Expanded(
                  child: PlainTextField(
                    hint: Text("Bedrooms"),
                    onChanged: (bedrooms) {
                      viewModel.uploadProperty.bedrooms = bedrooms;
                    },
                    textInputType: TextInputType.number,
                  ),
                ),
                Expanded(
                  child: PlainTextField(
                    hint: Text("Bathrooms"),
                    onChanged: (bathrooms) {
                      viewModel.uploadProperty.bathrooms = bathrooms;
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
                        navigate(path: featuresPath);
                      }
                    },
                    children: [
                      Text("Next", style: context.bodyMedium),
                      Icon(arrowFowardIcon),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
