import 'package:fluent_ui/fluent_ui.dart';
import 'package:robot_gui/screens/home/widgets/direction_widget.dart';
import 'package:robot_gui/screens/home/widgets/motion_widget.dart';
import '../../widgets/navigation/navigation_joystick.dart';
import '../home/widgets/camera.dart';
import '../home/widgets/map.dart';
import '../home/widgets/rviz.dart';
import '../../widgets/rpm_viewer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          child: Stack(
            alignment: Alignment.center,
            children: const [
              CameraViewer(),
              NavigationJoystick(),
              RMPViewer(),
              MotionWidget(),
              DirectionWidget(),
            ],
          ),
          flex: 4,
        ),
        const Divider(direction: Axis.vertical),
        Flexible(
          flex: 2,
          child: Column(
            children: const [
              Expanded(
                child: MapView(),
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
