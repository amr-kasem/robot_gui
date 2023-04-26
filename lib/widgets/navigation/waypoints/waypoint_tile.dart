import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as material;
import 'package:provider/provider.dart';
import 'package:robot_gui/providers/geo_navigation.dart';
import 'package:robot_gui/providers/waypoint.dart';

import '../../../models/geopoint.dart';
import '../../../providers/geo_navigation.dart';

class WayPointListTile extends StatelessWidget {
  const WayPointListTile({
    Key? key,
    required this.index,
  }) : super(key: key);
  final int index;
  @override
  Widget build(BuildContext context) {
    final _navigation = Provider.of<GeoNavigationProvider>(context);
    final _w = Provider.of<WayPointProvider>(context);

    return MouseRegion(
      onEnter: (e) {
        _w.hover = true;
      },
      onExit: (e) {
        _w.hover = false;
      },
      child: ListTile(
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
            '${(_w.data as GeoPoint).latitude.toStringAsFixed(7)},${(_w.data as GeoPoint).longitude.toStringAsFixed(7)}'),
        trailing: IconButton(
          icon: const Icon(FluentIcons.edit),
          onPressed: () {},
        ),
      ),
    );
  }
}
