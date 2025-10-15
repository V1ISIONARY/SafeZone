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
  bool _isVerifying = false;
  bool _isButtonDisabled = false;
  EmailOTP myauth = EmailOTP();
  String generatedOTP = "";
  bool _isSendingOTP = false;
  bool _showTitle = false;
  double _appBarHeight = 0;
  String _notificationText = "";
  Color _appBarColor = Colors.transparent;
  bool _agreedToTerms = false;

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
      currentStep += 1;
    });
  }

  void previousStep() {
    setState(() {
      currentStep--;
    });
  }

  Future<bool?> _showTermsDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false, // ❗ Prevent closing by tapping outside
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            "Terms and Conditions",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
              child: const Text(
            '''
Welcome to SafeZone.

By creating an account and using our services, you agree to comply with and be bound by these Terms and Conditions. Please read them carefully before proceeding.

SafeZone is designed to help users report and share safety-related information within their community. You agree that all information you provide during registration and while using the app is accurate, truthful, and up to date. Submitting false, misleading, or malicious reports is strictly prohibited and may result in the suspension or permanent termination of your account.

To enhance safety and accuracy, SafeZone may collect and use your location data when you submit reports or access certain features. This data is used solely for legitimate operational purposes and handled in accordance with our Privacy Policy.

You are responsible for maintaining the confidentiality of your account credentials and any actions taken under your account. You agree not to engage in any activity that could disrupt, damage, or impair the app’s functionality or other users’ experience.

SafeZone reserves the right to modify, suspend, or discontinue any part of the service at any time without prior notice. We may also update these Terms periodically, and continued use of the app after such updates constitutes your acceptance of the revised terms.

By tapping “I Agree,” you acknowledge that you have read, understood, and consent to these Terms and Conditions, as well as our Privacy Policy, governing the use of SafeZone and its related services.
  ''',
            style: TextStyle(fontSize: 13, height: 1.5),
          )),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () => Navigator.pop(context, true),
              child: const Text(
                "I Agree",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
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
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Account created successfully. Please log in to continue.',
                style: TextStyle(fontSize: 16),
              ),
              behavior: SnackBarBehavior.floating,
              duration: Duration(seconds: 3),
            ),
          );

          // Delay slightly so the snackbar shows before navigating
          Future.delayed(const Duration(milliseconds: 500), () {
            GoRouter.of(context).go('/login');
          });
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
                : () async {
                    setState(() => _isSendingOTP = true);

                    final bloc = context.read<AuthenticationBloc>();
                    bloc.add(CheckEmailEvent(email: emailController.text));

                    // Declare first (nullable), then assign after
                    StreamSubscription? subscription;
                    subscription = bloc.stream.listen((state) async {
                      if (state is EmailCheckSuccess) {
                        await sendOTP(emailController.text);
                        _checkIfShown(
                          text: 'Verification code sent successfully.',
                          color: Colors.green,
                        );
                        setState(() => _isSendingOTP = false);
                        subscription?.cancel();
                      } else if (state is EmailCheckError) {
                        _checkIfShown(text: state.message, color: Colors.red);
                        setState(() => _isSendingOTP = false);
                        subscription?.cancel();
                      }
                    });
                  },
            child: Container(
              height: 50,
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 30),
              decoration: BoxDecoration(
                color: widgetPricolor.withOpacity(_isSendingOTP ? 0.6 : 1),
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
            onTap: _isVerifying
                ? null
                : () async {
                    if (codeController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Please enter the OTP")),
                      );
                      return;
                    }

                    setState(() => _isVerifying = true);

                    await Future.delayed(const Duration(
                        milliseconds:
                            400)); // optional short delay for smooth UX

                    if (codeController.text == generatedOTP) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text("OTP verified successfully")),
                      );
                      nextStep();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text("Invalid OTP, please try again.")),
                      );
                    }

                    setState(() => _isVerifying = false);
                  },
            child: Container(
              height: 50,
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 30),
              decoration: BoxDecoration(
                color: widgetPricolor.withOpacity(_isVerifying ? 0.6 : 1),
                borderRadius: BorderRadius.circular(50),
              ),
              child: Center(
                child: _isVerifying
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        'Verify',
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
                final signupBloc = context.read<AuthenticationBloc>();
                final currentState = signupBloc.state;

                // Prevent double-taps or re-pressing during loading
                if (currentState is SignUpnLoading) return;

                if (passwordController.text != confirmPasswordController.text) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Passwords do not match")),
                  );
                  return;
                }

                // 1️⃣ Show Terms dialog BEFORE proceeding
                final agreed = await _showTermsDialog(context);

                // If user didn't agree, stop here
                if (agreed != true) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text("You must agree to continue.")),
                  );
                  return;
                }

                try {
                  // 🔒 Temporarily disable button for 2 seconds
                  setState(() => _isButtonDisabled = true);
                  await Future.delayed(const Duration(seconds: 2));

                  // 🕒 Proceed with the rest of the logic
                  Position position = await Geolocator.getCurrentPosition(
                    desiredAccuracy: LocationAccuracy.high,
                  );

                  signupBloc.add(UserSignUpEvent(
                    username: usernameController.text,
                    email: emailController.text,
                    password: passwordController.text,
                    address: addressController.text,
                    age: int.tryParse(ageController.text) ?? 18,
                    firstname: firstNameController.text,
                    lastname: lastNameController.text,
                    isAdmin: false,
                    isGirl: true,
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
                } finally {
                  // 🔓 Re-enable the button after delay and process
                  setState(() => _isButtonDisabled = false);
                }
              },
              child: Container(
                height: 50,
                margin: const EdgeInsets.only(bottom: 30),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: (_isButtonDisabled ||
                          context.watch<AuthenticationBloc>().state
                              is SignUpnLoading)
                      ? widgetPricolor.withOpacity(0.6)
                      : widgetPricolor,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Center(
                  child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
                    builder: (context, state) {
                      if (state is SignUpnLoading) {
                        return const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        );
                      } else {
                        return Text(
                          _isButtonDisabled
                              ? 'Please wait...'
                              : 'Create new account',
                          style: const TextStyle(
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
