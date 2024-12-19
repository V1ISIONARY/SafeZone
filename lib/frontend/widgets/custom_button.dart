import 'package:flutter/material.dart';
import 'package:safezone/resources/schema/colors.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.buttonColor = btnColor,
    this.textColor = Colors.white,
    this.isOutlined = false, // New parameter to switch button style
  });

  final String text;
  final VoidCallback onPressed;
  final Color buttonColor;
  final Color textColor;
  final bool isOutlined; // Boolean to switch button style

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 350,
      height: 50,
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: isOutlined
              ? buttonColor
                  .withOpacity(0.05) 
              : buttonColor, 
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
            side: BorderSide(
              color: isOutlined
                  ? buttonColor
                  : Colors.transparent,
            ),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(
            color: isOutlined? btnColor : textColor,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
