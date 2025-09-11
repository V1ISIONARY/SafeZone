import 'package:flutter/material.dart';
import 'package:safezone/backend/models/userModel/notifications_model.dart';
import 'package:safezone/resource/schema/colors.dart';
import 'package:safezone/resource/schema/texts.dart';

class NotificationDetails extends StatefulWidget {
  final NotificationModel notificationModel;
  final VoidCallback? onBack;
  const NotificationDetails({
    super.key, 
    this.onBack,
    required this.notificationModel
  });


  @override
  State<NotificationDetails> createState() => _NotificationDetailsState();
}

class _NotificationDetailsState extends State<NotificationDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [SizedBox(
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
                      Transform.translate(
                        offset: const Offset(-15, 0),
                        child: Row(children: [
                          GestureDetector(
                            onTap: widget.onBack ?? () => Navigator.pop(context),
                            child: Container(
                              margin: const EdgeInsets.all(10),
                              height: 20,
                              width: 20,
                              decoration: BoxDecoration(
                                border: Border.all(width: 1, color: Colors.black),
                                shape: BoxShape.circle,
                              ),
                              child:
                                  const Icon(Icons.arrow_back, color: Colors.black, size: 10),
                            ),
                          ),
                          CategoryText(text: widget.notificationModel.title),
                        ]),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 250),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 250, 250, 250),
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
                    style: TextStyle(color: Color(0xffDA5C56), fontSize: 11),
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
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 250, 250, 250),
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
                        RowText(
                            title: "Remarks", text: "remarksremarksremarks"),
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
