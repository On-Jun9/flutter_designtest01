import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ShowDialog extends StatelessWidget {
  const ShowDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: new Text("제보 화면 보기"),
      content: Container(
        // color: Colors.blue,
          child: Column(
            children: [
              // new Text(locationName),
              // new Text(infoTime),
              // new Text(locaLat2),
              // new Text(markerValue1),
              // new Image.network(imageUrl),
            ],
          )),
      actions: <Widget>[
        new TextButton(
          child: new Text('확인'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
