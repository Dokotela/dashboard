// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:io';
import 'dart:math';

// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';

// import 'package:dashboard/main.dart';

void main() {
  // testWidgets('Counter increments smoke test', (WidgetTester tester) async {
  //   // Build our app and trigger a frame.
  //   await tester.pumpWidget(MyApp());

  //   // Verify that our counter starts at 0.
  //   expect(find.text('0'), findsOneWidget);
  //   expect(find.text('1'), findsNothing);

  //   // Tap the '+' icon and trigger a frame.
  //   await tester.tap(find.byIcon(Icons.add));
  //   await tester.pump();

  //   // Verify that our counter has incremented.
  //   expect(find.text('0'), findsNothing);
  //   expect(find.text('1'), findsOneWidget);
  // });

  String here;
  for (var i = 0; i < 10; i++) {
    here += """{
        "resourceType": "Observation",
        "meta": {
          "profile": [
            "http://hl7.org/fhir/StructureDefinition/vitalsigns"
          ]
        },
        "status": "final",
        "category": [
          {
            "coding": [
              {
                "system": "http://terminology.hl7.org/CodeSystem/observation-category",
                "code": "vital-signs",
                "display": "Vital Signs"
              }
            ],
            "text": "Vital Signs"
          }
        ],
        "code": {
          "coding": [
            {
              "system": "http://loinc.org",
              "code": "2708-6",
              "display": "Oxygen saturation in Arterial blood"
            }
          ]
        },
        "subject": {
          "reference": "Patient/ae4db233-2d41-4d1d-80ee-8046baeaadb8"
        },
        "effectiveDateTime": "2020-06-18T${Random().nextInt(23)}:${Random().nextInt(59)}:${Random().nextInt(99)}+05:00",
        "valueQuantity": {
          "value": ${Random().nextInt(19) + 80},
          "unit": "%",
          "system": "http://unitsofmeasure.org",
          "code": "%"
        },
        "referenceRange": [
          {
            "low": {
              "value": 90,
              "unit": "%",
              "system": "http://unitsofmeasure.org",
              "code": "%"
            },
            "high": {
              "value": 99,
              "unit": "%",
              "system": "http://unitsofmeasure.org",
              "code": "%"
            }
          }
        ]
      },""";
  }

  File('./test/test.json').writeAsString(here);
}
