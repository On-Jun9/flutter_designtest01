import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ReportGooglemap extends StatefulWidget {
  const ReportGooglemap({Key? key}) : super(key: key);

  @override
  _ReportGooglemapState createState() => _ReportGooglemapState();
}

class _ReportGooglemapState extends State<ReportGooglemap> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('dd'),
      ),
      body: Text('d'),
    );
    //   GoogleMap(
    //     initialCameraPosition: initialCameraPosition
    // );
  }
}
