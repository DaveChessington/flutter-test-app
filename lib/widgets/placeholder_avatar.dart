import 'package:flutter/material.dart';

class PlaceHolderAvatar extends StatelessWidget {
  const PlaceHolderAvatar({
    super.key,
    this.width = 46,
    this.height = 46,
    this.fontColor = Colors.white,
    this.backGroundColor = const Color.fromARGB(255, 77, 195, 113),
    this.initials = "",
  });
  final double width;
  final double height;
  final Color fontColor;
  final Color backGroundColor;
  final String initials;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: backGroundColor,
        borderRadius: BorderRadius.circular(10),
      ),
      alignment: Alignment.center,
      child: Text(
        initials,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: fontColor,
        ),
      ),
    );
  }
}
