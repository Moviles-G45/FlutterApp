
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../../data/models/app_notification.dart';
import '../../data/models/mall_location.dart';
import '../../isolate/location_check_isolate.dart';
import '../../services/location_service.dart';
import '../../services/notification_service.dart';

import 'dart:isolate';


class LocationNotifierViewModel extends ChangeNotifier {
  
  final LocationService locationService;
  final NotificationService notificationService;

  LocationNotifierViewModel({
    required this.locationService,
    required this.notificationService,
  });

  final List<MallLocation> malls = [
    MallLocation(name: 'Parque La Colina', latitude: 4.712345, longitude: -74.072987),
    MallLocation(name: 'Andino', latitude: 4.666202, longitude: -74.054574),
    MallLocation(name: 'Gran Estación', latitude: 4.657029, longitude: -74.093051),
    MallLocation(name: 'Santafé', latitude: 4.749968, longitude: -74.048472),
    MallLocation(name: 'Unicentro', latitude: 4.700868, longitude: -74.042866),
    MallLocation(name: 'Centro Mayor', latitude: 4.578850, longitude: -74.129510),
    MallLocation(name: 'Titan Plaza', latitude: 4.690511, longitude: -74.090200),
    MallLocation(name: 'Plaza de las Américas', latitude: 4.627788, longitude: -74.149531),
    MallLocation(name: 'Portal 80', latitude: 4.723369, longitude: -74.112105),
    MallLocation(name: 'Bulevar Niza', latitude: 4.711095, longitude: -74.082716),
    MallLocation(name: 'Hayuelos', latitude: 4.662059, longitude: -74.135783),
    MallLocation(name: 'Plaza Imperial', latitude: 4.754091, longitude: -74.108203),
    MallLocation(name: 'El Retiro', latitude: 4.665972, longitude: -74.053760),
    MallLocation(name: 'Palatino', latitude: 4.684134, longitude: -74.032898),
    MallLocation(name: 'Atlantis Plaza', latitude: 4.666633, longitude: -74.054011),
    MallLocation(name: 'Calima', latitude: 4.621982, longitude: -74.082785),
    MallLocation(name: 'Cedritos', latitude: 4.719978, longitude: -74.042256),
    MallLocation(name: 'Multiplaza', latitude: 4.667145, longitude: -74.122163),
    MallLocation(name: 'Salitre Plaza', latitude: 4.659910, longitude: -74.103100),
    MallLocation(name: 'Avenida Chile', latitude: 4.648420, longitude: -74.063446),
  ];

  Timer? _monitorTimer;
  String? _lastMallNotified;

  void startMonitoring() {
    final nowDateOnly = DateTime.now();
final dateOnlyString = DateTime(nowDateOnly.year, nowDateOnly.month, nowDateOnly.day).toIso8601String();
    _monitorTimer = Timer.periodic(const Duration(seconds: 5), (_) async {
      try {
        final current = await locationService.getCurrentLocation();

        final nearbyMallName = await _runProximityCheckInIsolate(current);

        if (nearbyMallName != null && nearbyMallName != _lastMallNotified) {
          final title = "🛍️ Nearby Shopping Alert";
          final message = "You're near $nearbyMallName. Did you spend anything? 💸";

          await notificationService.showLocalNotification(title, message);

          await notificationService.saveNotification(
            

  AppNotification(
    name: title,
    content: message,
    userId:1,
    date: dateOnlyString
  ),
);


          _lastMallNotified = nearbyMallName;
        }
      } catch (e) {
        debugPrint("Location monitoring error: $e");
      }
    });
  }

  void stopMonitoring() {
    _monitorTimer?.cancel();
  }

  Future<String?> _runProximityCheckInIsolate(Position userPosition) async {
    final receivePort = ReceivePort();

    final request = LocationCheckRequest(
      userPosition: userPosition,
      malls: malls,
      sendPort: receivePort.sendPort,
    );

    await Isolate.spawn(locationCheckIsolate, request);

    final result = await receivePort.first;
    return result as String?;
  }
}