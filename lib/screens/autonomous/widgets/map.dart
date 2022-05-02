import 'package:easy_localization/easy_localization.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as material;
import 'package:provider/provider.dart';
import 'package:robot_gui/providers/map_view.dart';
import 'package:robot_gui/providers/navigation.dart';

import '../../../models/way_point.dart';
import 'map_widget.dart';
import 'waypoints_list.dart';

class MapView extends StatefulWidget {
  const MapView({Key? key}) : super(key: key);

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  bool newPath = false;
  bool editWayPointList = false;
  void activateNewPath(bool v) {
    setState(() {
      newPath = v;
    });
  }

  @override
  Widget build(BuildContext context) {
    final _navigation = Provider.of<NavigationProvider>(context);
    final _upcomming = _navigation.upComing;
    final _mapViewProvider =
        Provider.of<MapViewProvider>(context, listen: false);

    return Stack(
      children: [
        GestureDetector(
          onSecondaryTap: () {
            setState(() {
              newPath = false;
            });
          },
          child: MapWidget(
            newPath: newPath,
            activateNewPath: activateNewPath,
          ),
        ),
        Align(
          alignment: material.AlignmentDirectional.topEnd,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (newPath) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
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
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: Padding(
                    key: ValueKey(editWayPointList),
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: IconButton(
                      icon: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.white
                              .withOpacity(editWayPointList ? 0.8 : 0.4),
                        ),
                        padding: const EdgeInsets.all(5),
                        child: const Icon(
                          FluentIcons.edit_list_pencil,
                          size: 24,
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          editWayPointList = !editWayPointList;
                        });
                      },
                    ),
                  ),
                ),
              ],
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
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
                            : FluentIcons.pen_workspace,
                        key: ValueKey(newPath),
                        size: 24,
                      ),
                    ),
                  ),
                  onPressed: () async {
                    if (newPath) {
                      setState(() {
                        newPath = false;
                        editWayPointList = false;
                      });
                    } else {
                      setState(() {
                        newPath = true;
                      });
                    }
                  },
                ),
              ),
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
              const SizedBox(width: 5)
            ],
          ),
        ),
        WayPointsList(
          editWayPointList: editWayPointList,
          upcomming: _upcomming,
          setSelectedIndex: (v) => _mapViewProvider.selectedIndex = v,
          changeWayPointIndex: _navigation.replaceWayPoint,
        )
      ],
    );
  }
}
