import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:robot_gui/widgets/title_bar/battery_level.dart';
import 'package:window_manager/window_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import '../widgets/title_bar/connection_status.dart';
import 'home/home_screen.dart';
import 'settings/settings_screen.dart';
import '../widgets/title_bar/window_buttons.dart';

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
          ),
          PaneItem(
            icon: const Icon(FluentIcons.settings),
            title: const Text('Navigation.Settings').tr(),
          ),
        ],
        onChanged: (i) => setState(
          () {
            index = i;
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
                    BatteryLevel(),
                    SizedBox(width: 15),
                    ConnectionStatus(),
                    SizedBox(width: 15),
                    WindowButtons(),
                  ],
                ),
              ),
      ),
      content: NavigationBody(
        index: index,
        children: [
          const HomeScreen(),
          SettingsScreen(updateView: updateView),
        ],
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
