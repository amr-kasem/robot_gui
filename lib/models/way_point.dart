import 'dart:convert' as json;

import 'package:robot_gui/providers/waypoint.dart';

class WayPoint {
  late double latitude;
  late double longitude;
  bool reached = false;
  double? yaw;
  late WayPointProvider provider;

  WayPoint({required this.latitude, required this.longitude}) {
    provider = WayPointProvider(this);
  }

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'reached': reached,
      'yaw': yaw ?? 0,
    };
  }

  @override
  String toString() {
    return json.jsonEncode(toJson());
  }
}
