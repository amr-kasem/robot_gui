import 'dart:async';
import 'dart:developer';
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
    sdlInit(SDL_INIT_JOYSTICK | SDL_INIT_HAPTIC);
    sdlJoystickEventState(SDL_ENABLE);
    fetch();
    if (_list.isNotEmpty) {
      currentController = 0;
    }
  }
  List<JoyStick?> _list = [];
  void fetch() {
    _list = [
      null,
      ...List.generate(
        sdlNumJoysticks(),
        (i) => JoyStick(i, SdlGameControllerEx.nameForIndex(i) ?? "Unnamed Controller ($i)"),
      )
    ];
  }

  // ignore: non_constant_identifier_names
  Pointer<SdlJoystick>? _sdl_joystick;
  Pointer<SdlHaptic>? gJoyHaptic;

  void attach() {
    if (!(_worker?.isActive ?? false) && joyStick != null) {
      _worker = Timer.periodic(
        const Duration(milliseconds: 100),
        (timer) {
          sdlJoystickUpdate();
          int axisCount = sdlJoystickNumAxes(_sdl_joystick!);
          int buttonCount = sdlJoystickNumButtons(_sdl_joystick!);
          joyStick!.axis = [
            for (int i = 0; i < axisCount; i++)
              sdlJoystickGetAxis(_sdl_joystick!, i)
          ];
          joyStick!.buttons = [
            for (int i = 0; i < buttonCount; i++)
              sdlJoystickGetButton(_sdl_joystick!, i)
          ];
          joyStick!.axis =
              joyStick!.axis.map((int e) => e.abs() > 200 ? e : 0).toList();
          _ros.setLinear(((joyStick?.axis[3] ?? 0) / 32768) * -1.49);
          _ros.setAngular(((joyStick?.axis[0] ?? 0) / 32768) * -0.99);
          if (joyStick!.buttons[1] == 1 && !_ros.isEmergency) {
            _ros.isEmergency = true;
            if (sdlHapticRumblePlay(gJoyHaptic!, 0.9, 150) != 0) {
              log(
                "Warning: Unable to play haptic rumble! ${sdlGetError()}\n",
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
            if (sdlHapticRumblePlay(gJoyHaptic!, 0.7, 500) != 0) {
              log(
                "Warning: Unable to play haptic rumble! ${sdlGetError()}\n",
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
            // log('pressed');
            notifyListeners();
          } else if (!_ros.isEmergency &&
              joyStick!.buttons[5] != 1 &&
              pickPoint) {
            pickPoint = false;
            // log('released');
            notifyListeners();
          }
          log(joyStick!.buttons.toString());
        },
      );
    }
  }

  void detach() {
    if (_worker?.isActive ?? false) _worker?.cancel();
  }

  bool pickPoint = false;
  List<JoyStick?> get list => [..._list];
  int? _currentController;
  bool active = false;
  set currentController(int? i) {
    _currentController = i;
    if (i == -1) {
      active = false;
      return;
    }

    active = true;
    if (i != null) _sdl_joystick = sdlJoystickOpen(i);
    //Check if joystick supports haptic
    if (!(sdlJoystickIsHaptic(_sdl_joystick!) == SDL_TRUE)) {
      log(
        "Warning: Controller does not support haptics! SDL Error: ${sdlGetError()}\n",
      );
    } else {
      //Get joystick haptic device
      gJoyHaptic = sdlHapticOpenFromJoystick(_sdl_joystick!);
      if (gJoyHaptic == null) {
        log(
          "Warning: Unable to get joystick haptics! SDL Error: ${sdlGetError()}\n",
        );
      } else {
        //Initialize rumble
        if (sdlHapticRumbleInit(gJoyHaptic!) < 0) {
          log(
            "Warning: Unable to initialize haptic rumble! SDL Error: ${sdlGetError()}\n",
          );
        }
      }
    }
    notifyListeners();
  }

  int? get currentController => _currentController;

  JoyStick? get joyStick =>
      _currentController == -1 ? null : _list[_currentController! + 1];
}
