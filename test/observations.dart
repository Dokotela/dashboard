import 'dart:convert';
import 'dart:math';

import 'package:fhir/fhir_r4.dart' as r4;
import 'package:http/http.dart';

void main() async {
  for (var i = 0; i < 100; i++) {
    var bundle = r4.Bundle(
      resourceType: 'Bundle',
      type: r4.BundleType.transaction,
      entry: [
        r4.BundleEntry(
          resource: r4.Observation(
            resourceType: 'Observation',
            status: r4.ObservationStatus.final_,
            category: [
              r4.CodeableConcept(
                coding: [
                  r4.Coding(
                    system: r4.FhirUri(
                        "http://terminology.hl7.org/CodeSystem/observation-category"),
                    code: r4.Code('vital-signs'),
                    display: 'Vital Signs',
                  ),
                ],
                text: 'Vital Signs',
              ),
            ],
            code: r4.CodeableConcept(
              coding: [
                r4.Coding(
                  system: r4.FhirUri('http://loinc.org'),
                  code: r4.Code('2708-6'),
                  display: 'Oxygen saturation in Arterial blood',
                ),
              ],
            ),
            subject: r4.Reference(reference: 'Patient/226'),
            effectiveDateTime: r4.FhirDateTime(DateTime.now()),
            valueQuantity: r4.Quantity(
              value: r4.Decimal(Random().nextInt(30) + 70.0),
              unit: '%',
              system: r4.FhirUri('http://unitsofmeasure.org'),
              code: r4.Code('%'),
            ),
          ),
          request: r4.BundleRequest(
            method: r4.BundleRequestMethod.post,
            url: r4.FhirUri('Observation'),
          ),
        ),
      ],
    );
    var headers = {'content-type': 'application/fhir+json'};
    var response = await post('http://localhost:8080/hapi-fhir-jpaserver/fhir/',
        headers: headers, body: jsonEncode(bundle.toJson()));
    print(response.statusCode);
    print(response.body);
    await Future.delayed(Duration(seconds: 15));
  }
}
