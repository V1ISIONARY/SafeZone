import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:safezone/resources/schema/colors.dart';

class Read extends StatefulWidget {
  const Read({super.key});

  @override
  State<Read> createState() => _ReadState();
}

class _ReadState extends State<Read> {
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
