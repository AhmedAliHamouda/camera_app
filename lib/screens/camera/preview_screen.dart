import 'dart:io';
import 'dart:typed_data';

import 'package:camera_app/utils/custom_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PreviewScreen extends StatefulWidget{
  final String imgPath;

  PreviewScreen({required this.imgPath});

  @override
  _PreviewScreenState createState() => _PreviewScreenState();

}
class _PreviewScreenState extends State<PreviewScreen>{


  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      CustomFunctions.popScreen(context);});
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   automaticallyImplyLeading: true,
      // ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Image.file(File(widget.imgPath),fit: BoxFit.cover,),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: double.infinity,
                height: 60.0,
                color: Colors.black,
                child: Center(
                  child:Text('Picture Saved Successfully',style: TextStyle(color: Colors.white,fontSize: 16.0),)
                ),
              ),
            )
          ],
        ),
      ),
    );
  }


}