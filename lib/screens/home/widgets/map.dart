import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter/material.dart' as material;
import 'package:provider/provider.dart';
import 'package:robot_gui/models/geopoint.dart';
import 'package:robot_gui/models/odompoint.dart';
import 'package:robot_gui/providers/joystick.dart';
import 'package:robot_gui/providers/ros_client.dart';
import 'package:roslib/actionlib/action_goal.dart';
import 'package:vector_math/vector_math.dart' as vector;
import 'dart:math' as math;

import '../../../providers/odom_navigation.dart';
import '../../../widgets/navigation/waypoints/way_point_widget.dart';

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
    final _navigation = Provider.of<OdomNavigationProvider>(context);
    final _ros = Provider.of<ROSClient>(context, listen: false);

    return Stack(
      children: [
        StreamBuilder(
          stream: _ros.gps,
          builder: (context, snapshot) {
            lat = (snapshot.data as Map?)?['msg']?['latitude'] ?? lat;
            long = (snapshot.data as Map?)?['msg']?['longitude'] ?? long;
            try {
              if (isTracking) {
                _mapController.move(LatLng(lat, long), _mapController.zoom);
              }
            } catch (e) {}
            return FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                center: LatLng(lat, long),
                zoom: 15,
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
                // onLongPress: (_, _w) {
                //   _navigation.addWayPoint(odom(
                //     latitude: _w.latitude,
                //     longitude: _w.longitude,
                //   ));
                //   _navigation.setCurrentTarget(0);
                //   _navigation.isNavigating = true;
                // },
              ),
              layers: [
                TileLayerOptions(
                  urlTemplate:
                      "http://192.168.0.104/OSM_sat_tiles/{z}/{x}/{y}.png",
                  // urlTemplate:
                  //     "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  // subdomains: ['a', 'b', 'c'],
                  attributionBuilder: (_) {
                    return Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: const Text(
                        "Misc.jaguar_local_map",
                        style: TextStyle(
                            color: Color.fromARGB(255, 102, 102, 102)),
                      ).tr(),
                    );
                  },
                  attributionAlignment:
                      Localizations.localeOf(context).languageCode == 'ar'
                          ? Alignment.topLeft
                          : Alignment.topRight,
                ),
                MarkerLayerOptions(
                  markers: [
                    Marker(
                      width: 40.0,
                      height: 40.0,
                      point: LatLng(lat, long),
                      builder: (ctx) => StreamBuilder(
                        stream: _ros.odom,
                        builder: (context, dataSnapshot) {
                          final q = vector.Quaternion(
                            (dataSnapshot.data as Map?)?['msg']?['pose']
                                    ?['pose']?['orientation']?['x'] ??
                                0,
                            (dataSnapshot.data as Map?)?['msg']?['pose']
                                    ?['pose']?['orientation']?['y'] ??
                                0,
                            (dataSnapshot.data as Map?)?['msg']?['pose']
                                    ?['pose']?['orientation']?['z'] ??
                                0,
                            (dataSnapshot.data as Map?)?['msg']?['pose']
                                    ?['pose']?['orientation']?['w'] ??
                                1,
                          );
                          var roll = math.atan2(2.0 * (q.y * q.z + q.w * q.x),
                              q.w * q.w - q.x * q.x - q.y * q.y + q.z * q.z);
                          // var pitch = -asin(-2.0 * (q.x * q.z - q.w * q.y));
                          // var yaw = -atan2(2.0 * (q.x * q.y + q.w * q.z),
                          //     q.w * q.w + q.x * q.x - q.y * q.y - q.z * q.z);

                          return Transform.rotate(
                            angle: roll,
                            child: Icon(
                              // material.Icons.navigation,
                              material.Icons.my_location,
                              color: Colors.teal,
                              size: 40,
                            ),
                          );
                        },
                      ),
                    ),
                    ..._navigation.wayPoints.asMap().entries.map(
                          (e) => Marker(
                            anchorPos: AnchorPos.align(AnchorAlign.top),
                            width: 50.0,
                            height: 50.0,
                            point: LatLng(
                              (e.value).lat,
                              (e.value).long,
                            ),
                            builder: (ctx) => ChangeNotifierProvider.value(
                              value: e.value.provider,
                              child: WayPointWidget(
                                id: e.key,
                                deleteButton: Align(
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
                                ),
                                builder: (Widget child) => child,
                              ),
                            ),
                          ),
                        ),
                  ],
                ),
              ],
            );
          },
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
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: StreamBuilder(
                    stream: _ros.odom,
                    builder: (context, dataSnapshot) {
                      return IconButton(
                        icon: Consumer<JoyStickProvider>(
                          child: const Icon(
                            FluentIcons.add,
                            size: 24,
                          ),
                          builder: (context, js, c) {
                            if (js.pickPoint) {
                              var _p = (dataSnapshot.data as Map?)?['msg']
                                  ?['pose']?['pose']?['position'];
                              if (_p != null) {
                                _navigation.addWayPoint(
                                  OdomPoint(
                                    x: _p['x'],
                                    y: _p['y'],
                                    lat: lat,
                                    long: long,
                                  ),
                                );
                              }
                              // print('picked');
                            }
                            return Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.white
                                    .withOpacity(js.pickPoint ? 1 : 0.4),
                              ),
                              padding: const EdgeInsets.all(5),
                              child: c,
                            );
                          },
                        ),
                        onPressed: () async {
                          var _p = (dataSnapshot.data as Map?)?['msg']?['pose']
                              ?['pose']?['position'];
                          _navigation.addWayPoint(
                            OdomPoint(
                              x: _p['x'],
                              y: _p['y'],
                              lat: lat,
                              long: long,
                            ),
                          );
                        },
                      );
                    }),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: IconButton(
                  icon: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.white.withOpacity(0.4),
                    ),
                    padding: const EdgeInsets.all(5),
                    child: const Icon(
                      FluentIcons.blocked,
                      size: 24,
                    ),
                  ),
                  onPressed: () async {
                    _navigation.clearPath();
                  },
                ),
              ),
            ],
          ),
        ),
        FutureBuilder(
            future: _navigation.initiate(),
            builder: (context, d) {
              return d.connectionState == ConnectionState.waiting || d.hasError
                  ? const SizedBox.shrink()
                  : Align(
                      alignment: AlignmentDirectional.bottomStart,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          StreamBuilder(
                            stream: _ros.odomAction.status,
                            builder: (context, data) {
                              // return Container(
                              //   color: Colors.white,
                              //   child: Text(
                              //     data.data.toString(),
                              //   ),
                              // );

                              return Padding(
                                padding: const EdgeInsets.all(15),
                                child: FilledButton(
                                  onPressed: data.data == null
                                      ? null
                                      : () {
                                          if (!_navigation.isNavigating) {
                                            _navigation.start();
                                          } else {
                                            _navigation.cancel();
                                          }
                                        },
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      AnimatedSwitcher(
                                        duration:
                                            const Duration(milliseconds: 200),
                                        child: Icon(
                                          _navigation.isNavigating
                                              ? FluentIcons.stop_solid
                                              : FluentIcons.box_play_solid,
                                          key: ValueKey(
                                              _navigation.isNavigating),
                                          color: _navigation.isNavigating
                                              ? Colors.red
                                              : Colors.white,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      Text(
                                        data.data == null
                                            ? 'Actions.Buttons.unavailable'.tr()
                                            : data.data ==
                                                    ActionServerStatus.REJECTED
                                                ? 'Actions.Buttons.rejected'
                                                    .tr()
                                                : data.data ==
                                                            ActionServerStatus
                                                                .READY ||
                                                        data.data ==
                                                            ActionServerStatus
                                                                .NOTSET
                                                    ? 'Actions.Buttons.startMission'
                                                        .tr()
                                                    : data.data ==
                                                            ActionServerStatus
                                                                .PREEMPTED
                                                        ? 'Actions.Buttons.preempted'
                                                            .tr()
                                                        : data.data ==
                                                                ActionServerStatus
                                                                    .PREEMPTING
                                                            ? 'Actions.Buttons.preempting'
                                                                .tr()
                                                            : data.data ==
                                                                    ActionServerStatus
                                                                        .ABORTED
                                                                ? 'Actions.Buttons.aborted'
                                                                    .tr()
                                                                : data.data ==
                                                                        ActionServerStatus
                                                                            .ACTIVE
                                                                    ? 'Actions.Buttons.cancelMission'
                                                                        .tr()
                                                                    : '${data.data}'
                                                                        .tr(),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    );
            })
      ],
    );
  }
}
