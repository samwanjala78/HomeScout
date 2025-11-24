part of "upload_flow_library.dart";

class UploadPhotos extends StatefulWidget {
  const UploadPhotos({super.key});

  @override
  State<UploadPhotos> createState() => _UploadPhotosState();
}

List<File> imageFiles = [];

bool _isPhotosUploading = false;

bool _showErrorText = false;

class _UploadPhotosState extends State<UploadPhotos> {
  @override
  build(BuildContext context) {
    PropertiesViewModel viewmodel = Provider.of<PropertiesViewModel>(context);
    setState(() {
      pageNumber = 3;
    });

    Widget imageMissingWidget = SizedBox(
      width: double.infinity,
      child: SpacedColumn(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            _showErrorText
                ? "Add at least one photo before continuing"
                : "Added photos will appear hear",
            style: context.titleMedium?.copyWith(
              color: _showErrorText ? Colors.red : context.titleMedium?.color,
            ),
            textAlign: TextAlign.center,
          ),
          Icon(imageMissingIcon, size: context.screenWidth * 0.4),
        ],
      ),
    );

    Widget imageHeader = Text(
      "Uploaded photos (${imageFiles.length})",
      style: context.titleMedium,
    );

    Widget uploadPhotoFlow = uploadFlow(
      context,
      children: [
        Text("Property photos", style: context.titleLarge),
        FadedText(
          padding: 0,
          "Add photos to showcase your property (first photo will be the main image)",
          style: context.titleSmall,
        ),

        IntrinsicHeight(
          child: Row(
            spacing: spacingValue,
            children: [
              Expanded(
                child: uploadPhotoCard(
                  content: [Icon(cameraIcon), Text("Take photo")],
                  onTap: () async {
                    requestCameraPermission(
                      isGranted: () async {
                        XFile? image = await pickImageFromCamera();
                        setState(() {
                          image != null
                              ? imageFiles.add(File(image.path))
                              : null;
                        });
                      },
                    );
                  },
                ),
              ),
              Expanded(
                child: uploadPhotoCard(
                  content: [
                    Icon(galleryIcon),
                    Text("Choose from gallery", textAlign: TextAlign.center),
                  ],
                  onTap: () {
                    requestCameraPermission(
                      isGranted: () async {
                        XFile? image = await pickImageFromGallery();
                        setState(() {
                          image != null
                              ? imageFiles.add(File(image.path))
                              : null;
                        });
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),

        VerticalSpacer(height: spacingValue * 2),

        imageFiles.isEmpty ? imageMissingWidget : imageHeader,

        imageGrid(
          imageFile: imageFiles,
          onRemove: (index) {
            setState(() {
              imageFiles.removeAt(index);
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
              context: context,
              onPressed: () {
                context.pop();
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
                if (imageFiles.isNotEmpty) {
                  navigateToContactInfo(
                    onStart: () {
                      setState(() {
                        _isPhotosUploading = true;
                        _showErrorText = false;
                      });
                    },
                    onEnd: () {
                      setState(() {
                        _isPhotosUploading = false;
                      });
                    },
                    viewmodel: viewmodel,
                  );
                } else {
                  setState(() {
                    _showErrorText = true;
                  });
                }
              },
              children: [
                Text("Next", style: context.bodyMedium),
                Icon(arrowFowardIcon),
              ],
            ),
          ),
        ],
      ),
    );

    return Scaffold(
      body: Stack(
        children: [
          uploadPhotoFlow,
          _isPhotosUploading ? loadingIcon : Container(),
        ],
      ),
    );
  }
}

Widget uploadPhotoCard({
  required List<Widget> content,
  void Function()? onTap,
}) {
  return clickableCard(
    child: SpacedColumn(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: content,
    ),
    onTap: onTap,
  );
}

Widget imageGrid({
  required List<File> imageFile,
  void Function(int index)? onRemove,
  required BuildContext context,
}) {
  return GridView.count(
    crossAxisCount: 2,
    childAspectRatio: 1,
    shrinkWrap: true,
    children: List.generate(imageFile.length, (index) {
      return Hero(
        tag: imageFile[index].hashCode,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black54,
            borderRadius: BorderRadius.circular(radiusValue),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(radiusValue),
            child: Stack(
              children: [
                Image.file(
                  imageFile[index],
                  width: imageRes.width,
                  height: imageRes.height,
                  fit: fit,
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.5),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      visualDensity: VisualDensity.compact,
                      onPressed: () {
                        onRemove?.call(index);
                      },
                      icon: Icon(Icons.close, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }),
  );
}

Future<void> navigateToContactInfo({
  required Function() onStart,
  required Function() onEnd,
  required PropertiesViewModel viewmodel,
}) async {
  onStart();
  viewmodel.uploadProperty.imageUrls =
      (await NetworkLayer.uploadImageToCloudinary(imageFiles))!;
  onEnd();

  navigate(path: contactInfoPath);
}
