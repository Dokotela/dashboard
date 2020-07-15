import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import 'package:fhir/fhir_r4.dart';

import 'export.dart';

class PatientInformation {
  Patient patient;
  double screenSize;
  List<Tuple2<double, FhirDateTime>> sat;

  PatientInformation({
    this.patient,
    this.screenSize,
    this.sat,
  }) {
    sat = <Tuple2<double, FhirDateTime>>[];
  }

  Row patientRow() => Row(
        children: [
          getPatientName(),
          getSaturation(),
          getTrend(),
        ],
      );

  Future<void> getVitals({FhirDateTime last}) async {
    var result = await getPatientVitals(patient.id.toString());
    if (result.value1 != null && result.value1.isNotEmpty) {
      sat = <Tuple2<double, FhirDateTime>>[];
      result.value1.forEach((satValue) => sat.add(satValue));
    }
    print('GetVitals: ${sat.last.value2}');
  }

  Container getPatientName() {
    var name = '${patient?.name[0]?.family}, '
        '${patient?.name[0]?.given?.join(" ")}';
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

  Container getSaturation() {
    var latest = '';
    if (sat.isNotEmpty) {
      if (sat.length > 1) {
        sat.sort((a, b) => DateTime.parse(a.value2.toString())
            .compareTo(DateTime.parse(b.value2.toString())));
      }
      latest = '${sat.last.value1.toInt().toString()}%';
    } else {
      latest = 'N/A';
    }

    print('GetSats: ${sat.last.value2}');

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
            '$latest',
            style: TextStyle(fontSize: screenSize * .05),
          ),
        ],
      ),
    );
  }

  Container getTrend() {
    print('GetTrend: ${sat.last.value2}');
    return Container(child: scatterChart(screenSize, sat));
  }
}
