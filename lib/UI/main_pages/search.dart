import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:real_estate/UI/ui.dart';
import 'package:real_estate/constants/ui_constants.dart';
import 'package:real_estate/util/util.dart';

import '../../data/viewmodel.dart';
import '../../main.dart';

double defaultLatitude = -1.286389;
double defaultLongitude = 36.8219;

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

List<bool> _isSelected = [true, false];

class _SearchPageState extends State<SearchPage> {
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    PropertiesViewModel viewModel = Provider.of<PropertiesViewModel>(context);

    double longitude = viewModel.locationData?.longitude ?? defaultLongitude;
    double latitude = viewModel.locationData?.latitude ?? defaultLatitude;

    Widget searchField = PlainTextField(
      controller: searchController,
      hint: Text('Search properties'),
      onChanged: (value) {
        viewModel.search(value);
      },
    );

    Widget toggleButtons = ToggleButtons(
      borderRadius: BorderRadius.circular(radiusValue),
      isSelected: _isSelected,
      onPressed: (index) async {
        setState(() {
          if (index == 0) {
            _isSelected[0] = true;
            _isSelected[1] = false;
          } else {
            _isSelected[0] = false;
            _isSelected[1] = true;
          }
        });
        viewModel.locationData = await getCurrentLocation();
      },
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: paddingValue),
          child: Icon(listIcon),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: paddingValue),
          child: Icon(mapsIcon),
        ),
      ],
    );

    List<Widget> listItems = [];

    for (var property in viewModel.displayedSearchProperties) {
      listItems.add(
        searchPageCard(
          viewmodel: viewModel,
          property: property,
          onTap: () {
            navigate(
              path: detailPath,
              extra: viewModel.displayedSearchProperties.indexOf(property),
            );
          },
          context: context,
          onLiked: () {
            Property updated = property.copyWith(liked: !property.liked);
            viewModel.updateProperty(updated);
          },
        ),
      );
    }

    Widget propertiesListView = SingleChildScrollView(
      child: Column(children: listItems),
    );

    Widget propertiesList = listItems.isEmpty
        ? Center(child: Text("No results", style: context.titleMedium))
        : propertiesListView;

    Set<Marker> markers = {};

    for (var property in viewModel.displayedSearchProperties) {
      markers.add(
        Marker(
          markerId: MarkerId(property.id),
          position: LatLng(property.lat, property.lng),
          onTap: () {},
        ),
      );
    }

    Widget mapScreen = CustomMap(
      key: const ValueKey("main-map"),
      initLongitude: longitude,
      initLatitude: latitude,
      markers: markers,
      onMapCreated: (controller) {
        if (viewModel.displayedSearchProperties.isEmpty) {
          updatePosition(latitude, longitude, controller);
        } else {
          log("${viewModel.displayedSearchProperties[0].lat} lat");
          updatePosition(
            viewModel.displayedSearchProperties[0].lat,
            viewModel.displayedSearchProperties[0].lng,
            controller,
          );
        }
      },
    );

    Widget body = Expanded(
      child: IndexedStack(
        index: _isSelected[0] ? 0 : 1,
        children: [propertiesList, mapScreen],
      ),
    );

    return SpacedColumn(
      padding: 0,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        topSpacer(context),
        Padding(padding: paddingValueHorizontal, child: searchField),
        Padding(
          padding: paddingValueHorizontal,
          child: Divider(color: context.backgroundColor),
        ),
        Padding(
          padding: paddingValueHorizontal,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              listItems.isEmpty
                  ? Text("")
                  : FadedText(
                      searchController.text.isNotEmpty
                          ? "${listItems.length} properties found"
                          : "Recommended for you",
                    ),
              toggleButtons,
            ],
          ),
        ),
        body,
      ],
    );
  }
}
