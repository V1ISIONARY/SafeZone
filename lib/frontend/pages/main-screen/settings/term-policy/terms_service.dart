import 'package:flutter/material.dart';

import '../../../../../resources/schema/texts.dart';

class TermsService extends StatefulWidget {
  const TermsService({super.key});

  @override
  State<TermsService> createState() => _TermsServiceState();
}

class _TermsServiceState extends State<TermsService> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: CategoryText(
          text: "Terms & Service"
        ),
      ),
    );
  }
}