import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:safezone/backend/bloc/authBloc/auth_bloc.dart';
import 'package:safezone/backend/bloc/authBloc/auth_event.dart';
import 'package:safezone/backend/bloc/authBloc/auth_state.dart';

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

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        if (state is SignUpSuccess) {
          GoRouter.of(context).go('/');
        } else if (state is SignUpFailed || state is SignUpError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(state is SignUpFailed
                    ? state.message
                    : (state as SignUpError).message)),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: currentStep > 0
              ? IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: previousStep,
                )
              : null,
        ),
        body: Column(
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
          Text(
            'Enter your email address',
            style: GoogleFonts.poppins(
              fontSize: 20,
              color: const Color(0xFF5C5C5C),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 11),
          Text(
            'Make sure to enter a valid email address for account verification.',
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.w200,
              color: const Color(0xFF707070),
            ),
          ),
          const SizedBox(height: 47),
          TextField(
            controller: emailController,
            decoration: InputDecoration(
              labelText: "Email Address",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 15),
            ),
          ),
          const Spacer(),
          ElevatedButton(
            onPressed: nextStep,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF8D88),
              minimumSize: const Size(double.infinity, 50),
            ),
            child: const Text("Send Code"),
          ),
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
          Text(
            'One-Time Code sent',
            style: GoogleFonts.poppins(
              fontSize: 20,
              color: const Color(0xFF5C5C5C),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 11),
          Text(
            'We have sent an email to visionary@gmail.com containing a 6-digit code',
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.w200,
              color: const Color(0xFF707070),
            ),
          ),
          const SizedBox(height: 47),
          TextField(
            controller: codeController,
            keyboardType: TextInputType.number,
            maxLength: 6,
            decoration: InputDecoration(
              hintText: "Enter 6-digit code",
              counterText: "",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 15),
            ),
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                codeController.clear();
              },
              child: const Text(
                "Clear",
                style: TextStyle(color: Colors.red),
              ),
            ),
          ),
          const Spacer(),
          ElevatedButton(
            onPressed: nextStep,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              minimumSize: const Size(double.infinity, 50),
            ),
            child: const Text("Verify"),
          ),
        ],
      ),
    );
  }

  Widget _buildUserDetailsStep(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Tell Us About Yourself",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 11),
          Text(
            'We’re almost there! Add these details to set up your account.',
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.w200,
              color: const Color(0xFF707070),
            ),
          ),
          const SizedBox(height: 47),
          TextField(
            controller: firstNameController,
            decoration: InputDecoration(
              hintText: "Enter First Name",
              labelText: "First Name",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              filled: true,
              fillColor: Colors.grey[100],
              contentPadding: const EdgeInsets.symmetric(horizontal: 15),
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: lastNameController,
            decoration: InputDecoration(
              hintText: "Enter Last Name",
              labelText: "Last Name",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              filled: true,
              fillColor: Colors.grey[100],
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
              labelText: "Gender",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              filled: true,
              fillColor: Colors.grey[100],
              contentPadding: const EdgeInsets.symmetric(horizontal: 15),
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: usernameController,
            decoration: InputDecoration(
              hintText: "Enter Username",
              labelText: "Username",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              filled: true,
              fillColor: Colors.grey[100],
              contentPadding: const EdgeInsets.symmetric(horizontal: 15),
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: passwordController,
            obscureText: true,
            decoration: InputDecoration(
              hintText: "Enter Password",
              labelText: "Password",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              filled: true,
              fillColor: Colors.grey[100],
              contentPadding: const EdgeInsets.symmetric(horizontal: 15),
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: confirmPasswordController,
            obscureText: true,
            decoration: InputDecoration(
              hintText: "Confirm Password",
              labelText: "Confirm Password",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              filled: true,
              fillColor: Colors.grey[100],
              contentPadding: const EdgeInsets.symmetric(horizontal: 15),
            ),
          ),
          const Spacer(),
          ElevatedButton(
            onPressed: () {
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
              ));

              context.push('/login');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF8D88),
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              "Create New Account",
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
