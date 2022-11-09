// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_maps_tut/constants/my_strings.dart';
import 'package:flutter_maps_tut/data/models/place.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PlasesWebServices {
  late Dio dio;
  PlasesWebServices() {
    BaseOptions options = BaseOptions(
      connectTimeout: 20 * 1000,
      receiveTimeout: 20 * 1000,
      receiveDataWhenStatusError: true,
    );
    dio = Dio(options);
  }

  Future<List<dynamic>> fetchSuggestion(
      String place, String sessionToken) async {
    try {
      Response response = await dio.get(
        suggestionBaseUrl,
        queryParameters: {
          "input": place,
          "types": "address",
          "components": "country:eg",
          "key": googleApiKey,
          "sessiontoken": sessionToken,
        },
      );
      return response.data["predictions"];
    } catch (error) {
      if (kDebugMode) {
        print(error.toString());
      }
      return [];
    }
  }

  Future<dynamic> getPlaceLocation(String placeId, String sessionToken) async {
    try {
      Response response = await dio.get(
        placeLocationBaseUrl,
        queryParameters: {
          "place_id": placeId,
          "fields": "geometry",
          "key": googleApiKey,
          "sessiontoken": sessionToken,
        },
      );
      return response.data;
    } catch (error) {
      return Future.error(
          "Place location error: ", StackTrace.fromString("This is its trace"));
    }
  }

  Future<dynamic> getDirections(LatLng origin, LatLng destination) async {
    try {
      Response response = await dio.get(
        directionsBaseUrl,
        queryParameters: {
          "origin": "${origin.latitude},${origin.longitude}",
          "destination": "${destination.latitude},${destination.longitude}",
          "key": googleApiKey,
        },
      );
      return response.data;
    } catch (error) {
      return Future.error(
          "Destination error: ", StackTrace.fromString("This is its trace"));
    }
  }
}
