import 'dart:async';
import 'dart:developer';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:real_estate/constants/ui_constants.dart';
import 'package:real_estate/data/viewmodel.dart';
import 'package:real_estate/util/util.dart';
import 'package:shimmer/shimmer.dart';

class AnimatedButton extends StatefulWidget {
  const AnimatedButton({
    super.key,
    required this.onPressed,
    required this.begin,
    required this.end,
    required this.child,
  });

  final VoidCallback onPressed;
  final Color? begin;
  final Color? end;
  final Widget child;

  @override
  State<StatefulWidget> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton> {
  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<Color?>(
      tween: ColorTween(begin: widget.begin, end: widget.end),
      duration: const Duration(milliseconds: 300),
      builder: (context, color, child) {
        return ElevatedButton(
          onPressed: widget.onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            foregroundColor: Colors.white,
          ),
          child: widget.child,
        );
      },
    );
  }
}

class FadedText extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final double padding;

  const FadedText(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.padding = paddingValue,
  });

  @override
  State<StatefulWidget> createState() => _FadedTextState();
}

class _FadedTextState extends State<FadedText> {
  TextStyle? fadedTextStyle(TextStyle? baseTextStyle) {
    final fadedColor = baseTextStyle?.color?.withValues(alpha: 0.6);
    return baseTextStyle?.copyWith(color: fadedColor);
  }

  @override
  Widget build(BuildContext context) {
    final style = widget.style ?? Theme.of(context).textTheme.bodyMedium;
    return Padding(
      padding: EdgeInsets.all(widget.padding),
      child: Text(
        widget.text,
        style: fadedTextStyle(style),
        textAlign: widget.textAlign,
        softWrap: true,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
    );
  }
}

class PaddedText extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;

  const PaddedText({this.text = "", super.key, this.style, this.textAlign});

  @override
  State<StatefulWidget> createState() => _PaddedTextState();
}

class _PaddedTextState extends State<PaddedText> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(paddingValue),
      child: Text(
        widget.text,
        style: widget.style,
        textAlign: widget.textAlign,
      ),
    );
  }
}

class VerticalSpacer extends StatefulWidget {
  final double? height;

  const VerticalSpacer({super.key, this.height = spacingValue});

  @override
  State<StatefulWidget> createState() => _VerticalSpacerState();
}

class _VerticalSpacerState extends State<VerticalSpacer> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(height: super.widget.height);
  }
}

class HorizontalSpacer extends StatefulWidget {
  final double? width;

  const HorizontalSpacer({super.key, this.width});

  @override
  State<StatefulWidget> createState() => _HorizontalSpacerState();
}

class _HorizontalSpacerState extends State<HorizontalSpacer> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(width: super.widget.width ?? spacingValue);
  }
}

class SpacedColumn extends StatefulWidget {
  final List<Widget> children;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisAlignment mainAxisAlignment;
  final double? spacing;
  final double padding;

  const SpacedColumn({
    super.key,
    this.children = const <Widget>[],
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.spacing = spacingValue,
    this.padding = paddingValue,
  });

  @override
  State<SpacedColumn> createState() => _SpacedColumnState();
}

class _SpacedColumnState extends State<SpacedColumn> {
  List<Widget> get widgets => widget.children;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(widget.padding),
      child: Column(
        crossAxisAlignment: super.widget.crossAxisAlignment,
        mainAxisAlignment: super.widget.mainAxisAlignment,
        spacing: widget.spacing ?? 0,
        children: widgets,
      ),
    );
  }
}

class SpacedRow extends StatefulWidget {
  final List<Widget> children;
  final double? spacing;
  final CrossAxisAlignment? crossAxisAlignment;
  final MainAxisAlignment? mainAxisAlignment;
  final EdgeInsetsGeometry padding;

  const SpacedRow({
    super.key,
    this.children = const <Widget>[],
    this.spacing = spacingValue,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.padding = const EdgeInsets.all(paddingValue),
  });

  @override
  State<SpacedRow> createState() => _SpacedRowState();
}

class _SpacedRowState extends State<SpacedRow> {
  List<Widget> get widgets => widget.children;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding,
      child: Row(
        crossAxisAlignment: widget.crossAxisAlignment!,
        mainAxisAlignment: widget.mainAxisAlignment!,
        spacing: widget.spacing ?? 0,
        children: widgets,
      ),
    );
  }
}

class RefreshSpacedVerticalListView extends StatefulWidget {
  final Future<void> Function() onRefresh;
  final double padding;
  final List<Widget> listItems;
  final GlobalKey<AnimatedListState>? listKey;

  const RefreshSpacedVerticalListView({
    super.key,
    required this.onRefresh,
    this.padding = paddingValue,
    required this.listItems,
    this.listKey,
  });

  @override
  State<RefreshSpacedVerticalListView> createState() =>
      _RefreshSpacedVerticalListViewState();
}

class _RefreshSpacedVerticalListViewState
    extends State<RefreshSpacedVerticalListView> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: widget.padding),
      child: RefreshIndicator(
        onRefresh: widget.onRefresh,
        child: ListView.separated(
          key: widget.listKey,
          itemCount: widget.listItems.length,
          itemBuilder: (context, index) {
            return widget.listItems[index];
          },
          separatorBuilder: (BuildContext context, int index) {
            return VerticalSpacer();
          },
        ),
      ),
    );
  }
}

Widget spacedVerticalListView(
  List<Widget> listItems, {
  double padding = paddingValue,
}) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: padding),
    child: ListView.separated(
      itemCount: listItems.length,
      itemBuilder: (context, index) {
        return listItems[index];
      },
      separatorBuilder: (BuildContext context, int index) {
        return VerticalSpacer();
      },
    ),
  );
}

Widget spacedHorizontalListView(List<Widget> listItems) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: paddingValue),
    child: ListView.separated(
      itemCount: listItems.length,
      itemBuilder: (context, index) {
        return listItems[index];
      },
      separatorBuilder: (BuildContext context, int index) {
        return HorizontalSpacer();
      },
    ),
  );
}

class SpacedDivider extends StatefulWidget {
  final double? height;
  final double? thickness;
  final double? indent;
  final double? endIndent;
  final BorderRadiusGeometry? radius;
  final Color? color;

  const SpacedDivider({
    super.key,
    this.height,
    this.thickness,
    this.indent,
    this.endIndent,
    this.radius,
    this.color,
  });

  @override
  State<SpacedDivider> createState() => _SpacedDividerState();
}

class _SpacedDividerState extends State<SpacedDivider> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        VerticalSpacer(),
        Divider(
          key: super.widget.key,
          height: super.widget.height,
          thickness: super.widget.thickness,
          indent: super.widget.indent,
          endIndent: super.widget.endIndent,
          radius: super.widget.radius,
          color: super.widget.color,
        ),
        VerticalSpacer(),
      ],
    );
  }
}

class SizedCard extends StatefulWidget {
  final List<Widget> children;
  final void Function()? onTap;
  final Color? color;

  const SizedCard({super.key, required this.children, this.onTap, this.color});

  @override
  State<SizedCard> createState() => _SizedCardState();
}

class _SizedCardState extends State<SizedCard> {
  @override
  Widget build(BuildContext context) {
    return clickableCard(
      borderRadius: 999,
      color: widget.color,
      onTap: widget.onTap,
      child: SpacedRow(
        padding: EdgeInsets.all(paddingValue),
        spacing: spacingValue / 4,
        mainAxisAlignment: MainAxisAlignment.start,
        children: widget.children,
      ),
    );
  }
}

class PlainTextField extends StatefulWidget {
  final Widget? hint;
  final Widget? prefixIcon;
  final Widget? label;
  final void Function(String)? onChanged;
  final void Function()? onTap;
  final Iterable<String>? autofillHints;
  final bool obscureText;
  final String? Function(String? value)? validator;
  final TextInputType? textInputType;
  final List<TextInputFormatter>? textInputFormatter;
  final String? initialText;
  final Widget? suffixIcon;
  final String? errorText;
  final TextEditingController? controller;

  const PlainTextField({
    super.key,
    this.textInputFormatter,
    this.hint,
    this.prefixIcon,
    this.onChanged,
    this.label,
    this.autofillHints,
    this.obscureText = false,
    this.validator,
    this.textInputType,
    this.initialText,
    this.suffixIcon,
    this.errorText,
    this.onTap,
    this.controller,
  });

  @override
  State<PlainTextField> createState() => _PlainTextFieldState();
}

class _PlainTextFieldState extends State<PlainTextField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textCapitalization: TextCapitalization.sentences,
      controller: widget.controller,
      onTap: widget.onTap,
      keyboardType: widget.textInputType,
      inputFormatters: widget.textInputFormatter,
      cursorColor: Colors.blue,
      initialValue: widget.initialText,
      onChanged: widget.onChanged,
      decoration: InputDecoration(
        errorText: widget.errorText,
        suffixIcon: widget.suffixIcon,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(999),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide.none,
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
        hint: widget.hint,
        prefixIcon: widget.prefixIcon,
        label: widget.label,
        filled: true,
        fillColor: context.backgroundColor,
      ),
      autofillHints: widget.autofillHints,
      obscureText: widget.obscureText,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "This field can't be empty";
        }
        return widget.validator?.call(value);
      },
    );
  }
}

Widget imageContainer(
  Property property, {
  double borderRadius = radiusValue,
  double padding = paddingValue,
  required BuildContext context,
}) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.black54,
      borderRadius: BorderRadius.vertical(top: Radius.circular(borderRadius)),
    ),
    width: context.getMaxWidth,
    height: context.getImageHeight,
    child: ClipRRect(
      borderRadius: BorderRadius.vertical(top: Radius.circular(borderRadius)),
      child: CachedNetworkImage(
        imageUrl: property.imageUrls[0],
        fit: fit,
        height: imageRes.width,
        width: imageRes.width,
        errorWidget: (context, error, stackTrace) {
          log("Image failed: $error");
          return Icon(Icons.error);
        },
      ),
    ),
  );
}

Widget propertyType(Property property) => Container(
  decoration: BoxDecoration(
    color: Colors.blue.shade900,
    borderRadius: BorderRadius.circular(radiusValue / 2),
  ),
  child: Padding(
    padding: EdgeInsets.all(paddingValue),
    child: Text(property.type, style: TextStyle(color: Colors.white)),
  ),
);

Widget decoratedIconButton({
  required Widget icon,
  void Function()? onPressed,
}) => Container(
  decoration: BoxDecoration(color: Colors.black54, shape: BoxShape.circle),
  child: IconButton(onPressed: onPressed, icon: icon),
);

Widget iconTextPair(
  Widget icon,
  Widget text, {
  MainAxisAlignment mainAxisAlignment = MainAxisAlignment.spaceBetween,
}) => Row(
  mainAxisSize: MainAxisSize.min,
  mainAxisAlignment: mainAxisAlignment,
  children: [
    icon,
    HorizontalSpacer(width: spacingValue / 2),
    text,
  ],
);

Widget textIconPair(
  Widget text,
  Widget icon, {
  MainAxisAlignment mainAxisAlignment = MainAxisAlignment.spaceBetween,
}) => Row(
  mainAxisSize: MainAxisSize.min,
  mainAxisAlignment: mainAxisAlignment,
  children: [
    text,
    HorizontalSpacer(width: spacingValue / 4),
    icon,
  ],
);

Widget locationPair(BuildContext context, Property property) => iconTextPair(
  Icon(locationIcon, color: context.fadedIconColor),
  FadedText(property.location),
);

Widget ratingPair(BuildContext context, Property property) => iconTextPair(
  Icon(starIcon, color: Colors.amber),
  FadedText(property.rating.toString(), style: TextStyle(color: Colors.amber)),
);

Widget viewPair(BuildContext context, Property property) => iconTextPair(
  Icon(eyeIcon, color: context.highlightColor),
  Text(
    property.views.toString(),
    style: TextStyle(color: context.highlightColor),
  ),
);

Widget homeCard({
  required PropertiesViewModel viewmodel,
  required Property property,
  required Function() onTap,
  required BuildContext context,
  Color? color,
  required Widget iconButton,
}) {
  Widget propertyImage = imageContainer(property, context: context);

  Widget propertyTitle = Text(property.title);

  Widget price = Text(property.price);

  CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.start;

  Widget roomsBaths = Row(
    spacing: spacingValue,
    children: [
      iconTextPair(
        Icon(bedIcon, color: context.highlightColor),
        Text(
          property.bedrooms,
          style: TextStyle(color: context.highlightColor),
        ),
      ),

      iconTextPair(
        Icon(bathIcon, color: context.highlightColor),
        Text(
          property.bathrooms,
          style: TextStyle(color: context.highlightColor),
        ),
      ),
    ],
  );

  Widget metadata = Padding(
    padding: paddingValueAll,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: crossAxisAlignment,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            propertyTitle,
            locationPair(context, property),
            VerticalSpacer(),
            roomsBaths,
          ],
        ),
        Column(
          crossAxisAlignment: crossAxisAlignment,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            price,
            ratingPair(context, property),
            VerticalSpacer(),
            viewPair(context, property),
          ],
        ),
      ],
    ),
  );

  Widget cardContents = Stack(
    children: [
      Column(children: [propertyImage, metadata]),
      Padding(
        padding: paddingValueAll,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            propertyType(property),
            customIconContainer(color: Colors.black54, child: iconButton),
          ],
        ),
      ),
    ],
  );

  return clickableCard(
    color: color,
    child: cardContents,
    onTap: () async {
      viewmodel.validateView(
        userId: viewmodel.currentUser!.id,
        propertyId: property.id,
      );
      onTap();
    },
  );
}

Widget searchPageCard({
  required PropertiesViewModel viewmodel,
  required Property property,
  required Function() onTap,
  required BuildContext context,
  required Function() onLiked,
  Color? color,
}) {
  Widget propertyImage = Hero(
    tag: property.title,
    child: Container(
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.horizontal(
          left: Radius.circular(radiusValue),
        ),
      ),
      width: 140,
      height: context.getImageHeight * 0.6,
      child: ClipRRect(
        borderRadius: BorderRadius.horizontal(
          left: Radius.circular(radiusValue),
        ),
        child: CachedNetworkImage(
          imageUrl: property.imageUrls[0],
          fit: fit,
          height: imageRes.width,
          width: imageRes.width,
          errorWidget: (context, error, stackTrace) {
            log("Image failed: $error");
            return Icon(Icons.error);
          },
        ),
      ),
    ),
  );

  Widget propertyTitle = Text(property.title, overflow: TextOverflow.ellipsis);

  Widget price = Text(
    property.price,
    style: TextStyle(
      color: context.highlightColor,
      overflow: TextOverflow.ellipsis,
    ),
  );

  Widget roomsBaths = Row(
    spacing: spacingValue,
    children: [
      iconTextPair(
        Icon(bedIcon, color: context.highlightColor),
        Text(
          property.bedrooms,
          style: TextStyle(color: context.highlightColor),
        ),
      ),
      iconTextPair(
        Icon(bathIcon, color: context.highlightColor),
        Text(
          property.bathrooms,
          style: TextStyle(color: context.highlightColor),
        ),
      ),
    ],
  );

  Widget metadata = Padding(
    padding: paddingValueAll,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        propertyTitle,
        locationPair(context, property),
        price,
        roomsBaths,
      ],
    ),
  );

  Widget cardContents = Stack(
    children: [
      Row(children: [propertyImage, metadata]),
      Padding(
        padding: paddingValueAll,
        child: Align(
          alignment: Alignment.topLeft,
          child: propertyType(property),
        ),
      ),
    ],
  );

  return clickableCard(
    color: color,
    child: cardContents,
    onTap: () async {
      viewmodel.validateView(
        userId: viewmodel.currentUser!.id,
        propertyId: property.id,
      );
      onTap();
    },
  );
}

Widget customIconContainer({
  required Widget child,
  Color color = Colors.white,
  double borderRadius = radiusValue,
  double padding = paddingValue,
}) {
  return Container(
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadiusGeometry.all(Radius.circular(borderRadius)),
    ),
    child: Padding(padding: EdgeInsetsGeometry.all(padding), child: child),
  );
}

Widget roundedButton({
  Key? key,
  required final void Function() onPressed,
  required Widget child,
  ButtonStyle? style,
}) {
  return ElevatedButton(
    key: key,
    onPressed: onPressed,
    style:
        style ??
        ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusValue),
          ),
        ),
    child: child,
  );
}

Widget clickableCard({
  required Widget child,
  void Function()? onTap,
  Color? color,
  Color? shadowColor,
  double borderRadius = radiusValue,
}) {
  return Card(
    shadowColor: shadowColor,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(borderRadius),
    ),
    color: color,
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(radiusValue),
      child: child,
    ),
  );
}

Widget customButton({
  required void Function() onPressed,
  required List<Widget> children,
  AlignmentGeometry alignment = Alignment.centerRight,
  MainAxisSize mainAxisSize = MainAxisSize.min,
  double innerPadding = 0,
}) {
  return Align(
    alignment: alignment,
    child: roundedButton(
      onPressed: onPressed,
      child: Padding(
        padding: EdgeInsetsGeometry.all(innerPadding),
        child: Row(
          mainAxisSize: mainAxisSize,
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: spacingValue / 2,
          children: children,
        ),
      ),
    ),
  );
}

Widget uploadFlow(
    BuildContext context,{
  required List<Widget> children,
  required Widget bottomWidget,
}) {
  return Column(
    children: [
      Expanded(
        child: SingleChildScrollView(
          child: SpacedColumn(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [topSpacer(context), ...children],
          ),
        ),
      ),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: paddingValue),
        child: bottomWidget,
      ),
    ],
  );
}

Widget featuresGrid({
  required List<Feature> features,
  void Function(int index)? onTap,
  required BuildContext context,
}) {
  return SizedBox(
    width: context.getMaxWidth,
    child: Wrap(
      spacing: spacingValue,
      runSpacing: spacingValue,
      children: List.generate(features.length, (index) {
        return SizedBox(
          width: (context.getMaxWidth - spacingValue - paddingValue * 2) / 2,
          child: IntrinsicHeight(
            child: ListTile(
              tileColor: Colors.blue.withValues(alpha: context.alpha),
              leading: features[index].icon is String
                  ? loadSVG(features[index].icon, context: context)
                  : Icon(features[index].icon),
              title: Text(
                features[index].label,
                softWrap: true,
                overflow: TextOverflow.fade,
                maxLines: 2,
              ),
              titleTextStyle: context.bodyMedium,
              onTap: () {
                onTap?.call(index);
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(radiusValue),
              ),
            ),
          ),
        );
      }),
    ),
  );
}

Widget loadingIcon = Center(
  child: LoadingAnimationWidget.fourRotatingDots(color: Colors.blue, size: 60),
);

Widget placeHolderShimmer({
  required Widget child,
  required BuildContext context,
}) {
  return Shimmer.fromColors(
    baseColor: context.getBrightness == Brightness.dark
        ? Colors.grey.shade900
        : Colors.grey.shade300,
    highlightColor: context.getBrightness == Brightness.dark
        ? Colors.grey.shade800
        : Colors.grey.shade200,
    child: child,
  );
}

Widget container({
  required double width,
  required double height,
  BorderRadiusGeometry? borderRadius,
  required BuildContext context,
}) {
  return Container(
    width: width,
    height: height,
    decoration: BoxDecoration(
      borderRadius: borderRadius ?? BorderRadius.circular(radiusValue),
      color: context.backgroundColor,
    ),
  );
}

class CustomMap extends StatefulWidget {
  final double initLatitude;
  final double initLongitude;
  final Set<Marker> markers;
  final Function(LatLng latlng)? onTap;
  final Function(GoogleMapController controller)? onMapCreated;
  final bool zoomControlsEnabled;
  final bool scrollGesturesEnabled;
  final bool rotateGesturesEnabled;
  final bool tiltGesturesEnabled;
  final bool myLocationButtonEnabled;
  final bool zoomGesturesEnabled;

  const CustomMap({
    super.key,
    required this.initLatitude,
    required this.initLongitude,
    this.markers = const <Marker>{},
    this.onTap,
    this.zoomControlsEnabled = true,
    this.scrollGesturesEnabled = true,
    this.rotateGesturesEnabled = true,
    this.tiltGesturesEnabled = true,
    this.myLocationButtonEnabled = true,
    this.zoomGesturesEnabled = true,
    this.onMapCreated,
  });

  @override
  State<CustomMap> createState() => _CustomMapState();
}

class _CustomMapState extends State<CustomMap> {
  @override
  Widget build(BuildContext context) {
    CameraPosition initialPosition = CameraPosition(
      target: LatLng(widget.initLatitude, widget.initLongitude),
      zoom: 17,
    );

    return GoogleMap(
      markers: widget.markers,
      initialCameraPosition: initialPosition,
      onMapCreated: widget.onMapCreated,
      onTap: widget.onTap,
      zoomControlsEnabled: widget.zoomControlsEnabled,
      scrollGesturesEnabled: widget.scrollGesturesEnabled,
      rotateGesturesEnabled: widget.rotateGesturesEnabled,
      tiltGesturesEnabled: widget.tiltGesturesEnabled,
      myLocationButtonEnabled: widget.myLocationButtonEnabled,
      zoomGesturesEnabled: widget.zoomGesturesEnabled,
    );
  }
}

Future<void> updatePosition(
  double lat,
  double lng,
  GoogleMapController controller,
) async {
  controller.animateCamera(CameraUpdate.newLatLng(LatLng(lat, lng)));
}

Container buttonContainer(Widget child, BuildContext context, Color? color) {
  return Container(
    decoration: ShapeDecoration(
      color:
          color ??
          (context.getBrightness == Brightness.dark
              ? Colors.blue.shade900
              : Colors.blue.shade300),
      shape: StadiumBorder(),
    ),
    child: Padding(
      padding: EdgeInsets.symmetric(
        vertical: paddingValue / 2,
        horizontal: paddingValue * 2,
      ),
      child: child,
    ),
  );
}

AppBar blurredAppBar({
  required Widget title,
  List<Widget>? actions,
  bool? centerTitle,
}) {
  return AppBar(
    centerTitle: centerTitle,
    elevation: 0,
    title: title,
    actions: actions,
    flexibleSpace: ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(color: Colors.transparent),
      ),
    ),
  );
}

Widget topSpacer(BuildContext context) => Container(
  height: MediaQuery.of(context).padding.top + kToolbarHeight,
  color: Colors.transparent,
);

void toast(String message, {Toast toastLength = Toast.LENGTH_SHORT}) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: toastLength,
    gravity: ToastGravity.BOTTOM,
    textColor: Colors.white,
    fontSize: 16.0,
  );
}
