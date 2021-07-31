import 'dart:io';

import 'package:camera_app/models/galleryModels/image_model.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class ImagesScreen extends StatefulWidget {
  final ImageModel imageModel;
  ImagesScreen({required this.imageModel, Key? key}) : super(key: key);

  @override
  _ImagesScreenState createState() => _ImagesScreenState();
}

class _ImagesScreenState extends State<ImagesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.imageModel.folderName!,
        ),
      ),
      body: widget.imageModel.files!.isEmpty
          ? Center(
              child: Container(
                child: Text('No Images Found in this Folder'),
              ),
            )
          : Container(
        color: Colors.black87,
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 3.0,
                  crossAxisSpacing: 3.0,
                ),
                itemCount: widget.imageModel.files!.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    child: Image.file(File(widget.imageModel.files![index]),
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                    // child: FadeInImage(
                    //   image: FileImage(
                    //     File(widget.imageModel.files![index]),
                    //   ),
                    //   placeholder: MemoryImage(kTransparentImage),
                    //   fit: BoxFit.cover,
                    //   width: double.infinity,
                    //   height: double.infinity,
                    // ),
                  );
                },
              ),
            ),
    );
  }
}
