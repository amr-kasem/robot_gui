import 'package:easy_localization/easy_localization.dart';
import 'package:fluent_ui/fluent_ui.dart';

import 'widgets/joystick_selector.dart';

class SettingsScreen extends StatelessWidget {
  final Function updateView;
  const SettingsScreen({Key? key, required this.updateView}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final values = {
      'Arabic': const Locale('ar'),
      'English': const Locale('en'),
    };
    return ScaffoldPage.scrollable(
      children: [
        Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Settings.SelectLanguage").tr(),
              const SizedBox(height: 15),
              Combobox<Locale>(
                isExpanded: true,
                items: values.keys
                    .map(
                      (String e) => ComboboxItem<Locale>(
                        value: values[e],
                        child: Text('Languages.$e').tr(),
                      ),
                    )
                    .toList(),
                value: context.locale,
                onChanged: (value) {
                  if (value != null) context.setLocale(value);
                  updateView();
                },
              ),
              const SizedBox(height: 15),
              const Divider(),
            ],
          ),
        ),
        const JoyStickSelector(),
      ],
    );
  }
}
