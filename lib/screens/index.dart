import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:robot_gui/screens/autonomous/autonomous_screen.dart';
import 'package:robot_gui/screens/log/log_screen.dart';
import 'package:robot_gui/screens/terminal/terminal_screen.dart';
import 'package:robot_gui/widgets/title_bar/battery_level.dart';
import 'package:window_manager/window_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import '../providers/ros_client.dart';
import '../widgets/title_bar/connection_status.dart';
import '../widgets/title_bar/emergency_button.dart';
import 'home/home_screen.dart';
import 'settings/settings_screen.dart';
import '../widgets/title_bar/window_buttons.dart';
import 'package:flutter/material.dart' as material;
import 'dart:math' as math;

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WindowListener {
  final viewKey = GlobalKey();
  int index = 0;
  @override
  void initState() {
    windowManager.addListener(this);
    super.initState();
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
  }

  void updateView() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final _ros = Provider.of<ROSClient>(context, listen: false);

    return NavigationView(
      key: viewKey,
      pane: NavigationPane(
        displayMode: PaneDisplayMode.compact,
        header: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              'DrRobot',
              style: FluentTheme.of(context).typography.title,
            ),
          ),
        ),
        selected: index,
        items: [
          PaneItem(
            icon: const Icon(FluentIcons.home),
            title: const Text('Navigation.Main').tr(),
            body: const HomeScreen(),
          ),
          PaneItem(
            icon: Transform.rotate(
                angle: math.pi / 4,
                child: const Icon(material.Icons.navigation_outlined)),
            title: const Text('Navigation.Navigation').tr(),
            body : const AutonomousScreen(),
          ),
          // PaneItem(
          //   icon: const Icon(FluentIcons.command_prompt),
          //   title: const Text('Navigation.Terminal').tr(),
          // ),
          // PaneItem(
          //   icon: const Icon(FluentIcons.file_system),
          //   title: const Text('Navigation.Log').tr(),
          // ),
          PaneItem(
            icon: const Icon(FluentIcons.settings),
            title: const Text('Navigation.Settings').tr(),
            body:  SettingsScreen(updateView: updateView),
          ),
        ],
        onChanged: (i) => setState(
          () {
            index = i;
            if (index != 0) {
              _ros.isEmergency = true;
              _ros.forceEmergency = true;
            } else {
              _ros.forceEmergency = false;
            }
          },
        ),
      ),
      appBar: NavigationAppBar(
        automaticallyImplyLeading: false,
        title: () {
          return DragToMoveArea(
            key: UniqueKey(),
            child: Align(
              alignment: AlignmentDirectional.centerStart,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: const Text('Title').tr(),
              ),
            ),
          );
        }(),
        actions: kIsWeb
            ? null
            : DragToMoveArea(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Spacer(),
                    EmergencyButton(),
                    SizedBox(width: 15),
                    BatteryLevel(),
                    SizedBox(width: 15),
                    ConnectionStatus(),
                    SizedBox(width: 15),
                    WindowButtons(),
                  ],
                ),
              ),
      ),
    
    );
  }

  @override
  void onWindowClose() async {
    bool _isPreventClose = await windowManager.isPreventClose();
    if (_isPreventClose) {
      showDialog(
        context: context,
        builder: (_) {
          return ContentDialog(
            title: const Text('Actions.onClose.title').tr(),
            content: const Text('Actions.onClose.alert').tr(),
            actions: [
              Button(
                child: const Text('Actions.Buttons.yes').tr(),
                onPressed: () {
                  Navigator.pop(context);
                  windowManager.setPreventClose(false);
                  windowManager.close();
                },
              ),
              FilledButton(
                child: const Text('Actions.Buttons.no').tr(),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      );
    }
  }
}
