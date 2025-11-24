import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:real_estate/UI/main_pages/search.dart';
import 'package:real_estate/data/viewmodel.dart';
import 'package:real_estate/UI/ui.dart';
import 'package:real_estate/constants/ui_constants.dart';
import 'package:real_estate/util/util.dart';
import 'package:real_estate/main.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        PropertiesViewModel viewModel = Provider.of<PropertiesViewModel>(
          context,
          listen: false,
        );

        await viewModel.initApp();
      }
    });
  }

  bool isRentSelected = true;
  bool isBuySelected = true;
  String sortBy = 'Rating';

  @override
  Widget build(BuildContext context) {
    PropertiesViewModel viewModel = Provider.of<PropertiesViewModel>(context);
    final properties = viewModel.properties;
    double topIconHeight = context.getTopIconHeight;

    Offstage(
      child: CustomMap(
        initLatitude: defaultLatitude,
        initLongitude: defaultLongitude,
      ),
    );

    void showSortOptions() {
      showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (context) => Padding(
          padding: const EdgeInsets.all(16),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                VerticalSpacer(),
                Text('Sort Properties', style: context.titleMedium),
                const Divider(),
                ListTile(
                  title: FadedText('Price (Low to High)'),
                  onTap: () {
                    viewModel.sortProperties(SortOptions.priceLow);
                    sortBy = SortOptions.priceLow.option;
                    context.pop();
                  },
                ),
                ListTile(
                  title: FadedText('Price (High to Low)'),
                  onTap: () {
                    viewModel.sortProperties(SortOptions.priceHigh);
                    sortBy = SortOptions.priceHigh.option;
                    context.pop();
                  },
                ),
                ListTile(
                  title: FadedText('Rating'),
                  onTap: () {
                    viewModel.sortProperties(SortOptions.rating);
                    sortBy = SortOptions.rating.option;
                    context.pop();
                  },
                ),
              ],
            ),
          ),
        ),
      );
    }

    Widget topCard = SizedBox(
      width: context.getMaxWidth,
      child: IntrinsicHeight(
        child: Row(
          children: [
            Expanded(
              child: SizedCard(
                children: [
                  customContainer(
                    padding: EdgeInsets.all(paddingValue),
                    color: Colors.white,
                    borderRadius: 999,
                    child: Icon(
                      apartmentIcon,
                      size: topIconHeight,
                      color: context.highlightColor,
                      fill: 1,
                    ),
                  ),
                  Text("Rent Apartments", textAlign: TextAlign.center),
                ],
                onTap: () {
                  isRentSelected = true;
                  isBuySelected = false;
                  viewModel.filterProperties(
                    (element) => element.type == PropertyType.forRent.type,
                  );
                },
              ),
            ),
            Expanded(
              child: SizedCard(
                children: [
                  customContainer(
                    padding: EdgeInsets.all(paddingValue),
                    color: Colors.white,
                    borderRadius: 999,
                    child: Icon(
                      homeIcon,
                      size: topIconHeight,
                      color: context.highlightColor,
                      fill: 1,
                    ),
                  ),
                  Text("Buy Homes", textAlign: TextAlign.center),
                ],
                onTap: () {
                  isRentSelected = false;
                  isBuySelected = true;
                  viewModel.filterProperties(
                    (element) => element.type == PropertyType.forSale.type,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );

    Widget propertyListControls = Center(
      key: ValueKey("Home controls"),
      child: SizedBox(
        width: context.getMaxWidth,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                viewModel.resetProperties();
              },
              child: Text("Show all"),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              spacing: spacingValue / 4,
              children: [
                InkWell(
                  onTap: showSortOptions,
                  child: textIconPair(
                    customContainer(
                      padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                      color: Colors.blue.shade900,
                      child: Text(sortBy, style: context.bodySmall),
                    ),
                    Icon(sortIcon),
                  ),
                ),
                HorizontalSpacer(width: spacingValue / 2),
                Icon(filterIcon),
              ],
            ),
          ],
        ),
      ),
    );

    Widget imagePlaceholder = placeHolderShimmer(
      child: container(
        width: context.getMaxWidth,
        height: context.getImageHeight,
        borderRadius: BorderRadius.vertical(top: Radius.circular(radiusValue)),
        context: context,
      ),
      context: context,
    );

    Widget titlePlaceholder = placeHolderShimmer(
      child: container(
        width: context.getMaxWidth / 2,
        height: textPlaceholderHeight,
        context: context,
      ),
      context: context,
    );

    Widget additionalInfoPlaceholder = placeHolderShimmer(
      child: container(
        width: context.getMaxWidth / 4,
        height: textPlaceholderHeight,
        context: context,
      ),
      context: context,
    );

    Widget metadataPlaceholder = Padding(
      padding: paddingValueAll,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            spacing: 4,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              titlePlaceholder,
              VerticalSpacer(height: spacingValue / 4),
              additionalInfoPlaceholder,
              VerticalSpacer(),
              additionalInfoPlaceholder,
            ],
          ),
          Column(
            spacing: 4,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              additionalInfoPlaceholder,
              VerticalSpacer(height: spacingValue / 4),
              additionalInfoPlaceholder,
              VerticalSpacer(),
              additionalInfoPlaceholder,
            ],
          ),
        ],
      ),
    );

    List<Widget> placeholders = List.generate(
      viewModel.propertyCount,
      (index) => Card(
        key: ValueKey(index),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusValue),
        ),
        child: Column(children: [imagePlaceholder, metadataPlaceholder]),
      ),
    );

    List<Widget> listItems = [
      topCard,
      propertyListControls,
      if (properties.isEmpty) ...placeholders,
    ];

    for (var property in properties) {
      Widget mainCard = homeCard(
        key: ValueKey(property.id),
        viewmodel: viewModel,
        property: property,
        onTap: () {
          navigate(path: detailPath, extra: properties.indexOf(property));
        },
        context: context,
        iconButton: AnimatedIconButton(
          onPressed: () async {
            Property updated = property.copyWith(liked: !property.liked);
            Property? newProperty = await viewModel.updateProperty(updated);
            int currentPropertyIndex = properties.indexOf(property);
            if (newProperty != null) {
              setState(() {
                properties[currentPropertyIndex] = newProperty;
              });
            }
          },
          icon: Icon(
            favoriteIcon,
            color: property.liked ? Colors.red : Colors.white,
            fill: property.liked ? 1.0 : 0.0,
          ),
        ),
      );

      listItems.add(mainCard);
    }

    log("length: ${listItems.length}");

    return RefreshSpacedVerticalListView(
      key: ValueKey(listItems.length),
      onRefresh: () async {
        await viewModel.getProperties();
      },
      listItems: listItems,
    );
  }
}

Future<void> navigateToHomePage(BuildContext context) async {
  if (context.mounted) {
    context.pushReplacement(homePath);
  }
  // PropertiesViewModel viewModel = Provider.of<PropertiesViewModel>(
  //   context,
  //   listen: false,
  // );
  //
  // await viewModel.getProperties();
}
