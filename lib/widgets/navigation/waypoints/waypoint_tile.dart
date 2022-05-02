import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as material;
import 'package:provider/provider.dart';
import 'package:robot_gui/providers/waypoint.dart';

import '../../../providers/navigation.dart';

class WayPointListTile extends StatelessWidget {
  const WayPointListTile({
    Key? key,
    required this.index,
  }) : super(key: key);
  final int index;
  @override
  Widget build(BuildContext context) {
    final _navigation = Provider.of<NavigationProvider>(context);
    final _w = Provider.of<WayPointProvider>(context);

    return MouseRegion(
      onEnter: (e) {
        _w.hover = true;
      },
      onExit: (e) {
        _w.hover = false;
      },
      child: ListTile(
        contentPadding: const EdgeInsetsDirectional.only(end: 40),
        leading: GestureDetector(
          onTap: () {
            if (_w.willSwap) {
              _navigation.clearSwap();
              _w.willSwap = false;
            } else {
              _w.willSwap = true;
              _navigation.addToSwapList(index);
            }
          },
          child: Icon(
            _w.willSwap
                ? material.Icons.swap_vert_circle
                : material.Icons.location_on,
            key: ValueKey(_w.willSwap),
            color: _w.hover || _w.willSwap ? Colors.blue : null,
          ),
        ),
        title: Text('${index + 1}'),
        subtitle: Text(
            '${_w.data.latitude.toStringAsFixed(7)},${_w.data.longitude.toStringAsFixed(7)}'),
        trailing: IconButton(
          icon: const Icon(FluentIcons.edit),
          onPressed: () {},
        ),
      ),
    );
  }
}
