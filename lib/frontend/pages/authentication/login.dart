// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // Import BLoC package
import 'package:flutter_svg/svg.dart';
import 'package:safezone/backend/bloc/authBloc/auth_bloc.dart';
import 'package:safezone/backend/bloc/authBloc/auth_event.dart';
import 'package:safezone/backend/bloc/authBloc/auth_state.dart';
import 'package:safezone/frontend/pages/authentication/register.dart';
import 'package:safezone/frontend/widgets/bottom_navigation.dart';
import 'package:safezone/resources/schema/colors.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _passwordVisible = false;
  bool _rememberMe = false;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Background Image (Positioned at the top)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Image.asset(
              'lib/resources/images/login.png',
              width: double.infinity,
              fit: BoxFit.cover, // Adjust as needed
            ),
          ),

          // Foreground Content
          SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 130),
                  Align(
                    alignment: Alignment.topLeft,
                    child: SvgPicture.asset(
                      'lib/resources/svg/logo.svg',
                      height: 50,
                    ),
                  ),
                  SizedBox(height: 50),
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF5C5C5C),
                        fontFamily: 'Poppins',
                      ),
                      children: const [
                        TextSpan(text: 'Welcome Back To '),
                        TextSpan(
                          text: 'SafeZone',
                          style: TextStyle(
                            color: Color(0xFFEF8D88),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Enter your details below',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF707070),
                    ),
                  ),
                  SizedBox(height: 50),
                  Text(
                    'Email address or username',
                    style: TextStyle(
                      color: Color(0xFF5C5C5C),
                    ),
                  ),
                  SizedBox(height: 8),   // TODO: add validations
                  TextField(
                    controller: emailController,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: textColor,
                    ),
                    decoration: InputDecoration(
                      hintText: "safezone@gmail.com",
                      hintStyle: TextStyle(
                          fontSize: 14,
                          color: labelFormFieldColor,
                          fontWeight: FontWeight.w200),
                      labelText: "Email address",
                      labelStyle: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w200,
                        color: labelFormFieldColor,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 12),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Password',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF5C5C5C),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: passwordController,
                    obscureText: !_passwordVisible,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: textColor,
                    ),
                    decoration: InputDecoration(
                      hintText: "Enter Password",
                      hintStyle: TextStyle(
                          fontSize: 14,
                          color: labelFormFieldColor,
                          fontWeight: FontWeight.w200),
                      labelText: "Password",
                      labelStyle: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w200,
                        color: labelFormFieldColor,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 12),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _passwordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Color(0xFF707070),
                        ),
                        onPressed: () {
                          setState(() {
                            _passwordVisible = !_passwordVisible;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Checkbox(
                            value: _rememberMe,
                            onChanged: (value) {
                              setState(() {
                                _rememberMe = value!;
                              });
                            },
                            side: BorderSide(
                              color: Color(0x99EF8D88),
                              width: 2,
                            ),
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            visualDensity: VisualDensity.compact,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                          Text(
                            'Remember me',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xFF707070),
                            ),
                          ),
                        ],
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          'Forgot Password?',
                          style: TextStyle(
                              color: Color(0xFFEF8D88),
                              fontSize: 11,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 100),
                  ElevatedButton(
                    onPressed: () {
                      final email = emailController.text;
                      final password = passwordController.text;

                      context.read<AuthenticationBloc>().add(
                            UserLogin(email, password),
                          );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFEF8D88),
                      padding: EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account yet? ",
                        style: TextStyle(fontSize: 11, color: textColor),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RegisterScreen()),
                          );
                        },
                        child: Text(
                          'Sign Up',
                          style: TextStyle(
                              color: Color(0xFFEF8D88),
                              fontWeight: FontWeight.bold,
                              fontSize: 11),
                        ),
                      ),
                    ],
                  ),
                  BlocListener<AuthenticationBloc, AuthenticationState>(
                    listener: (context, state) {
                      if (state is LoginSuccess) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BottomNavigationWidget()),
                        );
                      }
                    },
                    child: Container(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
