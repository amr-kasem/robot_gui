import 'package:robot_gui/providers/waypoint.dart';

abstract class WayPoint {
  abstract bool reached;
  abstract WayPointProvider provider;

  Map<String, dynamic> toJson();

  @override
  String toString();

  @override
  int get hashCode;
  @override
  bool operator ==(Object other);
}
