import 'package:flutter/material.dart';
import 'package:safezone/resource/schema/colors.dart';

class LoginErrorDialog extends StatelessWidget {
  final String message;

  const LoginErrorDialog({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    String displayMessage = message.toString();
    if (displayMessage.toLowerCase().contains('invalid credentials')) {
      displayMessage = 'Invalid username or password';
    }
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 0,
      child: Container(
        padding: const EdgeInsets.only(
          top: 24
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Wrong Credentials",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              displayMessage,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 11,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 24),
            Divider(
              color: Colors.grey,
              height: 0.5,
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 20),
                ),
                child: const Text(
                  "OK",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: widgetPricolor,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}