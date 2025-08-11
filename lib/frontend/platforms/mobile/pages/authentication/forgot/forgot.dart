import 'dart:math';

import 'package:email_otp/email_otp.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:page_transition/page_transition.dart';
import 'package:safezone/backend/architecture/bloc/authBloc/auth_bloc.dart';
import 'package:safezone/backend/architecture/bloc/authBloc/auth_event.dart';
import 'package:safezone/backend/architecture/bloc/authBloc/auth_state.dart';

import '../../../../../../backend/properties/import.dart';

class Forgot extends StatefulWidget {
  const Forgot({super.key});

  @override
  State<Forgot> createState() => _ForgotState();
}

class _ForgotState extends State<Forgot> {
  EmailOTP myauth = EmailOTP();
  String generatedOTP = "";
  final TextEditingController emailController = TextEditingController();
  final TextEditingController codeController = TextEditingController();

  Future<void> sendOTP(String recipientEmail) async {
    const String senderEmail = 'safezone.SY2425@gmail.com';
    final String senderPassword = dotenv.env['GMAIL_PASSWORD'] ?? '';

    if (senderPassword.isEmpty) {
      print('Error: GMAIL_PASSWORD is not set in .env file');
      return;
    }

    generatedOTP = (Random().nextInt(900000) + 100000).toString();

    final smtpServer = gmail(senderEmail, senderPassword);

    final String htmlContent = '''
    <html>
      <body>
        <table align="center" width="100%" cellpadding="0" cellspacing="0" role="presentation">
          <tr>
            <td align="center">
              <img src="https://firebasestorage.googleapis.com/v0/b/safezone-11724.firebasestorage.app/o/Group%2031.png?alt=media&token=393c849f-c3e6-4c19-a231-62350ec23667" alt="SafeZone Logo" style="width:150px;height:auto;">
            </td>
          </tr>
        </table>
        <p>Dear user,</p>
        <p>Welcome to SafeZone app!</p>
        <p>To proceed with your verification request, here's your one-time PIN:</p>
        <h2>$generatedOTP</h2>
        <p>One Time PIN is only valid for 10 minutes.</p>
        <p>Did you request for this? If not, please ignore this email or report this activity to our customer service by sending an email to <a href="mailto:safezone.SY2425@gmail.com">safezone.SY2425@gmail.com</a>.</p>
        <p>Thank you.</p>
      </body>
    </html>
    ''';

    final message = Message()
      ..from = const Address(senderEmail, 'SafeZone App')
      ..recipients.add(recipientEmail)
      ..subject = 'SafeZone OTP Code'
      ..html = htmlContent;

    try {
      await send(message, smtpServer);
      print('OTP sent successfully: $generatedOTP');
    } catch (e) {
      print('Error sending OTP: $e');
    }
  }

  bool _showTitle = false;
  double _appBarHeight = 0;
  String _notificationText = "";
  Color _appBarColor = Colors.transparent;

  void _checkIfShown({required String text, required Color color}) {
    setState(() {
      _appBarHeight = 40;
      _appBarColor = color;
      _showTitle = true;
      _notificationText = text;
    });

    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          _appBarHeight = 0;
          _appBarColor = Colors.transparent;
          _showTitle = false;
        });
      }
    });
  }

  bool _showTitleOtp = false;
  double _otp = 0;
  Color _otpColor = Colors.transparent;

  Future<void> _checkIfShownOtp(bool open) async {
    Future.delayed(const Duration(milliseconds: 200), () {
      setState(() {
        if (open) {
          _otp = 50;
          _otpColor = widgetPricolor;
          _showTitleOtp = true;
        } else {
          _otp = 0;
          _otpColor = Colors.transparent;
          _showTitleOtp = false;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(children: [
      AppBar(
        toolbarHeight: 0,
        automaticallyImplyLeading: false,
      ),
      AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: _appBarHeight,
        color: _appBarColor,
        width: double.infinity,
        alignment: Alignment.center,
        child: _showTitle
            ? CategoryDescripText(
                text: _notificationText,
                color: Colors.white,
              )
            : null,
      ),
      AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        centerTitle: true,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            margin: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              border: Border.all(width: 1, color: Colors.black),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.arrow_back, color: Colors.black, size: 10),
          ),
        ),
      ),
      Expanded(
          child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Forgot Password',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 5),
            Flexible(
                child: Text(
              "Enter the email associated with you account and we'll send an email with\nintructions to reset your password.",
              style: GoogleFonts.poppins(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: Colors.black45,
              ),
            )),
            const SizedBox(height: 20),
            TextField(
              controller: emailController,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w200,
                color: textColor,
              ),
              decoration: InputDecoration(
                  hintText: "Email Address",
                  hintStyle: const TextStyle(
                      fontSize: 13,
                      color: labelFormFieldColor,
                      fontWeight: FontWeight.w200),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide:
                        const BorderSide(color: widgetPricolor, width: 2),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                  suffixIcon: _showTitleOtp
                      ? Padding(
                          padding: const EdgeInsets.only(right: 15),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                emailController.clear();
                                _checkIfShownOtp(false);
                              });
                            },
                            child: const Icon(
                              Icons.close,
                              color: Colors.grey,
                            ),
                          ))
                      : null),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: _otp,
              width: double.infinity,
              alignment: Alignment.center,
              margin: EdgeInsets.only(top: _showTitleOtp ? 20 : 0),
              child: _showTitleOtp
                  ? TextField(
                      controller: codeController,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w200,
                        color: textColor,
                      ),
                      decoration: InputDecoration(
                        hintText: "Enter 6-digit code",
                        counterText: "",
                        hintStyle: const TextStyle(
                            fontSize: 13,
                            color: labelFormFieldColor,
                            fontWeight: FontWeight.w200),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide:
                              const BorderSide(color: widgetPricolor, width: 2),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 15),
                      ),
                    )
                  : null,
            ),
            const SizedBox(height: 20),
            _showTitleOtp
                ? SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: GestureDetector(
                      onTap: () {
                        if (codeController.text == generatedOTP) {
                          _checkIfShown(
                              text: 'OTP verified successfully',
                              color: Colors.green);
                          Navigator.push(
                            context,
                            PageTransition(
                              child: Createnew(email: emailController.text),
                              type: PageTransitionType.rightToLeft,
                              duration: const Duration(milliseconds: 300),
                            ),
                          );
                        } else {
                          _checkIfShown(
                              text: 'Invalid OTP, please try again.',
                              color: Colors.red);
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: widgetPricolor,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: const Center(
                          child: Text(
                            'Confirm',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                : SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: GestureDetector(
                      onTap: () {
                        final bloc = context.read<AuthenticationBloc>();
                        bloc.add(CheckEmailEvent(email: emailController.text));
                        bloc.stream.listen((state) {
                          if (state is EmailCheckSuccess) {
                            sendOTP(emailController.text);
                            _checkIfShownOtp(true);
                          } else if (state is EmailCheckError) {
                            _checkIfShown(
                                text: state.message, color: Colors.red);
                          }
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: widgetPricolor,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: const Center(
                          child: Text(
                            'Send Code',
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
        ),
      ))
    ]));
  }
}
