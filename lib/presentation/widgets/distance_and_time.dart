// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_maps_tut/constants/my_color.dart';

import 'package:flutter_maps_tut/data/models/place_destination.dart';

class DistanceAndTime extends StatelessWidget {
  final PlaceDestination? placeDestination;
  final bool isTimeAndDistanceVisible;
  const DistanceAndTime({
    Key? key,
    this.placeDestination,
    required this.isTimeAndDistanceVisible,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isTimeAndDistanceVisible,
      child: Positioned(
        top: 0,
        bottom: 570,
        left: 0,
        right: 0,
        child: Row(
          children: [
            Flexible(
              flex: 1,
              child: Card(
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                margin: const EdgeInsets.fromLTRB(
                  20,
                  50,
                  20,
                  0,
                ),
                color: Colors.white,
                child: ListTile(
                  dense: true,
                  horizontalTitleGap: 0,
                  leading: const Icon(
                    Icons.access_time_filled,
                    color: MyColors.blue,
                    size: 30,
                  ),
                  title: Text(
                    placeDestination!.totalDurarion,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 30,
            ),
            Flexible(
              flex: 1,
              child: Card(
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                margin: const EdgeInsets.fromLTRB(
                  20,
                  50,
                  20,
                  0,
                ),
                color: Colors.white,
                child: ListTile(
                  dense: true,
                  horizontalTitleGap: 0,
                  leading: const Icon(
                    Icons.directions_car_filled,
                    color: MyColors.blue,
                    size: 30,
                  ),
                  title: Text(
                    placeDestination!.totalDistance,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
