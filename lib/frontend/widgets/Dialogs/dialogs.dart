import 'package:flutter/material.dart';
import 'package:safezone/frontend/widgets/buttons/custom_button.dart';
import 'package:safezone/resources/schema/colors.dart';
import 'package:go_router/go_router.dart';

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
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 25),
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
              const Text(
                "Report an Incident",
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: textColor),
              ),
              const SizedBox(height: 10),
              const Text(
                "Report any incidents or unsafe situations to help keep you and others safe",
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w100,
                    color: textColor),
                textAlign: TextAlign.center,
              ),
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
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
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
              const Text(
                "Mark this place safe",
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: textColor),
              ),
              const SizedBox(height: 10),
              const Text(
                "Are you sure this location is safe? Marking it as safe will help others.",
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w100,
                    color: textColor),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              CustomButton(
                text: "Confirm Safe Zone",
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

