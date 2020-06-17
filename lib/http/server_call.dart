import 'dart:convert';

import 'package:fhir/fhir_r4.dart';
import 'package:http/http.dart';

Future<Patient> getPatient(String name) async {
  var server = 'http://52.188.54.157:8080/fhir/';
  var headers = {
    'Content-type': 'application/json',
    'Authorization': 'Basic Y2xpZW50OnNlY3JldA=='
  };
  var response = await get('$server/Patient?family=$name', headers: headers);
  var patient;
  if (response.statusCode == 200) {
    print('here');
    var patBundle = Bundle.fromJson(json.decode(response.body));
    patient = Patient.fromJson(patBundle.entry[0].resource.toJson());
  } else {
    print(response.body);
  }
  return patient;
}
