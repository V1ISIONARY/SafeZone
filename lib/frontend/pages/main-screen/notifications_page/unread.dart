import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safezone/backend/bloc/notificationBloc/notification_bloc.dart';
import 'package:safezone/backend/bloc/notificationBloc/notification_event.dart';
import 'package:safezone/backend/bloc/notificationBloc/notification_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:safezone/resources/schema/colors.dart';
import 'package:safezone/backend/models/userModel/notifications_model.dart';

class Unread extends StatefulWidget {
  final String userToken;

  const Unread({super.key, required this.userToken});

  @override
  State<Unread> createState() => _UnreadState();
}

class _UnreadState extends State<Unread> {
  List<NotificationModel> unreadNotifications = [];
  int userId = 0;

  @override
  void initState() {
    super.initState();
    _fetchUserIdAndNotifications();
  }

  Future<void> _fetchUserIdAndNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getInt('id') ?? 0;

    if (userId != 0) {
      context.read<NotificationBloc>().add(FetchNotifications(userId));
    }
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
            unreadNotifications = state.notifications
                .where((notification) => !notification.isRead)
                .toList();

            return unreadNotifications.isNotEmpty
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
      itemCount: unreadNotifications.length,
      itemBuilder: (context, index) {
        final notification = unreadNotifications[index];

        return GestureDetector(
          onTap: () {
            _markAsRead(notification);
          },
          child: Container(
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
                    child: const Icon(
                      Icons.notifications,
                      color: btnColor,
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
                        const SizedBox(height: 4),
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
          ),
        );
      },
    );
  }

  void _markAsRead(NotificationModel notification) {
    final updatedNotification = notification.copyWith(isRead: true);

    setState(() {
      unreadNotifications.removeWhere((notif) => notif.id == notification.id);
    });

    context
        .read<NotificationBloc>()
        .add(MarkNotificationAsRead(updatedNotification.id));
  }

  Widget _buildPlaceholder() {
    return widget.userToken == 'guest'
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
                  'No Unread Notifications',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                  ),
                  textAlign: TextAlign.center,
                ),
                const Text(
                  'You have no new notifications.',
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
          const Icon(Icons.error, color: Colors.red, size: 50),
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
