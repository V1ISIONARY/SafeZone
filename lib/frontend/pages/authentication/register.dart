import 'dart:math';

import 'package:email_otp/email_otp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:safezone/backend/bloc/authBloc/auth_bloc.dart';
import 'package:safezone/backend/bloc/authBloc/auth_event.dart';
import 'package:safezone/backend/bloc/authBloc/auth_state.dart';
import 'package:geolocator/geolocator.dart';
import 'package:safezone/resources/schema/texts.dart';

import '../../../resources/schema/colors.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  int currentStep = 0;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController codeController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  EmailOTP myauth = EmailOTP();
  String generatedOTP = "";
  String? selectedGender;

  @override
  void dispose() {
    emailController.dispose();
    codeController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void nextStep() {
    setState(() {
      currentStep++;
    });
  }

  void previousStep() {
    setState(() {
      currentStep--;
    });
  }

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
      nextStep();
      print('OTP sent successfully: $generatedOTP');
    } catch (e) {
      print('Error sending OTP: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        if (state is SignUpSuccess) {
          GoRouter.of(context).go('/login');
        } else if (state is SignUpFailed || state is SignUpError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state is SignUpFailed
                    ? state.message
                    : (state as SignUpError).message,
              ),
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: const CategoryText(text: "Sign Up"),
          leading: GestureDetector(
            onTap: () {
              if (currentStep > 0) {
                previousStep();
              } else {
                Navigator.pop(context);
              }
            },
            child: Container(
              margin: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.black),
                shape: BoxShape.circle,
              ),
              child:
                  const Icon(Icons.arrow_back, color: Colors.black, size: 10),
            ),
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              _buildProgressIndicator(),
              Expanded(
                child: currentStep == 0
                    ? _buildEmailStep()
                    : currentStep == 1
                        ? _buildCodeVerificationStep()
                        : _buildUserDetailsStep(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(3, (index) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 5),
            width: 95,
            height: 7,
            decoration: BoxDecoration(
              color: index <= currentStep
                  ? const Color(0xFFEF8D88)
                  : Colors.grey[300],
              borderRadius: BorderRadius.circular(5),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildEmailStep() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CategoryText(
            text: 'Enter your email address',
          ),
          const SizedBox(height: 5),
          CategoryDescripText(
            text:
                'Make sure to enter a valid email address for account verification.',
          ),
          const SizedBox(height: 30),
          TextField(
            controller: emailController,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w200,
              color: textColor,
            ),
            decoration: InputDecoration(
              hintText: "Email Address",
              hintStyle: TextStyle(
                  fontSize: 13,
                  color: labelFormFieldColor,
                  fontWeight: FontWeight.w200),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: widgetPricolor, width: 2),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 15),
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () {
              sendOTP(emailController.text);
            },
            child: Container(
              height: 50,
              width: double.infinity,
              margin: EdgeInsets.only(bottom: 30),
              decoration: BoxDecoration(
                color: widgetPricolor,
                borderRadius: BorderRadius.circular(50),
              ),
              child: Center(
                child: Text(
                  'Send Code',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildCodeVerificationStep() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CategoryText(
            text: 'One-Time Code sent',
          ),
          const SizedBox(height: 5),
          CategoryDescripText(
            text:
                'We have sent an email to ${emailController.text} containing a 6-digit code',
          ),
          const SizedBox(height: 30),
          TextField(
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
                borderSide: BorderSide(color: widgetPricolor, width: 2),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 15),
            ),
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () {
                codeController.clear();
              },
              child: Text(
                "Clear",
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                  color: widgetPricolor,
                ),
              ),
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () async {
              if (codeController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Please enter the OTP")),
                );
                return;
              }

              if (codeController.text == generatedOTP) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("OTP verified successfully")),
                );
                nextStep();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text("Invalid OTP, please try again.")),
                );
              }
            },
            child: Container(
              height: 50,
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 30),
              decoration: BoxDecoration(
                color: widgetPricolor,
                borderRadius: BorderRadius.circular(50),
              ),
              child: const Center(
                child: Text(
                  'Verify',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildUserDetailsStep(BuildContext context) {
    return SingleChildScrollView(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CategoryText(
              text: "Tell Us About Yourself",
            ),
            const SizedBox(height: 5),
            CategoryDescripText(
              text:
                  'We’re almost there! Add these details to set up your account.',
            ),
            const SizedBox(height: 30),
            TextField(
              controller: firstNameController,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w200,
                color: textColor,
              ),
              decoration: InputDecoration(
                hintText: "Enter First Name",
                hintStyle: TextStyle(
                    fontSize: 13,
                    color: labelFormFieldColor,
                    fontWeight: FontWeight.w200),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: widgetPricolor, width: 2),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 15),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: lastNameController,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w200,
                color: textColor,
              ),
              decoration: InputDecoration(
                hintText: "Enter Last Name",
                hintStyle: TextStyle(
                    fontSize: 13,
                    color: labelFormFieldColor,
                    fontWeight: FontWeight.w200),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: widgetPricolor, width: 2),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 15),
              ),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: selectedGender,
              items: ['Male', 'Female'].map((gender) {
                return DropdownMenuItem(
                  value: gender,
                  child: Text(gender),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedGender = value;
                });
              },
              decoration: InputDecoration(
                hintText: "Gender",
                hintStyle: TextStyle(
                    fontSize: 13,
                    color: labelFormFieldColor,
                    fontWeight: FontWeight.w200),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: widgetPricolor, width: 2),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 15),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: usernameController,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w200,
                color: textColor,
              ),
              decoration: InputDecoration(
                hintText: "Enter Username",
                hintStyle: TextStyle(
                    fontSize: 13,
                    color: labelFormFieldColor,
                    fontWeight: FontWeight.w200),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: widgetPricolor, width: 2),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 15),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: passwordController,
              obscureText: true,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w200,
                color: textColor,
              ),
              decoration: InputDecoration(
                hintText: "Enter Password",
                hintStyle: TextStyle(
                    fontSize: 13,
                    color: labelFormFieldColor,
                    fontWeight: FontWeight.w200),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: widgetPricolor, width: 2),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 15),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: confirmPasswordController,
              obscureText: true,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w200,
                color: textColor,
              ),
              decoration: InputDecoration(
                hintText: "Confirm Password",
                hintStyle: TextStyle(
                    fontSize: 13,
                    color: labelFormFieldColor,
                    fontWeight: FontWeight.w200),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: widgetPricolor, width: 2),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 15),
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () async {
                if (passwordController.text != confirmPasswordController.text) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Passwords do not match")),
                  );
                  return;
                }

                Position position = await Geolocator.getCurrentPosition(
                    desiredAccuracy: LocationAccuracy.high);

                final signupBloc = context.read<AuthenticationBloc>();

                signupBloc.add(UserSignUpEvent(
                  username: usernameController.text,
                  email: emailController.text,
                  password: passwordController.text,
                  address:
                      'Some address', // Replace with actual input if required
                  firstname: firstNameController.text,
                  lastname: lastNameController.text,
                  isAdmin: false,
                  isGirl: selectedGender == 'Female',
                  isVerified: true,
                  latitude: position.latitude, // Pass latitude
                  longitude: position.longitude, // Pass longitude
                ));
              },
              child: Container(
                height: 50,
                margin: EdgeInsets.only(bottom: 30),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: widgetPricolor,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Center(
                  child: Text(
                    'Create new account',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                    ),
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
