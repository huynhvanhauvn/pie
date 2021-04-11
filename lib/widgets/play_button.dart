import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pie/utils/app_type.dart';

class PlayButton extends StatefulWidget {
  final VoidCallback onPress;
  final bool isPlaying;

  PlayButton({this.onPress, this.isPlaying});

  @override
  State<StatefulWidget> createState() => PlayButtonState();
}

class PlayButtonState extends State<PlayButton>
    with SingleTickerProviderStateMixin {
  AnimationController controller;

  @override
  void initState() {
    controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant PlayButton oldWidget) {
    if(widget.isPlaying != oldWidget.isPlaying) {
      widget.isPlaying ? controller.forward() : controller.reverse();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onPress();
      },
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(32),
        ),
        child: AnimatedIcon(
          size: 32,
          color: Colors.white,
          icon: AnimatedIcons.play_pause,
          progress: controller,
        ),
      ),
    );
  }
}
