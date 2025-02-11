import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Unread extends StatefulWidget {
  const Unread({super.key});

  @override
  State<Unread> createState() => _UnreadState();
}

class _UnreadState extends State<Unread> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
    );
  }
}