import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_designtest01/design/ReportGooglemap.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';

LatLng? tapLatLng;

class ReportPage extends StatefulWidget {
  const ReportPage({Key? key, this.tapLatLng}) : super(key: key);

  final tapLatLng;//좌표값 가져옴

  @override
  _ReportPageState createState() => _ReportPageState();
}

enum emer{u,m,d}
late final XFile? image;
File? _image;

class _ReportPageState extends State<ReportPage> {
  emer? _emer = emer.u;
  final _valueList = ['교통사고', '화재', '기타'];
  var _selectedValue = '교통사고';
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.45662871370885, 126.95005995529378),
    zoom: 14.4746,
  );
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{}; //마커 테스트

  Completer<GoogleMapController> _controller = Completer();


  @override
  void initState() {
    super.initState();
    _image = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('제보하기')),
      body: ListView(
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(8),
            child:Text('긴급도'),
          ),
          ListTile(
            //ListTile - title에는 내용,
            //leading or trailing에 체크박스나 더보기와 같은 아이콘을 넣는다.
            title: const Text('상'),
            leading: Radio(
              value: emer.u,
              groupValue: _emer,
              onChanged: (emer? value) {
                setState(() {
                  _emer = value;
                });
              },
            ),
          ),
          ListTile(
            title: const Text('중'),
            leading: Radio<emer>(
              value: emer.m,
              groupValue: _emer,
              onChanged: (emer? value) {
                setState(() {
                  _emer = value;
                });
              },
            ),
          ),
          ListTile(
            title: const Text('하'),
            leading: Radio<emer>(
              value: emer.d,
              groupValue: _emer,
              onChanged: (emer? value) {
                setState(() {
                  _emer = value;
                });
              },
            ),
          ),
          Container(
            margin: EdgeInsets.all(8),
            child:Text('응급유형'),
          ),
          Container(
              margin: EdgeInsets.all(8),
              child:DropdownButton(
                value: _selectedValue,
                items: _valueList.map(
                      (value) {
                    return DropdownMenuItem (
                      value: value,
                      child: Text(value),
                    );
                  },
                ).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedValue = value.toString();
                  });
                },
              )
          ),
          TextFormField(
            // initialValue: '제보내용',
            maxLength: 20,
            decoration: InputDecoration(
              icon: Icon(Icons.text_format),
              labelText: '설명',
              helperText: '상황 설명',
              suffixIcon: Icon(
                Icons.check_circle,
              ),
            ),

          ),
          Container(
            margin: EdgeInsets.all(8),
            child:Text('사진첨부'),
          ),
          ListTile(
            title: Text('사진첨부'),
            leading:
            SizedBox(
              height: 100,
              width: 100,
              child: _image == null ? Text('사진없음') : Image.file(_image!)
            ),
            onTap: (){
              setState(() {
                _takePhoto(ImageSource.gallery);
              });
            },

          ),
          Container(
            margin: EdgeInsets.all(8),
            child:Text('위치'),
          ),
          ListTile(
            title: Text('좌표 : ' + ''),
            onTap: (){
              Navigator.push(
              //네비게이터
              context,
              MaterialPageRoute(
              //페이지 이동
              builder: (context) => ReportGooglemap()));
            },
          ),
          ElevatedButton(
            child: Text('제보하기'),
            onPressed: (){
            },
          )
        ]
      ),
    );
  }
  Future _takePhoto(ImageSource imageSource) async{
    var image = await ImagePicker().pickImage(source: imageSource);
    setState(() {
      _image = File(image!.path);
    });
  }
}


