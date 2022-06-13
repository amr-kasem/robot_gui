import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_mjpeg/flutter_mjpeg.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:http_auth/http_auth.dart' as http_auth;
import 'package:http/http.dart' as http;

class CameraViewer extends StatefulWidget {
  const CameraViewer({Key? key}) : super(key: key);

  @override
  State<CameraViewer> createState() => _CameraViewerState();
}

class _CameraViewerState extends State<CameraViewer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Mjpeg(
        width: double.infinity,
        key: UniqueKey(),
        stream: 'http://192.168.0.65/mjpg/video.mjpg',
        fit: BoxFit.contain,
        loading: (ctx) => const Center(
          child: ProgressRing(),
        ),
        username: 'root',
        password: 'drrobot',
        isLive: true,
        // timeout: const Duration(seconds: 2),
        error: (ctx, e, v) {
          return TextButton(
            onPressed: () => setState(() {}),
            child: Container(
              color: FluentTheme.of(context).micaBackgroundColor,
              padding: const EdgeInsets.all(30),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(
                    FluentIcons.refresh,
                    size: 48,
                  ),
                  const SizedBox(height: 15),
                  Center(
                    child: const Text("Actions.Buttons.retry").tr(),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
