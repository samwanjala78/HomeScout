part of "upload_flow_library.dart";

class PropertyFeatures extends StatefulWidget {
  const PropertyFeatures({super.key});

  @override
  State<PropertyFeatures> createState() => _PropertyFeaturesState();
}

class _PropertyFeaturesState extends State<PropertyFeatures> {
  @override
  Widget build(BuildContext context) {
    PropertiesViewModel viewmodel = Provider.of<PropertiesViewModel>(context);
    isFeatureSelected[1] = true;
    isFeatureSelected[2] = true;
    isFeatureSelected[4] = true;

    setState(() {
      pageNumber = 2;
    });

    return Scaffold(
      body: uploadFlow(
        context,
        children: [
          Text(
            "Property features",
            style: context.titleLarge,
            textAlign: TextAlign.start,
          ),
          FadedText(
            "Select features that apply to your property",
            style: context.titleSmall,
            textAlign: TextAlign.start,
          ),
          uploadFeaturesGrid(
            features: Feature.values,
            onTap: (index) {
              setState(() {
                isFeatureSelected[index] = !isFeatureSelected[index];
              });
            },
            context: context,
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
                  _navigateToUploadPhotos(viewmodel);
                },
                children: [
                  Text("Next", style: context.bodyMedium),
                  Icon(arrowFowardIcon),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void _navigateToUploadPhotos(PropertiesViewModel viewmodel) {
  List<String> selectedFeatures = Feature.values.keys
      .whereIndexed((index, _) => isFeatureSelected[index] == true)
      .toList();

  viewmodel.uploadProperty.features = selectedFeatures;

  navigate(path: uploadPhotosPath);
}

Widget uploadFeaturesGrid({
  required Map<String, Feature> features,
  required void Function(int index) onTap,
  required BuildContext context,
}) {
  return SizedBox(
    width: context.getMaxWidth,
    child: Wrap(
      spacing: spacingValue,
      runSpacing: spacingValue,
      children: List.generate(features.length, (index) {
        Feature feature = features.values.elementAt(index);
        return SizedBox(
          width: (context.getMaxWidth - spacingValue - paddingValue * 2) / 2,
          child: IntrinsicHeight(
            child: ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(radiusValue),
              ),
              leading: feature.icon is String
                  ? loadSVG(feature.icon, context: context)
                  : Icon(feature.icon),
              title: Text(
                feature.label,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              tileColor: isFeatureSelected[index]
                  ? Colors.blue.withValues(alpha: context.alpha)
                  : context.backgroundColor,
              titleTextStyle: context.bodyMedium,
              onTap: () {
                onTap(index);
              },
            ),
          ),
        );
      }),
    ),
  );
}
