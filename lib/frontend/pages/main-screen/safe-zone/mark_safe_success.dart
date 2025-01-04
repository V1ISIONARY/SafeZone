import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:safezone/frontend/widgets/buttons/custom_button.dart';
import 'package:safezone/resources/schema/colors.dart';
import 'package:safezone/resources/schema/texts.dart';

class MarkSafeSuccess extends StatefulWidget {
  const MarkSafeSuccess({super.key});

  @override
  State<MarkSafeSuccess> createState() => _MarkSafeSuccessState();
}

class _MarkSafeSuccessState extends State<MarkSafeSuccess> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const CategoryText(text: ""),
      ),
      body: Center(
        child: Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: 20.0), 
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
                "Thank you for helping keep the community safe! Your safe zone submission is under review and will be verified shortly.",
                textAlign: TextAlign.center,
                style: TextStyle(color: textColor, fontSize: 15),
              ),
              const Spacer(),
              CustomButton(
                text: "Back to Home",
                isOutlined: true,
                onPressed: () {
                  context.push('/');
                },
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
