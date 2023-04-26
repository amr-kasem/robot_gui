import 'package:easy_localization/easy_localization.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as material;
import 'package:provider/provider.dart';
import 'package:robot_gui/providers/ros_client.dart';

class EmergencyButton extends StatelessWidget {
  const EmergencyButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Consumer<ROSClient>(
        builder: ((ctx, _ros, _) => IconButton(
              onPressed: () {
                if (_ros.forceEmergency) {
                  showDialog(
                    context: ctx,
                    builder: (_c) => ContentDialog(
                      title: const Text("Caution!"),
                      content: const Text("You can't unlock here"),
                      actions: [
                        FilledButton(
                          child: const Text('Actions.Buttons.ok').tr(),
                          onPressed: Navigator.of(_c).pop,
                        )
                      ],
                    ),
                  );
                  return;
                }
                if (_ros.isEmergency) {
                  showDialog(
                    context: ctx,
                    builder: (_c) => ContentDialog(
                      title: Text("Caution!"),
                      content: Text("are you sure"),
                      actions: [
                        Button(
                          child: const Text('Actions.Buttons.yes').tr(),
                          onPressed: () {
                            Navigator.pop(context);
                            _ros.isEmergency = false;
                          },
                        ),
                        FilledButton(
                          child: const Text('Actions.Buttons.no').tr(),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  );
                } else {
                  _ros.isEmergency = true;
                }
              },
              icon: Icon(
                _ros.isEmergency
                    ? material.Icons.lock
                    : material.Icons.lock_open,
                color: _ros.isEmergency ? Colors.red : Colors.black,
                size: 28,
              ),
            )),
      ),
    );
  }
}
