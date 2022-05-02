import 'package:easy_localization/easy_localization.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as material;
import 'package:provider/provider.dart';
import 'package:robot_gui/widgets/navigation/waypoints/waypoints_list_view.dart';
import '/providers/navigation.dart';

import 'map_widget.dart';

class MapView extends StatelessWidget {
  const MapView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _navigation = Provider.of<NavigationProvider>(context, listen: false);
    return Stack(
      children: [
        GestureDetector(
          onSecondaryTap: () {
            _navigation.editableWayPointList = false;
          },
          child: const MapWidget(),
        ),
        Consumer<NavigationProvider>(
          builder: (context, _p, child) {
            return Align(
              alignment: material.AlignmentDirectional.topEnd,
              child: Row(
                mainAxisSize: MainAxisSize.min,
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
            );
          },
        ),
        const WayPointsListView(),
      ],
    );
  }
}
