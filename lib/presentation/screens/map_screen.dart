import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_maps_tut/business_logic/cubit/maps/maps_cubit.dart';
import 'package:flutter_maps_tut/business_logic/cubit/phone_auth/phone_auth_cubit.dart';
import 'package:flutter_maps_tut/constants/my_color.dart';
import 'package:flutter_maps_tut/data/models/place.dart';
import 'package:flutter_maps_tut/data/models/place_destination.dart';
import 'package:flutter_maps_tut/data/models/plase_suggestion.dart';
import 'package:flutter_maps_tut/helpers/location_helper.dart';
import 'package:flutter_maps_tut/presentation/widgets/distance_and_time.dart';
import 'package:flutter_maps_tut/presentation/widgets/my_drawer.dart';
import 'package:flutter_maps_tut/presentation/widgets/place_item.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:uuid/uuid.dart';

class MapScreen extends StatefulWidget {
  MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  @override
  void initState() {
    super.initState();
    getMyCurrentLocation();
  }

  FloatingSearchBarController controller = FloatingSearchBarController();
  Completer<GoogleMapController> _mapController = Completer();
  static Position? position;
  List<PlaseSuggestion> places = [];
  static final CameraPosition _myCurrentLocatinCameraPosition = CameraPosition(
    bearing: 0,
    target: LatLng(
      position!.latitude,
      position!.longitude,
    ),
    tilt: 0,
    zoom: 17,
  );
  // These  Variable for getPlaceLocation
  Set<Marker> markers = Set();
  late PlaseSuggestion placeSuggestion;
  late Place selectedPlace;
  late Marker searchedPlaceMarker;
  late Marker currentLocationMarker;
  late CameraPosition gotToSearchedForPlace;
  void buildCameraNewPosition() {
    gotToSearchedForPlace = CameraPosition(
      bearing: 0.0,
      tilt: 0.0,
      target: LatLng(
        selectedPlace.result.geometry.location.lat,
        selectedPlace.result.geometry.location.lng,
      ),
      zoom: 13,
    );
  }

  // These  Variable for getDirection
  PlaceDestination? placeDirection;
  var progressIndicator = false;
  late List<LatLng> polyLinePoints;
  var isSearchedPlaceMarkerClicked = false;
  var isTimeAndDistanceVisible = false;
  late String time;
  late String distance;
  Future<void> getMyCurrentLocation() async {
    position = await LocationHelper.getCurrentLocation().whenComplete(
      () {
        setState(() {});
      },
    );
    // position = await Geolocator.getLastKnownPosition().whenComplete(
    //   () {
    //     setState(() {});
    //   },
    // );
  }

  Widget buildMap() {
    return GoogleMap(
      mapType: MapType.normal,
      myLocationEnabled: true,
      zoomControlsEnabled: false,
      myLocationButtonEnabled: false,
      markers: markers,
      initialCameraPosition: _myCurrentLocatinCameraPosition,
      onMapCreated: (GoogleMapController googleMapController) {
        _mapController.complete(googleMapController);
      },
      polylines: placeDirection != null
          ? {
              Polyline(
                polylineId: const PolylineId("my_polyLine"),
                color: Colors.black,
                width: 2,
                points: polyLinePoints,
              ),
            }
          : {},
    );
  }

  Future<void> _goToMyCurrentLocation() async {
    final GoogleMapController controller = await _mapController.future;
    controller.animateCamera(
        CameraUpdate.newCameraPosition(_myCurrentLocatinCameraPosition));
  }

  Widget buildFloatingSearchBar() {
    final bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return FloatingSearchBar(
      controller: controller,
      elevation: 6,
      hintStyle: const TextStyle(fontSize: 18),
      queryStyle: const TextStyle(fontSize: 18),
      hint: "Find a place",
      border: BorderSide.none,
      margins: const EdgeInsets.fromLTRB(20, 70, 20, 0),
      padding: const EdgeInsets.fromLTRB(2, 0, 2, 0),
      height: 52,
      iconColor: MyColors.blue,
      scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
      transitionDuration: const Duration(milliseconds: 600),
      transitionCurve: Curves.easeOut,
      physics: const BouncingScrollPhysics(),
      axisAlignment: isPortrait ? 0.0 : -1,
      openAxisAlignment: 0.0,
      width: isPortrait ? 600 : 500,
      debounceDelay: const Duration(milliseconds: 500),
      progress: progressIndicator,
      onQueryChanged: (query) {
        getPlacesSuggestions(query);
      },
      onFocusChanged: (_) {
        setState(() {
          isTimeAndDistanceVisible = false;
        });
      },
      transition: CircularFloatingSearchBarTransition(),
      actions: [
        FloatingSearchBarAction(
          showIfOpened: false,
          child: CircularButton(
            icon: Icon(
              Icons.place,
              color: Colors.black.withOpacity(0.6),
            ),
            onPressed: () {},
          ),
        )
      ],
      builder: (context, transition) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              buildSuggestionsBloc(),
              buildSelectedPlaceLocationBloc(),
              buildDirectionBloc(),
            ],
          ),
        );
      },
    );
  }

  Widget buildDirectionBloc() {
    return BlocListener<MapsCubit, MapsState>(
      listener: (context, state) {
        if (state is DirectionsLoaded) {
          placeDirection = (state).placeDirections;
          getPolylinePoints();
        }
      },
      child: Container(),
    );
  }

  void getPolylinePoints() {
    polyLinePoints = placeDirection!.polyLinePoints
        .map((polyLinePoint) =>
            LatLng(polyLinePoint.latitude, polyLinePoint.longitude))
        .toList();
  }

  Widget buildSelectedPlaceLocationBloc() {
    return BlocListener<MapsCubit, MapsState>(
      listener: (context, state) {
        if (state is PlaceDetalisLoaded) {
          selectedPlace = (state).place;
          goToMySearchedForLocation();
          getDirections();
        }
      },
      child: Container(),
    );
  }

  void getDirections() {
    BlocProvider.of<MapsCubit>(context).emitPlaceDirections(
      LatLng(position!.latitude, position!.longitude),
      LatLng(
        selectedPlace.result.geometry.location.lat,
        selectedPlace.result.geometry.location.lng,
      ),
    );
  }

  Future<void> goToMySearchedForLocation() async {
    buildCameraNewPosition();
    final GoogleMapController controller = await _mapController.future;

    controller.animateCamera(
      CameraUpdate.newCameraPosition(gotToSearchedForPlace),
    );
    buildSearchedPlaceMarker();
  }

  void buildSearchedPlaceMarker() {
    searchedPlaceMarker = Marker(
      position: gotToSearchedForPlace.target,
      markerId: const MarkerId("1"),
      onTap: () {
        buildCurrentLocationMarker();
        // Show Time And Distance
        setState(() {
          isSearchedPlaceMarkerClicked = true;
          isTimeAndDistanceVisible = true;
        });
      },
      infoWindow: InfoWindow(
        title: "${placeSuggestion.description}",
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    );
    addMarkerToMarkerAndUpdateUI(searchedPlaceMarker);
  }

  void buildCurrentLocationMarker() {
    currentLocationMarker = Marker(
      position: LatLng(
        position!.latitude,
        position!.longitude,
      ),
      markerId: const MarkerId("2"),
      onTap: () {},
      infoWindow: const InfoWindow(
        title: "Your Current Location",
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
    );
    addMarkerToMarkerAndUpdateUI(currentLocationMarker);
  }

  void addMarkerToMarkerAndUpdateUI(Marker marker) {
    setState(() {
      markers.add(marker);
    });
  }

  void getPlacesSuggestions(String query) {
    final sessionToken = Uuid().v4();
    BlocProvider.of<MapsCubit>(context)
        .emitPlaceSuggestions(query, sessionToken);
  }

  Widget buildSuggestionsBloc() {
    return BlocBuilder<MapsCubit, MapsState>(builder: (context, state) {
      if (state is PlacesLoaded) {
        places = (state).places;
        if (places.isNotEmpty) {
          return buildPlacesList();
        } else {
          return Container();
        }
      }
      return Container();
    });
  }

  Widget buildPlacesList() {
    return ListView.builder(
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            controller.close();
          },
          child: InkWell(
            onTap: () async {
              placeSuggestion = places[index];
              controller.close();
              getSelectedPlaceLocation();
              polyLinePoints.clear();
              removeAllMarkersAndUpdateUI();
            },
            child: PlaceItem(
              suggstation: places[index],
            ),
          ),
        );
      },
      itemCount: places.length,
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
    );
  }

  void removeAllMarkersAndUpdateUI() {
    setState(() {
      markers.clear();
    });
  }

  void getSelectedPlaceLocation() {
    final sessionToken = Uuid().v4();
    BlocProvider.of<MapsCubit>(context).emitPlaceLocation(
      placeSuggestion.placeId,
      sessionToken,
    );
    // TODO:
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: MyDrawer(),
        body: Stack(
          fit: StackFit.expand,
          children: [
            position != null
                ? buildMap()
                : const Center(
                    child: CircularProgressIndicator(
                      color: MyColors.blue,
                    ),
                  ),
            buildFloatingSearchBar(),
            isSearchedPlaceMarkerClicked
                ? DistanceAndTime(
                    isTimeAndDistanceVisible: isTimeAndDistanceVisible,
                    placeDestination: placeDirection,
                  )
                : Container(),
          ],
        ),
        floatingActionButton: Container(
          margin: const EdgeInsets.fromLTRB(
            0,
            0,
            8,
            30,
          ),
          child: FloatingActionButton(
            backgroundColor: Colors.blue,
            onPressed: _goToMyCurrentLocation,
            child: const Icon(
              Icons.place,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
