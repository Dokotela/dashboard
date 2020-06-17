import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ScatterChartSample1 extends StatefulWidget {
  final double screenSize;

  ScatterChartSample1(this.screenSize);
  @override
  State<StatefulWidget> createState() => _ScatterChartSample1State(screenSize);
}

class _ScatterChartSample1State extends State {
  double screenSize;
  final maxX = 50.0;
  final maxY = 50.0;
  final radius = 8.0;

  Color blue1 = const Color(0xFF0D47A1);
  Color blue2 = const Color(0xFF42A5F5).withOpacity(0.8);

  bool showFlutter = true;

  _ScatterChartSample1State(this.screenSize);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          showFlutter = !showFlutter;
        });
      },
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
                scatterSpots: randomData(),
                minX: 0,
                maxX: maxX,
                minY: 0,
                maxY: maxY,
                borderData: FlBorderData(
                  show: false,
                ),
                gridData: FlGridData(
                  show: true,
                ),
                titlesData: FlTitlesData(
                  show: false,
                ),
                scatterTouchData: ScatterTouchData(
                  enabled: false,
                ),
              ),
              swapAnimationDuration: const Duration(milliseconds: 600),
            ),
          ),
        ),
      ),
    );
  }

  List<ScatterSpot> randomData() {
    const blue1Count = 21;
    const blue2Count = 57;
    return List.generate(blue1Count + blue2Count, (i) {
      Color color;
      if (i < blue1Count) {
        color = blue1;
      } else {
        color = blue2;
      }

      return ScatterSpot(
        (Random().nextDouble() * (maxX - 8)) + 4,
        (Random().nextDouble() * (maxY - 8)) + 4,
        color: color,
        radius: 2,
      );
    });
  }
}
