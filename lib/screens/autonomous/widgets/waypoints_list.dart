import 'package:fluent_ui/fluent_ui.dart';

import '../../../models/way_point.dart';
import 'waypoint_tile.dart';

class WayPointsList extends StatelessWidget {
  const WayPointsList({
    Key? key,
    required this.editWayPointList,
    required List<WayPoint> upcomming,
    required this.setSelectedIndex,
    required this.changeWayPointIndex,
  })  : _upcomming = upcomming,
        super(key: key);

  final bool editWayPointList;
  final List<WayPoint> _upcomming;
  final Function(int?) setSelectedIndex;
  final Function(int, int) changeWayPointIndex;
  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 200),
      alignment: AlignmentDirectional.topStart,
      child: Container(
        width: editWayPointList ? 300 : 0,
        color: Colors.white.withOpacity(0.4),
        child: ReorderableListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 15),
          itemBuilder: (ctx, index) => MouseRegion(
            key: ValueKey(index),
            onEnter: (e) {
              setSelectedIndex(index);
            },
            onExit: (e) {
              setSelectedIndex(null);
            },
            child: WayPointListTile(
              index: index,
              wayPoint: _upcomming[index],
            ),
          ),
          itemCount: _upcomming.length,
          onReorder: (int oldIndex, int newIndex) {
            if (oldIndex < newIndex) {
              newIndex -= 1;
            }
            changeWayPointIndex(oldIndex, newIndex);
          },
        ),
      ),
    );
  }
}
