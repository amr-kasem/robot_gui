import 'package:fluent_ui/fluent_ui.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:roslib/roslib.dart';
import 'dart:async';

class ROSClient extends ChangeNotifier {
  late final Ros _ros;
  double MaxLinearVel = 1.5;
  double MinLinearVel = -1.5;
  double MaxAngularVel = 1;
  double MinAngularVel = -1;

  bool _emergencyStop = true;
  bool _forceEmergency = false;

  ROSClient() {
    _ros = Ros();
    _cmdVel = Topic(
      ros: _ros,
      name: '/cmd_vel',
      type: "geometry_msgs/Twist",
      reconnectOnClose: true,
      queueLength: 10,
      queueSize: 10,
    );
    _cmdVelFB = Topic(
      ros: _ros,
      name: '/cmd_vel',
      type: "geometry_msgs/Twist",
      reconnectOnClose: true,
      queueLength: 10,
      queueSize: 10,
    );
    connect();
  }

  final cmdVelMsg = {
    'linear': {
      'x': 0.0,
      'y': 0.0,
      'z': 0.0,
    },
    'angular': {
      'x': 0.0,
      'y': 0.0,
      'z': 0.0,
    },
  };
  late final _cmdVel;
  late final _cmdVelFB;
  late final _cmdPubTimer;
  Stream<Status> get status => _ros.statusStream!;
  Stream<dynamic> get cmdVelFB => _cmdVelFB.subscription!;
  Stream<dynamic> get cmdVel =>
      Stream.periodic(const Duration(milliseconds: 100), (_) => cmdVelMsg);

  Stream<dynamic> get relativePose =>
      Stream.periodic(const Duration(milliseconds: 100), (_) => {'yaw': 0.0});

  void connect() async {
    _ros.connect(url: 'ws://0.0.0.0:9090');
    await _cmdVelFB.subscribe();
    _cmdPubTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      _cmdVel.publish(cmdVelMsg);
    });
  }

  double hysteresisCheck(double value, {double width = 0.01}) {
    if (value < width && value > -width) {
      return 0;
    }
    return value;
  }

  void linearUp({i = 0.01}) {
    if (_emergencyStop) return;
    if (cmdVelMsg['linear']!['x']! < MaxLinearVel) {
      cmdVelMsg['linear']!['x'] = cmdVelMsg['linear']!['x']! + i;
    }
    cmdVelMsg['linear']!['x'] = hysteresisCheck(cmdVelMsg['linear']!['x']!);
  }

  void linearDown({i = 0.01}) {
    if (_emergencyStop) return;
    if (cmdVelMsg['linear']!['x']! > MinLinearVel) {
      cmdVelMsg['linear']!['x'] = cmdVelMsg['linear']!['x']! - i;
    }
    cmdVelMsg['linear']!['x'] = hysteresisCheck(cmdVelMsg['linear']!['x']!);
  }

  void angularUp({i = 0.01}) {
    if (_emergencyStop) return;
    if (cmdVelMsg['angular']!['z']! < MaxAngularVel) {
      cmdVelMsg['angular']!['z'] = cmdVelMsg['angular']!['z']! + i;
    }
    cmdVelMsg['angular']!['z'] = hysteresisCheck(cmdVelMsg['angular']!['z']!);
  }

  void angularDown({i = 0.01}) {
    if (_emergencyStop) return;
    if (cmdVelMsg['angular']!['z']! > MinAngularVel) {
      cmdVelMsg['angular']!['z'] = cmdVelMsg['angular']!['z']! - i;
    }
    cmdVelMsg['angular']!['z'] = hysteresisCheck(cmdVelMsg['angular']!['z']!);
  }

  void zeroLinear() {
    cmdVelMsg['linear']!['x'] = 0;
  }

  void zeroAngular() {
    cmdVelMsg['angular']!['z'] = 0;
  }

  bool get isEmergency => _emergencyStop;

  set isEmergency(bool v) {
    print(v);
    print(_forceEmergency);
    if (!_forceEmergency) {
      _emergencyStop = v;
      zeroAngular();
      zeroLinear();
      notifyListeners();
    }
  }

  bool get forceEmergency => _forceEmergency;
  set forceEmergency(bool v) {
    _forceEmergency = v;
  }
}
