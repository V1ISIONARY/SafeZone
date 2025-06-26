import 'package:flutter/widgets.dart';

import '../../../../../backend/properties/import.dart';

class ContactDT extends StatelessWidget {
  const ContactDT({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "Contact",
              style: TextStyle(
                color: Colors.black,
                fontSize: 15,
              ),
            ),
            Spacer(),
            Icon(
              Icons.cancel_outlined,
              size: 20,
              color: Colors.black38,
            )
          ],
        )
      ],
    );
  }
}