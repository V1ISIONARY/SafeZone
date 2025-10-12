import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:safezone/frontend/root/authentication/login.dart';

import '../../../../../backend/properties/import.dart';

class Settingsbtn extends StatelessWidget {
  final String title;
  final String svgIcon;
  final String navigateTo;
  final String? description;
  final VoidCallback onTap;
  final bool? replace;

  const Settingsbtn({
    super.key,
    required this.title,
    required this.svgIcon,
    required this.navigateTo,
    this.description,
    required this.onTap,
    this.replace,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap();
        if(navigateTo.toLowerCase() == 'login') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const LoginRT(),
            ),
          );
        }
        if (replace != null && replace == true) {
          context.go('/$navigateTo');
        } else {
          context.push('/$navigateTo');
        }
      },
      child: Container(
        width: double.infinity,
        color: Colors.white,
        margin: const EdgeInsets.symmetric(vertical: 15),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: 25,
                  width: 25,
                  margin: const EdgeInsets.only(right: 17),
                  child: SvgPicture.asset(
                    svgIcon,
                    color: const Color.fromARGB(179, 0, 0, 0),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PrimaryText(text: title),
                    if (description != null) DescriptionText(text: description!)
                  ],
                ),
              ],
            ),
            const Spacer(),
            Container(
                height: 15,
                width: 15,
                margin: const EdgeInsets.only(right: 17),
                child: Icon(
                  Icons.chevron_right_outlined,
                  color: Colors.grey[500],
                )),
          ],
        ),
      ),
    );
  }
}
