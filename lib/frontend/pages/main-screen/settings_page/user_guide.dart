import 'package:flutter/material.dart';

import '../../../../resources/schema/texts.dart';

class UserGuide extends StatelessWidget {
  const UserGuide({
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: CategoryText(
          text: "User Guide"
        ),
      ),
    );
  }
}