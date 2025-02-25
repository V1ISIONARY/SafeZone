import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safezone/backend/bloc/notificationBloc/notification_bloc.dart';
import 'package:safezone/backend/bloc/notificationBloc/notification_event.dart';
import 'package:safezone/backend/bloc/notificationBloc/notification_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:safezone/resources/schema/colors.dart';
import 'package:safezone/backend/models/userModel/notifications_model.dart';

class Read extends StatefulWidget {
  final String userToken;

  const Read({super.key, required this.userToken});

  @override
  State<Read> createState() => _ReadState();
}

class _ReadState extends State<Read> {
  List<NotificationModel> readNotifications = []; // Store read notifications locally
  int userId = 0; // Default userId

  @override
  void initState() {
    super.initState();
    _fetchUserIdAndNotifications();
  }

  Future<void> _fetchUserIdAndNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getInt('id') ?? 0; // Get stored userId, default to 0 if not found

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
            readNotifications = state.notifications
                .where((notification) => notification.isRead)
                .toList();

            return readNotifications.isNotEmpty
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
      itemCount: readNotifications.length,
      itemBuilder: (context, index) {
        final notification = readNotifications[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            title: Text(
              notification.title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(notification.message),
            trailing: Text(
              notification.createdAt,
              style: const TextStyle(color: Colors.grey, fontSize: 12),
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
                  'No Read Notifications',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                  ),
                  textAlign: TextAlign.center,
                ),
                const Text(
                  'You have not read any notifications yet.',
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
