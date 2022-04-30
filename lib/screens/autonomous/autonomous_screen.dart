import 'package:fluent_ui/fluent_ui.dart';
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
          child: MapView(),
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
                    // NavigationJoystick(),
                    // RMPViewer(),
                    MotionWidget(),
                    // DirectionWidget(),
                  ],
                ),
              ),
              Divider(),
              Expanded(
                child: RvizView(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
