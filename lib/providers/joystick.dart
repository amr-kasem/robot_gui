import 'dart:async';
import 'dart:ffi';

import 'package:flutter/foundation.dart';
import 'package:robot_gui/models/joystick.dart';
import 'package:robot_gui/providers/odom_navigation.dart';
import 'package:robot_gui/providers/ros_client.dart';

import 'package:sdl2/sdl2.dart';

class JoyStickProvider with ChangeNotifier {
  factory JoyStickProvider.update(
      ROSClient ros, OdomNavigationProvider odom, JoyStickProvider obj) {
    obj._ros = ros;
    obj._odom = odom;
    return obj;
  }
  Timer? _worker;
  late ROSClient _ros;
  late OdomNavigationProvider _odom;
  JoyStickProvider() {
    SDL_Init(SDL_INIT_JOYSTICK | SDL_INIT_HAPTIC);
    SDL_JoystickEventState(SDL_ENABLE);
    fetch();
    if (_list.isNotEmpty) {
      currentController = 0;
    }
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
  Pointer<SDL_Haptic>? gJoyHaptic;

  void attach() {
    if (!(_worker?.isActive ?? false)) {
      _worker = Timer.periodic(
        const Duration(milliseconds: 100),
        (timer) {
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
          joyStick!.axis =
              joyStick!.axis.map((int e) => e.abs() > 200 ? e : 0).toList();
          _ros.setLinear(((joyStick?.axis[3] ?? 0) / 32768) * -1.49);
          _ros.setAngular(((joyStick?.axis[0] ?? 0) / 32768) * -0.99);
          if (joyStick!.buttons[1] == 1 && !_ros.isEmergency) {
            _ros.isEmergency = true;
            if (SDL_HapticRumblePlay(gJoyHaptic, 0.9, 150) != 0) {
              print(
                "Warning: Unable to play haptic rumble! ${SDL_GetError()}\n",
              );
            }
          }
          if (_ros.isEmergency &&
              joyStick!.buttons[3] == 1 &&
              joyStick!.buttons[4] == 1 &&
              joyStick!.buttons[5] == 1 &&
              joyStick!.buttons[6] == 1 &&
              joyStick!.buttons[7] == 1) {
            _ros.isEmergency = false;
            if (SDL_HapticRumblePlay(gJoyHaptic, 0.7, 500) != 0) {
              print(
                "Warning: Unable to play haptic rumble! ${SDL_GetError()}\n",
              );
            }
          } else if (!_ros.isEmergency &&
              joyStick!.buttons[3] != 1 &&
              joyStick!.buttons[4] != 1 &&
              joyStick!.buttons[5] == 1 &&
              joyStick!.buttons[6] != 1 &&
              joyStick!.buttons[7] != 1 &&
              !pickPoint) {
            pickPoint = true;
            // print('pressed');
            notifyListeners();
          } else if (!_ros.isEmergency &&
              joyStick!.buttons[5] != 1 &&
              pickPoint) {
            pickPoint = false;
            // print('released');
            notifyListeners();
          }
          print(joyStick!.buttons);
        },
      );
    }
  }

  void detach() {
    if (_worker?.isActive ?? false) _worker?.cancel();
  }

  bool pickPoint = false;
  List<JoyStick> get list => [..._list];
  int? _currentController;
  set currentController(int? i) {
    _currentController = i;
    if (i != null) _sdl_joystick = SDL_JoystickOpen(i);
    //Check if joystick supports haptic
    if (!(SDL_JoystickIsHaptic(_sdl_joystick) == SDL_TRUE)) {
      print(
        "Warning: Controller does not support haptics! SDL Error: ${SDL_GetError()}\n",
      );
    } else {
      //Get joystick haptic device
      gJoyHaptic = SDL_HapticOpenFromJoystick(_sdl_joystick);
      if (gJoyHaptic == null) {
        print(
          "Warning: Unable to get joystick haptics! SDL Error: ${SDL_GetError()}\n",
        );
      } else {
        //Initialize rumble
        if (SDL_HapticRumbleInit(gJoyHaptic) < 0) {
          print(
            "Warning: Unable to initialize haptic rumble! SDL Error: ${SDL_GetError()}\n",
          );
        }
      }
    }
    notifyListeners();
  }

  int? get currentController => _currentController;

  JoyStick? get joyStick =>
      _currentController == null ? null : _list[_currentController!];
}
