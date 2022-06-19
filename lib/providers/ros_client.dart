import 'package:fluent_ui/fluent_ui.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:roslib/roslib.dart';
import 'dart:async';

class ROSClient extends ChangeNotifier {
  late final Ros _ros;
  double maxLinearVel = 1.5;
  double minLinearVel = -1.5;
  double maxAngularVel = 1;
  double minAngularVel = -1;

  bool _emergencyStop = true;
  bool _forceEmergency = false;
  late final Topic _cmdVel;
  late final Topic _cmdVelFB;
  late final Timer _cmdPubTimer;
  late final ActionClient odomAction;

  late final Topic _gps;

  late final Topic _odom;

  bool isAutonomous = false;

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

    _gps = Topic(
      ros: _ros,
      name: '/gps/filtered',
      type: "sensor_msgs/NavSatFix",
      reconnectOnClose: true,
      queueLength: 10,
      queueSize: 10,
    );
    _odom = Topic(
      ros: _ros,
      name: '/odometry/filtered/global',
      type: "nav_msgs/Odometry",
      reconnectOnClose: true,
      queueLength: 10,
      queueSize: 10,
    );

    connect();
    odomAction = ActionClient(
      ros: _ros,
      // serverName: 'OdomNavigate',
      serverName: 'EpsiNavigate',
      actionName: 'odom_navigateAction',
      packageName: 'autonomous_manager',
    );
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

  Stream<Status> get status => _ros.statusStream!;
  Stream<dynamic> get cmdVelFB => _cmdVelFB.subscription!;
  Stream<dynamic> get gps => _gps.subscription!;
  Stream<dynamic> get cmdVel =>
      Stream.periodic(const Duration(milliseconds: 100), (_) => cmdVelMsg);
  Stream<dynamic> get odom => _odom.subscription!;

  Stream<dynamic> get relativePose =>
      Stream.periodic(const Duration(milliseconds: 100), (_) => {'yaw': 0.0});

  void connect() async {
    _ros.connect(url: 'ws://192.168.0.104:9090');
    await _cmdVelFB.subscribe();
    await _gps.subscribe();
    await _odom.subscribe();
    _cmdPubTimer = Timer.periodic(
      const Duration(milliseconds: 100),
      (timer) {
        if (!isAutonomous) {
          _cmdVel.publish(cmdVelMsg);
        }
      },
    );
  }

  double hysteresisCheck(double value, {double width = 0.01}) {
    if (value < width && value > -width) {
      return 0;
    }
    return value;
  }

  void linearUp({i = 0.01}) {
    if (_emergencyStop) return;
    if (cmdVelMsg['linear']!['x']! < maxLinearVel) {
      cmdVelMsg['linear']!['x'] = cmdVelMsg['linear']!['x']! + i;
    }
    cmdVelMsg['linear']!['x'] = hysteresisCheck(cmdVelMsg['linear']!['x']!);
  }

  void linearDown({i = 0.01}) {
    if (_emergencyStop) return;
    if (cmdVelMsg['linear']!['x']! > minLinearVel) {
      cmdVelMsg['linear']!['x'] = cmdVelMsg['linear']!['x']! - i;
    }
    cmdVelMsg['linear']!['x'] = hysteresisCheck(cmdVelMsg['linear']!['x']!);
  }

  void angularUp({i = 0.01}) {
    if (_emergencyStop) return;
    if (cmdVelMsg['angular']!['z']! < maxAngularVel) {
      cmdVelMsg['angular']!['z'] = cmdVelMsg['angular']!['z']! + i;
    }
    cmdVelMsg['angular']!['z'] = hysteresisCheck(cmdVelMsg['angular']!['z']!);
  }

  void angularDown({i = 0.01}) {
    if (_emergencyStop) return;
    if (cmdVelMsg['angular']!['z']! > minAngularVel) {
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
    if (!_forceEmergency) {
      if (v == false) {
        isAutonomous = false;
      }
      _emergencyStop = v;
      zeroAngular();
      zeroLinear();
      notifyListeners();
    }
  }

  // ignore: unnecessary_getters_setters
  bool get forceEmergency => _forceEmergency;
  set forceEmergency(bool v) {
    _forceEmergency = v;
  }
}
