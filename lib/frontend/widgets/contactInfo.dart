import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
            padding: EdgeInsets.only(top: 10, bottom: 20),
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
                Text(
                  "Miro Asuncion",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 15
                  ),
                ),
                Text(
                  "(+63) 970 815 2371",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                    fontSize: 11
                  ),
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