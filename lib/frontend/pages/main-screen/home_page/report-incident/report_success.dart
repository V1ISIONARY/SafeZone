import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:safezone/frontend/widgets/buttons/custom_button.dart';
import 'package:safezone/resources/schema/colors.dart';

class ReportSuccess extends StatefulWidget {
  const ReportSuccess({super.key});

  @override
  State<ReportSuccess> createState() => _ReportSuccessState();
}

class _ReportSuccessState extends State<ReportSuccess> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(""),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 200),
              Image.asset(
                "lib/resources/svg/success.png",
                width: 150,
                height: 150,
              ),
              const SizedBox(height: 30),
              const Text(
                "Thank you for sharing! Your report helps protect women and keep our community safe. We truly appreciate your effort in making the world a safer place for everyone.",
                textAlign: TextAlign.center,
                style: TextStyle(color: textColor, fontSize: 15),
              ),
              const Spacer(),
              CustomButton(
                  text: "Go to reports history",
                  onPressed: () {
                    context.push('/reports-history');
                  }),
              const SizedBox(height: 10),
              CustomButton(
                  text: "Back to Home",
                  isOutlined: true,
                  onPressed: () {
                    context.push('/');
                  }),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
