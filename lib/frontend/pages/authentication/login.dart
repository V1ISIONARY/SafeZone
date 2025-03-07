// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // Import BLoC package
import 'package:go_router/go_router.dart';
import 'package:page_transition/page_transition.dart';
import 'package:safezone/backend/bloc/authBloc/auth_bloc.dart';
import 'package:safezone/backend/bloc/authBloc/auth_event.dart';
import 'package:safezone/backend/bloc/authBloc/auth_state.dart';
import 'package:safezone/backend/bloc/notificationBloc/notification_polling.dart';
import 'package:safezone/frontend/pages/authentication/register.dart';
import 'package:safezone/resources/schema/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Login extends StatefulWidget {
  const Login({super.key});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _passwordVisible = false;
  bool _rememberMe = false;
  final NotificationPollingService _pollingService =
      NotificationPollingService();
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
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Image.asset(
              'lib/resources/images/login.png',
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
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
                    child: Image.asset(
                      'lib/resources/images/email.png',
                      height: 50,
                    ),
                  ),
                  SizedBox(height: 30),
                  RichText(
                    text: TextSpan(
                      text: 'Welcome Back To ',
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1),
                      children: [
                        TextSpan(
                          text: 'SafeZone',
                          style: TextStyle(
                            color: widgetPricolor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Enter your details below',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF707070),
                    ),
                  ),
                  SizedBox(height: 50),
                  Text(
                    'Email address or username',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.black45,
                    ),
                  ),
                  SizedBox(height: 8),
                  TextField(
                    controller: emailController,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w200,
                      color: textColor,
                    ),
                    decoration: InputDecoration(
                      hintText: "safezone@gmail.com",
                      hintStyle: TextStyle(
                          fontSize: 13,
                          color: labelFormFieldColor,
                          fontWeight: FontWeight.w200),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: widgetPricolor, width: 2),
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
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.black45,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: passwordController,
                    obscureText: !_passwordVisible,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w200,
                      color: textColor,
                    ),
                    decoration: InputDecoration(
                      hintText: "hsl******",
                      hintStyle: TextStyle(
                          fontSize: 13,
                          color: labelFormFieldColor,
                          fontWeight: FontWeight.w200),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: widgetPricolor, width: 2),
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 12),
                      suffixIcon: Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _passwordVisible = !_passwordVisible;
                            });
                          },
                          child: Icon(
                            _passwordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Color(0xFF707070),
                          ),
                        ),
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
                            activeColor: widgetPricolor,
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
                      GestureDetector(
                        child: Text(
                          "Forgot Password?",
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w400,
                            color: widgetPricolor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 100),
                  Container(
                      height: 50,
                      width: double.infinity,
                      margin:
                          EdgeInsets.symmetric(vertical: 40, horizontal: 20),
                      child: GestureDetector(
                        onTap: () {
                          final email = emailController.text;
                          final password = passwordController.text;

                          context.read<AuthenticationBloc>().add(
                                UserLogin(email, password),
                              );
                        },
                        child: BlocBuilder<AuthenticationBloc,
                            AuthenticationState>(
                          builder: (context, state) {
                            return Container(
                              height: 50,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: widgetPricolor,
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: Center(
                                child: state is LoginLoading
                                    ? Container(
                                        height: 20,
                                        width: 20,
                                        child: Center(
                                            child: CircularProgressIndicator(
                                                color: Colors.white,
                                                strokeWidth: 1)),
                                      )
                                    : Text(
                                        'Sign In',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.white,
                                        ),
                                      ),
                              ),
                            );
                          },
                        ),
                      )),
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    child: Center(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account yet?",
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.black87,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 7),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  PageTransition(
                                    child: RegisterScreen(),
                                    type: PageTransitionType.rightToLeft,
                                    duration: Duration(milliseconds: 300),
                                  ),
                                );
                              },
                              child: Text(
                                "Sign Up",
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: widgetPricolor,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  BlocListener<AuthenticationBloc, AuthenticationState>(
                    listener: (context, state) async {
                      if (state is LoginSuccess) {
                        Navigator.pop(
                            context); // Close the loading dialog if it's open

                        final SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        int userId = prefs.getInt('id') ?? 0;
                        await prefs.setString('userToken', userId.toString());

                        if (userId != 0) {
                          int intervalInSeconds = 10;
                          _pollingService.startPolling(
                              userId, intervalInSeconds);
                        }

                        context.go(
                          '/home',
                          extra: userId.toString(),
                        );

                        // Navigator.pushReplacement(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => BottomNavigationWidget(
                        //         userToken: userId.toString()),
                        //   ),
                        // );
                        print(state);
                      } else if (state is LoginError) {
                        Navigator.pop(
                            context); // Close the loading dialog if it's open
                        print(state.message);
                      }
                    },
                    child: Container(),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
