import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safezone/backend/architecture/bloc/notificationBloc/notification_bloc.dart';
import 'package:safezone/backend/architecture/bloc/notificationBloc/notification_event.dart';
import 'package:safezone/backend/architecture/bloc/notificationBloc/notification_state.dart';
import 'package:safezone/frontend/platforms/mobile/widgets/loading/shimmer_loading.dart';
import 'package:safezone/resource/schema/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:safezone/backend/models/userModel/notifications_model.dart';

class All extends StatefulWidget {
  final String userToken;
  final Function(NotificationModel) onOpenNotification;

  const All({
    super.key,
    required this.userToken,
    required this.onOpenNotification,
  });

  @override
  State<All> createState() => _AllState();
}

class _AllState extends State<All> {
  List<NotificationModel> notifications = [];
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
            return ListView.builder(
              itemCount: 4,
              itemBuilder: (context, index) => const ShimmerNotificationCard(),
            );
          } else if (state is NotificationError) {
            return _buildError(state.message);
          } else if (state is NotificationUpdated) {
            _fetchUserIdAndNotifications();
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
    return Container(
      margin: const EdgeInsets.only(bottom: 30.0),
      child: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return GestureDetector(
            onTap: () {
              widget.onOpenNotification(notification);
              if (!notification.isRead) {
                setState(() {
                  notifications[index] = notification.copyWith(isRead: true);
                });
                context.read<NotificationBloc>().add(
                  MarkNotificationAsRead(notification.id),
                );
              }
            },
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: notification.isRead
                    ? Colors.transparent
                    : const Color.fromARGB(10, 0, 0, 0),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        border: Border.all(
                          color: notification.isRead
                              ? const Color.fromARGB(44, 0, 0, 0)
                              : Colors.transparent,
                          width: notification.isRead ? 1 : 0,
                        ),
                      ),
                      child: Icon(
                        Icons.notifications,
                        color:
                            notification.isRead ? Colors.grey : widgetPricolor,
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
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            notification.message,
                            style: const TextStyle(
                              color: labelFormFieldColor,
                              fontSize: 10,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            notification.createdAt,
                            style: const TextStyle(
                              color: Color.fromARGB(132, 92, 92, 92),
                              fontSize: 10,
                            ),
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
      ),
    );
  }

  Widget _buildPlaceholder() {
    return widget.userToken == 'guest'
        ? const SizedBox.shrink()
        : Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'lib/resource/image/png/notif1.png',
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
          const Icon(Icons.error, color: Colors.red, size: 50),
          const SizedBox(height: 10),
          Text(
            "Error: $message",
            style: const TextStyle(color: Colors.red, fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}