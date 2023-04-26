import 'package:fluent_ui/fluent_ui.dart';

import '../../../widgets/navigation/ui_elements/direction_visualizer.dart';

class DirectionWidget extends StatelessWidget {
  const DirectionWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Align(
      alignment: AlignmentDirectional.topCenter,
      child: Padding(
        padding: EdgeInsets.all(25),
        child: SizedBox(
          height: 70,
          width: 70,
          child: DirectionVisualizer(),
        ),
      ),
    );
  }
}
