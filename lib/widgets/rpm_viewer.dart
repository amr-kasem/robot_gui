import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:fluent_ui/fluent_ui.dart';

class RMPViewer extends StatelessWidget {
  const RMPViewer({
    Key? key,
  }) : super(key: key);

  Widget _getRadialGauge() {
    return SfRadialGauge(
      title: const GaugeTitle(
        text: 'D',
        textStyle: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      axes: <RadialAxis>[
        RadialAxis(
          minimum: 0,
          maximum: 1.5,
          radiusFactor: 2,
          axisLineStyle: AxisLineStyle(
            thickness: 15,
            dashArray: const [0.1, 0.2, 0.35, 0.5, 0.8, 1.2, 1.5],
            cornerStyle: CornerStyle.bothCurve,
            gradient: SweepGradient(
              colors: <Color>[Colors.green, Colors.red],
              stops: const <double>[0.7, 0.3],
            ),
          ),
          ranges: <GaugeRange>[
            GaugeRange(
              startValue: 0,
              endValue: 1.2,
              startWidth: 3,
              endWidth: 15,
              rangeOffset: 0,
              gradient: SweepGradient(
                colors: <Color>[Colors.blue, Colors.green],
              ),
            ),
          ],
          pointers: const <GaugePointer>[
            NeedlePointer(
              value: 1.2,
              needleStartWidth: 1,
              needleEndWidth: 5,
              knobStyle: KnobStyle(
                knobRadius: 0.05,
                borderColor: Colors.black,
                borderWidth: 0.02,
                color: Colors.white,
              ),
            ),
          ],
          annotations: const <GaugeAnnotation>[
            GaugeAnnotation(
              widget: Text(
                '1.2',
                style: TextStyle(
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
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.bottomEnd,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 50),
        child: SizedBox(
          height: 150,
          width: 150,
          child: _getRadialGauge(),
        ),
      ),
    );
  }
}
