import 'dart:math';

import 'package:email_otp/email_otp.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:geolocator/geolocator.dart';
import 'package:safezone/backend/architecture/bloc/authBloc/auth_bloc.dart';
import 'package:safezone/backend/architecture/bloc/authBloc/auth_event.dart';
import 'package:safezone/backend/architecture/bloc/authBloc/auth_state.dart';

import '../../../../../backend/properties/import.dart';

class RegisterMD extends StatefulWidget {
  const RegisterMD({super.key});

  @override
  _RegisterMDState createState() => _RegisterMDState();
}

class _RegisterMDState extends State<RegisterMD> {
  int currentStep = 0;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController codeController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController ageController = TextEditingController(text: "18");
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  EmailOTP myauth = EmailOTP();
  String generatedOTP = "";
  String? selectedGender;
  bool _isSendingOTP = false;
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

  @override
  void dispose() {
    emailController.dispose();
    codeController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    addressController.dispose();
    ageController.dispose();
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
    setState(() {
      _isSendingOTP = true;
    });

    const String senderEmail = 'safezone.SY2425@gmail.com';
    final String senderPassword = dotenv.env['GMAIL_PASSWORD'] ?? '';

    if (senderPassword.isEmpty) {
      print('Error: GMAIL_PASSWORD is not set in .env file');
      _checkIfShown(text: "Email sender error", color: Colors.red);
      setState(() {
        _isSendingOTP = false;
      });
      return;
    }

    generatedOTP = (Random().nextInt(900000) + 100000).toString();

    final smtpServer = gmail(senderEmail, senderPassword);

    final String htmlContent = '''
    <html>
      <body>
        <p>Welcome to SafeZone!</p>
        <p>Your OTP is:</p>
        <h2>$generatedOTP</h2>
        <p>Valid for 10 minutes.</p>
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
      _checkIfShown(text: "Failed to send OTP", color: Colors.red);
    }

    setState(() {
      _isSendingOTP = false;
    });
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
        body: SafeArea(
          child: Column(
            children: [
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
                    child: const Icon(Icons.arrow_back,
                        color: Colors.black, size: 10),
                  ),
                ),
              ),
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
          const CategoryText(
            text: 'Enter your email address',
          ),
          const SizedBox(height: 5),
          const CategoryDescripText(
            text:
                'Make sure to enter a valid email address for account verification.',
          ),
          const SizedBox(height: 30),
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
                fontWeight: FontWeight.w200,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: widgetPricolor, width: 2),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 15),
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: _isSendingOTP
                ? null
                : () {
                    final bloc = context.read<AuthenticationBloc>();
                    bloc.add(CheckEmailEvent(email: emailController.text));

                    // Wait for result then trigger OTP
                    bloc.stream.listen((state) {
                      if (state is EmailCheckSuccess) {
                        sendOTP(emailController.text);
                      } else if (state is EmailCheckError) {
                        _checkIfShown(text: state.message, color: Colors.red);
                      }
                    });
                  },
            child: Container(
              height: 50,
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 30),
              decoration: BoxDecoration(
                color: widgetPricolor,
                borderRadius: BorderRadius.circular(50),
              ),
              child: Center(
                child: _isSendingOTP
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
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
                borderSide: const BorderSide(color: widgetPricolor, width: 2),
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
              child: const Text(
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

  double strengthWidth = 10;
  bool _isPasswordVisible = false;
  bool showConfirmPassword = false;
  Color strengthColor = Colors.black12;

  void _checkPasswordStrength(String password) {
    final RegExp uppercase = RegExp(r'[A-Z]');
    final RegExp lowercase = RegExp(r'[a-z]');
    final RegExp digit = RegExp(r'\d');
    final RegExp specialChar = RegExp(r'[@$!%*?&]');

    int strength = 0;

    if (password.length >= 8) strength++;
    if (uppercase.hasMatch(password)) strength++;
    if (lowercase.hasMatch(password)) strength++;
    if (digit.hasMatch(password)) strength++;
    if (specialChar.hasMatch(password)) strength++;
    if (password.contains(" ")) strength = 0;

    setState(() {
      if (password.isEmpty) {
        strengthColor = Colors.grey;
        strengthWidth = 10;
        showConfirmPassword = false;
      } else if (password.length < 8) {
        strengthColor = Colors.red;
        strengthWidth = 50.0;
        showConfirmPassword = false;
      } else if (strength < 5) {
        strengthColor = Colors.orange;
        strengthWidth = 200.0;
        showConfirmPassword = true;
      } else {
        strengthColor = Colors.green;
        strengthWidth = MediaQuery.of(context).size.width - 40;
        showConfirmPassword = true;
      }
    });
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
            const CategoryDescripText(
              text:
                  'We’re almost there! Add these details to set up your account.',
            ),
            const SizedBox(height: 30),
            TextField(
              controller: firstNameController,
              maxLength: 20,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w200,
                color: textColor,
              ),
              decoration: InputDecoration(
                counterText: "",
                hintText: "Enter First Name",
                hintStyle: const TextStyle(
                    fontSize: 13,
                    color: labelFormFieldColor,
                    fontWeight: FontWeight.w200),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: widgetPricolor, width: 2),
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
              maxLength: 20,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w200,
                color: textColor,
              ),
              decoration: InputDecoration(
                counterText: "",
                hintText: "Enter Last Name",
                hintStyle: const TextStyle(
                    fontSize: 13,
                    color: labelFormFieldColor,
                    fontWeight: FontWeight.w200),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: widgetPricolor, width: 2),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 15),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: ageController,
              keyboardType: TextInputType.number,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w200,
                color: textColor,
              ),
              inputFormatters: [
                LengthLimitingTextInputFormatter(2),
              ],
              decoration: InputDecoration(
                hintText: "Age",
                hintStyle: const TextStyle(
                    fontSize: 13,
                    color: labelFormFieldColor,
                    fontWeight: FontWeight.w200),
                suffixIcon: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      child: const Icon(Icons.arrow_drop_up),
                      onTap: () {
                        int currentAge = int.tryParse(ageController.text) ?? 18;
                        if (currentAge < 99) {
                          ageController.text = (currentAge + 1).toString();
                        }
                      },
                    ),
                    GestureDetector(
                      child: const Icon(Icons.arrow_drop_down),
                      onTap: () {
                        int currentAge = int.tryParse(ageController.text) ?? 18;
                        if (currentAge > 1) {
                          ageController.text = (currentAge - 1).toString();
                        }
                      },
                    ),
                  ],
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: widgetPricolor, width: 2),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 15),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: addressController,
              maxLength: 50,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w200,
                color: textColor,
              ),
              decoration: InputDecoration(
                counterText: "",
                hintText: "Enter Address",
                hintStyle: const TextStyle(
                    fontSize: 13,
                    color: labelFormFieldColor,
                    fontWeight: FontWeight.w200),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: widgetPricolor, width: 2),
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
                hintStyle: const TextStyle(
                    fontSize: 13,
                    color: labelFormFieldColor,
                    fontWeight: FontWeight.w200),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: widgetPricolor, width: 2),
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
              maxLength: 20,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w200,
                color: textColor,
              ),
              decoration: InputDecoration(
                hintText: "Enter Username",
                hintStyle: const TextStyle(
                    fontSize: 13,
                    color: labelFormFieldColor,
                    fontWeight: FontWeight.w200),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: widgetPricolor, width: 2),
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
                maxLength: 20,
                obscureText: !_isPasswordVisible,
                onChanged: _checkPasswordStrength,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w200,
                  color: textColor,
                ),
                decoration: InputDecoration(
                    hintText: "Enter Password",
                    hintStyle: const TextStyle(
                      fontSize: 13,
                      color: labelFormFieldColor,
                      fontWeight: FontWeight.w200,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide:
                          const BorderSide(color: widgetPricolor, width: 2),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                    suffixIcon: Padding(
                        padding: const EdgeInsets.only(right: 15),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                          child: Icon(
                            _isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.grey,
                          ),
                        )))),
            const SizedBox(height: 20),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              width: strengthWidth,
              height: 8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: strengthColor,
              ),
            ),
            const SizedBox(height: 20),
            if (showConfirmPassword)
              Column(
                children: [
                  TextField(
                    controller: confirmPasswordController,
                    maxLength: 20,
                    obscureText: !_isPasswordVisible,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w200,
                      color: textColor,
                    ),
                    decoration: InputDecoration(
                      hintText: "Confirm Password",
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
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            GestureDetector(
              onTap: () async {
                if (passwordController.text != confirmPasswordController.text) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Passwords do not match")),
                  );
                  return;
                }

                try {
                  // Get user location
                  Position position = await Geolocator.getCurrentPosition(
                    desiredAccuracy: LocationAccuracy.high,
                  );

                  final signupBloc = context.read<AuthenticationBloc>();

                  // Dispatch event to trigger sign-up
                  signupBloc.add(UserSignUpEvent(
                    username: usernameController.text,
                    email: emailController.text,
                    password: passwordController.text,
                    address: addressController.text,
                    age: int.tryParse(ageController.text) ?? 18,
                    firstname: firstNameController.text,
                    lastname: lastNameController.text,
                    isAdmin: false,
                    isGirl: selectedGender == 'Female',
                    isVerified: true,
                    latitude: position.latitude,
                    longitude: position.longitude,
                  ));
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content:
                            Text("Failed to get location: ${e.toString()}")),
                  );
                }
              },
              child: Container(
                height: 50,
                margin: const EdgeInsets.only(bottom: 30),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: widgetPricolor,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Center(
                  child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
                    builder: (context, state) {
                      if (state is LoginLoading) {
                        return const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 1,
                          ),
                        );
                      } else {
                        return const Text(
                          'Create new account',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        );
                      }
                    },
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
