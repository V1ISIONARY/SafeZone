import 'package:flutter/material.dart';
import 'package:safezone/resources/schema/colors.dart';

class Contactinfo extends StatelessWidget {
  final String name;
  final String phone;

  const Contactinfo({super.key, required this.name, required this.phone});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: textColor, fontSize: 15
                  ),
                ),
                const SizedBox(height: 5,),
                Text(
                  phone,
                  style: const TextStyle(
                    color: labelFormFieldColor, fontSize: 13
                  ),
                ),
              ],
            ),
          ),
          const Divider(
            height: 1,
            color: Colors.black12,
          ),
        ],
      ),
    );
  }
}
