import 'package:flutter/material.dart';
import 'package:safezone/resources/schema/colors.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.buttonColor = btnColor,
    this.textColor = Colors.white,
    this.isOutlined = false,
    this.width = 350,
    this.height = 50,
  });

  final String text;
  final VoidCallback onPressed;
  final Color buttonColor;
  final Color textColor;
  final bool isOutlined;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor:
              isOutlined ? buttonColor.withOpacity(0.05) : buttonColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
            side: BorderSide(
              color: isOutlined ? buttonColor : Colors.transparent,
            ),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          textAlign: TextAlign.center,
          text,
          style: TextStyle(
            color: isOutlined ? btnColor : textColor,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
