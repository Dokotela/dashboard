import 'package:dartz/dartz.dart' as dartz;
import 'package:fhir/fhir_r4.dart' as r4;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ScatterChartSample1 extends StatefulWidget {
  final double screenSize;
  final List<dartz.Tuple2<double, r4.FhirDateTime>> sat;
  final List<dartz.Tuple2<double, r4.FhirDateTime>> hr;

  ScatterChartSample1(this.screenSize, this.sat, this.hr);
  @override
  State<StatefulWidget> createState() =>
      _ScatterChartSample1State(screenSize, sat, hr);
}

class _ScatterChartSample1State extends State {
  double screenSize;
  List<dartz.Tuple2<double, r4.FhirDateTime>> sat;
  List<dartz.Tuple2<double, r4.FhirDateTime>> hr;
  double end = DateTime.now().add(Duration(hours: 1)).hour.toDouble();
  double start = DateTime.now().add(Duration(hours: -5)).hour.toDouble();
  final maxY = 150.0;

  bool showFlutter = true;

  _ScatterChartSample1State(this.screenSize, this.sat, this.hr);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        width: screenSize * .5,
        height: 200,
        child: AspectRatio(
          aspectRatio: 1,
          child: Card(
            color: const Color(0xffffffff),
            elevation: 6,
            child: ScatterChart(
              ScatterChartData(
                scatterSpots: classifyData(sat, hr),
                minX: start,
                maxX: end,
                minY: 40,
                maxY: maxY,
                borderData: FlBorderData(
                  show: false,
                ),
                gridData: FlGridData(
                  show: true,
                ),
                titlesData: FlTitlesData(
                  show: true,
                  leftTitles: SideTitles(
                    showTitles: true,
                    getTitles: (value) {
                      switch (value.toInt() % 10) {
                        case 0:
                          return value.toString();
                        default:
                          return '';
                      }
                    },
                  ),
                ),
                scatterTouchData: ScatterTouchData(
                  enabled: false,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<ScatterSpot> classifyData(
    List<dartz.Tuple2<double, r4.FhirDateTime>> sat,
    List<dartz.Tuple2<double, r4.FhirDateTime>> hr,
  ) {
    Color blue = const Color(0x6C7CCA);
    Color yellow = const Color(0xEEF331);
    Color red = const Color(0xF31929);
    Color purple = const Color(0xB819F3);

    return List.generate(sat.length + hr.length, (i) {
      Color color;
      double time;
      double value;
      if (i < sat.length) {
        color =
            sat[i].value1 < 92.0 ? yellow : sat[i].value1 < 85.0 ? red : blue;
        DateTime original = DateTime.parse(sat[i].value2.toString());
        time = original.hour + original.minute / 60 + original.second / 3600;
        value = sat[i].value1;
      } else {
        var item = hr[i - sat.length];
        color = (item.value1 < 60 || item.value1 > 100)
            ? yellow
            : (item.value1 < 50 || item.value1 > 120) ? red : purple;
        DateTime original = DateTime.parse(item.value2.toString());
        time = original.hour + original.minute / 60 + original.second / 3600;
        value = item.value1;
      }

      return ScatterSpot(
        (time),
        (value),
        color: color,
        radius: 1.5,
      );
    });
  }
}
