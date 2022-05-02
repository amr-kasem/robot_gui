import 'package:flutter/material.dart';
import 'dart:math' as math;

class MotionVisualizer extends StatelessWidget {
  const MotionVisualizer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double roll = 0;
    double pitch = 0;
    return Padding(
      padding: const EdgeInsets.all(15),
      child: LayoutBuilder(builder: (context, constraints) {
        return Stack(
          alignment: Alignment.center,
          children: [
            CustomPaint(
              painter: OpenPainter(),
              size: Size(constraints.maxHeight, constraints.maxWidth),
            ),
            Transform.rotate(
              angle: roll,
              child: Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.topCenter,
                padding: EdgeInsets.only(
                  top: constraints.maxHeight / 2 +
                      constraints.maxHeight / 2 * math.sin(pitch) -
                      16,
                ),
                clipBehavior: Clip.hardEdge,
                width: double.infinity,
                height: double.infinity,
                child: Row(
                  children: [
                    const Expanded(
                      child: Divider(
                        color: Colors.white,
                        thickness: 3,
                      ),
                    ),
                    Transform.rotate(
                      angle: -roll,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Directionality(
                          textDirection: TextDirection.ltr,
                          child: Text(
                            "${roll.toStringAsFixed(2)}",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Expanded(
                      child: Divider(
                        color: Colors.white,
                        thickness: 3,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        );
      }),
    );
  }
}

class OpenPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var x = size.width / 2;
    var y = size.height / 2;
    var r = size.shortestSide / 2;
    var paint1 = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    canvas.drawCircle(
      Offset(x, y),
      r,
      paint1,
    );
    canvas.drawLine(
      Offset(x + r - 7, y),
      Offset(x + r + 15, y),
      paint1,
    );
    canvas.drawLine(
      Offset(x - r + 7, y),
      Offset(x - r - 15, y),
      paint1,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
