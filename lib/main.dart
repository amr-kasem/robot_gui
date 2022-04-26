import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart' as flutter_acrylic;
import 'package:provider/provider.dart';
import 'package:robot_gui/providers/ros_client.dart';
import 'package:robot_gui/screens/index.dart';
import 'package:system_theme/system_theme.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:window_manager/window_manager.dart';
import 'package:easy_localization/easy_localization.dart';

const String appTitle = 'Fluent UI Showcase for Flutter';

/// Checks if the current environment is a desktop environment.
bool get isDesktop {
  if (kIsWeb) return false;
  return [
    TargetPlatform.windows,
    TargetPlatform.linux,
    TargetPlatform.macOS,
  ].contains(defaultTargetPlatform);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await EasyLocalization.ensureInitialized();

  if (kIsWeb ||
      [TargetPlatform.windows, TargetPlatform.android]
          .contains(defaultTargetPlatform)) {
    SystemTheme.accentColor;
  }

  setPathUrlStrategy();

  if (isDesktop) {
    await flutter_acrylic.Window.initialize();
    await WindowManager.instance.ensureInitialized();
    windowManager.waitUntilReadyToShow().then((_) async {
      await windowManager.setTitleBarStyle(TitleBarStyle.hidden,
          windowButtonVisibility: false);
      await windowManager.setSize(const Size(755, 545));
      await windowManager.setMinimumSize(const Size(755, 545));
      await windowManager.center();
      await windowManager.show();
      await windowManager.setPreventClose(true);
      await windowManager.setSkipTaskbar(false);
    });
  }

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path:
          'assets/translations', // <-- change the path of the translation files
      fallbackLocale: const Locale('en'),
      child: const MyApp(),
    ),
  );
}

class ForwardIntent extends Intent {
  const ForwardIntent();
}

class BackwardIntent extends Intent {
  const BackwardIntent();
}

class LeftIntent extends Intent {
  const LeftIntent();
}

class RightIntent extends Intent {
  const RightIntent();
}

class BreakIntent extends Intent {
  const BreakIntent();
}

class BreakLinearIntent extends Intent {
  const BreakLinearIntent();
}

class BreakAngularIntent extends Intent {
  const BreakAngularIntent();
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ROSClient()),
      ],
      child: FluentApp(
        shortcuts: {
          LogicalKeySet(LogicalKeyboardKey.arrowUp): const ForwardIntent(),
          LogicalKeySet(LogicalKeyboardKey.arrowDown): const BackwardIntent(),
          LogicalKeySet(LogicalKeyboardKey.arrowLeft): const LeftIntent(),
          LogicalKeySet(LogicalKeyboardKey.arrowRight): const RightIntent(),
          LogicalKeySet(LogicalKeyboardKey.space): const BreakIntent(),
          LogicalKeySet(LogicalKeyboardKey.keyX): const BreakLinearIntent(),
          LogicalKeySet(LogicalKeyboardKey.keyZ): const BreakAngularIntent(),
        },
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        home: const MyHomePage(),
      ),
      builder: (ctx, child) {
        final _ros = Provider.of<ROSClient>(ctx, listen: false);
        return Actions(
          child: child!,
          actions: <Type, Action<Intent>>{
            ForwardIntent: CallbackAction<ForwardIntent>(
              onInvoke: (ForwardIntent intent) => _ros.linearUp(),
            ),
            BackwardIntent: CallbackAction<BackwardIntent>(
              onInvoke: (BackwardIntent intent) => _ros.linearDown(),
            ),
            LeftIntent: CallbackAction<LeftIntent>(
              onInvoke: (LeftIntent intent) => _ros.angularUp(),
            ),
            RightIntent: CallbackAction<RightIntent>(
              onInvoke: (RightIntent intent) => _ros.angularDown(),
            ),
            BreakIntent: CallbackAction<BreakIntent>(
              onInvoke: (BreakIntent intent) {
                _ros.zeroAngular();
                _ros.zeroLinear();
                return;
              },
            ),
            BreakLinearIntent: CallbackAction<BreakLinearIntent>(
              onInvoke: (BreakLinearIntent intent) => _ros.zeroLinear(),
            ),
            BreakAngularIntent: CallbackAction<BreakAngularIntent>(
              onInvoke: (BreakAngularIntent intent) => _ros.zeroAngular(),
            ),
          },
        );
      },
    );
  }
}
