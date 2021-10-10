import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ShowDialog extends StatefulWidget {
  const ShowDialog({Key? key, required this.markerValue1}) : super(key: key);

  final String markerValue1;

  @override
  _ShowDialogState createState() => _ShowDialogState();
}

class _ShowDialogState extends State<ShowDialog> {

  String imageUrl = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    printUrl();
  }
  @override
  Widget build(BuildContext context) {
    var getData = FirebaseFirestore.instance
        .collection('제보')
        .doc(widget.markerValue1)
        .get();
    return FutureBuilder<DocumentSnapshot>(
      future: getData,
      builder: (context, snapshot) {
        var _emer = '';
        if (snapshot.hasData) {
          if (snapshot.data!['긴급도'] == 'emer.u') {
            _emer = '상';
          } else if (snapshot.data!['긴급도'] == 'emer.m') {
            _emer = '중';
          } else {
            _emer = '하';
          }
          var _time = snapshot.data!['제보시간'].toDate().add(Duration(hours: 9));
          Timestamp(1633859188, 529000000).seconds;
          return AlertDialog(
            title: Text('제보 화면 보기'),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  // Text(widget.markerValue1),
                  // Text(snapshot.data!['제보시간'].toString()),
                  Text('긴급도', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(_emer),
                  Text('설명', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(snapshot.data!['설명']),
                  Text('유형', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(snapshot.data!['유형']),
                  Text('제보시간', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(DateFormat.yMd('ko_KR').add_jms().format(_time).toString()),
                  imageUrl==''? Container(child: CircularProgressIndicator()) : Container(child: Image.network(imageUrl)),
                ],
              ),
            ),
          );
        } else {
          return AlertDialog(
            title: Text('제보 화면 보기'),
            content: Container(child: CircularProgressIndicator()),
          );

        }
      },
    );
  }
  printUrl() async {
    String url = (await FirebaseStorage.instance.ref().child('images/${widget.markerValue1}').getDownloadURL()).toString();
    // print(url);
    setState(() {
      imageUrl = url;
    });
  }
}
// setState(() {
//     getValue();
//   });
//   return AlertDialog(
//     title: Text('제보 화면 보기'),
//     content: SingleChildScrollView(
//       child: ListBody(
//         children: [
//           Text(widget.markerValue1),
//           Text('설명', style: TextStyle(fontWeight: FontWeight.bold)),
//           Text(_comment),
//           Text('유형', style: TextStyle(fontWeight: FontWeight.bold)),
//           Text(_type),
//           Text('제보시간', style: TextStyle(fontWeight: FontWeight.bold)),
//           Text(_time)
//         ],
//       ),
//     ),
//   );
// }
//
// Future<void> getValue() async {
//   await FirebaseFirestore.instance
//       .collection('제보')
//       .doc(widget.markerValue1)
//       .get()
//       .then((value) {
//     setState(() {
//       if (value['긴급도'] == 'emer.u') {
//         _emer = '상';
//       } else if (value['긴급도'] == 'emer.m') {
//         _emer = '중';
//       } else {
//         _emer = '하';
//       }
//       _comment = value['설명'];
//       _type = value['유형'];
//       // var date = DateTime.fromMillisecondsSinceEpoch();
//
//       _time = DateFormat('y-MM-d H시m분s초')
//           .format(value['제보시간'].toDate()+1000)
//           .toString();
//     });
//   });
// }

//   getValue();
//   return AlertDialog(
//     title: new Text("제보 화면 보기"),
//     content:SingleChildScrollView(
//       child: ListBody(
//         children: [
//           Text('설명',style: TextStyle(fontWeight: FontWeight.bold)),
//           Text(_comment),
//           Text('유형',style: TextStyle(fontWeight: FontWeight.bold)),
//           Text(_type),
//           Text('제보시간',style: TextStyle(fontWeight: FontWeight.bold)),
//           Text(_time)
//         ],
//       ),
//     ),
//     actions: <Widget>[
//       new TextButton(
//         child: new Text('확인'),
//         onPressed: () {
//           Navigator.pop(context);
//         },
//       ),
//     ],
//   );
// }
// Future<void> getValue() async {
//   FirebaseFirestore.instance.collection('제보').doc(markerValue1).get().then((value) {
//     if(value['긴급도'] == 'emer.u'){
//       _emer = '상';
//     }else if(value['긴급도'] == 'emer.m'){
//       _emer = '중';
//     }else{
//       _emer = '하';
//     }
//     _comment = value['설명'];
//     _type = value['유형'];
//     // var date = DateTime.fromMillisecondsSinceEpoch();
//
//     _time = DateFormat('y-MM-d h시m분s초').format(value['제보시간'].toDate()).toString();
//
//
//   });
// }
// }
