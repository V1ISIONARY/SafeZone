import 'package:flutter/material.dart';
import 'package:safezone/frontend/widgets/buttons/custom_button.dart';
import 'package:safezone/resources/schema/colors.dart';
import 'package:go_router/go_router.dart';

import '../../../resources/schema/texts.dart';

void showCreateReportDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: bgColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                "lib/resources/svg/exclamation-mark.png",
                width: 74,
                height: 74,
              ),
              const SizedBox(height: 10),
              CategoryText(text: "Report an Incident"),
              const SizedBox(height: 5),
              CategoryDescripText(text: "Report any incidents or unsafe situations to help keep you\nand others safe", alignment: 'center'),
              const SizedBox(height: 20),
              CustomButton(
                text: "Create Report",
                onPressed: () {
                  context.push('/create-report');
                },
                width: 150,
                height: 40,
                isOutlined: true,
              ),
            ],
          ),
        ),
      );
    },
  );
}

void showMarkSafeDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: bgColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                "lib/resources/svg/shield.png",
                width: 74,
                height: 74,
              ),
              const SizedBox(height: 10),
              CategoryText(text: "Mark this place safe"),
              const SizedBox(height: 5),
              CategoryDescripText(text: "Are you sure this location is safe? Marking it as safe will help\nothers.", alignment: "center",),
              const SizedBox(height: 20),
              CustomButton(
                text: "Create safe zone",
                onPressed: () {
                  context.push('/mark-safe-zone');
                },
                width: 150,
                height: 40,
                isOutlined: true,
              ),
            ],
          ),
        ),
      );
    },
  );
}
