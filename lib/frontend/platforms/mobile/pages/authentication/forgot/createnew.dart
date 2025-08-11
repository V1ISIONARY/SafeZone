import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:safezone/backend/architecture/bloc/authBloc/auth_bloc.dart';
import 'package:safezone/backend/architecture/bloc/authBloc/auth_event.dart';
import 'package:safezone/backend/architecture/bloc/authBloc/auth_state.dart';

import '../../../../../../backend/properties/import.dart';

class Createnew extends StatefulWidget {
  final String email;
  const Createnew({super.key, required this.email});

  @override
  State<Createnew> createState() => _CreatenewState();
}

class _CreatenewState extends State<Createnew> {
  final TextEditingController currentPasswordController =
      TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    passwordController.dispose();
    currentPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  double strengthWidth = 10;
  bool _isPasswordVisible = false;
  bool _isCPasswordVisible = false;
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

  bool _showTitle = false;
  double _appBarHeight = 0;
  String _notificationText = "";
  Color _appBarColor = Colors.transparent;

  Future<void> _checkIfShown(
      {required String text, required Color color}) async {
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {
          _appBarHeight = 40;
          _appBarColor = color;
          _notificationText = text;
          _showTitle = true;
        });
      }

      Future.delayed(const Duration(seconds: 5), () {
        if (mounted) {
          setState(() {
            _appBarHeight = 0;
            _appBarColor = Colors.transparent;
            _showTitle = false;
          });
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
              'Create new password',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 5),
            Flexible(
                child: Text(
              "Your new password must be different from any of your previously used passwords to enhance security and protect your account.",
              style: GoogleFonts.poppins(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: Colors.black45,
              ),
            )),
            const SizedBox(height: 20),
            TextField(
                controller: currentPasswordController,
                obscureText: !_isCPasswordVisible,
                onChanged: _checkPasswordStrength,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w200,
                  color: textColor,
                ),
                decoration: InputDecoration(
                    hintText: "Enter Current Password",
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
                              _isCPasswordVisible = !_isCPasswordVisible;
                            });
                          },
                          child: Icon(
                            _isCPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.grey,
                          ),
                        )))),
            const SizedBox(height: 20),
            TextField(
                controller: passwordController,
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
              onTap: () {
                String currentPassword = currentPasswordController.text;
                String newPassword = passwordController.text;
                String confirmNewPassword = confirmPasswordController.text;

                if (newPassword.isEmpty || confirmNewPassword.isEmpty) {
                  setState(() {
                    _checkIfShown(
                        text: "All fields are required", color: Colors.red);
                  });
                } else if (newPassword != confirmNewPassword) {
                  setState(() {
                    _checkIfShown(
                        text: "New password and confirm password not match",
                        color: Colors.orange);
                  });
                } else {
                  print("Dispatching ResetPasswordEvent");
                  print("Email: ${widget.email}");
                  print("Current Password: $currentPassword");
                  print("New Password: $newPassword");

                  final bloc = context.read<AuthenticationBloc>();
                  bloc.add(
                    ResetPasswordEvent(
                      email: widget.email,
                      password: currentPassword,
                      newPassword: newPassword,
                    ),
                  );

                  bloc.stream.listen((state) {
                    if (state is UpdateMyPasswordSuccess) {
                      _checkIfShown(
                          text: 'Password updated successfully',
                          color: Colors.green);
                    } else if (state is UpdateMyPasswordError) {
                      if (state.message.contains("incorrect password")) {
                        _checkIfShown(
                            text: "Current password is incorrect.",
                            color: Colors.red);
                      } else {
                        _checkIfShown(text: state.message, color: Colors.red);
                      }
                    }
                  });
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
                child: const Center(
                    child: Text(
                  'Reset Password',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                  ),
                )),
              ),
            )
          ],
        ),
      ))
    ]));
  }
}
