// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_maps_tut/data/models/place.dart';
import 'package:flutter_maps_tut/data/models/place_destination.dart';
import 'package:flutter_maps_tut/data/models/plase_suggestion.dart';
import 'package:flutter_maps_tut/data/webservices/plases_web_services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapsRepository {
  final PlasesWebServices plasesWebServices;
  MapsRepository({
    required this.plasesWebServices,
  });
  Future<List<PlaseSuggestion>> fetchSuggestion(
      String place, String sessionToken) async {
    final suggestions =
        await plasesWebServices.fetchSuggestion(place, sessionToken);
    return suggestions
        .map((suggestion) => PlaseSuggestion.fromJson(suggestion))
        .toList();
  }

  Future<Place> getPlaceLocation(String placeId, String sessionToken) async {
    final place =
        await plasesWebServices.getPlaceLocation(placeId, sessionToken);
    return Place.fromJson(place);
  }

  Future<PlaceDestination> getDirections(
      LatLng origin, LatLng destination) async {
    final directions =
        await plasesWebServices.getDirections(origin, destination);
    return PlaceDestination.fromJson(directions);
  }
}
