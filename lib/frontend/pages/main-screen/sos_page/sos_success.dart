import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:safezone/frontend/widgets/buttons/custom_button.dart';
import 'package:safezone/resources/schema/colors.dart';
import 'package:safezone/resources/schema/texts.dart';

class SosSuccess extends StatefulWidget {
  const SosSuccess({super.key});

  @override
  State<SosSuccess> createState() => _SosSuccessState();
}

class _SosSuccessState extends State<SosSuccess> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const CategoryText(text: "SOS Sent"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 200),
            Image.asset(
              "lib/resources/svg/sos-success.png",
              width: 150,
              height: 150,
            ),
            const SizedBox(height: 30),
            const Text(
              "SOS sent!!",
              textAlign: TextAlign.center,
              style: TextStyle(color: textColor, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20,),
            const Text(
              "Your circle and emergency contacts have been notified.",
              textAlign: TextAlign.center,
              style: TextStyle(color: textColor, fontSize: 15),
            ),
            const Spacer(),
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
    );
  }
}
