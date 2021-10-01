import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_designtest01/design/firstAid.dart';
import 'package:flutter_designtest01/design/glogin.dart';
import 'package:flutter_designtest01/design/testpage1.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';

class home extends StatefulWidget {
  @override
  State<home> createState() => homeState();

}

class homeState extends State<home> {

  CollectionReference users = FirebaseFirestore.instance.collection('user');

  var _login = LoginWidget();

  Completer<GoogleMapController> _controller = Completer();

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{}; //마커 테스트

  String markerValue1 ='';
  String locaname='';
  String locaLat='';
  String locationName = '';

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

  // Stream<QuerySnapshot> collectionStraem = FirebaseFirestore.instance.collection('제보').snapshots();

  @override
  void initState() {

    super.initState();
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
        title: Text('메인페이지(구글지도)'),
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
      drawer: Drawer(
        child: ListView(
          // padding: EdgeInsets.only(right: 10.0),
          children: <Widget>[
            //메뉴 로그인
            UserAccountsDrawerHeader(
              // onDetailsPressed: _showDialog,
                accountName: Text('구글 이름 구현'),
                accountEmail: Text('구글 이메일 구현'),
              decoration: BoxDecoration(
                color: Colors.blueGrey,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10)
                )
              ),
            ),
            //메뉴 리스트
            ListTile(
              leading: Icon( //메뉴1 아이콘
                Icons.home,
                color: Colors.grey[850],
              ),
              title: Text('메뉴1'), //메뉴1 텍스트
              onTap: () async{ //메뉴1 동작

              },
              trailing: Icon(Icons.arrow_forward_ios), //메뉴1 화살표
            ),
            ListTile(
              leading: Icon( //메뉴2 아이콘
                Icons.account_box,
                color: Colors.grey[850],
              ),
              title: Text('로그인'), //메뉴2 텍스트
              onTap: () { //메뉴1 동작
                _login.signInWithGoogle();
              },
              trailing: Icon(Icons.arrow_forward_ios), //메뉴1 화살표
            ),
            ListTile(
              leading: Icon( //메뉴3 아이콘
                Icons.check,
                color: Colors.grey[850],
              ),
              title: Text('응급처치 요령'), //메뉴2 텍스트
              onTap: () {
                Navigator.push( //네비게이터
                    context,
                    MaterialPageRoute( //페이지 이동
                        builder: (context) => firstaid()
                    )
                );
              }, //메뉴2 동작
              trailing: Icon(Icons.arrow_forward_ios), //메뉴2 화살표
            )
          ],
        ),
      ),

      //홈 구글맵 구현
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('좌표').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return CircularProgressIndicator();
            } else {
              print("스트림빌더 작동");
              markers = {};
              snapshot.data!.docs.forEach((change) {
                var markerIdVal = change.id;
                final MarkerId markerId = MarkerId(markerIdVal);
                markers[markerId] = Marker(
                  markerId:  markerId,
                  onTap: (){
                    markerValue1 = markerIdVal;
                    getlocainfo(markerValue1);
                    print(markerIdVal);
                    },
                  position: LatLng(
                    change['stationLocation'].latitude,
                    change['stationLocation'].longitude),
                  infoWindow: InfoWindow(
                      title: change['name'],
                      snippet: '정보 추가',
                      onTap: ( ){
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
                initialCameraPosition: _kGooglePlex,
                myLocationButtonEnabled: true,
                myLocationEnabled: true,
                markers: Set<Marker>.of(markers.values),
                //마커
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                  print("구글맵 로딩");
                },
              );
            }

          }
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: (){}, //변경
          label: Text('이동')
      ),
    );
  }

  Future<void> _testadd() async {
    //데이터 삽입 테스트
    FirebaseFirestore.instance.collection('좌표').add(
        {'1': '123.124142', '2': '213.1242141'});
  }


  Stream<QuerySnapshot> loadData2(){
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
        position: LatLng(specify['stationLocation'].latitude,
            specify['stationLocation'].longitude),
        infoWindow: InfoWindow(
            title: specify['name'], snippet: specify['stationAddress']),
        onTap: () { //마커 동작
          Navigator.push( //네비게이터
              context,
              MaterialPageRoute( //페이지 이동
                  builder: (context) => testpage1()
              )
          );
        }
    );
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

  Future<String> _getAppBarNameWidget() async{
    await FirebaseFirestore.instance.collection('좌표').get().then((ds) async{
      var name = ds.docs[1].get('name');
      print(name);
      return name;
    });
    return '';
  }

  void getlocainfo(String markerId){
    FirebaseFirestore.instance.collection('좌표').doc(markerId).get().then((ds) {
      locaname = ds.get('name').toString();
      locaLat = ds.get('stationLocation').latitude.toString();
    });
  }

  Future<String> asd1234() async{
    await FirebaseFirestore.instance.collection('좌표').doc(markerValue1).get().then((ds) async{
      // var name = ds.docs[0].get('name');
      var name = ds.get('name');
      print(name);
      print(markerValue1.toString());
      return name;
    });
    return '';
  }

  String asd12345() {
    FirebaseFirestore.instance.collection('좌표').doc(markerValue1).get().then((ds) {
      // var name = ds.docs[0].get('name');
      locaname = ds.get('name').toString();

      print('locaname : '+ locaname);
      print('markerValue1.toString : '+markerValue1.toString());
      locationName = locaname;
    });
    return locationName;
  }



  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context){
        // FirebaseFirestore.instance.collection('좌표').doc(markerValue1.toString()).get().then((makerInfo) {
        //   String locationName =  makerInfo['name'].toString();
        //   print(locationName);
        // });
        print('dialog : ' + locaname);
        return AlertDialog(
          title: new Text("Alert Dialog title"),
          content: Container(
            color: Colors.blue,
              child: Column(

                children: [
                  new Text(locaname),
                  new Text(locaLat),
                ],

              )
          ),
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
