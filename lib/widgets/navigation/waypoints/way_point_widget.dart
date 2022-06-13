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
    required this.id,
  }) : super(key: key);
  final int id;

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
                          Text((_p.data as GeoPoint)
                              .longitude
                              .toStringAsFixed(7)),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(
                            width: 80,
                            child: Text('دائرة عرض :'),
                          ),
                          Text((_p.data as GeoPoint)
                              .latitude
                              .toStringAsFixed(7)),
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
            Consumer<GeoNavigationProvider>(builder: (context, _n, _) {
              return _n.editablePath
                  ? Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.5),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const Icon(
                            FluentIcons.remove,
                            size: 10,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            _n.deleteWayPoint(_p.data as GeoPoint);
                          },
                        ),
                      ),
                    )
                  : const SizedBox.shrink();
            }),
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
      child: Consumer<GeoNavigationProvider>(
        builder: (context, _p, c) {
          return _p.editablePath
              ? ContextMenuArea(
                  width: 180,
                  verticalPadding: 20,
                  builder: (BuildContext context) => [
                    Shortcuts(
                      shortcuts: {
                        LogicalKeySet(LogicalKeyboardKey.escape):
                            const HideMenuIntent(),
                      },
                      child: Actions(
                        actions: {
                          HideMenuIntent: CallbackAction<HideMenuIntent>(
                            onInvoke: (HideMenuIntent intent) =>
                                Navigator.of(context).pop(),
                          ),
                        },
                        child: Focus(
                          autofocus: true,
                          child: Column(
                            children: [
                              TappableListTile(
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                                leading: const Icon(FluentIcons.move),
                                title: const Text('Modify'),
                              ),
                              TappableListTile(
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                                leading: const Icon(
                                    material.Icons.move_down_rounded),
                                title: const Text('Change index'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                  child: c!,
                )
              : c!;
        },
        child: _marker,
      ),
    );
  }
}
