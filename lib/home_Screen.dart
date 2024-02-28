import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ubicacion/bloc/location.dart';
import 'package:ubicacion/screens/map_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<Position>? _locationPermissionFuture;

  @override
  void initState() {
    super.initState();
    _locationPermissionFuture = Location().fetchCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Geolocator'),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Center(
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  _locationPermissionFuture = Location().fetchCurrentLocation();
                });
              },
              child: const Text('Obtener permisos de ubicación'),
            ),
          ),
          FutureBuilder<Position>(
            future: _locationPermissionFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container();
              } else if (snapshot.hasError) {
                return const Text('Error al obtener permisos de ubicación');
              } else {
                return Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: 200,
                      width: double.infinity,
                      child: const MapScreen(),
                    ),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}