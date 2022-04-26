import 'package:fluent_ui/fluent_ui.dart';
import 'package:robot_gui/widgets/navigation/motion_visualizer.dart';

class MotionWidget extends StatelessWidget {
  const MotionWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.topStart,
      child: SizedBox(
        height: 150,
        width: 150,
        child: DecoratedBox(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                Colors.black.withOpacity(0.2),
                Colors.black.withOpacity(0.2),
                Colors.black.withOpacity(0.2),
                Colors.black.withOpacity(0.2),
                Colors.transparent,
              ],
            ),
          ),
          child: const MotionVisualizer(),
        ),
      ),
    );
  }
}
