// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:safezone/frontend/widgets/account_display.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../resources/schema/colors.dart';
import '../../../resources/schema/texts.dart';

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
            margin: EdgeInsets.all(15),
            decoration: BoxDecoration(
              border: Border.all(width: 1, color: Colors.black),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.arrow_back, color: Colors.black, size: 10),
          ),
        ),
        title: CategoryText(
          text: "Account Details"
        ),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 15),
        child: ListView(
          children: [
            Container(
              width: double.infinity,
              height: 250,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 240, 240, 240),
                borderRadius: BorderRadius.circular(5),
                // boxShadow: const [
                //   BoxShadow(
                //     color: Colors.grey,
                //     blurRadius: 2,
                //     offset: Offset(1, 1),
                //   ),
                // ],
              ),
              child: Center(
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          color: Colors.black38,
                          shape: BoxShape.circle
                        ),
                        child: ClipRRect(
                          child: Image.asset(
                            'lib/resources/images/miro.png',
                            fit: BoxFit.cover,
                          )
                        )
                      ),
                      SizedBox(height: 10),
                      CategoryText(
                        text: "$firstName $lastName"
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 13,
                            height: 13,
                            child: SvgPicture.asset(
                              'lib/resources/svg/verified.svg',
                              color: widgetPricolor,
                            ),
                          ),
                          SizedBox(width: 5),
                          CategoryDescripText(
                            text: "Verified at Safezone"
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 15),
              child: Container(
                width: double.infinity,
                child: Stack(
                  children: [
                    CategoryText(text: 'Credentials'),
                    Positioned(
                      right: 0,
                      top: 0,
                      bottom: 0,
                      child: Container(
                        width: 20,
                        height: 20,
                        child: SvgPicture.asset(
                          'lib/resources/svg/edit.svg'
                        ),
                      )
                    )
                  ],
                ),
              ),
            ),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 245, 245, 245),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Container(
                margin: EdgeInsets.only(
                  left: 10,
                  right: 10
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AccountDisplay(
                      title: "Password", 
                      svgIcon: "lib/resources/svg/password.svg", 
                      data: password
                    ),
                    Divider(
                      height: 0.5,
                      color: Colors.white,
                    ),
                    AccountDisplay(
                      title: "Phone", 
                      svgIcon: "lib/resources/svg/phone.svg", 
                      data: phone
                    ),
                    Divider(
                      height: 0.5,
                      color: Colors.white,
                    ),
                    AccountDisplay(
                      title: "Email", 
                      svgIcon: "lib/resources/svg/mail.svg", 
                      data: email
                    ),
                    Divider(
                      height: 0.5,
                      color: Colors.white,
                    ),
                    AccountDisplay(
                      title: "Location", 
                      svgIcon: "lib/resources/svg/location.svg", 
                      data: address
                    )
                  ],
                )
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 15),
              child: CategoryText(text: 'Privacy & Security'),
            ),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 245, 245, 245),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Container(
                margin: EdgeInsets.only(
                  left: 10,
                  right: 10
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AccountDisplay(
                      title: "Two-step Authentication", 
                      svgIcon: "lib/resources/svg/two-step.svg", 
                      data: "Enable"
                    ),
                    Divider(
                      height: 0.5,
                      color: Colors.white,
                    ),
                    AccountDisplay(
                      title: "Alerts for Suspicious Activity", 
                      svgIcon: "lib/resources/svg/two-step.svg", 
                      data: "Enable"
                    )
                  ]
                )
              )
            ),
          ]
        )
      )
    );
  }
}