import 'package:flutter/foundation.dart';
import 'package:robot_gui/models/way_point.dart';

class WayPointProvider with ChangeNotifier {
  WayPoint data;
  WayPointProvider(this.data);

  bool _hover = false;
  bool get hover => _hover;

  set hover(bool h) {
    _hover = h;
    notifyListeners();
  }

  bool _willSwap = false;
  bool get willSwap => _willSwap;
  set willSwap(bool v) {
    _willSwap = v;
    notifyListeners();
  }
}
