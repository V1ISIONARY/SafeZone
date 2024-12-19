import 'package:flutter/material.dart';
import 'package:safezone/resources/schema/colors.dart';
import 'package:go_router/go_router.dart';

class SosCountdown extends StatefulWidget {
  const SosCountdown({super.key});

  @override
  State<SosCountdown> createState() => _SosCountdownState();
}

class _SosCountdownState extends State<SosCountdown> {
  int _countdown = 5;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    Future.delayed(const Duration(seconds: 1), () {
      if (_countdown > 1) {
        setState(() {
          _countdown--;
        });
        _startCountdown();
      } else {
        context.go('/sos-success');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: btnColor,
      appBar: AppBar(
        backgroundColor: btnColor,
        title: const Text("SOS Sent", style: TextStyle(color: bgColor),),
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
                    color: bgColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 60),
              Text(
                '$_countdown',
                style: const TextStyle(
                  fontSize: 64,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFEFEFEF), // Equivalent to #FEFEFE
                ),
              ),
              const SizedBox(height: 60),
              const Text(
                "Your SOS will be sent to your trusted circle. Check who’s in your circle",
                textAlign: TextAlign.center,
                style: TextStyle(color: bgColor, fontSize: 15),
              ),
              const SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }
}
