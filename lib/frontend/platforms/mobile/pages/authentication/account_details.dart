import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:safezone/backend/architecture/bloc/authBloc/auth_event.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../backend/architecture/bloc/authBloc/auth_bloc.dart';
import '../../../../../backend/properties/import.dart';

class AccountDetails extends StatefulWidget {
  const AccountDetails({super.key});

  @override
  State<AccountDetails> createState() => _AccountDetailsState();
}

class _AccountDetailsState extends State<AccountDetails> {
  String username = '';
  String email = '';
  String firstName = '';
  String lastName = '';
  String phone = '';
  String password = '';
  String address = '';
  bool isAdmin = false;
  bool isGirl = false;
  bool isVerified = false;

  Future<void> loadUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username') ?? 'User';
      password = prefs.getString('password') ?? '*****';
      phone = prefs.getString('phone') ?? 'Phone Number not set';
      email = prefs.getString('email') ?? 'user@example.com';
      firstName = prefs.getString('first_name') ?? 'First Name';
      lastName = prefs.getString('last_name') ?? 'Last Name';
      address = prefs.getString('address') ?? 'Address not set';
      isAdmin = prefs.getBool('is_admin') ?? false;
      isGirl = prefs.getBool('is_girl') ?? false;
      isVerified = prefs.getBool('is_verified') ?? false;
    });
  }

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  void _showChangePasswordDialog(BuildContext context) {
    final TextEditingController currentPasswordController =
        TextEditingController();
    final TextEditingController newPasswordController = TextEditingController();
    final TextEditingController confirmNewPasswordController =
        TextEditingController();
    String? errorMessage;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text("Change Password"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: currentPasswordController,
                    decoration: InputDecoration(
                      labelText: 'Current Password',
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.lock),
                    ),
                    obscureText: true,
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: newPasswordController,
                    decoration: InputDecoration(
                      labelText: 'New Password',
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.lock_outline),
                    ),
                    obscureText: true,
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: confirmNewPasswordController,
                    decoration: InputDecoration(
                      labelText: 'Confirm New Password',
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.lock_outline),
                    ),
                    obscureText: true,
                  ),
                  if (errorMessage != null) ...[
                    SizedBox(height: 10),
                    Text(
                      errorMessage!,
                      style: TextStyle(color: Colors.red),
                    ),
                  ],
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text("Cancel"),
                ),
                TextButton(
                  onPressed: () {
                    String currentPassword = currentPasswordController.text;
                    String newPassword = newPasswordController.text;
                    String confirmNewPassword =
                        confirmNewPasswordController.text;

                    if (currentPassword.isEmpty ||
                        newPassword.isEmpty ||
                        confirmNewPassword.isEmpty) {
                      setState(() {
                        errorMessage = 'All fields are required.';
                      });
                    } else if (newPassword != confirmNewPassword) {
                      setState(() {
                        errorMessage = 'New passwords do not match.';
                      });
                    } else if (newPassword.length < 8) {
                      setState(() {
                        errorMessage =
                            'Password must be at least 8 characters.';
                      });
                    } else {
                      // Dispatch event to update password
                      context.read<AuthenticationBloc>().add(
                            ChangePasswordEvent(
                              password: currentPassword,
                              newPassword: newPassword,
                            ),
                          );
                      Navigator.of(context).pop(); // Close dialog
                    }
                  },
                  child: const Text("Confirm"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
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
        title: CategoryText(text: "Account Details"),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 15),
        child: ListView(
          children: [
            Container(
              width: double.infinity,
              height: 250,
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 240, 240, 240),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        color: Colors.black38,
                        shape: BoxShape.circle,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Image.asset(
                          'lib/resource/image/png/profile.jpg',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    CategoryText(text: "$firstName $lastName"),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 13,
                          height: 13,
                          child: SvgPicture.asset(
                            'lib/resource/svg/verified.svg',
                            color: widgetPricolor,
                          ),
                        ),
                        SizedBox(width: 5),
                        CategoryDescripText(text: "Verified at Safezone"),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Credentials Section
            Padding(
              padding: EdgeInsets.symmetric(vertical: 15),
              child: SizedBox(
                width: double.infinity,
                child: Stack(
                  children: [
                    CategoryText(text: 'Credentials'),
                    Positioned(
                      right: 0,
                      top: 0,
                      bottom: 0,
                      child: GestureDetector(
                        onTap: () => _showChangePasswordDialog(context),
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: SvgPicture.asset(
                            'lib/resource/svg/edit.svg',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Display Credentials Section
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 245, 245, 245),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Container(
                margin: EdgeInsets.only(left: 10, right: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AccountDisplay(
                      title: "Password",
                      svgIcon: "lib/resource/svg/password.svg",
                      data: password,
                    ),
                    Divider(height: 0.5, color: Colors.white),
                    // AccountDisplay(
                    //   title: "Phone",
                    //   svgIcon: "lib/resource/svg/phone.svg",
                    //   data: phone,
                    // ),
                    // Divider(height: 0.5, color: Colors.white),
                    AccountDisplay(
                      title: "Email",
                      svgIcon: "lib/resource/svg/mail.svg",
                      data: email,
                    ),
                    Divider(height: 0.5, color: Colors.white),
                    AccountDisplay(
                      title: "Location",
                      svgIcon: "lib/resource/svg/location.svg",
                      data: address,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
