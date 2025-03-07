import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../models/fighter.dart';
import '../../services/supabase_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  MapboxMap? mapboxMap;
  StreamSubscription<geo.Position>? positionStream;
  geo.Position? currentPosition;
  List<Fighter> fighters = [];

  final SupabaseService _supabaseService = SupabaseService();

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
    _loadFighters();
  }

  Future<void> _requestLocationPermission() async {
    var status = await Permission.location.request();
    if (status.isGranted) {
      _enableUserLocation();
    }
  }

  void _enableUserLocation() {
    mapboxMap?.location.updateSettings(
      LocationComponentSettings(
        enabled: true,
        pulsingEnabled: true,
        showAccuracyRing: true,
      ),
    );

    positionStream = geo.Geolocator.getPositionStream(
      locationSettings: const geo.LocationSettings(
        accuracy: geo.LocationAccuracy.high,
        distanceFilter: 5,
      ),
    ).listen((geo.Position position) {
      setState(() {
        currentPosition = position;
      });
      _updateUserPosition(position);
    });

    geo.Geolocator.getCurrentPosition(
      desiredAccuracy: geo.LocationAccuracy.high,
    ).then((geo.Position position) {
      setState(() {
        currentPosition = position;
      });
      _updateUserPosition(position);
    });
  }

  void _updateUserPosition(geo.Position position) {
    mapboxMap?.flyTo(
      CameraOptions(
        center: Point(
          coordinates: Position(position.longitude, position.latitude),
        ),
        zoom: 2,
      ),
      MapAnimationOptions(duration: 1000),
    );
  }

  Future<void> _loadFighters() async {
    try {
      List<Fighter> fetchedFighters = await _supabaseService.getFighters();
      setState(() {
        fighters = fetchedFighters;
      });
      _addFighterMarkers();
    } catch (e) {
      print('Erreur lors du chargement des combattants: $e');
    }
  }

  void _addFighterMarkers() async {
    if (mapboxMap == null) return;

    final annotationManager = await mapboxMap!.annotations.createPointAnnotationManager();

    final ByteData bytes =
    await rootBundle.load('assets/images/marker.png');
    final Uint8List imageData = bytes.buffer.asUint8List();

    for (var fighter in fighters) {
      if (fighter.longitude != null && fighter.latitude != null) {
        annotationManager.create(
          PointAnnotationOptions(
            geometry: Point(
              coordinates: Position(fighter.longitude!, fighter.latitude!),
            ),
            iconSize: 0.1,
            image: imageData,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    positionStream?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: SizedBox(
                      height: 600,
                      width: double.infinity,
                      child: MapWidget(
                        styleUri: MapboxStyles.STANDARD,
                        cameraOptions: CameraOptions(
                          center: Point(
                            coordinates: Position(4.850000, 45.750000),
                          ),
                          zoom: 2,
                        ),
                        onMapCreated: (controller) {
                          setState(() {
                            mapboxMap = controller;
                          });
                          _addFighterMarkers();
                        },
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    right: 20,
                    child: FloatingActionButton(
                      mini: true,
                      onPressed: _requestLocationPermission,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Icon(
                        currentPosition != null
                            ? Icons.my_location
                            : Icons.location_searching,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
