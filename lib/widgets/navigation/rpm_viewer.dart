import 'package:provider/provider.dart';
import 'package:robot_gui/providers/ros_client.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:fluent_ui/fluent_ui.dart';

class RMPViewer extends StatelessWidget {
  const RMPViewer({
    Key? key,
  }) : super(key: key);

  Widget _getRadialGauge(BuildContext context, _ros) {
    return StreamBuilder(
      stream: _ros.cmdVelFB,
      builder: (context, snapshot) {
        var l = 0.0, a = 0.0;

        if (snapshot.data != null) {
          final twist = (snapshot.data as Map)['msg'];
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
            final isRtl = Directionality.of(context) == TextDirection.rtl;
            return SfRadialGauge(
              axes: <RadialAxis>[
                RadialAxis(
                  minimum: -1.5,
                  maximum: 1.5,
                  centerY: 0.5,
                  axisLabelStyle: const GaugeTextStyle(
                    fontWeight: FontWeight.w900,
                  ),
                  centerX: isRtl ? 0.35 : 0.65,
                  radiusFactor: 1,
                  axisLineStyle: AxisLineStyle(
                    thickness: 3,
                    cornerStyle: CornerStyle.bothCurve,
                    color: Colors.black.withOpacity(0.4),
                  ),
                  ranges: <GaugeRange>[
                    GaugeRange(
                      startValue: 0,
                      endValue: l,
                      startWidth: 5,
                      endWidth: 5,
                      rangeOffset: 3,
                      color: Colors.blue,
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
                      needleColor: Colors.black.withOpacity(0.3),
                      knobStyle: KnobStyle(
                        knobRadius: 0.05,
                        borderColor: Colors.black.withOpacity(0.3),
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
                  radiusFactor: 0.5,
                  centerY: 0.76,
                  centerX: isRtl ? 0.84 : 0.16,
                  labelOffset: 6,
                  axisLabelStyle: const GaugeTextStyle(
                    fontWeight: FontWeight.w900,
                  ),
                  axisLineStyle: AxisLineStyle(
                    thickness: 2,
                    cornerStyle: CornerStyle.bothCurve,
                    color: Colors.black.withOpacity(0.4),
                  ),
                  ranges: <GaugeRange>[
                    GaugeRange(
                      startValue: 0,
                      endValue: a,
                      startWidth: 2,
                      endWidth: 2,
                      rangeOffset: 2,
                      color: Colors.blue,
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
                      needleColor: Colors.black.withOpacity(0.3),
                      knobStyle: KnobStyle(
                        knobRadius: 0.05,
                        borderColor: Colors.black.withOpacity(0.3),
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
                          fontSize: 18,
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
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final _ros = Provider.of<ROSClient>(context, listen: false);

    return Align(
      alignment: AlignmentDirectional.bottomEnd,
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: SizedBox(
          height: 300,
          width: 450,
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.25),
                    ),
                    height: double.infinity,
                    width: 306,
                  ),
                ),
              ),
              Align(
                alignment: AlignmentDirectional.bottomStart,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.25),
                  ),
                  height: 145,
                  width: 145,
                ),
              ),
              _getRadialGauge(context, _ros),
              GestureDetector(
                onDoubleTap: () {
                  _ros.zeroLinear();
                },
                child: Padding(
                  padding: const EdgeInsets.all(7.0),
                  child: Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      height: double.infinity,
                      width: 300,
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onDoubleTap: () {
                  _ros.zeroAngular();
                },
                child: Align(
                  alignment: AlignmentDirectional.bottomStart,
                  child: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    height: 145,
                    width: 145,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
