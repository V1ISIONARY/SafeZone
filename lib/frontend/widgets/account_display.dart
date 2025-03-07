import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../resources/schema/texts.dart';

class AccountDisplay extends StatelessWidget {
  
  final String title;
  final String svgIcon;
  final String data;

  const AccountDisplay({
    super.key,
    required this.title,
    required this.svgIcon,
    required this.data
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
      },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(
          vertical: 15
        ),
        child: Stack(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 25,
                  width: 25,
                  margin: const EdgeInsets.only(right: 17),
                  child: SvgPicture.asset(
                    svgIcon,
                    color: const Color.fromARGB(179, 0, 0, 0),
                  )
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DescriptionText(
                      text: title,
                    ),
                    PrimaryText(
                      text: data
                    ),
                  ],
                )
              ],
            ),
            // Positioned(
            //   right: -10,
            //   top: 5,
            //   bottom: 5,
            //   child: Container(
            //     height: 20,
            //     width: 20,
            //     margin: EdgeInsets.only(right: 17),
            //     child: SvgPicture.asset(
            //       'lib/resources/svg/proceed.svg',
            //       color: const Color.fromARGB(179, 0, 0, 0),
            //     )
            //   )
            // )
          ],
        )
      )
    );
  }

}