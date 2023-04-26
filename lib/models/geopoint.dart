import 'dart:convert' as json;
import 'package:robot_gui/models/waypoint.dart';
import 'package:robot_gui/providers/waypoint.dart';

class GeoPoint extends WayPoint {
  late double latitude;
  late double longitude;
  @override
  bool reached = false;
  double? yaw;
  @override
  late WayPointProvider provider;

  GeoPoint({required this.latitude, required this.longitude}) {
    provider = WayPointProvider(this);
  }

  @override
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
    return other is GeoPoint &&
        (other.latitude - latitude).abs() < 0.00003 &&
        (other.longitude - longitude).abs() < 0.00003;
  }
}
