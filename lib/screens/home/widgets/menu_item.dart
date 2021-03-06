import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:pie/utils/app_color.dart';
import 'package:pie/widgets/outline_box.dart';

class MenuItem extends StatelessWidget {
  final double top;
  final double left;
  final double bottom;
  final double right;
  final double height;
  final String title;
  final String lottie;
  final VoidCallback onPress;
  final Gradient gradient;

  MenuItem(
      {this.top,
      this.left,
      this.bottom,
      this.right,
      this.height,
      this.title,
      this.lottie,
      this.onPress,
      this.gradient});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        height: height,
        margin: EdgeInsets.only(
          left: left,
          right: right,
          top: top,
          bottom: bottom,
        ),
        child: OutlineBox(
          strokeWidth: 4,
          radius: 16,
          gradient: gradient,
          onPressed: onPress,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColor.primary,
                ),
              ),
              LottieBuilder.network(
                lottie,
                width: 50,
                height: 50,
                fit: BoxFit.fill,
              ),
            ],
          ),
        ),
      );
  }
}
