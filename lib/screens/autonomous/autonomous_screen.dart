import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';
import 'package:robot_gui/providers/map_view.dart';
import '../../widgets/monitor/camera.dart';
import '../../widgets/monitor/rviz.dart';
import 'widgets/map.dart';
import 'widgets/motion_widget.dart';

class AutonomousScreen extends StatelessWidget {
  const AutonomousScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          child: ChangeNotifierProvider(
            create: (_) => MapViewProvider(),
            child: const MapView(),
          ),
          flex: 4,
        ),
        const Divider(direction: Axis.vertical),
        Flexible(
          flex: 2,
          child: Column(
            children: [
              Expanded(
                child: Stack(
                  alignment: Alignment.center,
                  children: const [
                    CameraViewer(),
                    MotionWidget(),
                  ],
                ),
              ),
              const Divider(),
              const Expanded(
                child: RvizView(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
