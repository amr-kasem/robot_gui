import 'dart:ffi';

import 'package:flutter/foundation.dart';
import 'package:robot_gui/models/joystick.dart';

import 'package:sdl2/sdl2.dart';

class JoyStickProvider with ChangeNotifier {
  JoyStickProvider() {
    SDL_Init(SDL_INIT_JOYSTICK);
    SDL_JoystickEventState(SDL_ENABLE);
  }
  List<JoyStick> _list = [];
  void fetch() {
    _list = List.generate(
      SDL_NumJoysticks(),
      (i) => JoyStick(i, SDL_JoystickNameForIndex(i)),
    );
  }

  // ignore: non_constant_identifier_names
  Pointer<SDL_Joystick>? _sdl_joystick;

  List<JoyStick> get list => [..._list];
  int? _currentController;
  set currentController(int? i) {
    _currentController = i;
    if (i != null) _sdl_joystick = SDL_JoystickOpen(i);
    notifyListeners();
  }

  int? get currentController => _currentController;
  Stream<void> query() {
    return Stream.periodic(
      const Duration(milliseconds: 100),
      (computationCount) {
        SDL_JoystickUpdate();
        int axisCount = SDL_JoystickNumAxes(_sdl_joystick);
        int buttonCount = SDL_JoystickNumButtons(_sdl_joystick);
        joyStick!.axis = [
          for (int i = 0; i < axisCount; i++)
            SDL_JoystickGetAxis(_sdl_joystick, i)
        ];
        joyStick!.buttons = [
          for (int i = 0; i < buttonCount; i++)
            SDL_JoystickGetButton(_sdl_joystick, i)
        ];
      },
    );
  }

  JoyStick? get joyStick =>
      _currentController == null ? null : _list[_currentController!];
}
