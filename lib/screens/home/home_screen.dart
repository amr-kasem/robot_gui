import 'package:fluent_ui/fluent_ui.dart';
import 'package:robot_gui/screens/home/widgets/camera.dart';
import 'package:robot_gui/screens/home/widgets/map.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Flexible(
          child: CameraViewer(),
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
                child: Center(
                  child: Text("data"),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
