import 'package:flutter/material.dart';

class MenuItem extends StatelessWidget {
  final double top;
  final double left;
  final double bottom;
  final double right;
  final double height;
  final String title;
  final VoidCallback onPress;

  MenuItem({this.top, this.left, this.bottom, this.right, this.height, this.title, this.onPress});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onPress(),
      child: Container(
        width: double.infinity,
        height: height,
        margin: EdgeInsets.only(
          left: left,
          right: right,
          top: top,
          bottom: bottom,
        ),
        decoration: BoxDecoration(
          color: Colors.amber,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}