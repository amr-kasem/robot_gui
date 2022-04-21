import 'package:fluent_ui/fluent_ui.dart';
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
            children: const [
              Center(
                child: CameraViewer(),
              ),
              NavigationJoystick(),
              RMPViewer(),
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
