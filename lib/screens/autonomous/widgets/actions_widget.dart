import 'package:easy_localization/easy_localization.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';

import '../../../providers/navigation.dart';

class ActionsList extends StatefulWidget {
  const ActionsList({Key? key}) : super(key: key);

  @override
  State<ActionsList> createState() => _ActionsListState();
}

class _ActionsListState extends State<ActionsList> {
  bool _running = false;
  bool _hover = false;
  @override
  Widget build(BuildContext context) {
    final _navigation = Provider.of<NavigationProvider>(context);
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_navigation.wayPoints.isNotEmpty && !_navigation.editablePath)
            MouseRegion(
              cursor: SystemMouseCursors.click,
              onEnter: (e) {
                setState(() {
                  _hover = true;
                });
              },
              onExit: (e) {
                setState(() {
                  _hover = false;
                });
              },
              child: FilledButton(
                onPressed: () {
                  setState(() {
                    _running = !_running;
                  });
                },
                child: Row(
                  children: [
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child: Icon(
                        _running
                            ? FluentIcons.stop_solid
                            : FluentIcons.box_play_solid,
                        key: ValueKey(_running),
                        color: _running ? Colors.red : Colors.white,
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Text(
                      !_running
                          ? 'Actions.Buttons.startMission'.tr()
                          : 'Actions.Buttons.cancelMission'.tr(),
                    ),
                  ],
                ),
              ),
            )
        ],
      ),
    );
  }
}
