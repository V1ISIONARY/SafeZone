import 'package:flutter/material.dart';

import '../../../../../resources/schema/texts.dart';

class CommunityStandards extends StatefulWidget {
  const CommunityStandards({super.key});

  @override
  State<CommunityStandards> createState() => _CommunityStandardsState();
}

class _CommunityStandardsState extends State<CommunityStandards> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: CategoryText(
          text: "Community Standards"
        ),
      ),
    );
  }
}