import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File pickedImage;

  bool isImageLoaded = false;

  Future pickImage() async {
    var tempStore = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      pickedImage = tempStore;
      isImageLoaded = true;
    });
  }

  Future decode() async {
    FirebaseVisionImage ourImage = FirebaseVisionImage.fromFile(pickedImage);
    BarcodeDetector barcodeDetector = FirebaseVision.instance.barcodeDetector();
    List barCodes = await barcodeDetector.detectInImage(ourImage);

    for (Barcode readableCode in barCodes) {
      print(readableCode.displayValue + "hema");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: <Widget>[
        SizedBox(height: 100.0),
        isImageLoaded
            ? Center(
                child: Container(
                    height: 200.0,
                    width: 200.0,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: FileImage(pickedImage), fit: BoxFit.cover))),
              )
            : Container(),
        SizedBox(height: 10.0),
        RaisedButton(
          child: Text('Pick an image'),
          onPressed: pickImage,
        ),
        SizedBox(height: 10.0),
        RaisedButton(
          child: Text('Read Bar Code'),
          onPressed: decode,
        )
      ],
    ));
  }
}
