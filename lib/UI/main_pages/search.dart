import 'package:flutter/material.dart';
import 'package:real_estate/UI/ui.dart';
import 'package:real_estate/constants/ui_constants.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return RealEstateApp(
      child: SpacedColumn(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          PlainTextField(
            hint: Text('Search properties'),
            prefixIcon: Icon(searchIcon),
          ),
          Divider(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FadedText(text: "2 properties found"),
              SpacedRow(children: [ViewToggleButtons()]),
            ],
          ),
        ],
      ),
    );
  }
}
