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
    var blue = Colors.blue;
    var yellow = Colors.yellow;
    var red = Colors.red;
    var purple = Colors.purple;

    return List.generate(sat?.length ?? 0 + hr?.length ?? 0, (i) {
      Color color;
      double time;
      double value;
      String dateTime;
      if (i < sat?.length ?? 0) {
        color =
            sat[i].value1 < 92.0 ? yellow : sat[i].value1 < 85.0 ? red : blue;
        dateTime = sat[i].value2.toString();

        value = sat[i].value1;
      } else if ((i - sat?.length ?? 0) < (hr?.length ?? 0)) {
        var item = hr[i - sat?.length ?? 0];
        color = (item.value1 < 60 || item.value1 > 100)
            ? yellow
            : (item.value1 < 50 || item.value1 > 120) ? red : purple;
        dateTime = item.value2.toString();

        value = item.value1;
      }
      time = double.parse(dateTime.substring(11, 13)) +
          double.parse(dateTime.substring(14, 16)) / 60 +
          double.parse(dateTime.substring(17, 19)) / 3600;

      return ScatterSpot(
        (time),
        (value),
        color: color,
        radius: 1,
      );
    });
  }
}
