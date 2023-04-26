import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as material;
import 'package:joystick/joystick.dart';
import 'package:provider/provider.dart';
import 'package:robot_gui/providers/joystick.dart';
import 'package:robot_gui/providers/ros_client.dart';

class NavigationJoystick extends StatefulWidget {
  const NavigationJoystick({
    Key? key,
  }) : super(key: key);

  @override
  State<NavigationJoystick> createState() => _NavigationJoystickState();
}

class _NavigationJoystickState extends State<NavigationJoystick> {
  JoyStickProvider? provider;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    provider?.detach();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _rosClient = Provider.of<ROSClient>(context, listen: false);

    provider = Provider.of<JoyStickProvider>(context);
    provider?.attach();
    return Align(
      alignment: AlignmentDirectional.bottomStart,
      child: SizedBox(
        height: 150,
        width: 150,
        child: material.Material(
          color: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Directionality(
                  textDirection: TextDirection.ltr,
                  child: Joystick(
                    size: 100,
                    isDraggable: false,
                    iconColor: Colors.white,
                    backgroundColor: Colors.white,
                    opacity: 0.25,
                    joystickMode: JoystickModes.all,
                    onUpPressed: () {
                      if (provider?.active ?? false) _rosClient.linearUp();
                    },
                    onLeftPressed: () {
                      if (provider?.active ?? false) _rosClient.angularUp();
                    },
                    onRightPressed: () {
                      if (provider?.active ?? false) _rosClient.angularDown();
                    },
                    onDownPressed: () {
                      if (provider?.active ?? false) _rosClient.linearDown();
                    },
                    onPressed: (_direction) {},
                  ),
                ),
                material.IconButton(
                  iconSize: 20,
                  splashRadius: 15,
                  onPressed: () {
                    _rosClient.zeroAngular();
                    _rosClient.zeroLinear();
                  },
                  icon: const Icon(
                    material.Icons.stop_circle,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
