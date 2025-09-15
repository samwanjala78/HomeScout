import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'package:real_estate/constants/ui_constants.dart';
import 'package:real_estate/data/viewmodel.dart';
import 'package:real_estate/gen/assets.gen.dart';
import 'package:real_estate/util/util.dart';

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

  const FadedText({
    this.text = "",
    super.key,
    this.style,
    this.textAlign,
    this.padding = paddingValue / 4,
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
        overflow: TextOverflow.visible,
        maxLines: 2,
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
      padding: EdgeInsets.all(paddingValue / 4),
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

  const VerticalSpacer({super.key, this.height = paddingValue});

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
    return SizedBox(width: super.widget.width ?? paddingValue);
  }
}

class RealEstateApp extends StatefulWidget {
  final Widget child;

  const RealEstateApp({super.key, required this.child});

  @override
  State<RealEstateApp> createState() => _RealEstateAppState();
}

class _RealEstateAppState extends State<RealEstateApp> {
  @override
  Widget build(BuildContext context) {
    return Material(elevation: 0, child: SafeArea(child: super.widget.child));
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
    this.spacing = paddingValue,
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
        children: [
          for (var i = 0; i < widgets.length; i++) ...[
            widgets[i],
            if (i < widgets.length - 1) VerticalSpacer(height: widget.spacing),
          ],
        ],
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
    this.spacing = paddingValue,
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
        children: [
          for (var i = 0; i < widgets.length; i++) ...[
            widgets[i],
            if (i < widgets.length - 1) HorizontalSpacer(width: widget.spacing),
          ],
        ],
      ),
    );
  }
}

Widget spacedVerticalListView(
  List<Widget> listItems, {
  double padding = paddingValue / 2,
  Future<void> Function()? onRefresh,
}) {
  Widget pullDownListView = SafeArea(
    child: RefreshIndicator(
      onRefresh: onRefresh!,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: padding),
        child: ListView.separated(
          itemCount: listItems.length,
          itemBuilder: (context, index) {
            return listItems[index];
          },
          separatorBuilder: (BuildContext context, int index) {
            return VerticalSpacer();
          },
        ),
      ),
    ),
  );

  Widget listView = Padding(
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

  return onRefresh != null ? pullDownListView : listView;
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

class ViewToggleButtons extends StatefulWidget {
  const ViewToggleButtons({super.key});

  @override
  State<ViewToggleButtons> createState() => _ViewToggleButtonsState();
}

class _ViewToggleButtonsState extends State<ViewToggleButtons> {
  List<bool> isSelected = [true, false];

  @override
  Widget build(BuildContext context) {
    return ToggleButtons(
      isSelected: isSelected,
      onPressed: (index) {
        setState(() {
          for (int i = 0; i < isSelected.length; i++) {
            isSelected[i] = i == index;
          }
        });
      },
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: paddingValue),
          child: Icon(grid),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: paddingValue),
          child: Icon(maps),
        ),
      ],
    );
  }
}

class SizedCard extends StatefulWidget {
  final List<Widget> children;
  final void Function()? onTap;

  const SizedCard({super.key, required this.children, this.onTap});

  @override
  State<SizedCard> createState() => _SizedCardState();
}

class _SizedCardState extends State<SizedCard> {
  @override
  Widget build(BuildContext context) {
    return roundedCard(
      child: SpacedColumn(
        mainAxisAlignment: MainAxisAlignment.start,
        children: widget.children,
      ),
      onTap: widget.onTap,
    );
  }
}

class PlainTextField extends StatefulWidget {
  final Widget? hint;
  final Widget? prefixIcon;
  final Widget? label;
  final void Function(String)? onChanged;
  final Iterable<String>? autofillHints;
  final bool obscureText;
  final String? Function(String? value)? validator;
  final TextInputType? textInputType;
  final List<TextInputFormatter>? textInputFormatter;
  final String? initialText;
  final Widget? suffixIcon;

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
    this.initialText = "",
    this.suffixIcon,
  });

  @override
  State<PlainTextField> createState() => _PlainTextFieldState();
}

class _PlainTextFieldState extends State<PlainTextField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: widget.textInputType,
      inputFormatters: widget.textInputFormatter,
      textCapitalization: TextCapitalization.sentences,
      cursorColor: Colors.blue,
      initialValue: widget.initialText,
      onChanged: (value) {
        widget.onChanged?.call(value);
      },
      decoration: InputDecoration(
        suffixIcon: widget.suffixIcon,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(radius),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue, width: 1),
          borderRadius: BorderRadius.circular(radius),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 1),
          borderRadius: BorderRadius.circular(radius),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 1),
          borderRadius: BorderRadius.circular(radius),
        ),
        hint: widget.hint,
        hintStyle: TextStyle(
          color: context.brightness == Brightness.dark
              ? Colors.black
              : Colors.white,
        ),
        prefixIcon: widget.prefixIcon,
        label: widget.label,
        filled: true,
        fillColor: context.brightness == Brightness.dark
            ? Colors.grey.shade800
            : Colors.grey.shade300,
      ),
      autofillHints: widget.autofillHints,
      obscureText: widget.obscureText,
      validator: (value) => widget.validator?.call(value),
    );
  }
}

Widget imageContainer(
  Property property, {
  double borderRadius = radius,
  double padding = paddingValue / 4,
  int cacheHeight = 500,
  required BuildContext context,
}) {
  return Hero(
    tag: property.title,
    child: Container(
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.vertical(top: Radius.circular(borderRadius)),
      ),
      width: double.infinity,
      height: getImageHeight(context.screenWidth, context.screenHeight),
      child: ClipRRect(
        borderRadius: BorderRadius.vertical(top: Radius.circular(borderRadius)),
        child: Image.network(
          property.imageUrls[0],
          fit: fit,
          height: imageRes.width,
          width: imageRes.width,
          errorBuilder: (context, error, stackTrace) {
            log("Image failed: $error");
            return Icon(Icons.error);
          },
        ),
      ),
    ),
  );
}

Widget propertyType(Property property) => Container(
  decoration: BoxDecoration(
    color: Colors.black54,
    borderRadius: BorderRadius.circular(radius / 2),
  ),
  child: Padding(
    padding: EdgeInsets.all(paddingValue / 4),
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

Widget iconTextPair(Widget icon, Widget text) => Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    icon,
    HorizontalSpacer(width: paddingValue / 4),
    text,
  ],
);

Widget locationPair(BuildContext context, Property property) => iconTextPair(
  Icon(location, color: context.fadedIconColor),
  FadedText(text: property.location),
);

Widget ratingPair(BuildContext context, Property property) => iconTextPair(
  Icon(star, color: Colors.amber),
  FadedText(text: property.rating),
);

Widget viewPair(BuildContext context, Property property) => iconTextPair(
  Icon(eye, color: context.fadedIconColor),
  FadedText(text: property.views),
);

Widget mainCard({
  required Property property,
  required Function() onTap,
  required BuildContext context,
  required Function() onLiked,
}) {
  Widget propertyImage = imageContainer(property, context: context);

  Widget propertyTitle = Text(property.title);

  Widget price = Text(property.price);

  CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.start;

  Widget roomsBaths = Row(
    spacing: paddingValue,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(bed, color: context.fadedIconColor),
          HorizontalSpacer(width: paddingValue / 4),
          FadedText(text: property.bedrooms),
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(bath, color: context.fadedIconColor),
          HorizontalSpacer(width: paddingValue / 4),
          FadedText(text: property.bedrooms),
        ],
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
            decoratedIconButton(
              icon: loadSVG(
                Assets.icons.heartRegularFull,
                color: property.liked ? Colors.red : Colors.white,
                context: context,
              ),
              onPressed: onLiked,
            ),
          ],
        ),
      ),
    ],
  );

  return SizedBox(
    width: double.infinity,
    child: roundedCard(child: cardContents, onTap: onTap),
  );
}

Widget roundedButton({
  required final void Function() onPressed,
  required Widget child,
  ButtonStyle? style,
}) {
  return ElevatedButton(
    onPressed: onPressed,
    style:
        style ??
        ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
          ),
        ),
    child: child,
  );
}

Widget roundedCard({
  required Widget child,
  double borderRadius = radius,
  void Function()? onTap,
}) {
  return Card(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(borderRadius),
    ),
    child: InkWell(onTap: onTap, child: child),
  );
}

Widget labeledTextField({
  final Widget? hint,
  final Widget? prefixIcon,
  required final Widget label,
  final void Function(String)? onChanged,
  final Iterable<String>? autofillHints,
  final bool obscureText = false,
  final String? Function(String? value)? validator,
  TextInputType? textInputType,
  List<TextInputFormatter>? textInputFormatter,
  String? initialText,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      label,
      VerticalSpacer(height: paddingValue / 2),
      PlainTextField(
        hint: hint,
        prefixIcon: prefixIcon,
        onChanged: onChanged,
        autofillHints: autofillHints,
        obscureText: obscureText,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "This field can't be empty";
          }
          return validator?.call(value);
        },
        textInputType: textInputType,
        textInputFormatter: textInputFormatter,
        initialText: initialText,
      ),
    ],
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
          spacing: paddingValue / 2,
          children: children,
        ),
      ),
    ),
  );
}

Widget uploadFlow({
  required List<Widget> children,
  required Widget bottomWidget,
}) {
  return SafeArea(
    child: Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: SpacedColumn(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: paddingValue),
          child: bottomWidget,
        ),
      ],
    ),
  );
}

Widget featuresGrid({
  required List<Feature> features,
  void Function(int index)? onTap,
  required BuildContext context,
}) {
  return GridView.count(
    crossAxisCount: 2,
    childAspectRatio: 2.5,
    shrinkWrap: true,
    physics: NeverScrollableScrollPhysics(),
    children: List.generate(features.length, (index) {
      return roundedCard(
        child: SpacedRow(
          mainAxisAlignment: MainAxisAlignment.center,
          padding: EdgeInsets.only(left: paddingValue),
          children: [
            features[index].icon is String
                ? loadSVG(features[index].icon, context: context)
                : Icon(features[index].icon),
            Expanded(
              child: Text(
                features[index].label,
                softWrap: true,
                overflow: TextOverflow.fade,
                maxLines: 2,
              ),
            ),
          ],
        ),
        onTap: () {
          onTap?.call(index);
        },
      );
    }),
  );
}

Widget loadingIcon = Center(
  child: LoadingAnimationWidget.fourRotatingDots(color: Colors.blue, size: 60),
);
