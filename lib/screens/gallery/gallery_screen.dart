import 'dart:io';
import 'package:camera_app/providers/galleryProvider/gallery_provider.dart';
import 'package:camera_app/screens/gallery/images_screen.dart';
import 'package:camera_app/utils/custom_functions.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:flutter/material.dart';

class GalleryScreen extends StatefulWidget {
  @override
  _GalleryScreenState createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen>
    with AutomaticKeepAliveClientMixin {
  bool _isLoading = true;
  @override
  void initState() {
    super.initState();
    Provider.of<GalleryProvider>(context, listen: false)
        .getImages()
        .then((value) {
      setState(() {
        _isLoading = false;
      });
    }).catchError((err) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gallery'),
        centerTitle: true,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Consumer<GalleryProvider>(
              builder: (context, galleryProvider, _) {
                return galleryProvider.images.isEmpty
                    ? Container()
                    : Container(
                        child: GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 1.0,
                          ),
                          itemCount: galleryProvider.images.length,
                          itemBuilder: (BuildContext context, int index) {
                            return InkWell(
                              onTap: () {
                                CustomFunctions.pushScreen(
                                    widget: ImagesScreen(
                                        imageModel:
                                            galleryProvider.images[index]),
                                    context: context);
                              },
                              child: Container(
                                child: Stack(
                                  alignment: Alignment.bottomCenter,
                                  children: <Widget>[
                                    FadeInImage(
                                      image: FileImage(
                                        File(galleryProvider
                                            .images[index].files![0]),
                                      ),
                                      placeholder:
                                          MemoryImage(kTransparentImage),
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      height: double.infinity,
                                    ),
                                    Container(
                                      color: Colors.black.withOpacity(0.7),
                                      height: 30,
                                      width: double.infinity,
                                      child: Center(
                                        child: Text(
                                          galleryProvider
                                              .images[index].folderName!,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontFamily: 'Regular'),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      );
              },
            ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
