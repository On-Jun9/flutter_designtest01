import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_designtest01/design/testpage1.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class home extends StatefulWidget {
  @override
  State<home> createState() => homeState();

}
class homeState extends State<home>{

  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  static final CameraPosition _kLake = CameraPosition(
      //bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      //tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('메인페이지(구글지도)'),
          actions: <Widget>[
            IconButton(
              onPressed: () {},//검색버튼(임시) 새로고침?
              icon: Icon(Icons.search),
            ),
            IconButton(
              onPressed: () {},//설정버튼(임시)
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
                  accountName: Text('구글 이름 구현'),
                  accountEmail: Text('구글 이메일 구현')
              ),
              //메뉴 리스트
              ListTile(
                leading: Icon(//메뉴1 아이콘
                  Icons.home,
                  color: Colors.grey[850],
                ),
                title: Text('메뉴1'),//메뉴1 텍스트
                onTap: (){//메뉴1 동작
                  Navigator.push(//네비게이터
                      context,
                      MaterialPageRoute(//페이지 이동
                          builder: (context)=> testpage1()
                      )
                  );
                },
                trailing: Icon(Icons.arrow_forward_ios),//메뉴1 화살표
              ),
              ListTile(
                leading: Icon(//메뉴2 아이콘
                  Icons.account_box,
                  color: Colors.grey[850],
                ),
                title: Text('메뉴2'),//메뉴2 텍스트
                onTap: (){},//메뉴2 동작
                trailing: Icon(Icons.arrow_forward_ios),//메뉴2 화살표
              )
            ],
          ),
        ),

        //홈 구글맵 구현
        body: GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition: _kGooglePlex,
          onMapCreated: (GoogleMapController controller){
           _controller.complete(controller);
          },
        ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: _goToMap,
          label: Text('이동')
      ),
      );
  }
  
  Future<void> _goToMap() async{
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
}
