import 'package:flutter/material.dart';
import 'package:safezone/backend/models/userModel/notifications_model.dart';
import 'package:safezone/resource/schema/colors.dart';
import 'package:safezone/resource/schema/texts.dart';

class NotificationDetails extends StatefulWidget {
  final NotificationModel notificationModel;
  final VoidCallback? onBack;
  const NotificationDetails(
      {super.key, this.onBack, required this.notificationModel});

  @override
  State<NotificationDetails> createState() => _NotificationDetailsState();
}

class _NotificationDetailsState extends State<NotificationDetails> {
  @override
  Widget build(BuildContext context) {
    final notification = widget.notificationModel;
    final bool isSOS = notification.type.toUpperCase() == "SOS";

    final String backgroundImage = isSOS
        ? 'lib/resource/image/png/notif_sos5.png'
        : 'lib/resource/image/png/notif_info.png';

    String? location;
    if (isSOS && notification.message.contains("- Location:")) {
      final parts = notification.message.split("- Location:");
      if (parts.length > 1) {
        location = parts[1].trim();
      }
    }

    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            child: Image.asset(
              backgroundImage,
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
                      CategoryText(text: notification.title),
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
                  text: TextSpan(
                    children: isSOS
                        ? [
                            TextSpan(
                              text: notification.message
                                  .split("- Location:")
                                  .first
                                  .trim(),
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 13,
                              ),
                            ),
                          ]
                        : [
                            TextSpan(
                              text: notification.message,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 13,
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
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 8.0),
                          child: Text(
                            'Details',
                            style: TextStyle(fontSize: 13),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(right: 8, left: 8, top: 8),
                          child: Divider(
                            color: labelFormFieldColor,
                            thickness: 0.1,
                          ),
                        ),
                        RowText(title: "Message", text: notification.message),
                        RowText(title: "Type", text: notification.type),
                        RowText(
                            title: "Created At", text: notification.createdAt),

                        // Show Location only if SOS
                        if (isSOS && location != null)
                          RowText(title: "Location", text: location),
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
