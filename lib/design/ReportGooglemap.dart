import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_designtest01/design/ReportPage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class ReportGooglemap extends StatefulWidget {
  const ReportGooglemap({Key? key}) : super(key: key);

  @override
  _ReportGooglemapState createState() => _ReportGooglemapState();
}

class _ReportGooglemapState extends State<ReportGooglemap> {
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{}; //마커
  LatLng currentPosition = LatLng(0, 0);
  var location = new Location();

  LatLng tapMap = LatLng(0,0);
  Completer<GoogleMapController> _controller = Completer();

  @override
  void initState() {
    super.initState();
    currentLocation();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('위치 직접 지정'),
      ),
      body: currentPosition == LatLng(0, 0) ? Center(child: CircularProgressIndicator()) :
      GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: CameraPosition(
          target: currentPosition,
          zoom: 16.4746,
        ),
        myLocationButtonEnabled: true,
        myLocationEnabled: true,
        markers: Set<Marker>.of(markers.values),
        onTap: (LatLng latLng){
          setState(() {
            tapLatLng = latLng;
            Marker marker = Marker(
              markerId: MarkerId(latLng.toString()),
              position: latLng,
            );
            markers[MarkerId('tap')] = marker; //ui 업데이트
          });
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.pop(context,tapLatLng);
          }, //변경
          label: Text('위치 설정')),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }
  Future<void> currentLocation() async {
    LocationData _locationData;
    _locationData = await location.getLocation();
    setState(() {
      currentPosition = LatLng(_locationData.latitude!.toDouble(), _locationData.longitude!.toDouble());
      print(currentPosition.toString());
    });
  }
}
