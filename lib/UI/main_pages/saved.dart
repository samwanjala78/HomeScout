import 'package:flutter/cupertino.dart';
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
      return mainCard(
        property: property,
        onTap: () {
          navigate(
            path: detailPath,
            index: viewModel.likedProperties.indexOf(property),
          );
        },
        context: context,
        onLiked: () {
          Property updated = property.copyWith(liked: !property.liked);
          viewModel.updateProperties(updated);
        },
      );
    }

    return viewModel.likedProperties.isEmpty
        ? noSavedProperties
        : spacedVerticalListView(
            viewModel.likedProperties
                .map((property) => mappedCard(property))
                .toList(),
            onRefresh: () => viewModel.fetchLikedProperties(),
          );
  }
}
