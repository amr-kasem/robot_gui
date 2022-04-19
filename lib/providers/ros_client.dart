import 'package:fluent_ui/fluent_ui.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:roslib/roslib.dart';

class ROSClient extends ChangeNotifier {
  late final Ros _ros;
  ROSClient() {
    _ros = Ros();
    connect();
  }
  Stream<Status> get status => _ros.statusStream;

  void connect() {
    print("trying to connect");
    _ros.connect(url: 'ws://0.0.0.0:9090');
  }
}
