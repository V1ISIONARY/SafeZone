import 'package:flutter/material.dart';
import 'package:safezone/resources/schema/colors.dart';

class All extends StatefulWidget {
  const All({super.key});

  @override
  State<All> createState() => _AllState();
}

class _AllState extends State<All> {
  bool hasContent = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: hasContent ? _buildContent() : _buildPlaceholder(),
      ),
    );
  }

  Widget _buildContent() {
    return const Text(
      "stuffff",
      style: TextStyle(
          fontSize: 15, fontWeight: FontWeight.bold, color: textColor),
    );
  }

  Widget _buildPlaceholder() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'lib/resources/images/notif1.png',
          width: 150,
          height: 150,
        ),
        const SizedBox(height: 20),
        const Text(
          "No notifications",
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      ],
    );
  }
}
