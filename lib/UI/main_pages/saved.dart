import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:real_estate/UI/ui.dart';
import 'package:real_estate/constants/ui_constants.dart';
import '../../data/viewmodel.dart';
import '../../util/util.dart';
import '../../main.dart';

class SavedPage extends StatefulWidget {
  const SavedPage({super.key});

  @override
  State<SavedPage> createState() => _SavedPageState();
}

class _SavedPageState extends State<SavedPage> {
  @override
  Widget build(BuildContext context) {
    PropertiesViewModel viewModel = Provider.of<PropertiesViewModel>(context);

    Widget noSavedProperties = Align(
      child: Text(
        "Saved properties will appear here",
        style: context.titleMedium,
      ),
    );

    mappedCard(Property property) {
      return homeCard(
        viewmodel: viewModel,
        property: property,
        onTap: () {
          navigate(
            path: detailPath,
            extra: viewModel.likedProperties.indexOf(property),
          );
        },
        context: context,
        iconButton: IconButton(
          onPressed: () async {
            Property updated = property.copyWith(liked: false);
            Property? newProperty = await viewModel.updateProperty(updated);
            if (newProperty != null) {
              setState(() {
                viewModel.likedProperties.remove(property);
              });
            }
          },
          icon: Icon(cancelIcon, color: Colors.red),
        ),
      );
    }

    return viewModel.likedProperties.isEmpty
        ? noSavedProperties
        : RefreshSpacedVerticalListView(
            key: ValueKey(viewModel.likedProperties.length),
            listItems: viewModel.likedProperties
                .map((property) => mappedCard(property))
                .toList(),
            onRefresh: () => viewModel.fetchSavedProperties(),
          );
  }
}

Future<void> navigateToSavedPage(BuildContext context) async {
  if(context.mounted) {
    context.pushReplacement(savedPath);
  }

  // PropertiesViewModel viewModel = Provider.of<PropertiesViewModel>(
  //   context,
  //   listen: false,
  // );
  // await viewModel.fetchSavedProperties();
}
