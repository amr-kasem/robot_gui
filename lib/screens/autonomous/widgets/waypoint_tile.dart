import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as material;
import 'package:provider/provider.dart';

import '../../../models/way_point.dart';
import '../../../providers/map_view.dart';
import '../../../providers/navigation.dart';

class WayPointListTile extends StatelessWidget {
  const WayPointListTile({
    Key? key,
    required this.index,
    required this.wayPoint,
  }) : super(key: key);

  final int index;
  final WayPoint wayPoint;

  @override
  Widget build(BuildContext context) {
    final _navigation = Provider.of<NavigationProvider>(context, listen: false);

    return ListTile(
      contentPadding: const EdgeInsetsDirectional.only(end: 40),
      leading: Consumer<MapViewProvider>(
        builder: (ctx, _p, _) {
          bool willSwap = _p.willSwap(index);
          return GestureDetector(
            onTap: () {
              if (willSwap) {
                _p.clearSwap();
              } else {
                _p.addToSwapList(index);
                if (_p.shouldSwap()) {
                  _navigation.swapPoints(_p.swapSet);
                  _p.clearSwap();
                }
              }
            },
            child: Icon(
              willSwap
                  ? material.Icons.swap_vert_circle
                  : material.Icons.location_on,
              key: ValueKey(willSwap),
              color: _p.selectedIndex == index || willSwap ? Colors.blue : null,
            ),
          );
        },
      ),
      title: Text('${index + 1}'),
      subtitle: Text(
          '${wayPoint.latitude.toStringAsFixed(3)},${wayPoint.longitude.toStringAsFixed(3)}'),
      trailing: IconButton(
        icon: const Icon(FluentIcons.edit),
        onPressed: () {},
      ),
    );
  }
}
