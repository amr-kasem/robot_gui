import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';
import 'package:roslib/core/ros.dart';

import '../../providers/ros_client.dart';

class ConnectionStatus extends StatelessWidget {
  const ConnectionStatus({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _rosClient = Provider.of<ROSClient>(context, listen: false);
    return StreamBuilder(
      stream: _rosClient.status,
      builder: (context, _s) {
        return Center(
          child: _s.data == Status.ERRORED
              ? Icon(
                  FluentIcons.error_badge,
                  size: 28,
                  color: Colors.red,
                )
              : _s.data == Status.CONNECTING
                  ? const ProgressRing()
                  : _s.data == Status.CLOSED
                      ? IconButton(
                          icon: const Icon(
                            FluentIcons.plug_disconnected,
                            size: 28,
                            color: Colors.black,
                          ),
                          onPressed: _rosClient.connect,
                        )
                      : Icon(
                          FluentIcons.plug_connected,
                          size: 28,
                          color: Colors.green,
                        ),
        );
      },
    );
  }
}
