import 'package:finances/config/theme/colors.dart';
import 'package:finances/presentation/widgets/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;
  LatLng _userLocation = LatLng(4.701378155722595, -74.03523435630727); 
  Set<Marker> _markers = {};
  String _selectedAtmName = '';
  String _selectedAtmAddress = '';

  final String googleMapsApiKey = "AIzaSyARgei34VyOKClGROzUwe4bIwQDgIrKvi4";


  @override
  void initState() {
    super.initState();
   // _getUserLocation();
  }

  // Obtener la ubicación actual del usuario y cargar los cajeros cercanos
  Future<void> _getUserLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Verificar si el servicio de ubicación está habilitado
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error("Los servicios de ubicación están deshabilitados.");
    }

    // Verificar permisos
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error("Permiso de ubicación denegado.");
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error("Permiso de ubicación denegado permanentemente.");
    }

    // Obtener la ubicación
    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      _userLocation = LatLng(position.latitude, position.longitude);
    });
    mapController.animateCamera(
      CameraUpdate.newLatLng(_userLocation),
    );


    try {
      List<dynamic> atmList =
          await fetchNearbyATMs(_userLocation.latitude, _userLocation.longitude, 1);
      _updateAtmMarkers(atmList);
    } catch (e) {
      print(e);
    }
  }

  // Consultar cajeros cercanos en el backend
  Future<List<dynamic>> fetchNearbyATMs(double lat, double lon, double radius) async {
    final response = await http.get(Uri.parse(
        'https://fastapi-service-185169107324.us-central1.run.app/atms/nearby?lat=$lat&lon=$lon&radius=$radius'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error al cargar cajeros');
    }
  }

  // Actualizar marcadores en el mapa a partir de la lista de cajeros
  void _updateAtmMarkers(List<dynamic> atmList) {
    Set<Marker> markers = atmList.map((atm) {
      return Marker(
        markerId: MarkerId(atm['id'].toString()),
        position: LatLng(
          double.parse(atm['latitud']),
          double.parse(atm['longitud']),
        ),
        infoWindow: InfoWindow(
          title: atm['nombre'],
          snippet: atm['direccion'],
        ),
        onTap: () {
          setState(() {
            _selectedAtmName = atm['nombre'];
            _selectedAtmAddress = atm['direccion'];
          });
        },
      );
    }).toSet();

    setState(() {
      _markers = markers;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Expenses", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.background,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.cardBackground),
          onPressed: () => Navigator.pushNamed(context, '/home'),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.notifications, color: AppColors.cardBackground), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: GoogleMap(
              initialCameraPosition:
                  CameraPosition(target: _userLocation, zoom: 15),
              onMapCreated: (GoogleMapController controller) {
                mapController = controller;
              },
              markers: _markers,
              myLocationEnabled: true,
            ),
          ),
          if (_selectedAtmName.isNotEmpty)
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius:
                    BorderRadius.vertical(top: Radius.circular(20)),
                boxShadow: [
                  BoxShadow(color: AppColors.background, blurRadius: 5)
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Cajero seleccionado:",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(color: Colors.black12, blurRadius: 3)
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Cajero",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                        Text(_selectedAtmName,
                            style: TextStyle(
                                color: AppColors.strongGreen, fontSize: 14)),
                        Text(_selectedAtmAddress,
                            style: TextStyle(
                                color: Colors.black87, fontSize: 14)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}