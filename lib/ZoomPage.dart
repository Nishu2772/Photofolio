import 'package:Photofolio/model/ImageItem.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class PhotoZoomPage extends StatefulWidget {
  List<ImageItem> galleryItems;
  PhotoZoomPage({super.key, required this.galleryItems});

  @override
  State<PhotoZoomPage> createState() => _PhotoZoomPageState();
}

class _PhotoZoomPageState extends State<PhotoZoomPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: PhotoViewGallery.builder(
        scrollPhysics: const BouncingScrollPhysics(),
        builder: (BuildContext context, int index) {
          return PhotoViewGalleryPageOptions(
            imageProvider: NetworkImage(widget.galleryItems[index].downloadUrl),
            initialScale: PhotoViewComputedScale.contained * 0.8,
            // heroAttributes: PhotoViewHeroAttributes(
            //   tag: galleryItems[index].id,
            // ),
          );
        },
        itemCount: widget.galleryItems.length,
        loadingBuilder:
            (context, event) => Center(
              child: Container(
                width: 20.0,
                height: 20.0,
                child: CircularProgressIndicator(),
              ),
            ),
      ),
    );
  }
}
