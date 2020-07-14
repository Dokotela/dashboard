import 'dart:convert';
import 'dart:math';
import 'dart:core' as core;

import 'package:fhir/fhir_r4.dart';
import 'package:http/http.dart';

void main() async {
  for (var i = 0; i < 100; i++) {
    var bundle = Bundle(
      resourceType: 'Bundle',
      type: BundleType.transaction,
      entry: [
        BundleEntry(
          resource: Observation(
            resourceType: 'Observation',
            status: ObservationStatus.final_,
            category: [
              CodeableConcept(
                coding: [
                  Coding(
                    system: FhirUri(
                        "http://terminology.hl7.org/CodeSystem/observation-category"),
                    code: Code('vital-signs'),
                    display: 'Vital Signs',
                  ),
                ],
                text: 'Vital Signs',
              ),
            ],
            code: CodeableConcept(
              coding: [
                Coding(
                  system: FhirUri('http://loinc.org'),
                  code: Code('2708-6'),
                  display: 'Oxygen saturation in Arterial blood',
                ),
              ],
            ),
            subject: Reference(reference: 'Patient/202'),
            effectiveDateTime: DateTime(core.DateTime.now().toString()),
            valueQuantity: Quantity(
              value: Decimal(Random().nextInt(30) + 70.0),
              unit: '%',
              system: FhirUri('http://unitsofmeasure.org'),
              code: Code('%'),
            ),
          ),
          request: BundleRequest(
            method: BundleRequestMethod.post,
            url: FhirUri('Observation'),
          ),
        ),
      ],
    );
    var headers = {'content-type': 'application/fhir+json'};
    var response = await post('http://localhost:8080/hapi-fhir-jpaserver/fhir/',
        headers: headers, body: jsonEncode(bundle.toJson()));
    core.print(response.statusCode);
    await core.Future.delayed(core.Duration(seconds: 5));
  }
}
