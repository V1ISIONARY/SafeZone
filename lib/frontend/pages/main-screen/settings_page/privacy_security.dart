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
        centerTitle: true,
        title: CategoryText(
          text: "Privacy Security"
        ),
      ),
    );
  }
}