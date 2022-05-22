import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dartssh2/dartssh2.dart';
import 'package:xterm/flutter.dart';
import 'package:xterm/xterm.dart';

import 'package:fluent_ui/fluent_ui.dart';

class SSHTerminalBackend extends TerminalBackend {
  late SSHClient client;

  String _host;
  String _username;
  String _password;

  final _exitCodeCompleter = Completer<int>();
  final _outStream = StreamController<String>();

  SSHTerminalBackend(this._host, this._username, this._password);

  void onWrite(String data) {
    _outStream.sink.add(data);
  }

  @override
  Future<int> get exitCode => _exitCodeCompleter.future;

  @override
  void init() async {
    // Use utf8.decoder to handle broken utf8 chunks
    final _sshOutput = StreamController<List<int>>();
    _sshOutput.stream.transform(utf8.decoder).listen(onWrite);

    onWrite('connecting $_host...');
    client = SSHClient(
      await SSHSocket.connect('localhost', 22),
      username: _username,
      printDebug: print,
      onPasswordRequest: () => _password,
    );
  }

  @override
  Stream<String> get out => _outStream.stream;

  @override
  void ackProcessed() {
    // NOOP
  }

  @override
  void resize(int width, int height, int pixelWidth, int pixelHeight) {
    // TODO: implement resize
  }

  @override
  void terminate() {
    // TODO: implement terminate
  }

  @override
  void write(String input) {
    // TODO: implement write
  }
}

class LogScreen extends StatefulWidget {
  const LogScreen({Key? key}) : super(key: key);

  @override
  State<LogScreen> createState() => _LogScreenState();
}

class _LogScreenState extends State<LogScreen> {
  @override
  Widget build(BuildContext context) {
    final terminal = Terminal(
      backend: SSHTerminalBackend('0.0.0.0', 'auk', ' '),
      maxLines: 10000,
    );
    return TerminalView(
      padding: 8,
      terminal: terminal,
    );
  }
}
