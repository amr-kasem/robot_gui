import 'package:flutter/foundation.dart';

class MapViewProvider with ChangeNotifier {
  int? _selectedIndex;
  List<int> _swapList = [];
  int? get selectedIndex => _selectedIndex;
  set selectedIndex(int? i) {
    _selectedIndex = i;
    notifyListeners();
  }

  void addToSwapList(int i) {
    if (_swapList.length < 2) {
      _swapList.add(i);
      notifyListeners();
    }
  }

  bool willSwap(i) {
    return _swapList.contains(i);
  }

  bool shouldSwap() {
    return _swapList.length > 1;
  }

  void clearSwap() {
    _swapList.clear();
    notifyListeners();
  }

  List<int> get swapSet => [..._swapList];
}
