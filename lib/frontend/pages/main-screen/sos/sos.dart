import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:safezone/frontend/widgets/buttons/sos_button.dart';
import 'package:safezone/resources/schema/colors.dart';
import 'package:safezone/resources/schema/texts.dart';

class SosPage extends StatefulWidget {
  const SosPage({super.key});
  @override
  State<SosPage> createState() => _SosPageState();
}

class _SosPageState extends State<SosPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const CategoryText(text: "SOS"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Tap or hold to send SOS",
                style: TextStyle(
                    color: textColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 60),
              GestureDetector(
                onTap: () {
                  context.push('/sos-countdown');
                },
                child: const SizedBox(
                  width: 200,
                  height: 200,
                  child: SosButton(), // TODO: fix render issue
                ),
              ),
              const SizedBox(height: 60),
              const Text(
                "Your SOS will be sent to your trusted circle. Check who’s in your circle",
                textAlign: TextAlign.center,
                style: TextStyle(color: textColor, fontSize: 15),
              ),
              const SizedBox(
                height: 60,
              )
            ],
          ),
        ),
      ),
    );
  }
}
