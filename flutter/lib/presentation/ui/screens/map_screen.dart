import 'package:finances/presentation/ui/widgets/bottom_nav_bar.dart';
import 'package:finances/presentation/viewmodels/home_viewmodel.dart';
import 'package:finances/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:finances/data/repositories/map_repository.dart';
import 'package:provider/provider.dart';
import '../../../config/theme/colors.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _mapController;
  LatLng _userLocation = const LatLng(4.701378155722595, -74.03523435630727);
  Set<Marker> _markers = {};
  String _selectedAtmName = '';
  String _selectedAtmAddress = '';

  final MapRepository _mapRepository = MapRepository();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getUserLocation(); // Obtener ubicación 
    });
  }

  Future<void> _getUserLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return;

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );

      if (!mounted) return;

      setState(() {
        _userLocation = LatLng(position.latitude, position.longitude);
      });

      _mapController?.animateCamera(CameraUpdate.newLatLng(_userLocation));

      final atmList = await _mapRepository.fetchNearbyATMs(
        latitude: _userLocation.latitude,
        longitude: _userLocation.longitude,
      );

      _updateAtmMarkers(atmList);
    } catch (e) {
      print("❌ Error al obtener ubicación: $e");
    }
  }

  void _updateAtmMarkers(List<dynamic> atmList) {
    final Set<Marker> newMarkers = atmList.map((atm) {
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
          if (mounted) {
            setState(() {
              _selectedAtmName = atm['nombre'];
              _selectedAtmAddress = atm['direccion'];
            });
          }
        },
      );
    }).toSet();

    if (mounted) {
      setState(() {
        _markers = newMarkers;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final homeVM = Provider.of<HomeViewModel>(context);
    final isOffline = homeVM.isOffline;
    return Scaffold(
      appBar: AppBar(
        title: const Text("ATMs Map", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.background,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.cardBackground),
          onPressed: () => Navigator.pushNamed(context, '/home'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () async {
              await AuthService().signOut();
              if (context.mounted) {
                Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Signed out successfully")),
                );
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          if (isOffline)
              Container(
                color: Colors.orange,
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 16),
                child: Row(
                  children: const [
                    Icon(Icons.wifi_off, color: Colors.white),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "You're offline. Showing last known data.",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
          Expanded(
            child: GoogleMap(
              initialCameraPosition: CameraPosition(target: _userLocation, zoom: 15),
              onMapCreated: (GoogleMapController controller) {
                _mapController = controller;
              },
              markers: _markers,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
            ),
          ),
          if (_selectedAtmName.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                boxShadow: [
                  BoxShadow(color: AppColors.background, blurRadius: 5),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Cajero seleccionado:", style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(color: Colors.black12, blurRadius: 3),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Cajero", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        Text(_selectedAtmName, style: const TextStyle(color: AppColors.strongGreen, fontSize: 14)),
                        Text(_selectedAtmAddress, style: const TextStyle(color: Colors.black87, fontSize: 14)),
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

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }
}
