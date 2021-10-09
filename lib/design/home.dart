import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_designtest01/design/DrawerPage.dart';
import 'package:flutter_designtest01/design/ReportPage.dart';
import 'package:flutter_designtest01/design/firstAid.dart';
import 'package:flutter_designtest01/design/glogin.dart';
import 'package:flutter_designtest01/design/testpage1.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:location/location.dart';

class home extends StatefulWidget {
  @override
  State<home> createState() => homeState();
}


class homeState extends State<home> {
  CollectionReference users = FirebaseFirestore.instance.collection('user');

  var _login = LoginWidget();

  User? user;
  Stream? authState;

  Completer<GoogleMapController> _controller = Completer();

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{}; //마커

  LatLng tapMap = LatLng(37.45662871370885, 126.95005995529378);
  String markerValue1 = '';
  String locaname = '';
  String locaLat1 = '';
  String locaLat2 = '';
  String locationName = '';
  LatLng currentPosition = LatLng(0, 0);
  var location = new Location();
  String imageUrl= '';

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.45662871370885, 126.95005995529378),
    zoom: 14.4746,
  );

  static final CameraPosition _kLake = CameraPosition(
      //bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      //tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  // Map<MarkerId,Marker> markers = <MarkerId,Marker>{};

  // // Stream<QuerySnapshot> collectionStraem = FirebaseFirestore.instance.collection('제보').snapshots();
  //
  // Future<Position> getCurrentLocation() async {
  //   Position position = await Geolocator.getCurrentPosition(
  //       desiredAccuracy: LocationAccuracy.high);
  //
  //   print(position.latitude);
  //   print( position.longitude);
  //   return position;
  // }

  @override
  void initState() {
    super.initState();

    authState = FirebaseAuth.instance.authStateChanges();

    user = FirebaseAuth.instance.currentUser;
    currentLocation();


    // getCurrentLocation();
    // if(user != null){
    //     var userName = user!.email.toString();
    //     var userEmail = user!.email.toString();
    //   }else{
    //   var userName = '사용자 이름';
    //   var userEmail = '사용자 이메일';
    // }
    // _markers.add(Marker(
    //     markerId: MarkerId("1"),
    //     draggable: true,
    //     // onTap: () => print("Marker!"),
    //     infoWindow: InfoWindow(title: 'SEOUL', snippet: 'welcome'),
    //     position: LatLng(37.56421135, 127.0016985)));
    // _markers.add(Marker(
    //   markerId: MarkerId("2"),
    //   draggable: true,
    //   infoWindow: InfoWindow(title: 'SEOUL', snippet: 'welcome'),
    //   position: LatLng(37.45662871370885, 126.95005995529378)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('주변 응급 상황'),
        actions: <Widget>[
          IconButton(
            onPressed: () {}, //검색버튼(임시) 새로고침?
            icon: Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {}, //설정버튼(임시)
            icon: Icon(Icons.more_vert),
          ),
        ],
      ),

      //사이드 메뉴 drawer
      drawer: Drawer(child: DrawerPage()),
      //홈 구글맵 구현
      body: currentPosition == LatLng(0, 0) ? Center(child: CircularProgressIndicator()) :
      StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('제보').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            } else {
              print("스트림빌더 작동");
              markers = {}; // 마커 초기화
              snapshot.data!.docs.forEach((change) {
                var markerIdVal = change.id;
                final MarkerId markerId = MarkerId(markerIdVal);
                markers[markerId] = Marker(
                  markerId: markerId,
                  onTap: () {
                    setState(() {
                      markerValue1 = markerIdVal;
                      printUrl();
                    });
                    getlocainfo(markerValue1);
                    print(markerIdVal);

                  },
                  position: LatLng(change['좌표'].latitude,
                      change['좌표'].longitude),
                  infoWindow: InfoWindow(
                    title: change['유형'] == '' ? '설명없음' : change['유형'],
                    snippet: change['설명'] == '' ? '설명없음' : change['설명'],
                    onTap: () {
                      _showDialog();
                    },

                    //       (){
                    //     Navigator.push(context, MaterialPageRoute(
                    //     builder: (context) => testpage1()
                    //     )
                    //   );
                    // }
                  ),
                );
              });
              return GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition: CameraPosition(
                  target: currentPosition,
                  zoom: 14.4746,
                ),
                myLocationButtonEnabled: true,
                myLocationEnabled: true,

                markers: Set<Marker>.of(markers.values),
                // onTap: (LatLng latlng) {
                //   print(latlng);
                //   tapMap = latlng;
                //   Marker marker =
                //       Marker(markerId: MarkerId('tap'), position: tapMap);
                //   markers[MarkerId('tap')] =
                //       Marker(markerId: MarkerId('tap'), position: tapMap);
                //   setState(() {
                //     markers[MarkerId('tap')] = marker; //ui 업데이트
                //   });
                // },

                //마커
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                  print("구글맵 로딩");
                },
              );
            }
          }),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
                //네비게이터
                context,
                MaterialPageRoute(
                    //페이지 이동
                    builder: (context) => ReportPage(tapLatLng: tapMap),
                ));
          }, //변경
          label: Text('제보')),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }

  Future<void> _testadd() async {
    //데이터 삽입 테스트
    FirebaseFirestore.instance
        .collection('좌표')
        .add({'1': '123.124142', '2': '213.1242141'});
  }

  Stream<QuerySnapshot> loadData2() {
    return FirebaseFirestore.instance.collection('좌표').snapshots();
  }

  void getMarkerData() async {
    //데이터 읽어오기 테스트
    FirebaseFirestore.instance.collection('좌표').get().then((myMarkers) {
      // for (int i = 0; i < myMarkers.docs.length; i++) {
      //   print(myMarkers.docs[i].get('좌표'));
      //   var asb = myMarkers.docs[i].get('좌표');
      //   print(asb['1']);
      // }
      if (myMarkers.docs.isNotEmpty) {
        for (int i = 0; i < myMarkers.docs.length; i++) {
          initMarker(myMarkers.docs[i].data(), myMarkers.docs[i].id);
          print(myMarkers.docs[i].data);
          print('-----------' + myMarkers.docs[i].id);
        }
      } else {
        print('없다');
      }
    });
  }

  void initMarker(specify, specifyId) {
    //마커 만들기
    var markerIdVal = specifyId;
    final MarkerId markerId = MarkerId(markerIdVal);
    final Marker marker = Marker(
        markerId: markerId,
        position: LatLng(specify['좌표'].latitude,
            specify['좌표'].longitude),
        infoWindow: InfoWindow(
            title: specify['설명'] == null ? ' ' : specify['설명'], snippet: specify['stationAddress']),
        onTap: () {
          //마커 동작
          print('마커!');
          Navigator.push(
              //네비게이터
              context,
              MaterialPageRoute(
                  //페이지 이동
                  builder: (context) => testpage1()));
        });
    // setState(() {
    //   markers[markerId] = marker; //ui 업데이트
    // });
    // print('-----------------------------------');
    // print(specify['stationLocation'].latitude);
    // print(specify['stationLocation'].longitude);
  }

  Future<void> _goToMap() async {
    //지도 이동

    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }

  Future<String> _getAppBarNameWidget() async {
    await FirebaseFirestore.instance.collection('좌표').get().then((ds) async {
      var name = ds.docs[1].get('설명');
      print(name);
      return name;
    });
    return '';
  }

  void getlocainfo(String markerId) {
    FirebaseFirestore.instance.collection('제보').doc(markerId).get().then((ds) {
      locaname = ds.get('설명').toString();
      locaLat1 = ds.get('좌표').latitude.toString();
      locaLat2 = ds.get('좌표').longitude.toString();
    });
  }

  Future<String> asd1234() async {
    await FirebaseFirestore.instance
        .collection('제보')
        .doc(markerValue1)
        .get()
        .then((ds) async {
      // var name = ds.docs[0].get('name');
      var name = ds.get('설명');
      print(name);
      print(markerValue1.toString());
      return name;
    });
    return '';
  }

  String asd12345() {
    FirebaseFirestore.instance
        .collection('좌표')
        .doc(markerValue1)
        .get()
        .then((ds) {
      // var name = ds.docs[0].get('name');
      locaname = ds.get('설명').toString();

      print('locaname : ' + locaname);
      print('markerValue1.toString : ' + markerValue1.toString());
      locationName = locaname;
    });
    return locationName;
  }

  Future<void> currentLocation() async {
    LocationData _locationData;
    _locationData = await location.getLocation();
    setState(() {
      currentPosition = LatLng(_locationData.latitude!.toDouble(), _locationData.longitude!.toDouble());
      print(currentPosition.toString());
    });
  }

  printUrl() async {
    String url = (await FirebaseStorage.instance.ref().child('images/${markerValue1}').getDownloadURL()).toString();
    // print(url);
    setState(() {
      imageUrl = url;
    });
  }

  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // FirebaseFirestore.instance.collection('좌표').doc(markerValue1.toString()).get().then((makerInfo) {
        //   String locationName =  makerInfo['name'].toString();
        //   print(locationName);
        // });
        print('dialog : ' + locaname);
        return AlertDialog(
          title: new Text("제보 화면 보기"),
          content: Container(
              // color: Colors.blue,
              child: Column(
            children: [
              new Text(locaname),
              new Text(locaLat1),
              new Text(locaLat2),
              new Text(markerValue1),
              new Image.network(imageUrl),
            ],
          )),
          actions: <Widget>[
            new FlatButton(
              child: new Text('확인'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
