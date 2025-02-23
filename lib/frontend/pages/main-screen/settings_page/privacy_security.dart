import 'package:flutter/material.dart';

import '../../../../resources/schema/texts.dart';

class PrivacySecurity extends StatefulWidget {
  const PrivacySecurity({
    super.key
  });

  @override
  State<PrivacySecurity> createState() => _PrivacySecurityState();
}

class _PrivacySecurityState extends State<PrivacySecurity> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: const CategoryText(text: "Privacy Security"),
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
    );
  }
}