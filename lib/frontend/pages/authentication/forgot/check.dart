import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:safezone/resources/schema/colors.dart';

class Check extends StatefulWidget {
  const Check({super.key});

  @override
  State<Check> createState() => _CheckState();
}

class _CheckState extends State<Check> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: Icon(
                      Icons.email,
                      color: widgetPricolor,
                      size: 50,
                    )
                  ),
                  SizedBox(height: 30),
                  Text(
                    'Check your mail',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(height: 15),
                  Flexible(
                    child: Text("We have sent a password recover\ninstructions to your email.", textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: Colors.black45,
                      ),
                    )
                  ),
                  SizedBox(height: 30),
                  SizedBox(
                    width: 200, 
                    height: 50,
                    child: GestureDetector(
                      onTap: () {
                        // sendOTP(emailController.text);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: widgetPricolor,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: const Center(
                          child: Text(
                            'Open email app',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ),
            Positioned(
              bottom: 30,
              right: 0,
              left: 0,
              child: Center(
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: 'Did not receive the email? Check your spam filter\n',
                    style: const TextStyle(fontSize: 11, color: Colors.black),
                    children: [
                      const TextSpan(
                        text: 'or ',
                        style: TextStyle(fontSize: 11, color: Colors.black),
                      ),
                      TextSpan(
                        text: 'try another email address',
                        style: const TextStyle(
                          fontSize: 11,
                          color: widgetPricolor, 
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.pop(context);
                          },
                      ),
                    ],
                  ),
                )
              )
            )
          ],
        ),
      ),
    );
  }
}