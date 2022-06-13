import 'dart:convert' as json;

import 'package:robot_gui/models/waypoint.dart';
import 'package:robot_gui/providers/waypoint.dart';

class OdomPoint extends WayPoint {
  late double x;
  late double y;
  @override
  bool reached = false;
  double? yaw;
  @override
  late WayPointProvider provider;

  OdomPoint({required this.x, required this.y}) {
    provider = WayPointProvider(this);
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'x': x,
      'y': y,
      'reached': reached,
      'yaw': yaw ?? 0,
    };
  }

  @override
  String toString() {
    return json.jsonEncode(toJson());
  }

  @override
  int get hashCode => x.hashCode + y.hashCode;
  @override
  bool operator ==(Object other) {
    return other is OdomPoint &&
        (other.x - x).abs() < 0.00003 &&
        (other.y - y).abs() < 0.00003;
  }
}
