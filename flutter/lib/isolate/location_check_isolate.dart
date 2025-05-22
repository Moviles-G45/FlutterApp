
import 'dart:isolate';
import 'package:geolocator/geolocator.dart';

import '../data/models/mall_location.dart';


class LocationCheckRequest {
  final Position userPosition;
  final List<MallLocation> malls;
  final SendPort sendPort;

  LocationCheckRequest({
    required this.userPosition,
    required this.malls,
    required this.sendPort,
  });
}


void locationCheckIsolate(LocationCheckRequest request) {
  for (final mall in request.malls) {
    final distance = Geolocator.distanceBetween(
      request.userPosition.latitude,
      request.userPosition.longitude,
      mall.latitude,
      mall.longitude,
    );

    if (distance < 150) {
      request.sendPort.send(mall.name);
      return;
    }
  }

  request.sendPort.send(null);
}
