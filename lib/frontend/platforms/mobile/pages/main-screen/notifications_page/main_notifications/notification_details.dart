import 'package:flutter/material.dart';
import 'package:safezone/backend/models/userModel/notifications_model.dart';
import 'package:safezone/resource/schema/colors.dart';
import 'package:safezone/resource/schema/texts.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationDetails extends StatefulWidget {
  const NotificationDetails({super.key, required this.notificationModel});

  final NotificationModel notificationModel;

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
    if (isSOS && notification.message.contains("Location:")) {
      final parts = notification.message.split("Location:");
      if (parts.length > 1) {
        location = parts[1].trim();
      }
    }

    print(notification.message);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            collapsedHeight:
                kToolbarHeight + MediaQuery.of(context).padding.top,
            floating: false,
            pinned: true,
            snap: false,
            backgroundColor: Colors.transparent,
            leading: Container(
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.black),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon:
                    const Icon(Icons.arrow_back, color: Colors.black, size: 14),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            title: CategoryText(text: notification.title),
            flexibleSpace: FlexibleSpaceBar(
              background: Image.asset(
                backgroundImage,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              const SizedBox(height: 20),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                margin: const EdgeInsets.symmetric(horizontal: 15),
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
                                  .split("📍")
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
                        _buildTwoColumnItem("Message", notification.message),
                        _buildTwoColumnItem("Type", notification.type),
                        _buildTwoColumnItem(
                            "Created At", notification.createdAt),
                        if (isSOS && location != null)
                          _buildTwoColumnItem("Location", location!),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _buildTwoColumnItem(String title, String text) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Text(
                title,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w600,
                  color: textColor,
                  fontSize: 13,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Text(
              text,
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w400,
                color: textColor.withOpacity(0.8),
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
