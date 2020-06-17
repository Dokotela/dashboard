import 'package:fhir/fhir_r4.dart';
import 'package:flutter/material.dart';

import 'charts.dart';

Row patientRow(Patient patient, double screenSize) {
  return Row(
    children: [
      patientName(patient, screenSize),
      heartRate(screenSize, 56),
      saturation(screenSize, 96),
      trend(screenSize),
    ],
  );
}

Container patientName(Patient patient, double screenSize) {
  var name = '${patient.name[0].family}, '
      '${patient.name[0].given.join(" ")}';
  var id = patient.id;
  var dob = patient?.birthDate?.toString() ?? 'unknown';
  return Container(
    width: screenSize * .15,
    child: Column(
      children: <Widget>[
        RichText(
          text: TextSpan(
            style: TextStyle(fontSize: screenSize * .015, color: Colors.black),
            children: <TextSpan>[
              TextSpan(
                text: 'Name: ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(text: '$name\n'),
              TextSpan(
                text: 'ID: ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(text: '$id\n'),
              TextSpan(
                text: 'DOB: ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(text: '$dob\n'),
            ],
          ),
        ),
      ],
    ),
  );
}

Container heartRate(double screenSize, int hr) {
  return Container(
    width: screenSize * .15,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          'Most Recent Heart Rate:',
          style: TextStyle(fontSize: screenSize * .012),
        ),
        Text(
          '$hr',
          style: TextStyle(fontSize: screenSize * .05),
        ),
      ],
    ),
  );
}

Container saturation(double screenSize, int sat) {
  return Container(
    width: screenSize * .15,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          'Most Recent O2Sat:',
          style: TextStyle(fontSize: screenSize * .012),
        ),
        Text(
          '$sat%',
          style: TextStyle(fontSize: screenSize * .05),
        ),
      ],
    ),
  );
}

Container trend(double screenSize) {
  return Container(child: ScatterChartSample1(screenSize));
}
