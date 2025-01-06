import 'package:flutter/material.dart';
import 'package:safezone/frontend/widgets/buttons/notification_btn.dart';

class Notif extends StatefulWidget {
  const Notif({super.key});

  @override
  State<Notif> createState() => _NotifState();
}

class _NotifState extends State<Notif> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        centerTitle: false,
        title: const Text(
          "Notification",
          style: TextStyle(
              fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
      body: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          children: [
            NotificationBtn(
                title: "Reports History",
                svgIcon: "lib/resources/svg/report_notif.svg",
                navigateTo: "Reports",
                description:
                    "Check the status and details of your submitted reports"),
          ],
        ),
      ),
    );
  }
}
