import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ImageBuffer extends StatelessWidget {
  final String photoURL;
  final double width;
  final double height;
  final BoxFit fit;
  const ImageBuffer(
      {required this.photoURL,
      required this.width,
      required this.height,
      required this.fit,
      super.key});

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: photoURL,
      fit: fit,
      height: height,
      width: width,
      // progressIndicatorBuilder: (context, url, downloadProgress) => SizedBox(
      //   height: height - 10,
      //   width: width - 10,
      //   child: Center(
      //     child: Column(
      //       mainAxisAlignment: MainAxisAlignment.center,
      //       children: [
      //         CircularProgressIndicator(
      //           color: Colors.black,
      //           value: downloadProgress.progress,
      //         ),
      //       ],
      //     ),
      //   ),
      // ),
      errorWidget: (context, url, error) =>
          Icon(Icons.error, size: width / 2, color: Colors.black),
    );
  }
}
