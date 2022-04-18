import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:robot_gui/screens/home/home_screen.dart';
import 'package:robot_gui/screens/settings/settings_screen.dart';
import 'package:window_manager/window_manager.dart';
import 'package:easy_localization/easy_localization.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WindowListener {
  final viewKey = GlobalKey();
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return NavigationView(
      key: viewKey,
      pane: NavigationPane(
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
            child: Align(
              alignment: AlignmentDirectional.center,
              child: const Text('Title').tr(),
            ),
          );
        }(),
        actions: kIsWeb
            ? null
            : DragToMoveArea(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [Spacer(), WindowButtons()],
                ),
              ),
      ),
      content: NavigationBody(
        index: index,
        children: [
          const Center(child: Text("test")),
          ScaffoldPage.scrollable(
            children: const [HomeScreen(), SettingsScreen()],
          ),
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
            title: const Text('Confirm close'),
            content: const Text('Are you sure you want to close this window?'),
            actions: [
              FilledButton(
                child: const Text('Yes'),
                onPressed: () {
                  Navigator.pop(context);
                  windowManager.destroy();
                },
              ),
              Button(
                child: const Text('No'),
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

class WindowButtons extends StatelessWidget {
  const WindowButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = FluentTheme.of(context);
    return SizedBox(
      width: 138,
      height: 50,
      child: WindowCaption(
        brightness: theme.brightness,
        backgroundColor: Colors.transparent,
      ),
    );
  }
}
