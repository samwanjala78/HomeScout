import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_google_places_sdk/flutter_google_places_sdk.dart'
    hide LatLng;
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:real_estate/UI/main_pages/search.dart';
import 'package:real_estate/UI/ui.dart';
import 'package:real_estate/constants/ui_constants.dart';
import 'package:real_estate/network/network_util.dart';
import 'package:real_estate/util/util.dart';
import '../../data/viewmodel.dart';

class SearchLocation extends StatefulWidget {
  const SearchLocation({super.key});

  @override
  State<SearchLocation> createState() => _SearchLocationState();
}

class _SearchLocationState extends State<SearchLocation> {
  List<AutocompletePrediction> _predictions = [];
  double? lat;
  double? lng;

  final _places = FlutterGooglePlacesSdk(
    "AIzaSyDKK4M85kgFAlesaUhxrmdRBht8IQcV_xk",
  );

  void _onSearchChanged(String input) async {
    if (input.isEmpty) {
      setState(() => _predictions = []);
      return;
    }

    final result = await _places.findAutocompletePredictions(input);
    setState(() {
      _predictions = result.predictions;
    });
  }

  final TextEditingController _controller = TextEditingController();
  GoogleMapController? _mapController;

  Future<void> _onPredictionTap(String placeId) async {
    final details = await _places.fetchPlace(
      placeId,
      fields: [PlaceField.Location, PlaceField.Address],
    );

    if (details.place != null && details.place!.latLng != null) {
      lat = details.place!.latLng!.lat;
      lng = details.place!.latLng!.lng;
    } else {
      return;
    }

    _controller.text = details.place!.address!;

    if (_mapController != null) {
      updatePosition(lat!, lng!, _mapController!);
    }

    setState(() {
      _predictions = [];
    });
  }

  final Set<Marker> _markers = {};

  Future<void> _onMapTap({
    required LatLng position,
    required PropertiesViewModel viewmodel,
  }) async {
    viewmodel.uploadProperty.lng = position.longitude;
    viewmodel.uploadProperty.lat = position.latitude;

    String location =
        await NetworkLayer.getNeighborhoodName(
          lat: position.latitude,
          lng: position.longitude,
        ) ??
        "unknown";

    viewmodel.uploadProperty.location = location;
    log("$location IDK");
    if (mounted) {
      _controller.text = location;
    } else {
      log("not mounted");
    }
    lat = position.latitude;
    lng = position.longitude;
    setState(() {
      _markers.clear();
      _markers.add(
        Marker(markerId: const MarkerId("picked"), position: position),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    PropertiesViewModel viewModel = Provider.of<PropertiesViewModel>(context);

    double longitude = viewModel.locationData?.longitude ?? defaultLongitude;
    double latitude = viewModel.locationData?.latitude ?? defaultLatitude;

    Widget searchBar = Hero(
      tag: "Searchbar",
      child: Padding(
        padding: paddingValueHorizontal,
        child: SearchBar(
          backgroundColor: WidgetStatePropertyAll(
            context.tintedBackgroundColor,
          ),
          elevation: WidgetStatePropertyAll(0),
          controller: _controller,
          trailing: [
            IconButton(
              onPressed: () {
                _controller.text = "";
              },
              icon: Icon(cancelIcon),
            ),
          ],
          hintText: "Search locations",
          onChanged: _onSearchChanged,
          autoFocus: true,
        ),
      ),
    );

    Widget mapScreen = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: paddingValueHorizontal,
          child: Text("Pin exact location", style: context.titleMedium),
        ),
        VerticalSpacer(),
        Expanded(
          child: CustomMap(
            initLongitude: longitude,
            initLatitude: latitude,
            markers: _markers,
            onTap: (position) async {
              await _onMapTap(position: position, viewmodel: viewModel);
            },
            onMapCreated: (controller) {
              _mapController = controller;
            },
          ),
        ),
      ],
    );

    if (_mapController != null) {
      updatePosition(lat ?? latitude, lng ?? longitude, _mapController!);
    }

    Widget predictionsList = Material(
      child: ListView.builder(
        itemCount: _predictions.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return ListTile(
              title: Text("My location"),
              leading: Icon(myLocation),
              onTap: () async {
                viewModel.locationData = await getCurrentLocation();
                setState(() {
                  _predictions = [];
                });
                if (_mapController != null) {
                  updatePosition(
                    viewModel.locationData?.longitude ?? defaultLongitude,
                    viewModel.locationData?.latitude ?? defaultLatitude,
                    _mapController!,
                  );
                }
              },
            );
          } else {
            final prediction = _predictions[index - 1];
            return ListTile(
              title: Text(prediction.fullText),
              leading: Icon(locationIcon),
              onTap: () async {
                await _onPredictionTap(prediction.placeId);
              },
            );
          }
        },
      ),
    );

    Widget body = Expanded(
      child: Stack(
        children: [
          mapScreen,
          _predictions.isNotEmpty ? predictionsList : Container(),
        ],
      ),
    );

    Widget bottomItems = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        customButton(
          context: context,
          onPressed: () {
            context.pop();
          },
          children: [
            Icon(cancelIcon),
            Text("Cancel", style: context.bodyMedium),
          ],
        ),
        customButton(
          context: context,
          onPressed: () {
            if (viewModel.uploadProperty.location.isNotEmpty) {
              context.pop();
            } else {
              toast("Please add a location");
            }
          },
          children: [
            Text("Done", style: context.bodyMedium),
            Icon(doneIcon),
          ],
        ),
      ],
    );

    return Scaffold(
      appBar: AppBar(title: Text("Choose location")),
      body: Padding(
        padding: EdgeInsets.only(bottom: 16),
        child: SpacedColumn(
          crossAxisAlignment: CrossAxisAlignment.start,
          padding: 0,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [searchBar, body, bottomItems],
        ),
      ),
    );
  }
}
