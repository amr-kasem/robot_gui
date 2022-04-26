import 'package:fluent_ui/fluent_ui.dart';
import 'package:robot_gui/widgets/navigation/motion_visualizer.dart';

class MotionWidget extends StatelessWidget {
  const MotionWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Align(
      alignment: AlignmentDirectional.topStart,
      child: SizedBox(
        height: 150,
        width: 150,
        child: MotionVisualizer(),
      ),
    );
  }
}
