import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_designtest01/design/ReportGooglemap.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';

LatLng? tapLatLng;

class ReportPage extends StatefulWidget {
  const ReportPage({Key? key, this.tapLatLng}) : super(key: key);

  final tapLatLng; //좌표값 가져옴

  @override
  _ReportPageState createState() => _ReportPageState();
}

enum emer { u, m, d }

late final XFile? image;
File? _image;

class _ReportPageState extends State<ReportPage> {
  emer? _emer = emer.u;
  final _valueList = ['교통사고', '화재', '기타'];
  var _selectedValue = '교통사고';
  String _comment = '';

  LatLng currentPosition = LatLng(0, 0);
  GeoPoint currentGeo = GeoPoint(0, 0);
  var location = new Location();
  String _choise = '';

  @override
  void initState() {
    super.initState();
    _image = null;
    currentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('제보하기')),
      body: ListView(children: <Widget>[
        Container(
          margin: EdgeInsets.all(8),
          child: Text('긴급도'),
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
          child: Text('응급유형'),
        ),
        Container(
            margin: EdgeInsets.all(8),
            child: DropdownButton(
              value: _selectedValue,
              items: _valueList.map(
                (value) {
                  return DropdownMenuItem(
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
            )),
        TextFormField(
          // initialValue: '제보내용',
          maxLength: 20,
          onChanged: (text) {
            _comment = text;
          },
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
          child: Text('사진첨부'),
        ),
        ListTile(
          title: Text('사진첨부'),
          leading: SizedBox(
              height: 100,
              width: 100,
              child: _image == null ? Text('사진없음') : Image.file(_image!)),
          onTap: () {
            setState(() {
              _takePhoto(ImageSource.gallery);
            });
          },
        ),
        Container(
          margin: EdgeInsets.all(8),
          child: Text('위치'),
        ),
        ListTile(
          title: Text('좌표 \n' + _choise),
          onTap: () async {
            final result = await Navigator.push(
                //네비게이터
                context,
                MaterialPageRoute(
                    //페이지 이동
                    builder: (context) => ReportGooglemap()));
            print(result);
            setState(() {
              result == null
                  ? print(result)
                  : _choise = result.latitude.toString() +
                      ' , ' +
                      result.longitude.toString();
              result == null
                  ? print(result)
                  : currentGeo = GeoPoint(result.latitude!.toDouble(),
                      result.longitude!.toDouble());
              ;
            });
          },
        ),
        ElevatedButton(
          child: Text('제보하기'),
          onPressed: () {
            // _uploadImage();
            _testadd();
            Navigator.pop(context);
          },
        )
      ]),
    );
  }

  Future _takePhoto(ImageSource imageSource) async {
    var image = await ImagePicker().pickImage(source: imageSource);
    setState(() {
      image == null ? _image = null : _image = File(image.path);
    });
  }

  Future<void> currentLocation() async {
    LocationData _locationData;
    _locationData = await location.getLocation();
    setState(() {
      currentPosition = LatLng(_locationData.latitude!.toDouble(),
          _locationData.longitude!.toDouble());
      print(currentPosition.toString());
      _choise = currentPosition.latitude.toString() +
          ' , ' +
          currentPosition.longitude.toString() +
          '(현재위치)';
      currentGeo =
          GeoPoint(currentPosition.latitude, currentPosition.longitude);
    });
  }

  Future<void> _testadd() async {
    //데이터 삽입 테스트
    FirebaseFirestore.instance.collection('제보').add({
      '긴급도': _emer.toString(),
      '설명': _comment,
      '유형': _selectedValue,
      '좌표': currentGeo,
      '제보시간': FieldValue.serverTimestamp()
    }).then((value) => {
      if (_image == null) {
        print('no Image')
      }else{
        FirebaseStorage.instance.ref().child('images/${value.id}').putFile(_image!),
  }
    })
    ;
  }

  void _uploadImage() async {
    if (_image == null) return;
    FirebaseStorage.instance.ref().child('images/12345').putFile(_image!);
    FirebaseStorage.instance.ref().child('images/12345').getDownloadURL();
  }
}
