import 'package:flutter/material.dart';
import 'dart:async';

class Blinking extends StatefulWidget {
  const Blinking({
    Key? key,
    required this.child,
    this.duration = const Duration(milliseconds: 700),
  }) : super(key: key);

  final Widget child;
  final Duration duration;

  @override
  State<Blinking> createState() => _BlinkingState();
}

class _BlinkingState extends State<Blinking> {
  bool visible = true;
  late final Timer t;
  @override
  void initState() {
    t = Timer.periodic(widget.duration, (timer) {
      setState(() {
        visible = !visible;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    t.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: visible ? 1 : 0,
      child: widget.child,
    );
  }
}
