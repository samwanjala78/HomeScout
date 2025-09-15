import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:real_estate/data/viewmodel.dart';
import 'package:real_estate/UI/ui.dart';
import 'package:real_estate/constants/ui_constants.dart';
import 'package:real_estate/gen/assets.gen.dart';
import 'package:real_estate/util/util.dart';
import 'package:real_estate/main.dart';
import 'package:shimmer/shimmer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    PropertiesViewModel viewModel = Provider.of<PropertiesViewModel>(context);
    double topIconWidth = getTopIconWidth(context.screenWidth);
    double topIconHeight = getTopIconHeight(context.screenHeight);
    final properties = viewModel.properties;

    Widget topCard = SpacedColumn(
        padding: 0,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Find your perfect home",
            style: context.titleMedium,
            textAlign: TextAlign.center,
          ),
          FadedText(
            text: "Discover amazing properties in your area",
            style: context.titleSmall,
          ),
          IntrinsicHeight(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: SizedCard(
                    children: [
                      loadSVG(
                        Assets.icons.house,
                        width: topIconWidth,
                        height: topIconHeight,
                        lightDarkIcon: false,
                        context: context,
                      ),
                      Text("Buy", textAlign: TextAlign.center),
                      FadedText(
                        text: "Find homes",
                        textAlign: TextAlign.center,
                      ),
                    ],
                    onTap: () {
                      viewModel.filterProperties(
                        (element) => element.type == PropertyType.forSale.type,
                      );
                    },
                  ),
                ),
                Expanded(
                  child: SizedCard(
                    children: [
                      loadSVG(
                        Assets.icons.apartments,
                        width: topIconWidth,
                        height: topIconHeight,
                        lightDarkIcon: false,
                        context: context,
                      ),
                      Text("Rent", textAlign: TextAlign.center),
                      FadedText(
                        text: "Get apartments",
                        textAlign: TextAlign.center,
                      ),
                    ],
                    onTap: () {
                      viewModel.filterProperties(
                        (element) => element.type == PropertyType.forRent.type,
                      );
                    },
                  ),
                ),
                Expanded(
                  child: SizedCard(
                    children: [
                      loadSVG(
                        Assets.icons.cash,
                        width: topIconWidth,
                        height: topIconHeight,
                        lightDarkIcon: false,
                        context: context,
                      ),
                      Text("Sell", textAlign: TextAlign.center),
                      FadedText(
                        text: "List property",
                        textAlign: TextAlign.center,
                      ),
                    ],
                    onTap: () {
                      navigate(path: basicInfoPath);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
    );

    Widget featuredHeader = Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("Featured Properties", style: context.bodyLarge),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(filter),
              HorizontalSpacer(width: paddingValue / 2),
              InkWell(
                child: Text("See all", style: context.bodyLarge),
                onTap: () {
                  viewModel.resetProperties();
                },
              ),
            ],
          ),
        ],
    );

    Widget placeholder = Shimmer.fromColors(
        baseColor: Colors.grey.shade500,
        highlightColor: Colors.grey.shade200,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade500,
            borderRadius: BorderRadius.circular(radius),
          ),
          width: double.infinity,
          height: context.screenHeight > context.screenWidth
              ? context.screenHeight * 0.3
              : context.screenWidth * 0.6,
        ),
    );

    List<Widget> listItems = [
      topCard,
      VerticalSpacer(height: paddingValue / 2),
      featuredHeader,
      ?properties.isEmpty ? placeholder : null,
    ];

    for (var property in properties) {
      listItems.add(
        mainCard(
          property: property,
          onTap: () {
            navigate(path: detailPath, index: properties.indexOf(property));
          },
          context: context,
          onLiked: () {
            Property updated = property.copyWith(liked: !property.liked);
            viewModel.updateProperties(updated);
          },
        ),
      );
    }

    return spacedVerticalListView(
      listItems,
      onRefresh: () async => viewModel.fetchProperties(),
    );
  }
}
