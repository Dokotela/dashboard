import 'package:dashboard/http/server_call.dart';
import 'package:flutter/material.dart';

import 'patient_information.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Widget> patients = <Widget>[];
  List<PatientInformation> patInfo = <PatientInformation>[];
  final patientController = TextEditingController();

  @override
  void dispose() {
    patientController.dispose();
    super.dispose();
  }

  Future<void> _randomTask() async {}

  @override
  Widget build(BuildContext context) {
    _randomTask();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add, color: Colors.white, size: 36.0),
            onPressed: () async {
              if (patientController.text != null &&
                  patientController.text != '') {
                var patient = await getPatient(patientController.text);
                setState(() {
                  if (patInfo.indexWhere((patientInfo) =>
                          patientInfo.patient.id == patient.id) ==
                      -1) {
                    patInfo.add(PatientInformation(
                        patient: patient,
                        screenSize: MediaQuery.of(context).size.width));
                  }
                  patients = <Widget>[];
                  patInfo
                      .forEach((patient) => patients.add(patient.patientRow()));
                });
                patientController.text = '';
              }
            },
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.5,
            child: TextField(
              style: TextStyle(color: Colors.white),
              controller: patientController,
              decoration: InputDecoration(
                labelText: "Please Enter Patient's Id",
                labelStyle: TextStyle(color: Colors.white),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white, width: 5.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white, width: 5.0),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: patients,
          ),
        ),
      ),
    );
  }
}
