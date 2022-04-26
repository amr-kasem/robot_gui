import 'dart:convert' as json;

class WayPoint {
  late double latitude;
  late double longitude;
  bool reached = false;
  double? yaw;

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
