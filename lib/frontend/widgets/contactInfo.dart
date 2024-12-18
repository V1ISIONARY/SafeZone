import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../resources/schema/texts.dart';

class Contactinfo extends StatelessWidget {
  const Contactinfo({
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "A",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.black54,
              fontSize: 13
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10, bottom: 15),
            child: Divider(
              height: 1,
              color: Colors.black12,
            )
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PrimaryText(
                  text: "Miro Asuncion"
                ),
                DescriptionText(
                  text: "(+63) 970 815 2371"
                )
              ],
            ),
          ),
          Divider(
              height: 1,
              color: Colors.black12,
            )
        ],
      ),
    );
  }
}