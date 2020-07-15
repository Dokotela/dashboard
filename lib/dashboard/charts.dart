import 'package:dartz/dartz.dart' as dartz;
import 'package:dartz/dartz_streaming.dart';
import 'package:fhir/fhir_r4.dart' as r4;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

GestureDetector scatterChart(
    double screenSize, List<dartz.Tuple2<double, r4.FhirDateTime>> sat) {
  double start = 0.0;
  double end = 5.0;
  final maxY = 150.0;
  var now = DateTime.now();
  var minute = now.minute;

  return GestureDetector(
    child: Container(
      width: screenSize * .4,
      height: 180,
      child: AspectRatio(
        aspectRatio: 1,
        child: Card(
          color: const Color(0xffffffff),
          elevation: 6,
          child: ScatterChart(
            ScatterChartData(
              scatterSpots: classifyData(sat, minute),
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
                bottomTitles: SideTitles(
                  showTitles: true,
                  getTitles: (value) {
                    switch (value.toInt()) {
                      case 5:
                        return ('${DateTime.now().add(Duration(minutes: -5)).toIso8601String().substring(11, 16)}');
                      case 5:
                        return ('${DateTime.now().add(Duration(minutes: -4)).toIso8601String().substring(11, 16)}');
                      case 4:
                        return ('${DateTime.now().add(Duration(minutes: -3)).toIso8601String().substring(11, 16)}');
                      case 3:
                        return ('${DateTime.now().add(Duration(minutes: -2)).toIso8601String().substring(11, 16)}');
                      case 2:
                        return ('${DateTime.now().add(Duration(minutes: -1)).toIso8601String().substring(11, 16)}');
                      case 1:
                        return ('${DateTime.now().add(Duration(minutes: 0)).toIso8601String().substring(11, 16)}');
                      case 0:
                        return ('${DateTime.now().add(Duration(minutes: 1)).toIso8601String().substring(11, 16)}');
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
  int minute,
) {
  var blue = Colors.blue;
  var yellow = Colors.yellow.shade700;
  var red = Colors.red.shade800;

  return List.generate(sat?.length ?? 0, (i) {
    Color color;
    double minSec;
    double value;
    String dateTime;
    if (i < sat?.length ?? 0) {
      color = sat[i].value1 < 85.0 ? red : sat[i].value1 < 92.0 ? yellow : blue;
      dateTime = sat[i].value2.toString();

      value = sat[i].value1;
    }

    var calcTime = DateTime.parse(dateTime);
    minSec = minute - calcTime.minute - calcTime.second / 60 + 1;

    return ScatterSpot(
      (minSec),
      (value),
      color: color,
      radius: 2,
    );
  });
}
