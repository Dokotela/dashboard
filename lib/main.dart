import 'package:dashboard/charts.dart';
import 'package:fhir/fhir_r4.dart';
import 'package:flutter/material.dart';

import 'server_call.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Covid-19 Home Monitoring Dashboard',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Covid-19 Home Monitoring Dashboard'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Widget> patients = <Widget>[];
  final patientController = TextEditingController();

  @override
  void dispose() {
    patientController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                  patients.add(
                      patientRow(patient, MediaQuery.of(context).size.width));
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
            style: TextStyle(fontSize: 36, color: Colors.black),
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
          style: TextStyle(fontSize: 24),
        ),
        Text(
          '$hr',
          style: TextStyle(fontSize: 100),
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
          style: TextStyle(fontSize: 24),
        ),
        Text(
          '$sat%',
          style: TextStyle(fontSize: 100),
        ),
      ],
    ),
  );
}

Container trend(double screenSize) {
  return Container(child: ScatterChartSample1(screenSize));
}
