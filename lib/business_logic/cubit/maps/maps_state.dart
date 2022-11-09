// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'maps_cubit.dart';

@immutable
abstract class MapsState {}

class MapsInitial extends MapsState {}

class PlacesLoaded extends MapsState {
  final List<PlaseSuggestion> places;
  PlacesLoaded({
    required this.places,
  });
}

class PlaceDetalisLoaded extends MapsState {
  final Place place;
  PlaceDetalisLoaded({
    required this.place,
  });
}

class DirectionsLoaded extends MapsState {
  final PlaceDestination placeDirections;
  DirectionsLoaded({
    required this.placeDirections,
  });
}
