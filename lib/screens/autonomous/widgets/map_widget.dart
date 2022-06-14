import 'package:contextmenu/contextmenu.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:provider/provider.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter/material.dart' as material;
import 'package:robot_gui/models/geopoint.dart';
import 'package:robot_gui/screens/autonomous/widgets/actions_widget.dart';

import '../../../providers/geo_navigation.dart';
import '../../../providers/geo_navigation.dart' as n;
import '../../../widgets/navigation/waypoints/way_point_widget.dart';

class MapWidget extends StatefulWidget {
  const MapWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  bool isTracking = false;
  final _mapController = MapController();
  var lat = 30.071836, long = 31.331618, yaw = 0.2;

  @override
  Widget build(BuildContext context) {
    final _navigation = Provider.of<GeoNavigationProvider>(context);
    try {
      if (isTracking) {
        _mapController.move(
          LatLng(lat, long),
          _mapController.zoom,
        );
      }
    } catch (e) {
      print(e);
    }
    return Stack(
      children: [
        MouseRegion(
          cursor: _navigation.editablePath
              ? SystemMouseCursors.precise
              : SystemMouseCursors.basic,
          child: FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              center: LatLng(lat, long),
              zoom: 18,
              minZoom: 9,
              maxZoom: 18,
              allowPanning: true,
              onPositionChanged: (_, _self) {
                if (_self) {
                  setState(() {
                    isTracking = false;
                  });
                }
              },
              onTap: (_, _w) {
                if (_navigation.editablePath) {
                  _navigation.addWayPoint(
                    GeoPoint(
                      latitude: _w.latitude,
                      longitude: _w.longitude,
                    ),
                  );
                }
              },
              onLongPress: (_, _w) {
                _navigation.editablePath = true;
              },
            ),
            layers: [
              TileLayerOptions(
                urlTemplate:
                    "http://192.168.0.104/OSM_sat_tiles/{z}/{x}/{y}.png",
              ),
              PolylineLayerOptions(
                polylines: [
                  Polyline(
                    points: [
                      LatLng(lat, long),
                      ..._navigation.wayPoints
                          .map((e) => LatLng((e).latitude, e.longitude))
                          .toList()
                    ],
                    color: material.Colors.white,
                    strokeWidth: 3,
                  ),
                  if (_navigation.mode == n.NavigationMode.goReturnRecursive &&
                      _navigation.wayPoints.isNotEmpty)
                    Polyline(
                      points: _navigation.wayPoints
                          .map(
                            (e) => LatLng(
                                (e).latitude + 0.00002, e.longitude + 0.00002),
                          )
                          .toList(),
                      color: Colors.orange,
                      strokeWidth: 3,
                      isDotted: true,
                    ),
                  if (_navigation.mode == n.NavigationMode.goReturnCircular &&
                      _navigation.wayPoints.isNotEmpty)
                    Polyline(
                      points: [
                        LatLng(
                          (_navigation.wayPoints.first).latitude,
                          (_navigation.wayPoints.first).longitude,
                        ),
                        LatLng(
                          (_navigation.wayPoints.last).latitude,
                          (_navigation.wayPoints.last).longitude,
                        ),
                      ],
                      color: Colors.orange,
                      strokeWidth: 3,
                      isDotted: true,
                    ),
                ],
              ),
              MarkerLayerOptions(
                markers: [
                  Marker(
                    width: 40.0,
                    height: 40.0,
                    point: LatLng(lat, long),
                    builder: (ctx) => Transform.rotate(
                      angle: yaw,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Icon(
                            material.Icons.navigation,
                            color: Colors.blue.normal,
                            size: 40,
                          ),
                          if (_navigation.editablePath)
                            MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: IconButton(
                                icon: const Icon(
                                  material.Icons.add,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  _navigation.addWayPoint(
                                    GeoPoint(latitude: lat, longitude: long),
                                    index: 0,
                                  );
                                },
                              ),
                            )
                        ],
                      ),
                    ),
                  ),
                  ..._navigation.wayPoints.asMap().entries.map(
                        (e) => Marker(
                          anchorPos: AnchorPos.align(AnchorAlign.top),
                          width: 50.0,
                          height: 50.0,
                          point: LatLng(
                            (e.value).latitude,
                            (e.value).longitude,
                          ),
                          builder: (ctx) => ChangeNotifierProvider.value(
                            value: e.value.provider,
                            child: WayPointWidget(
                              id: e.key,
                              deleteButton: _navigation.editablePath
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
                                            _navigation.deleteWayPoint(e.value);
                                          },
                                        ),
                                      ),
                                    )
                                  : const SizedBox.shrink(),
                              builder: (_marker) =>
                                  Consumer<GeoNavigationProvider>(
                                builder: (context, _p, c) {
                                  return _p.editablePath
                                      ? ContextMenuArea(
                                          width: 180,
                                          verticalPadding: 20,
                                          builder: (BuildContext context) => [
                                            Shortcuts(
                                              shortcuts: {
                                                LogicalKeySet(LogicalKeyboardKey
                                                        .escape):
                                                    const HideMenuIntent(),
                                              },
                                              child: Actions(
                                                actions: {
                                                  HideMenuIntent:
                                                      CallbackAction<
                                                          HideMenuIntent>(
                                                    onInvoke: (HideMenuIntent
                                                            intent) =>
                                                        Navigator.of(context)
                                                            .pop(),
                                                  ),
                                                },
                                                child: Focus(
                                                  autofocus: true,
                                                  child: Column(
                                                    children: [
                                                      TappableListTile(
                                                        onTap: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        leading: const Icon(
                                                            FluentIcons.move),
                                                        title: const Text(
                                                            'Modify'),
                                                      ),
                                                      TappableListTile(
                                                        onTap: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        leading: const Icon(material
                                                            .Icons
                                                            .move_down_rounded),
                                                        title: const Text(
                                                            'Change index'),
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
                            ),
                          ),
                        ),
                      ),
                ],
              ),
            ],
          ),
        ),
        Align(
          alignment: AlignmentDirectional.bottomEnd,
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: ToggleButton(
                  checked: isTracking,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(material.Icons.location_searching),
                      const SizedBox(width: 10),
                      const Text("Actions.Buttons.track").tr(),
                    ],
                  ),
                  onChanged: (v) {
                    setState(() {
                      _mapController.move(LatLng(lat, long), 18);

                      isTracking = !isTracking;
                    });
                  }),
            ),
          ),
        ),
        const Align(
          alignment: AlignmentDirectional.bottomStart,
          child: ActionsList(),
        )
      ],
    );
  }
}
