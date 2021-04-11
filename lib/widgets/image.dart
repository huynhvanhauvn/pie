import 'package:flutter/material.dart';

class MyImage extends StatelessWidget {
  final String url;
  final double width;
  final double height;
  final BoxFit fit;
  final double radius;

  MyImage({this.url, this.width, this.height, this.fit, this.radius});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius ?? 0),
      child: Image.network(
        'https://englishcommunication.000webhostapp.com/files/images/${url}',
        width: width,
        height: height,
        fit: fit,
      ),
    );
  }
}
