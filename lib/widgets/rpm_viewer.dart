import 'package:provider/provider.dart';
import 'package:robot_gui/providers/ros_client.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:fluent_ui/fluent_ui.dart';

class RMPViewer extends StatelessWidget {
  const RMPViewer({
    Key? key,
  }) : super(key: key);

  Widget _getRadialGauge(BuildContext context) {
    final _ros = Provider.of<ROSClient>(context, listen: false);
    return StreamBuilder(
        stream: _ros.cmdVelFB,
        builder: (context, snapshot) {
          var l = 0.0, a = 0.0;

          if (snapshot.data != null) {
            final twist = (snapshot.data as Map)['msg'];
            print(twist);
            l = twist['linear']['x'] as double;

            a = twist['angular']['z'] as double;
          }
          return StreamBuilder(
              stream: _ros.cmdVel,
              builder: (context, msg) {
                var lc = 0.0, ac = 0.0;
                if (msg.data != null) {
                  lc = (msg.data as Map)['linear']['x'] as double;

                  ac = (msg.data as Map)['angular']['z'] as double;
                }

                return SfRadialGauge(
                  axes: <RadialAxis>[
                    RadialAxis(
                      minimum: -1.5,
                      maximum: 1.5,
                      centerY: 0.6,
                      centerX: 1,
                      radiusFactor: 1.2,
                      axisLineStyle: AxisLineStyle(
                        thickness: 10,
                        cornerStyle: CornerStyle.bothCurve,
                        gradient: SweepGradient(
                          colors: <Color>[Colors.green, Colors.red],
                          stops: const <double>[0.7, 0.3],
                        ),
                      ),
                      ranges: <GaugeRange>[
                        GaugeRange(
                          startValue: 0,
                          endValue: l,
                          startWidth: 2,
                          endWidth: 10,
                          rangeOffset: 0,
                          gradient: SweepGradient(
                            colors: <Color>[Colors.blue, Colors.green],
                          ),
                        ),
                      ],
                      pointers: <GaugePointer>[
                        NeedlePointer(
                          value: l,
                          needleStartWidth: 1,
                          needleEndWidth: 5,
                          knobStyle: const KnobStyle(
                            knobRadius: 0.05,
                            borderColor: Colors.black,
                            borderWidth: 0.02,
                            color: Colors.white,
                          ),
                        ),
                        NeedlePointer(
                          value: lc,
                          needleStartWidth: 1,
                          needleEndWidth: 5,
                          needleColor: Colors.black.withOpacity(0.2),
                          knobStyle: KnobStyle(
                            knobRadius: 0.05,
                            borderColor: Colors.black.withOpacity(0.2),
                            borderWidth: 0.02,
                            color: Colors.white,
                          ),
                        ),
                      ],
                      annotations: <GaugeAnnotation>[
                        GaugeAnnotation(
                          widget: Text(
                            l.toStringAsFixed(2),
                            style: const TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          angle: 90,
                          positionFactor: 0.5,
                        )
                      ],
                    ),
                    RadialAxis(
                      minimum: -1,
                      isInversed: true,
                      maximum: 1,
                      radiusFactor: 0.8,
                      centerY: 0.8,
                      centerX: 0,
                      axisLineStyle: AxisLineStyle(
                        thickness: 5,
                        cornerStyle: CornerStyle.bothCurve,
                        gradient: SweepGradient(
                          colors: <Color>[Colors.green, Colors.red],
                          stops: const <double>[0.7, 0.3],
                        ),
                      ),
                      ranges: <GaugeRange>[
                        GaugeRange(
                          startValue: 0,
                          endValue: a,
                          startWidth: 2,
                          endWidth: 3,
                          rangeOffset: 0,
                          gradient: SweepGradient(
                            colors: <Color>[Colors.blue, Colors.green],
                          ),
                        ),
                      ],
                      pointers: <GaugePointer>[
                        NeedlePointer(
                          value: a,
                          needleStartWidth: 1,
                          needleEndWidth: 3,
                          knobStyle: const KnobStyle(
                            knobRadius: 0.05,
                            borderColor: Colors.black,
                            borderWidth: 0.02,
                            color: Colors.white,
                          ),
                        ),
                        NeedlePointer(
                          value: ac,
                          needleStartWidth: 1,
                          needleEndWidth: 3,
                          needleColor: Colors.black.withOpacity(0.2),
                          knobStyle: KnobStyle(
                            knobRadius: 0.05,
                            borderColor: Colors.black.withOpacity(0.2),
                            borderWidth: 0.02,
                            color: Colors.white,
                          ),
                        ),
                      ],
                      annotations: <GaugeAnnotation>[
                        GaugeAnnotation(
                          widget: Text(
                            a.toStringAsFixed(2),
                            style: const TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          angle: 90,
                          positionFactor: 0.5,
                        )
                      ],
                    )
                  ],
                );
              });
        });
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.bottomEnd,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 150, vertical: 50),
        child: SizedBox(
          height: 200,
          width: 200,
          child: _getRadialGauge(context),
        ),
      ),
    );
  }
}
