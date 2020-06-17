import 'dart:math';

import 'package:dartz/dartz.dart' as dartz;
import 'package:fhir/fhir_r4.dart' as r4;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ScatterChartSample1 extends StatefulWidget {
  final double screenSize;
  final dartz.Tuple2<double, r4.FhirDateTime> sat;
  final dartz.Tuple2<double, r4.FhirDateTime> hr;

  ScatterChartSample1(this.screenSize, this.sat, this.hr);
  @override
  State<StatefulWidget> createState() =>
      _ScatterChartSample1State(screenSize, sat, hr);
}

class _ScatterChartSample1State extends State {
  double screenSize;
  dartz.Tuple2<double, r4.FhirDateTime> sat;
  dartz.Tuple2<double, r4.FhirDateTime> hr;
  double end = DateTime.now().add(Duration(hours: 1)).hour.toDouble();
  double start = DateTime.now().add(Duration(hours: -5)).hour.toDouble();
  final maxY = 150.0;

  bool showFlutter = true;

  _ScatterChartSample1State(this.screenSize, this.sat, this.hr);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // onTap: () {
      //   setState(() {
      //     showFlutter = !showFlutter;
      //   });
      // },
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
    dartz.Tuple2<double, r4.FhirDateTime> sat,
    dartz.Tuple2<double, r4.FhirDateTime> hr,
  ) {
    Color blue1 = const Color(0xFF0D47A1);
    Color blue2 = const Color(0xFF42A5F5).withOpacity(0.8);
    var hr = 90.0;
    var sat = 98.0;
    var curVal = hr;
    var time = start;
    return List.generate(2000, (i) {
      Color color;
      var posNeg = Random().nextDouble() > .5 ? -1 : 1;
      if (i % 2 == 0) {
        color = blue1;
        curVal = hr;
        hr = Random().nextDouble() * posNeg + hr;
      } else {
        color = blue2;
        curVal = sat;
        sat = Random().nextDouble() * posNeg + sat;
      }
      time += .003;

      return ScatterSpot(
        (time),
        (curVal),
        color: color,
        radius: 1.5,
      );
    });
  }
}
