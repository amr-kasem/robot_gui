import 'package:easy_localization/easy_localization.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter/material.dart' as material;
import 'package:provider/provider.dart';
import 'package:robot_gui/providers/navigation.dart';

import '../../../models/way_point.dart';

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
    final _navigation = Provider.of<NavigationProvider>(context);
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
            },
            onLongPress: (_, _w) {
              // _navigation.currentTarget = WayPoint(
              //   latitude: _w.latitude,
              //   longitude: _w.longitude,
              // );
              _navigation.isNavigating = true;
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
                if (_navigation.currentTarget != null)
                  Marker(
                    anchorPos: AnchorPos.align(AnchorAlign.top),
                    width: 50.0,
                    height: 50.0,
                    point: LatLng(
                      _navigation.currentTarget!.latitude,
                      _navigation.currentTarget!.longitude,
                    ),
                    builder: (ctx) => Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Icon(
                          material.Icons.location_on,
                          color: Colors.blue.normal,
                          size: 40,
                        ),
                        Align(
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
                                _navigation.isNavigating = false;
                                // _navigation.currentTarget = null;
                              },
                            ),
                          ),
                        ),
                      ],
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
          alignment: material.AlignmentDirectional.topStart,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: IconButton(
              icon: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.white.withOpacity(0.4),
                ),
                padding: const EdgeInsets.all(5),
                child: const Icon(
                  FluentIcons.add,
                  size: 24,
                ),
              ),
              onPressed: () async {
                var _p = await showDialog(
                  context: context,
                  builder: (ctx) {
                    final _formKey = GlobalKey<FormState>();
                    double? _lat, _lng;
                    return ContentDialog(
                      title: Text('Input Location Data'),
                      content: Form(
                        key: _formKey,
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('دائرة عرض'),
                              TextFormBox(
                                placeholder: "30.2",
                                onSaved: (v) {
                                  _lat = double.parse(v!);
                                },
                              ),
                              Text('خط طول'),
                              TextFormBox(
                                placeholder: "31.2",
                                onSaved: (v) {
                                  _lng = double.parse(v!);
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      actions: [
                        FilledButton(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(FluentIcons.add),
                              SizedBox(width: 10),
                              Text('اضافة'),
                            ],
                          ),
                          onPressed: () {
                            _formKey.currentState!.save();
                            Navigator.of(ctx).pop(
                              {
                                'Latitude': _lat,
                                'Longitude': _lng,
                              },
                            );
                          },
                        ),
                        Button(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Icon(FluentIcons.add),
                              Text('إلغاء'),
                            ],
                          ),
                          onPressed: () {
                            // _formKey.currentState!.save();
                            Navigator.of(ctx).pop();
                          },
                        )
                      ],
                    );
                  },
                );
                if (_p != null) {
                  _p = _p as Map;
                  // _navigation.currentTarget = WayPoint(
                  //   latitude: _p['Latitude'],
                  //   longitude: _p['Longitude'],
                  // );
                  _navigation.isNavigating = true;
                }
              },
            ),
          ),
        )
      ],
    );
  }
}
