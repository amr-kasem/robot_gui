import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as material;
import 'package:provider/provider.dart';
import 'package:robot_gui/providers/navigation.dart';
import 'dart:math' as math;

import '../../animations/blinking.dart';

class DirectionVisualizer extends StatelessWidget {
  const DirectionVisualizer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final widgets = [
      Transform.rotate(
        angle: -math.pi / 2,
        child: const DirectionSign(
          icon: Icon(
            material.Icons.arrow_right_alt_rounded,
            size: 36,
          ),
        ),
      ),
      const DirectionSign(
        icon: Icon(
          material.Icons.turn_right,
          size: 36,
        ),
      ),
      const DirectionSign(
        icon: Icon(
          material.Icons.turn_left,
          size: 36,
        ),
      ),
      const DirectionSign(
        icon: Icon(
          material.Icons.u_turn_left,
          size: 36,
        ),
      ),
      const DirectionSign(
        icon: Icon(
          material.Icons.question_mark,
          size: 36,
        ),
      ),
    ];
    return Consumer<NavigationProvider>(
      builder: (ctx, _navigation, _) => _navigation.isNavigating
          ? navigationIcon(_navigation, widgets)
          : const SizedBox.shrink(),
    );
  }

  Widget navigationIcon(NavigationProvider _navigation, List<Widget> _widgets) {
    return StreamBuilder(
      stream: _navigation.direction,
      builder: ((context, snapshot) {
        switch (snapshot.data) {
          case NavigationDirection.ahead:
            return _widgets[0];
          case NavigationDirection.right:
            return _widgets[1];

          case NavigationDirection.left:
            return _widgets[2];

          case NavigationDirection.back:
            return _widgets[3];

          default:
            return _widgets[4];
        }
      }),
    );
  }
}

class DirectionSign extends StatelessWidget {
  final Widget icon;
  const DirectionSign({
    Key? key,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Blinking(
      child: Transform.rotate(
        angle: math.pi / 4,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Transform.rotate(
            angle: -math.pi / 4,
            child: icon,
          ),
        ),
      ),
    );
  }
}
