import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as material;
import 'package:joystick/joystick.dart';

class NavigationJoystick extends StatefulWidget {
  const NavigationJoystick({
    Key? key,
  }) : super(key: key);

  @override
  State<NavigationJoystick> createState() => _NavigationJoystickState();
}

class _NavigationJoystickState extends State<NavigationJoystick> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.bottomStart,
      child: SizedBox(
        height: 200,
        width: 200,
        child: material.Material(
          color: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.all(40),
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: Joystick(
                size: 100,
                isDraggable: false,
                iconColor: Colors.white,
                backgroundColor: Colors.black,
                opacity: 0.3,
                joystickMode: JoystickModes.all,
                onUpPressed: () {},
                onLeftPressed: () {},
                onRightPressed: () {},
                onDownPressed: () {},
                onPressed: (_direction) {},
              ),
            ),
          ),
        ),
      ),
    );
  }
}
