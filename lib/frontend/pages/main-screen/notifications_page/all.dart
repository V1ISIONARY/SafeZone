import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safezone/backend/bloc/notificationBloc/notification_bloc.dart';
import 'package:safezone/backend/bloc/notificationBloc/notification_event.dart';
import 'package:safezone/backend/bloc/notificationBloc/notification_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:safezone/resources/schema/colors.dart';
import 'package:safezone/backend/models/userModel/notifications_model.dart';

class All extends StatefulWidget {
  final String userToken;

  const All({super.key, required this.userToken});

  @override
  State<All> createState() => _AllState();
}

class _AllState extends State<All> {
  List<NotificationModel> notifications = []; // Store notifications locally
  int userId = 0; // Default userId

  @override
  void initState() {
    super.initState();
    _fetchUserIdAndNotifications();
  }

  Future<void> _fetchUserIdAndNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    userId =
        prefs.getInt('id') ?? 0; // Get stored userId, default to 0 if not found

    if (userId != 0) {
      context.read<NotificationBloc>().add(FetchNotifications(userId));
    }
    print(userId);
    print(userId);
    print(userId);
    print(userId);
    print(userId);
    print(userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocBuilder<NotificationBloc, NotificationState>(
        builder: (context, state) {
          if (state is NotificationLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is NotificationError) {
            return _buildError(state.message);
          } else if (state is NotificationLoaded) {
            notifications = state.notifications; 
            return notifications.isNotEmpty
                ? _buildNotificationList()
                : _buildPlaceholder();
          }
          return _buildPlaceholder();
        },
      ),
    );
  }

  Widget _buildNotificationList() {
    return ListView.builder(
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        final notification = notifications[index];

        return Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: const Color.fromARGB(10, 0, 0, 0), 
            borderRadius: BorderRadius.circular(5),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: Icon(
                    Icons.notifications,
                    color: notification.isRead
                        ? Colors.grey
                        : btnColor, 
                  ),
                ),
                const SizedBox(width: 16), 
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        notification.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: textColor,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(
                          height: 4), 
                      Text(
                        notification.message,
                        style: const TextStyle(
                          color: labelFormFieldColor,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        notification.createdAt,
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 11),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPlaceholder() {
    return widget.userToken == 'guess'
        ? Container()
        : Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'lib/resources/images/notif1.png',
                  width: 150,
                  height: 150,
                ),
                const SizedBox(height: 10),
                const Text(
                  'Empty Notification',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                  ),
                  textAlign: TextAlign.center,
                ),
                const Text(
                  'There are no new notifications, check back later.',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 9,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
  }

  Widget _buildError(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error, color: Colors.red, size: 50),
          const SizedBox(height: 10),
          Text(
            "Error: $message",
            style: const TextStyle(color: Colors.red, fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: _fetchUserIdAndNotifications,
            child: const Text("Retry"),
          ),
        ],
      ),
    );
  }
}
