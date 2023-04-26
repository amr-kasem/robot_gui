import 'package:fluent_ui/fluent_ui.dart';
import 'package:battery_indicator/battery_indicator.dart';

class BatteryLevel extends StatelessWidget {
  const BatteryLevel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: BatteryIndicator(
        batteryLevel: 30,
        ratio: 2.5,
        batteryFromPhone: false,
      ),
    );
  }
}
