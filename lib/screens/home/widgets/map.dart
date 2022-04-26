import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter/material.dart' as material;

class MapView extends StatefulWidget {
  const MapView({Key? key}) : super(key: key);

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  final _mapController = MapController();

  var lat = 30.2, long = 31.2, yaw = 0.2;

  bool isTracking = true;

  @override
  Widget build(BuildContext context) {
    try {
      if (isTracking) {
        _mapController.move(LatLng(lat, long), _mapController.zoom);
      }
    } catch (e) {}
    return Stack(
      children: [
        FlutterMap(
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
              }),
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
              ],
            ),
          ],
        ),
        Align(
          alignment: AlignmentDirectional.bottomEnd,
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: ToggleButton(
                checked: isTracking,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(material.Icons.location_searching),
                    Text("Track"),
                  ],
                ),
                onChanged: (v) {
                  setState(() {
                    isTracking = !isTracking;
                  });
                }),
          ),
        )
      ],
    );
  }
}
