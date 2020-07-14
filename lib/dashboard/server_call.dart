import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:http/http.dart';

import 'package:fhir/fhir_r4.dart';

Future<Patient> getPatient(String name) async {
  var server = 'http://localhost:8080/hapi-fhir-jpaserver/fhir/';
  var headers = {
    'Content-type': 'application/fhir+json',
  };
  var response = await get('$server/Patient/$name', headers: headers);
  var patient;
  if (response.statusCode == 200) {
    patient = Patient.fromJson(jsonDecode(response.body));
  } else {
    print(response.body);
  }
  return patient;
}

Future<
    Tuple2<List<Tuple2<double, FhirDateTime>>,
        List<Tuple2<double, FhirDateTime>>>> getPatientVitals(
    String id, FhirDateTime last) async {
  var server = 'http://localhost:8080/hapi-fhir-jpaserver/fhir/';
  var headers = {
    'Content-type': 'application/fhir+json',
  };

  var response = await get('$server/Observation?_count=1000', headers: headers);
  List<Tuple2<double, FhirDateTime>> sats = [];
  List<Tuple2<double, FhirDateTime>> hr = [];
  if (response.statusCode == 200) {
    var obsBundle = Bundle.fromJson(json.decode(response.body));
    if (int.parse(obsBundle.total.toString()) > 0) {
      obsBundle.entry.forEach((entry) {
        var obs = Observation.fromJson(entry.resource.toJson());
        if (DateTime.parse(obs.effectiveDateTime.toString())
            .isAfter(DateTime.parse(last.toString()))) {
          if (obs.code.coding[0].code.toString() == '2708-6') {
            sats.add(Tuple2(obs.valueQuantity.value.toJson() + 0.000001,
                obs.effectiveDateTime));
          } else if (obs.code.coding[0].code.toString() == '8867-4') {
            hr.add(Tuple2(obs.valueQuantity.value.toJson() + 0.000001,
                obs.effectiveDateTime));
          }
        }
      });
    }
  }
  return Tuple2(sats, hr);
}
