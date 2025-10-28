part of "upload_flow_library.dart";

var pageNumber = 1;

class UploadPage extends StatefulWidget {
  final Widget body;

  const UploadPage({super.key, required this.body});

  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    PreferredSizeWidget appbar = blurredAppBar(
      centerTitle: true,
      title: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("List your property"),
          FadedText("Step $pageNumber of 4", style: context.bodyMedium),
        ],
      ),
    );

    return SafeArea(
      child: Scaffold(
        appBar: appbar,
        extendBodyBehindAppBar: true,
        body: widget.body,
      ),
    );
  }
}
