import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as material;
import 'package:contextmenu/contextmenu.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:robot_gui/models/geopoint.dart';
import 'package:robot_gui/providers/geo_navigation.dart';
import 'package:robot_gui/providers/waypoint.dart';

class HideMenuIntent extends Intent {
  const HideMenuIntent();
}

class WayPointWidget extends StatelessWidget {
  const WayPointWidget({
    Key? key,
    required this.deleteButton,
    required this.id,
    required this.builder,
  }) : super(key: key);
  final int id;
  final Widget deleteButton;
  final Function(Widget child) builder;
  @override
  Widget build(BuildContext context) {
    final _provider = Provider.of<WayPointProvider>(context, listen: false);

    var _marker = Consumer<WayPointProvider>(
      builder: (ctx, _p, c) => AnimatedScale(
        duration: const Duration(milliseconds: 100),
        scale: _p.hover ? 1.2 : 1,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Tooltip(
              richMessage: WidgetSpan(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(
                            width: 80,
                            child: Text('خط طول :'),
                          ),
                          Text(_p.data.longitude.toStringAsFixed(7)),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(
                            width: 80,
                            child: Text('دائرة عرض :'),
                          ),
                          Text(_p.data.latitude.toStringAsFixed(7)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              child: Icon(
                material.Icons.location_on,
                color: _p.willSwap
                    ? Colors.magenta
                    : _p.hover
                        ? Colors.blue.darkest
                        : Colors.blue.normal,
                size: 40,
              ),
            ),
            deleteButton,
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  (id + 1).toString(),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
    return MouseRegion(
      onEnter: (event) {
        _provider.hover = true;
      },
      onExit: (event) {
        _provider.hover = false;
      },
      cursor: SystemMouseCursors.basic,
      child: builder(_marker),
    );
  }
}
