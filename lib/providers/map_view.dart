import 'package:flutter/foundation.dart';

class MapViewProvider with ChangeNotifier {
  int? _selectedIndex;
  int? get selectedIndex => _selectedIndex;
  set selectedIndex(int? i) {
    _selectedIndex = i;
    notifyListeners();
  }
}
