import 'dart:convert';

import 'package:camera_app/models/galleryModels/image_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:storage_path/storage_path.dart';

class GalleryProvider extends ChangeNotifier {
  List<ImageModel> images = [];
   bool _loading=true;

  bool get loading => _loading;

  set loading(bool loading) {
    _loading = loading;
    notifyListeners();
  }

  Future<void> getImages() async {
    String imagesPath = "";
    try {
      imagesPath = await StoragePath.imagesPath;
      List<dynamic> response = jsonDecode(imagesPath);
      images = response.map((e) => ImageModel.fromJson(e)).toList();
      loading=false;
      print(response);
    } on PlatformException {
      imagesPath = 'Failed to get path';
      loading=false;
    } catch (error){
      imagesPath = 'Failed to get path $error';
      loading=false;
    }
  }
}
