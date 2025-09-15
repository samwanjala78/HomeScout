import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:real_estate/UI/ui.dart';

import '../../data/viewmodel.dart';
import '../../constants/ui_constants.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({super.key});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    var selectedPropertyIndex = GoRouterState.of(context).extra as int;
    PropertiesViewModel viewModel = Provider.of<PropertiesViewModel>(context);
    final currentProperty = viewModel.properties[selectedPropertyIndex];

    PreferredSizeWidget appbar = AppBar(
      backgroundColor:
          (context.brightness == Brightness.dark ? Colors.black : Colors.white)
              .withValues(alpha: 0.4),
      flexibleSpace: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(color: Colors.transparent),
        ),
      ),
    );

    Widget image = imageContainer(currentProperty, context: context);

    Widget imageControlButtons = Positioned.fill(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {},
            icon: Icon(arrowBackAlt, color: Colors.white),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(arrowFowardAlt, color: Colors.white),
          ),
        ],
      ),
    );

    Widget imageCarousel = Stack(children: [image, imageControlButtons]);

    Widget infoColumn(String type, IconData icon, String property) {
      return SpacedColumn(
        spacing: paddingValue / 4,
        children: [
          Icon(icon),
          FadedText(text: property),
          FadedText(text: type),
        ],
      );
    }

    Widget propertyDetails = SpacedColumn(
      spacing: 0,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(currentProperty.title, style: context.bodyLarge),
            Text(currentProperty.price, style: context.bodyLarge),
          ],
        ),
        locationPair(context, currentProperty),
        Row(
          children: [
            ratingPair(context, currentProperty),
            HorizontalSpacer(),
            viewPair(context, currentProperty),
          ],
        ),
      ],
    );

    Widget infoCard = roundedCard(
      child: SpacedRow(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          infoColumn("Bedrooms", bed, currentProperty.bedrooms),
          infoColumn("Bathrooms", bath, currentProperty.bathrooms),
          infoColumn("Area", area, currentProperty.area),
        ],
      ),
    );

    List<Feature> features = currentProperty.features.map((stringFeature) => Feature.values[stringFeature]!).toList();

    Widget featuresColumn = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PaddedText(text: "Property Features", style: context.titleMedium),
        featuresGrid(features: features, onTap: (_){}, context: context),
      ],
    );

    Widget descriptionText = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PaddedText(text: "Description", style: context.titleMedium),
        FadedText(text: currentProperty.description),
      ],
    );

    Widget body = spacedVerticalListView([
      imageCarousel,
      propertyDetails,
      infoCard,
      featuresColumn,
      descriptionText,
    ]);

    return Scaffold(appBar: appbar, body: body, extendBodyBehindAppBar: true);
  }
}
