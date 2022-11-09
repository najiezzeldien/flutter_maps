import 'package:flutter_maps_tut/data/models/place.dart';
import 'package:flutter_maps_tut/data/models/place_destination.dart';
import 'package:flutter_maps_tut/data/models/plase_suggestion.dart';
import 'package:flutter_maps_tut/data/repository/maps_repo.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meta/meta.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'maps_state.dart';

class MapsCubit extends Cubit<MapsState> {
  final MapsRepository mapsRepository;
  MapsCubit(this.mapsRepository) : super(MapsInitial());
  void emitPlaceSuggestions(String place, String sessionToken) {
    mapsRepository.fetchSuggestion(place, sessionToken).then(
      (suggestions) {
        emit(PlacesLoaded(places: suggestions));
      },
    );
  }

  void emitPlaceLocation(String placeId, String sessionToken) {
    mapsRepository.getPlaceLocation(placeId, sessionToken).then(
      (place) {
        emit(PlaceDetalisLoaded(place: place));
      },
    );
  }

  void emitPlaceDirections(LatLng origin, LatLng destination) {
    mapsRepository.getDirections(origin, destination).then(
      (destinations) {
        emit(DirectionsLoaded(placeDirections: destinations));
      },
    );
  }
}
