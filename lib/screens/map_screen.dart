import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ubicacion/bloc/location.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  MapScreenState createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> {
  GoogleMapController? googleMapController;
  Position? currentPosition;
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _updateCurrentLocationOnMap();
  }

  void _updateCurrentLocationOnMap() async {
    currentPosition = await Location.determinePosition();
    if (currentPosition != null) {
      googleMapController?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(currentPosition!.latitude, currentPosition!.longitude),
            zoom: 14,
          ),
        ),
      );
      setState(() {
        _markers.add(
          Marker(
            markerId: MarkerId('currentLocation'),
            position: LatLng(currentPosition!.latitude, currentPosition!.longitude),
            infoWindow: InfoWindow(
              title: 'Ubicación actual',
            ),
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          height: 200,
          width: 200,
          child: GoogleMap(
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            markers: _markers,
            initialCameraPosition: CameraPosition(
              target: LatLng(currentPosition?.latitude ?? 0.0, currentPosition?.longitude ?? 0.0),
              zoom: 14,
            ),
            onMapCreated: (GoogleMapController controller) {
              googleMapController = controller;
              _updateCurrentLocationOnMap();
            },
          ),
        ),
      ),
    );
  }
}