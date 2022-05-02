import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';
import '../../../providers/navigation.dart';
import 'waypoint_tile.dart';

class WayPointsListView extends StatelessWidget {
  const WayPointsListView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _navigation = Provider.of<NavigationProvider>(context);

    return AnimatedSize(
      duration: const Duration(milliseconds: 200),
      alignment: AlignmentDirectional.topStart,
      child: Container(
        width: _navigation.editableWayPointList ? 300 : 0,
        color: Colors.white.withOpacity(0.4),
        child: ReorderableListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 15),
          itemBuilder: (ctx, index) => ChangeNotifierProvider.value(
            key: ValueKey(index),
            value: _navigation.wayPoints[index].provider,
            child: WayPointListTile(
              index: index,
            ),
          ),
          itemCount: _navigation.wayPoints.length,
          onReorder: (int oldIndex, int newIndex) {
            if (oldIndex < newIndex) {
              newIndex -= 1;
            }
            _navigation.replaceWayPoint(oldIndex, newIndex);
          },
        ),
      ),
    );
  }
}
