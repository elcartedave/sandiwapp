import 'package:flutter/material.dart';

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
    return Image.network(photoURL, fit: fit, height: height, width: width,
        loadingBuilder: (BuildContext context, Widget child,
            ImageChunkEvent? loadingProgress) {
      if (loadingProgress == null) {
        return child; // Image is fully loaded
      } else {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: SizedBox(
            height: height,
            width: width,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: Colors.black,
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            (loadingProgress.expectedTotalBytes ?? 1)
                        : null,
                  ),
                  const SizedBox(height: 10),
                  if (loadingProgress.expectedTotalBytes != null)
                    Text(
                      '${((loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)) * 100).toStringAsFixed(0)}%',
                      style: const TextStyle(color: Colors.black),
                    ),
                ],
              ),
            ),
          ),
        );
      }
    });
  }
}
