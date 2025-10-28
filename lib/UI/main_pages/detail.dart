import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:real_estate/UI/ui.dart';
import 'package:real_estate/util/util.dart';

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
    PropertiesViewModel viewModel = Provider.of<PropertiesViewModel>(context);
    var selectedPropertyIndex = GoRouterState.of(context).extra as int;
    final currentProperty = viewModel.properties[selectedPropertyIndex];

    Widget image = imageContainer(
      currentProperty,
      context: context,
      borderRadius: 0,
    );

    Widget imageControlButtons = Positioned.fill(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {},
            icon: Icon(arrowBackAltIcon, color: Colors.white),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(arrowFowardAltIcon, color: Colors.white),
          ),
        ],
      ),
    );

    Widget actions = Padding(
      padding: paddingValueAll,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.black54,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: context.pop,
              icon: Icon(arrowBack, color: Colors.white),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.black54,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: context.pop,
              icon: Icon(favoriteIcon, color: Colors.white),
            ),
          ),
        ],
      ),
    );

    Widget imageCarousel = Stack(
      children: [image, imageControlButtons, actions],
    );

    Widget infoColumn(String type, IconData icon, String property) {
      return SpacedColumn(
        spacing: spacingValue / 4,
        children: [
          Icon(icon),
          FadedText(property),
          FadedText(type),
        ],
      );
    }

    Widget propertyDetails = SpacedColumn(
      crossAxisAlignment: CrossAxisAlignment.start,
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

    Widget infoCard = clickableCard(
      child: SpacedRow(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          infoColumn("Bedrooms", bedIcon, currentProperty.bedrooms),
          infoColumn("Bathrooms", bathIcon, currentProperty.bathrooms),
          infoColumn("Area", areaIcon, currentProperty.area),
        ],
      ),
    );

    Widget locationCard = clickableCard(
      onTap: () {
        openMapAtMarker(currentProperty.lat, currentProperty.lng);
      },
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: paddingValue),
            child: Row(
              children: [
                Icon(locationIcon),
                FadedText(currentProperty.location),
              ],
            ),
          ),

          SizedBox(
            height: 150,
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(radiusValue),
              ),
              child: CustomMap(
                onTap: (_) {
                  openMapAtMarker(currentProperty.lat, currentProperty.lng);
                },
                zoomControlsEnabled: false,
                scrollGesturesEnabled: false,
                rotateGesturesEnabled: false,
                tiltGesturesEnabled: false,
                myLocationButtonEnabled: false,
                zoomGesturesEnabled: false,
                initLatitude: currentProperty.lat,
                initLongitude: currentProperty.lng,
                markers: {
                  Marker(
                    markerId: const MarkerId("location"),
                    position: LatLng(currentProperty.lat, currentProperty.lng),
                  ),
                },
              ),
            ),
          ),
        ],
      ),
    );

    List<Feature> features = currentProperty.features
        .map((stringFeature) => Feature.values[stringFeature]!)
        .toList();

    Widget featuresColumn = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PaddedText(text: "Property Features", style: context.titleMedium),
        featuresGrid(features: features, onTap: (_) {}, context: context),
      ],
    );

    Widget descriptionText = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PaddedText(text: "Description", style: context.titleMedium),
        FadedText(currentProperty.description),
      ],
    );

    Widget body = SingleChildScrollView(
      child: Column(
        children: [
          imageCarousel,
          VerticalSpacer(),
          Padding(
            padding: paddingValueAll,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: spacingValue,
              children: [
                propertyDetails,
                infoCard,
                locationCard,
                featuresColumn,
                descriptionText,
              ],
            ),
          ),
        ],
      ),
    );

    return SafeArea(child: Scaffold(body: body));
  }
}
