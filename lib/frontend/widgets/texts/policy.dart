import 'package:flutter/widgets.dart';

import '../../../resources/schema/colors.dart';
import '../../../resources/schema/texts.dart';

class PolicyText extends StatelessWidget {

  final String title;
  final String description; 
  const PolicyText({
    super.key,
    required this.title,
    required this.description
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 10,
            width: 2,
            color: widgetPricolor,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Transform.translate(
              offset: const Offset(0, -4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CategoryText(text: title),
                  CategoryDescripText(
                    text: description,
                  ),
                ],
              ),
            )
          ),
        ],
      ),
    );
  }
}