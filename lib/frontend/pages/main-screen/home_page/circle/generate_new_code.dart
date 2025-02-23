import 'package:flutter/material.dart';
import 'package:safezone/resources/schema/texts.dart';

class GenerateNewCode extends StatefulWidget {
  const GenerateNewCode({super.key});

  @override
  State<GenerateNewCode> createState() => _GenerateNewCodeState();
}

class _GenerateNewCodeState extends State<GenerateNewCode> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const CategoryText(text: "Generate New Code"),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            margin: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              border: Border.all(width: 1, color: Colors.black),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.arrow_back, color: Colors.black, size: 10),
          ),
        ),
      ),
      body: Container(),
    );
  }
}
