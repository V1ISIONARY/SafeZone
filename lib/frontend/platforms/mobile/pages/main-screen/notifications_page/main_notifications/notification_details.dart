import 'package:flutter/material.dart';
import 'package:safezone/backend/models/userModel/notifications_model.dart';
import 'package:safezone/resource/schema/colors.dart';
import 'package:safezone/resource/schema/texts.dart';

class NotificationDetails extends StatefulWidget {
  const NotificationDetails({super.key, required this.notificationModel});

  final NotificationModel notificationModel;

  @override
  State<NotificationDetails> createState() => _NotificationDetailsState();
}

class _NotificationDetailsState extends State<NotificationDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // TODO: add conditional statement to check notif's type and display the correct image
          SizedBox(
            width: double.infinity,
            child: Image.asset(
              'lib/resource/image/png/notif_sos5.png',
              fit: BoxFit.cover,
            ),
          ),

          Column(
            children: [
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          margin: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.black),
                            shape: BoxShape.circle,
                          ),
                          padding: const EdgeInsets.all(5),
                          child: const Icon(Icons.arrow_back,
                              color: Colors.black, size: 14),
                        ),
                      ),
                      const Spacer(),
                      CategoryText(text: widget.notificationModel.title),
                      const Spacer(),
                      const SizedBox(width: 44),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 250),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 50,
                      offset: const Offset(0, 0),
                    ),
                  ],
                ),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: const TextSpan(
                    text: 'widget.notificationModel.name',
                    style: TextStyle(color: Color(0xffDA5C56), fontSize: 13),
                    children: [
                      TextSpan(
                        text: ", has triggered the SOS!!",
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 50,
                        offset: const Offset(0, 0),
                      ),
                    ],
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 8.0),
                          child: Text(
                            'Details',
                            style: TextStyle(fontSize: 13),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 8, left: 8, top: 8),
                          child: Divider(
                            color: labelFormFieldColor,
                            thickness: 0.1,
                          ),
                        ),
                        RowText(
                            title: "Location",
                            text: "widget.notificationModel.location"),
                        RowText(title: "Contact", text: "09123454345"),
                        RowText(title: "Remarks", text: "remarksremarksremarks"),
                        RowText(title: "Otherother", text: "asdfasdfasdf"),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
