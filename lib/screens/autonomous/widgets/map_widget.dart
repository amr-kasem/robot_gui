import 'package:easy_localization/easy_localization.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:provider/provider.dart';
import 'package:latlong2/latlong.dart';

import 'package:flutter/material.dart' as material;
import '../../../models/way_point.dart';
import '../../../providers/navigation.dart';
import '../../../widgets/navigation/way_point_widget.dart';

class MapWidget extends StatefulWidget {
  const MapWidget({
    Key? key,
    required this.newPath,
    required this.activateNewPath,
  }) : super(key: key);

  @override
  State<MapWidget> createState() => _MapWidgetState();
  final bool newPath;
  final Function(bool) activateNewPath;
}

class _MapWidgetState extends State<MapWidget> {
  bool isTracking = false;
  final _mapController = MapController();
  var lat = 30.2, long = 31.2, yaw = 0.2;

  @override
  Widget build(BuildContext context) {
    try {
      if (isTracking) {
        _mapController.move(
          LatLng(lat, long),
          _mapController.zoom,
        );
      }
    } catch (e) {}
    final _navigation = Provider.of<NavigationProvider>(context);
    final _upcomming = _navigation.upComing;
    return Stack(
      children: [
        MouseRegion(
          cursor: widget.newPath
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
                if (widget.newPath) {
                  _navigation.addWayPoint(
                    WayPoint(
                      latitude: _w.latitude,
                      longitude: _w.longitude,
                    ),
                  );
                }
              },
              onLongPress: (_, _w) {
                widget.activateNewPath(true);
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
                  ..._upcomming.asMap().entries.map(
                        (e) => Marker(
                          anchorPos: AnchorPos.align(AnchorAlign.top),
                          width: 50.0,
                          height: 50.0,
                          point: LatLng(
                            e.value.latitude,
                            e.value.longitude,
                          ),
                          builder: (ctx) => WayPointWidget(
                            editable: widget.newPath,
                            id: e.key,
                            lat: e.value.latitude,
                            lng: e.value.longitude,
                            onDelete: () => _navigation.deleteWayPoint(e.value),
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
      ],
    );
  }
}
