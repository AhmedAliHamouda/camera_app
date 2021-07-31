

import 'package:camera/camera.dart';
import 'package:camera_app/screens/camera/preview_screen.dart';
import 'package:camera_app/screens/gallery/gallery_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:gallery_saver/gallery_saver.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({Key? key}) : super(key: key);

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen>
    with WidgetsBindingObserver {
  CameraController? controller;
  List? cameras;
  late int selectedCameraIndex;
  late String imgPath;
  bool _cameraOn = true;

  Future<void> _initCameraController(CameraDescription cameraDescription) async {
    if (controller != null) {
      //await controller?.dispose();
    }
    controller = CameraController(cameraDescription, ResolutionPreset.high);

    controller!.addListener(() {
      if (mounted) {
        print('this mounted2 ');
        //setState(() {});
      }

      if (controller!.value.hasError) {
        print('Camera error ${controller!.value.errorDescription}');
      }
    });

    try {
      await controller!.initialize();
    } on CameraException catch (e) {
      _showCameraException(e);
    }
    if (mounted) {
       setState(() {});
    }
  }

  void _showCameraException(CameraException e) {
    String errorText = 'Error:${e.code}\nError message : ${e.description}';
    print(errorText);
  }

  void _onCapturePressed(context) async {
    try {
      final pathPic = await controller!.takePicture();
      print(pathPic.path);

      await GallerySaver.saveImage(pathPic.path, albumName: 'DCIM/Camera')
          .then((value) async {
        if (value!) {
          _cameraOn = false;
          print('our camera is $_cameraOn');
          await controller!.dispose();
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => PreviewScreen(
                  imgPath: pathPic.path,
                ),
              )).then((res) async {
            if (controller != null || controller!.value.isInitialized) {
              _initCameraController(cameras![selectedCameraIndex]);
            }
            _cameraOn = true;
            print(_cameraOn);
          }).catchError((err) {
            _cameraOn = true;
            print(err);
          });
        }
      });
    } on CameraException catch (e) {
      _showCameraException(e);
    }
  }

  void _onSwitchCamera() {
    selectedCameraIndex =
        selectedCameraIndex < cameras!.length - 1 ? selectedCameraIndex + 1 : 0;
    CameraDescription selectedCamera = cameras![selectedCameraIndex];
    _initCameraController(selectedCamera);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    availableCameras().then((availableCameras) async {
      cameras = availableCameras;

      if (cameras!.length > 0) {
        setState(() {
          selectedCameraIndex = 0;
        });
        await _initCameraController(cameras![selectedCameraIndex])
            .then((void v) {});
      } else {
        print('No camera available');
      }
    }).catchError((err) {
      print('Error :${err.code}Error message : ${err.message}');
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    if (controller == null || !controller!.value.isInitialized) {
      return;
    }
    switch (state) {
      case AppLifecycleState.inactive:
        print('appLifeCycleState inactive');
        await controller?.dispose();

        break;
      case AppLifecycleState.resumed:
        print('appLifeCycleState resumed');
        if (controller != null || controller!.value.isInitialized) {
          _initCameraController(cameras![selectedCameraIndex])
              .then((void v) {});
          if (mounted) {
            setState(() {});
          }
        }
        break;
      case AppLifecycleState.paused:
        print('appLifeCycleState paused');
        await controller!.dispose();
        break;
      case AppLifecycleState.detached:
        print('appLifeCycleState suspending');
        await controller!.dispose();
        break;
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: SafeArea(
          child: controller == null || !controller!.value.isInitialized
              ? Container(
                  color: Colors.black87,
                  child: Center(
                    child: Icon(
                      CupertinoIcons.camera,
                      color: Colors.white,
                      size: 60,
                    ),
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: AspectRatio(
                        aspectRatio: controller!.value.aspectRatio,
                        child: _cameraOn
                            ? CameraPreview(controller!)
                            : Container(),
                      ),
                      // Container(
                      //   child: Expanded(child: CameraPreview(controller!)),
                      // ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: 120,
                        width: double.infinity,
                        padding: EdgeInsets.all(15),
                        color: Colors.black87,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            _cameraToggleRowWidget(),
                            _cameraControlWidget(context),
                            _showGallery(context),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
        ),
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      // floatingActionButton: _cameraControlWidget(context),
    );
  }


  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    controller!.dispose();
    super.dispose();
  }


  Widget _showGallery(context){

   return IconButton(
     icon: Icon(Icons.image_outlined,
         color: Colors.white, size: 40),
     onPressed: () async{
      // _cameraOn = false;
       await controller!.dispose();
       Navigator.push(
           context,
           MaterialPageRoute(
             builder: (BuildContext context) => GalleryScreen(),
           )).then((res) async {
         if (controller != null || controller!.value.isInitialized) {
           _initCameraController(cameras![selectedCameraIndex]);
         }

         setState(() {
           _cameraOn = true;
         });



         print(_cameraOn);
       }).catchError((err) {

           _cameraOn = true;
         print(err);
       });
       // CustomFunctions.pushScreen(
       //     widget: GalleryScreen(), context: context);
     },
   );
  }

  Widget _cameraControlWidget(context) {
    return Align(
      alignment: Alignment.center,
      child: FloatingActionButton(
        child: Icon(
          Icons.camera,
          color: Colors.black,
        ),
        backgroundColor: Colors.white,
        onPressed: () {
          _onCapturePressed(context);
        },
      ),
    );
  }

  Widget _cameraToggleRowWidget() {
    if (cameras == null || cameras!.isEmpty) {
      return Container();
    }
    CameraDescription selectedCamera = cameras![selectedCameraIndex];
    CameraLensDirection lensDirection = selectedCamera.lensDirection;
    //print('on camera length ${cameras!.length.toString()}');

    return Align(
      alignment: Alignment.centerLeft,
      child: IconButton(
        onPressed: _onSwitchCamera,
        icon: Icon(
          _getCameraLensIcon(lensDirection),
          color: Colors.white,
          size: 30,
        ),
      ),
    );
  }

  IconData _getCameraLensIcon(CameraLensDirection direction) {
    switch (direction) {
      case CameraLensDirection.back:
        return CupertinoIcons.switch_camera;
      case CameraLensDirection.front:
        return CupertinoIcons.switch_camera_solid;
      case CameraLensDirection.external:
        return Icons.camera;
      default:
        return Icons.device_unknown;
    }
  }
}
