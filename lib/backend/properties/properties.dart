import 'package:flutter/material.dart';

class SharedProperties {

  static final SharedProperties _instance = SharedProperties._internal();
  factory SharedProperties() => _instance;
  SharedProperties._internal();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController searchController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController fisrtNameController = TextEditingController();
  final TextEditingController groupNameController = TextEditingController();
  final TextEditingController groupCodeController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController confirmPassController = TextEditingController();

  bool rememberMe = false;
  bool passwordVisible = false;
  bool isSidebarCollapsed = false;

  ValueNotifier<bool> authenticationPage = ValueNotifier(true);
  ValueNotifier<bool> inSlide = ValueNotifier(false);
}
