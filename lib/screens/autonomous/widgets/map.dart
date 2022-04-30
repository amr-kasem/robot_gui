import 'package:easy_localization/easy_localization.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter/material.dart' as material;
import 'package:provider/provider.dart';
import 'package:robot_gui/providers/navigation.dart';

import '../../../models/way_point.dart';
import '../../../widgets/navigation/way_point_widget.dart';

class MapView extends StatefulWidget {
  const MapView({Key? key}) : super(key: key);

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  final _mapController = MapController();

  var lat = 30.2, long = 31.2, yaw = 0.2;

  bool isTracking = true;
  bool newPath = false;
  @override
  Widget build(BuildContext context) {
    final _navigation = Provider.of<NavigationProvider>(context);
    try {
      if (isTracking) {
        _mapController.move(LatLng(lat, long), _mapController.zoom);
      }
    } catch (e) {}
    return Stack(
      children: [
        GestureDetector(
          onSecondaryTap: () {
            setState(() {
              newPath = false;
            });
          },
          child: MouseRegion(
            cursor:
                newPath ? SystemMouseCursors.precise : SystemMouseCursors.basic,
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
                  if (newPath) {
                    _navigation.addWayPoint(
                      WayPoint(
                        latitude: _w.latitude,
                        longitude: _w.longitude,
                      ),
                    );
                  }
                },
                onLongPress: (_, _w) {
                  setState(() {
                    newPath = true;
                  });
                },
              ),
              layers: [
                TileLayerOptions(
                  urlTemplate: "http://map.localhost/{z}/{x}/{y}.png",
                ),
                MarkerLayerOptions(
                  markers: [
                    Marker(
                      width: 40.0,
                      height: 40.0,
                      point: LatLng(lat, long),
                      builder: (ctx) => Transform.rotate(
                        angle: yaw,
                        child: Icon(
                          material.Icons.navigation,
                          color: Colors.blue.normal,
                          size: 40,
                        ),
                      ),
                    ),
                    ..._navigation.upComing.asMap().entries.map(
                          (e) => Marker(
                            anchorPos: AnchorPos.align(AnchorAlign.top),
                            width: 50.0,
                            height: 50.0,
                            point: LatLng(
                              e.value.latitude,
                              e.value.longitude,
                            ),
                            builder: (ctx) => WayPointWidget(
                              editable: newPath,
                              id: e.key + 1,
                              lat: e.value.latitude,
                              lng: e.value.longitude,
                              onDelete: () =>
                                  _navigation.deleteWayPoint(e.value),
                            ),
                          ),
                        ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Align(
          alignment: AlignmentDirectional.bottomStart,
          child: Padding(
            padding: const EdgeInsets.all(15),
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
        Align(
          alignment: material.AlignmentDirectional.topEnd,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: IconButton(
                  icon: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.white.withOpacity(0.4),
                    ),
                    padding: const EdgeInsets.all(5),
                    child: const Icon(
                      FluentIcons.settings,
                      size: 24,
                    ),
                  ),
                  onPressed: () {},
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: IconButton(
                  icon: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.white.withOpacity(0.4),
                    ),
                    padding: const EdgeInsets.all(5),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 250),
                      child: Icon(
                        newPath
                            ? FluentIcons.check_mark
                            : FluentIcons.edit_list_pencil,
                        key: UniqueKey(),
                        size: 24,
                      ),
                    ),
                  ),
                  onPressed: () async {
                    if (newPath) {
                      setState(() {
                        newPath = false;
                      });
                    } else {
                      setState(() {
                        newPath = true;
                      });
                    }
                  },
                ),
              ),
            ],
          ),
        ),
        if (newPath)
          Align(
            alignment: material.AlignmentDirectional.topStart,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: IconButton(
                    icon: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.red.withOpacity(0.3),
                      ),
                      padding: const EdgeInsets.all(5),
                      child: const Icon(
                        FluentIcons.clear,
                        size: 24,
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () async {
                      await showDialog(
                        context: context,
                        builder: (context) => ContentDialog(
                          content: Text('are you sure?'),
                          title: Text('Caution!'),
                          actions: [
                            Button(
                              child: const Text('Actions.Buttons.yes').tr(),
                              onPressed: () {
                                Navigator.pop(context);
                                _navigation.clearPath();
                              },
                            ),
                            FilledButton(
                              child: const Text('Actions.Buttons.no').tr(),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          )
      ],
    );
  }
}
