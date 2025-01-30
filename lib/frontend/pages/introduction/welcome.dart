import 'package:flutter/material.dart';
import 'package:safezone/frontend/widgets/fade.dart';

class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.black,
            // child: Image.asset(
            //   'lib/resources/images/location.png',
            //   fit: BoxFit.cover,
            // ),
          ),
          Positioned(
            bottom: 40,
            right: 0,
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}