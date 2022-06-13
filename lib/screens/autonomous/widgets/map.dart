import 'package:easy_localization/easy_localization.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as material;
import 'package:provider/provider.dart';
import 'package:robot_gui/widgets/navigation/waypoints/waypoints_list_view.dart';
import '../../../providers/geo_navigation.dart';
import '../../../providers/geo_navigation.dart' as n;

import 'map_widget.dart';

class MapView extends StatelessWidget {
  const MapView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _navigation =
        Provider.of<GeoNavigationProvider>(context, listen: false);
    return Stack(
      children: [
        GestureDetector(
          onSecondaryTap: () {
            _navigation.editablePath = false;
            _navigation.editableWayPointList = false;
          },
          child: const MapWidget(),
        ),
        Consumer<GeoNavigationProvider>(
          builder: (context, _p, child) {
            return Align(
              alignment: material.AlignmentDirectional.topEnd,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_p.editablePath) ...[
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
                            material.Icons.block,
                            size: 24,
                            color: Colors.white,
                          ),
                        ),
                        onPressed: () async {
                          await showDialog(
                            context: context,
                            builder: (context) => ContentDialog(
                              content:
                                  const Text('Alerts.Messages.makesure').tr(),
                              title: const Text('Alerts.Titles.caution').tr(),
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
                        key: ValueKey(_p.editableWayPointList),
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: IconButton(
                          icon: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.white.withOpacity(
                                  _p.editableWayPointList ? 0.8 : 0.4),
                            ),
                            padding: const EdgeInsets.all(5),
                            child: const Icon(
                              FluentIcons.edit_list_pencil,
                              size: 24,
                            ),
                          ),
                          onPressed: () {
                            _p.editableWayPointList = !_p.editableWayPointList;
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
                            _p.editablePath
                                ? FluentIcons.check_mark
                                : FluentIcons.pen_workspace,
                            key: ValueKey(_p.editablePath),
                            size: 24,
                          ),
                        ),
                      ),
                      onPressed: () async {
                        if (_p.editablePath) {
                          _p.editablePath = false;
                          _p.editableWayPointList = false;
                        } else {
                          _p.editablePath = true;
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: material.Material(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.white.withOpacity(0.5),
                      child: material.ToggleButtons(
                        constraints: const BoxConstraints(
                          minHeight: 36,
                          minWidth: 36,
                          maxHeight: 36,
                          maxWidth: 36,
                        ),
                        fillColor: Colors.white,
                        selectedColor: Colors.black,
                        highlightColor: Colors.black.withOpacity(0.6),
                        splashColor: Colors.black.withOpacity(0.8),
                        color: Colors.black,
                        direction: Axis.vertical,
                        children: const [
                          Icon(material.Icons.arrow_right_alt_sharp),
                          Icon(material.Icons.compare_arrows_sharp),
                          Icon(material.Icons.mode_of_travel),
                        ],
                        isSelected: _navigation.navigationModeMask,
                        onPressed: (v) {
                          _navigation.mode = n.NavigationMode.values[v];
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 5)
                ],
              ),
            );
          },
        ),
        const WayPointsListView(),
      ],
    );
  }
}
