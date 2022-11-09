// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_maps_tut/constants/my_color.dart';

import 'package:flutter_maps_tut/data/models/plase_suggestion.dart';

class PlaceItem extends StatelessWidget {
  const PlaceItem({
    Key? key,
    required this.suggstation,
  }) : super(key: key);
  final PlaseSuggestion suggstation;
  @override
  Widget build(BuildContext context) {
    var subTitle = suggstation.description
        .replaceAll(suggstation.description.split(",")[0], "");
    return Container(
      width: double.infinity,
      margin: const EdgeInsetsDirectional.all(8),
      padding: const EdgeInsetsDirectional.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          ListTile(
            leading: Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: MyColors.lightBlue,
              ),
              child: const Icon(
                Icons.place,
                color: MyColors.blue,
              ),
            ),
            title: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "${suggstation.description.split(",")[0]}\n",
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: subTitle.substring(2),
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
