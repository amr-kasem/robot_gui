import 'package:easy_localization/easy_localization.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';
import 'package:robot_gui/models/joystick.dart';
import 'package:robot_gui/providers/joystick.dart';

class JoyStickSelector extends StatelessWidget {
  const JoyStickSelector({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<JoyStickProvider>(context);
    provider.fetch();
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Settings.SelectController").tr(),
              const SizedBox(height: 15),
              ComboBox<int>(
                isExpanded: true,
                items: provider.list
                    .map(
                      (JoyStick? e) => ComboBoxItem<int>(
                        value: e?.id ?? -1,
                        child: Text(e?.name ?? 'Keyboard'),
                      ),
                    )
                    .toList(),
                value: provider.currentController,
                onChanged: (value) {
                  provider.currentController = value ?? -1;
                },
              ),
              const SizedBox(height: 15),
              const Divider(),
            ],
          ),
        ),
      ],
    );
  }
}
