import 'package:flutter/services.dart';
import 'package:safezone/backend/architecture/bloc/authBloc/auth_bloc.dart';
import 'package:safezone/backend/architecture/bloc/authBloc/auth_event.dart';
import 'package:safezone/backend/architecture/bloc/authBloc/auth_state.dart';
import 'package:http/http.dart' as http;
import 'package:safezone/frontend/platforms/mobile/widgets/Dialogs/account.dart';

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
  bool _isCreatingAccount = false; // Add this
  EmailOTP myauth = EmailOTP();
  String generatedOTP = "";
  bool _isSendingOTP = false;
  bool _showTitle = false;
  double _appBarHeight = 0;
  String _notificationText = "";
  Color _appBarColor = Colors.transparent;
  bool _agreedToTerms = false;

  File? idImage;
  File? selfieImage;
  bool isVerifyingFace = false;
  bool isFaceMatched = false;
  String? faceVerificationResult;
  String? resultText;
  bool isLoading = false;
  final ImagePicker picker = ImagePicker();

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
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 8,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: widgetPricolor.withOpacity(0.1),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: const Column(
                    children: [
                      Icon(
                        Icons.security,
                        size: 40,
                        color: widgetPricolor,
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Terms & Conditions",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "Please read carefully before proceeding",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),

                // Content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTermSection(
                          icon: Icons.verified_user,
                          title: "Account Responsibility",
                          content:
                              "You are responsible for maintaining the confidentiality of your account credentials and any activities that occur under your account.",
                        ),
                        const SizedBox(height: 16),
                        _buildTermSection(
                          icon: Icons.report_problem,
                          title: "Accurate Reporting",
                          content:
                              "All information provided must be accurate and truthful. False, misleading, or malicious reports are strictly prohibited and may result in account suspension.",
                        ),
                        const SizedBox(height: 16),
                        _buildTermSection(
                          icon: Icons.location_on,
                          title: "Location Data",
                          content:
                              "SafeZone collects location data to enhance safety features. This data is used solely for operational purposes in accordance with our Privacy Policy.",
                        ),
                        const SizedBox(height: 16),
                        _buildTermSection(
                          icon: Icons.gpp_maybe,
                          title: "Service Changes",
                          content:
                              "We reserve the right to modify, suspend, or discontinue any part of our service. Continued use after updates constitutes acceptance of revised terms.",
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.orange[50],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.orange[200]!),
                          ),
                          child: Text(
                            "By tapping 'I Agree', you acknowledge that you have read, understood, and consent to these Terms and Conditions.",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.orange[800],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Buttons
                Container(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context, false),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.grey,
                            side: const BorderSide(color: Colors.grey),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            "Cancel",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => Navigator.pop(context, true),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: widgetPricolor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 2,
                          ),
                          child: const Text(
                            "I Agree",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTermSection({
    required IconData icon,
    required String title,
    required String content,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 20,
          color: widgetPricolor,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                content,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black54,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> pickImage(bool isID) async {
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        if (isID) {
          idImage = File(picked.path);
        } else {
          selfieImage = File(picked.path);
        }
      });
    }
  }

  Future<void> verifyImages() async {
    if (idImage == null || selfieImage == null) {
      setState(() => resultText = "Please select both images first.");
      return;
    }

    setState(() {
      isLoading = true;
      resultText = null;
    });

    try {
      final idBytes = await idImage!.readAsBytes();
      final selfieBytes = await selfieImage!.readAsBytes();

      final idBase64 = base64Encode(idBytes);
      final selfieBase64 = base64Encode(selfieBytes);

      final response = await http.post(
        Uri.parse(
          "https://safezone-flask-emhe2f667-faokunns-projects.vercel.app/verify",
        ), // change this
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"id_image": idBase64, "selfie_image": selfieBase64}),
      );

      final data = jsonDecode(response.body);
      setState(() {
        if (response.statusCode == 200) {
          final verified = data["verified"];
          final confidence = data["confidence"];
          isFaceMatched = verified;
          resultText =
              "Verification: ${verified ? "VERIFIED" : "FAILED TO VERIFY: PLEASE TAKE ANOTHER PICTURE"}";
        } else {
          resultText = "Error: ${data["error"] ?? "Something went wrong."}";
        }
      });
    } catch (e) {
      setState(() => resultText = "Error: $e");
    } finally {
      setState(() => isLoading = false);
    }
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

  Future<void> verifyFaceMatch() async {
    if (idImage == null || selfieImage == null) {
      setState(() {
        faceVerificationResult = "Please upload both ID and Selfie first.";
      });
      return;
    }

    setState(() {
      isVerifyingFace = true;
      faceVerificationResult = null;
    });

    try {
      final idBytes = await idImage!.readAsBytes();
      final selfieBytes = await selfieImage!.readAsBytes();

      final response = await http.post(
        Uri.parse("http://10.0.2.2:5000/verify"), // ⚠️ Change this if deployed
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "id_image": base64Encode(idBytes),
          "selfie_image": base64Encode(selfieBytes),
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data["verified"] == true) {
        setState(() {
          isFaceMatched = true;
          faceVerificationResult =
              "✅ Face Matched! Confidence: ${data["confidence"].toStringAsFixed(2)}%";
        });
      } else {
        setState(() {
          isFaceMatched = false;
          faceVerificationResult = "❌ Not matched. Please retake your photos.";
        });
      }
    } catch (e) {
      setState(() {
        faceVerificationResult = "Error: $e";
        isFaceMatched = false;
      });
    } finally {
      setState(() {
        isVerifyingFace = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        if (state is SignUpSuccess) {
          setState(() {
            _isCreatingAccount = false;
            _isButtonDisabled = false;
          });
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => const AccountCreatedDialog(),
          );
        } else if (state is SignUpFailed || state is SignUpError) {
          setState(() {
            _isCreatingAccount = false;
            _isButtonDisabled = false;
          });
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
                        : currentStep == 2
                            ? _buildUserDetailsStep(context)
                            : _buildFaceVerificationStep(context),
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
        children: List.generate(4, (index) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 5),
            width: 70,
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
            onTap: _isSendingOTP || _isButtonDisabled
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
                color: widgetPricolor.withOpacity(
                    (_isSendingOTP || _isButtonDisabled) ? 0.6 : 1),
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
            onTap: _isVerifying || _isButtonDisabled
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
                color: widgetPricolor
                    .withOpacity((_isVerifying || _isButtonDisabled) ? 0.6 : 1),
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
                  'We\'re almost there! Add these details to set up your account.',
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
              onTap: _isButtonDisabled
                  ? null
                  : () {
                      if (firstNameController.text.isEmpty ||
                          lastNameController.text.isEmpty ||
                          addressController.text.isEmpty ||
                          usernameController.text.isEmpty ||
                          passwordController.text.isEmpty ||
                          confirmPasswordController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text("Please fill in all fields")),
                        );
                        return;
                      }

                      if (passwordController.text !=
                          confirmPasswordController.text) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text("Passwords do not match")),
                        );
                        return;
                      }

                      nextStep();
                    },
              child: Container(
                height: 50,
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 30, top: 20),
                decoration: BoxDecoration(
                  color:
                      widgetPricolor.withOpacity(_isButtonDisabled ? 0.6 : 1),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Center(
                  child: _isButtonDisabled
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'Continue to Face Verification',
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

  Widget _buildFaceVerificationStep(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) {
        final isLoadingState = state is SignUpnLoading || _isCreatingAccount;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CategoryText(
                text: "Face Verification",
              ),
              const SizedBox(height: 5),
              const CategoryDescripText(
                text:
                    'Verify your identity by taking photos of your ID and a live selfie.',
              ),
              const SizedBox(height: 30),

              // Instructions
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue[200]!),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "📸 Important Instructions:",
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "• Ensure good lighting\n"
                      "• Hold your ID steady\n"
                      "• Remove any covers/cases from ID\n"
                      "• Take a clear, recent selfie\n"
                      "• Face should be clearly visible",
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              const Text(
                "Take Photos Using Camera",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      GestureDetector(
                        onTap: (isFaceMatched || isLoadingState)
                            ? null
                            : () => _showCameraOptions(true),
                        child: Container(
                          width: 140,
                          height: 140,
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: idImage != null
                                  ? (isFaceMatched ? Colors.green : Colors.blue)
                                  : Colors.grey[400]!,
                              width: idImage != null ? 2 : 1,
                            ),
                          ),
                          child: idImage != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child:
                                      Image.file(idImage!, fit: BoxFit.cover),
                                )
                              : const Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.credit_card,
                                          size: 40, color: Colors.grey),
                                      SizedBox(height: 8),
                                      Text("Take ID Photo",
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500)),
                                      SizedBox(height: 4),
                                      Text("Tap to capture",
                                          style: TextStyle(
                                              fontSize: 10,
                                              color: Colors.grey)),
                                    ],
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Government ID",
                        style: TextStyle(
                            fontSize: 12,
                            color: idImage != null
                                ? (isFaceMatched ? Colors.green : Colors.blue)
                                : Colors.black,
                            fontWeight: idImage != null
                                ? FontWeight.w600
                                : FontWeight.normal),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      GestureDetector(
                        onTap: (isFaceMatched || isLoadingState)
                            ? null
                            : () => _showCameraOptions(false),
                        child: Container(
                          width: 140,
                          height: 140,
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: selfieImage != null
                                  ? (isFaceMatched ? Colors.green : Colors.blue)
                                  : Colors.grey[400]!,
                              width: selfieImage != null ? 2 : 1,
                            ),
                          ),
                          child: selfieImage != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.file(selfieImage!,
                                      fit: BoxFit.cover),
                                )
                              : const Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.face,
                                          size: 40, color: Colors.grey),
                                      SizedBox(height: 8),
                                      Text("Take Selfie",
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500)),
                                      SizedBox(height: 4),
                                      Text("Tap to capture",
                                          style: TextStyle(
                                              fontSize: 10,
                                              color: Colors.grey)),
                                    ],
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Live Selfie",
                        style: TextStyle(
                            fontSize: 12,
                            color: selfieImage != null
                                ? (isFaceMatched ? Colors.green : Colors.blue)
                                : Colors.black,
                            fontWeight: selfieImage != null
                                ? FontWeight.w600
                                : FontWeight.normal),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 20),

              if (!isFaceMatched) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: isLoadingState
                            ? null
                            : () => _showCameraOptions(true),
                        icon: const Icon(Icons.credit_card, size: 16),
                        label: const Text("ID Photo"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[50],
                          foregroundColor: Colors.blue[700],
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: isLoadingState
                            ? null
                            : () => _showCameraOptions(false),
                        icon: const Icon(Icons.face, size: 16),
                        label: const Text("Selfie"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[50],
                          foregroundColor: Colors.blue[700],
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: (idImage != null &&
                            selfieImage != null &&
                            !isLoading &&
                            !isLoadingState)
                        ? verifyImages
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: widgetPricolor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            "Verify Identity",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w600),
                          ),
                  ),
                ),
                const SizedBox(height: 20),
              ],

              if (!isFaceMatched && resultText != null)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.orange[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.orange,
                    ),
                  ),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.warning,
                        color: Colors.orange,
                        size: 32,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        resultText!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.orange[800],
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Please retake photos and try again",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),

              if (isFaceMatched)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.green),
                  ),
                  child: const Column(
                    children: [
                      Icon(
                        Icons.verified_user,
                        color: Colors.green,
                        size: 40,
                      ),
                      SizedBox(height: 12),
                      Text(
                        "Identity Verified Successfully!",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Your identity has been verified. You can now create your account.",
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.green,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 30),

              GestureDetector(
                onTap:
                    (isFaceMatched && !isLoadingState) ? _createAccount : null,
                child: Container(
                  height: 55,
                  margin: const EdgeInsets.only(bottom: 30),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: (isFaceMatched && !isLoadingState)
                        ? widgetPricolor
                        : Colors.grey[400],
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: (isFaceMatched && !isLoadingState)
                        ? [
                            BoxShadow(
                              color: widgetPricolor.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            )
                          ]
                        : null,
                  ),
                  child: Center(
                    child: _buildAccountButtonContent(),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _showCameraOptions(bool isID) async {
    await showModalBottomSheet(
      context: context,
      builder: (context) {
        return SingleChildScrollView(
          child: Container(
            color: Colors.white,
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Container(
                    width: 50,
                    height: 5,
                    decoration: BoxDecoration(
                      color: widgetPricolor.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 30.0),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    _takePhotoWithCamera(isID);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white,
                    ),
                    height: 50,
                    width: double.infinity,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(width: 10),
                        Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color.fromARGB(255, 245, 245, 245),
                          ),
                          child: const Icon(
                            size: 24,
                            Icons.camera_alt,
                            color: widgetPricolor,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Take ${isID ? 'ID' : 'Selfie'} Photo',
                          style: const TextStyle(
                            fontSize: 13,
                            color: textColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 15.0),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    pickImage(isID);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white,
                    ),
                    height: 50,
                    width: double.infinity,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(width: 10),
                        Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color.fromARGB(255, 245, 245, 245),
                          ),
                          child: const Icon(
                            size: 24,
                            Icons.photo_library,
                            color: widgetPricolor,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Choose ${isID ? 'ID' : 'Selfie'} from Gallery',
                          style: const TextStyle(
                            fontSize: 13,
                            color: textColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 25.0),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _takePhotoWithCamera(bool isID) async {
    final picked = await picker.pickImage(
      source: ImageSource.camera,
      preferredCameraDevice: isID ? CameraDevice.rear : CameraDevice.front,
      maxWidth: 1920,
      maxHeight: 1080,
      imageQuality: 90,
    );

    if (picked != null) {
      setState(() {
        if (isID) {
          idImage = File(picked.path);
        } else {
          selfieImage = File(picked.path);
        }
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('${isID ? 'ID' : 'Selfie'} photo captured successfully'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  void _createAccount() async {
    final signupBloc = context.read<AuthenticationBloc>();
    final currentState = signupBloc.state;

    if (currentState is SignUpnLoading || _isCreatingAccount) return;

    final agreed = await _showTermsDialog(context);
    if (agreed != true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("You must agree to continue.")),
      );
      return;
    }

    try {
      setState(() {
        _isCreatingAccount = true;
        _isButtonDisabled = true;
      });

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
        SnackBar(content: Text("Failed to get location: ${e.toString()}")),
      );
      setState(() {
        _isCreatingAccount = false;
        _isButtonDisabled = false;
      });
    }
  }

  Widget _buildAccountButtonContent() {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) {
        final isLoading = state is SignUpnLoading || _isCreatingAccount;

        if (isLoading) {
          return const SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 2,
            ),
          );
        } else {
          return const Text(
            'Create Account',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          );
        }
      },
    );
  }
}
