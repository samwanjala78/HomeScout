part of "upload_flow_library.dart";

class PropertyFeatures extends StatefulWidget {
  const PropertyFeatures({super.key});

  @override
  State<PropertyFeatures> createState() => _PropertyFeaturesState();
}

class _PropertyFeaturesState extends State<PropertyFeatures> {

  @override
  Widget build(BuildContext context) {
    isFeatureSelected[1] = true;
    isFeatureSelected[2] = true;
    isFeatureSelected[4] = true;

    setState(() {
      pageNumber = 2;
    });
    return uploadFlow(
      children: [
        Text(
          "Property features",
          style: context.titleLarge,
          textAlign: TextAlign.start,
        ),
        FadedText(
          text: "Select features that apply to your property",
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
          contex: context
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
                _navigateToUploadPhotos();
              },
              children: [
                Text("Next", style: context.bodyMedium),
                Icon(arrowFoward),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

void _navigateToUploadPhotos() {
  List<String> selectedFeatures = Feature.values.keys
      .whereIndexed((index, _) => isFeatureSelected[index] == true)
      .toList();

  bufferPropertyObject.features = selectedFeatures;

  navigate(path: uploadPhotosPath);
}

Widget uploadFeaturesGrid({
  required Map<String, Feature> features,
  required void Function(int index) onTap,
  required BuildContext contex
}) {
  return GridView.count(
    crossAxisCount: 2,
    childAspectRatio: 2.5,
    shrinkWrap: true,
    physics: NeverScrollableScrollPhysics(),
    children: List.generate(features.length, (index) {
      Feature feature = features.values.elementAt(index);
      return roundedCard(
        child: SpacedRow(
          padding: EdgeInsets.symmetric(horizontal: paddingValue / 2),
          children: [
            feature.icon is String ? loadSVG(feature.icon, context: contex) : Icon(feature.icon),
            Expanded(
              child: Text(
                feature.label,
                softWrap: true,
                overflow: TextOverflow.fade,
                maxLines: 2,
              ),
            ),
            isFeatureSelected[index] ? Icon(done) : Container(),
          ],
        ),
        onTap: () {
          onTap(index);
        },
      );
    }),
  );
}
