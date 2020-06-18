import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import 'package:fhir/fhir_r4.dart';

import 'export.dart';

class PatientInformation {
  Patient patient;
  double screenSize;
  FhirDateTime last;
  List<Tuple2<double, FhirDateTime>> sat;
  List<Tuple2<double, FhirDateTime>> hr;

  PatientInformation({
    this.patient,
    this.screenSize,
    this.last,
    this.sat,
    this.hr,
  });

  void getVitals({FhirDateTime last}) async {
    var now = FhirDateTime(DateTime.now());
    var result = await getPatientVitals(
      patient.id.toString(),
      last ?? this.last,
    );
    this.last = now;
    result.value1.forEach((satValue) => sat.add(satValue));
    result.value2.forEach((hrValue) => hr.add(hrValue));
  }

  Row patientRow() => Row(
        children: [
          getPatientName(),
          getHeartRate(56),
          getSaturation(96),
          // getTrend(),
        ],
      );

  Container getPatientName() {
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
              style:
                  TextStyle(fontSize: screenSize * .015, color: Colors.black),
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

  Container getHeartRate(int hr) => Container(
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

  Container getSaturation(int sat) => Container(
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

  Container getTrend() {
    return Container(child: ScatterChartSample1(screenSize, sat, hr));
  }
}
