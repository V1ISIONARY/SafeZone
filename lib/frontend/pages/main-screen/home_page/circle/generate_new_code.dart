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
        centerTitle: true,
        title: const CategoryText(text: "Generate New Code"),
      ),
      body: Container(),
    );
  }
}
