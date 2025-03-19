import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:safezone/frontend/widgets/buttons/custom_button.dart';
import 'package:safezone/resources/schema/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
              const SizedBox(height: 50),
              const Text(
                "Thank you for sharing! Your report helps protect women and keep our community safe. We truly appreciate your effort in making the world a safer place for everyone.",
                textAlign: TextAlign.center,
                style: TextStyle(color: textColor, fontSize: 15),
              ),
              const Spacer(),
              CustomButton(
                widthSize: true,
                text: "Go to reports history",
                buttonColor: widgetPricolor,
                onPressed: () {
                  
                  context.go('/reports-history', extra: true);
                }
              ),
              const SizedBox(height: 10),
              CustomButton(
                widthSize: true,
                isOutlined: true,
                text: "Back to Home",
                textColor: widgetPricolor,
                onPressed: () async {
                  final prefs = await SharedPreferences.getInstance();
                  final userToken = prefs.getString('userToken'); 
                  if (userToken != null) {
                    context.go('/home', extra: userToken);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("User token not found! Please log in again."),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
