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

  @override
  int get hashCode => latitude.hashCode + longitude.hashCode;
  @override
  bool operator ==(Object other) {
    if (other is WayPoint) print((other.latitude - latitude).abs());
    return other is WayPoint &&
        (other.latitude - latitude).abs() < 0.00003 &&
        (other.longitude - longitude).abs() < 0.00003;
  }
}
