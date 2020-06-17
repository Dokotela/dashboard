import 'dart:convert';

import 'package:fhir/fhir_r4.dart';
import 'package:http/http.dart';

abstract class FhirService {
  static Future<Patient> getPatient(String id) async {
    var server = 'http://52.188.54.157:8080/fhir/';
    var headers = {
      'Content-type': 'application/json',
      'Authorization': 'Basic Y2xpZW50OnNlY3JldA=='
    };
    var response = await get('$server/Patient?_id=$id', headers: headers);
    var patient;
    if (response.statusCode == 200) {
      var patBundle = Bundle.fromJson(json.decode(response.body));
      patient = Patient.fromJson(patBundle.entry[0].resource.toJson());
    } else {
      print(response.body);
    }
    return patient;
  }
}
