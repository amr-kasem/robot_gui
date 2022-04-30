import 'package:flutter/foundation.dart';
import 'package:robot_gui/models/way_point.dart';
import 'package:robot_gui/providers/ros_client.dart';

enum NavigationDirection {
  ahead,
  back,
  left,
  right,
  unkown,
}

class NavigationProvider with ChangeNotifier {
  late ROSClient _ros;

  NavigationProvider();
  factory NavigationProvider.update(ROSClient ros, NavigationProvider obj) {
    obj._ros = ros;
    return obj;
  }

  bool _isNavigating = false;

  final List<WayPoint> _wayPoints = [];

  WayPoint? _currentTarget;

  WayPoint? get currentTarget => _currentTarget;

  set currentTarget(WayPoint? _p) {
    _currentTarget = _p;
    notifyListeners();
  }

  bool get isNavigating => _isNavigating;
  set isNavigating(bool v) {
    print("should be solved");
    if (_currentTarget == null) {
      return;
    }
    _isNavigating = v;
    notifyListeners();
  }

  Stream<NavigationDirection> get direction => _ros.relativePose.map(
        (event) {
          final data = (event as Map)['yaw'] as double;
          if (data - 0.0 < 0.0001) {
            return NavigationDirection.back;
          }
          return NavigationDirection.unkown;
        },
      );
}
