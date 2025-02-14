import 'package:flutter/material.dart';
import 'package:safezone/resources/schema/colors.dart';

class All extends StatefulWidget {
  final String userToken;
  const All({
    super.key,
    required this.userToken
  });

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
    return widget.userToken == 'guess' 
    ? Container()
    : Transform.translate(
      offset: Offset(0, -50),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 150,
            height: 150,
            child: Image.asset(
              'lib/resources/images/notif1.png',
              width: 150,
              height: 150,
            ) 
          ),
          const Text(
            'Empty Notification',
            style: TextStyle(
              color: Colors.black,
              fontSize: 15,
            ),
            textAlign: TextAlign.center,
          ),
          const Text(
            'this is no new notification, check back later.',
            style: TextStyle(
              color: Colors.black54,
              fontSize: 9,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
