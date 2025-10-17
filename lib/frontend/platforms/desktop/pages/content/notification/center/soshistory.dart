import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safezone/backend/architecture/bloc/notificationBloc/notification_bloc.dart';
import 'package:safezone/backend/architecture/bloc/notificationBloc/notification_event.dart';
import 'package:safezone/backend/architecture/bloc/notificationBloc/notification_state.dart';
import 'package:safezone/frontend/platforms/mobile/widgets/loading/shimmer_loading.dart';
import 'package:safezone/resource/schema/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:safezone/backend/models/userModel/notifications_model.dart';

class Soshistory extends StatefulWidget {
  final VoidCallback? onClose;
  final String userToken;
  final Function(NotificationModel) onOpenNotification;

  const Soshistory({
    super.key,
    required this.onClose,
    required this.userToken,
    required this.onOpenNotification,
  });

  @override
  State<Soshistory> createState() => _SoshistoryState();
}

class _SoshistoryState extends State<Soshistory>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<NotificationModel> allNotifications = [];
  int userId = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _fetchUserIdAndNotifications();
  }

  Future<void> _fetchUserIdAndNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getInt('id') ?? 0;
    if (userId != 0) {
      context.read<NotificationBloc>().add(FetchNotifications(userId));
    }
  }

  List<NotificationModel> _filterNotifications(String category) {
    switch (category) {
      case 'Unread':
        return allNotifications.where((n) => !n.isRead).toList();
      case 'Read':
        return allNotifications.where((n) => n.isRead).toList();
      case 'All':
      default:
        return allNotifications;
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
            // ✅ Only SOS notifications
            allNotifications = state.notifications
                .where((n) => n.type.toLowerCase() == "sos")
                .toList();

            if (allNotifications.isEmpty) return _buildPlaceholder();

            return Column(
              children: [
                TabBar(
                  controller: _tabController,
                  indicatorColor: widgetPricolor,
                  labelColor: Colors.black,
                  labelStyle: const TextStyle(fontSize: 12),
                  tabs: const [
                    Tab(text: "All"),
                    Tab(text: "Unread"),
                    Tab(text: "Read"),
                  ],
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildNotificationList("All"),
                      _buildNotificationList("Unread"),
                      _buildNotificationList("Read"),
                    ],
                  ),
                ),
              ],
            );
          }
          return _buildPlaceholder();
        },
      ),
    );
  }

  Widget _buildNotificationList(String category) {
    final filtered = _filterNotifications(category);
    if (filtered.isEmpty) {
      return _buildEmptyTab(category);
    }

    return ListView.builder(
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        final notification = filtered[index];
        return GestureDetector(
          onTap: () {
            widget.onOpenNotification(notification);
            if (!notification.isRead) {
              setState(() {
                filtered[index] = notification.copyWith(isRead: true);
              });
              context
                  .read<NotificationBloc>()
                  .add(MarkNotificationAsRead(notification.id));
            }
          },
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: notification.isRead
                  ? Colors.transparent
                  : const Color.fromARGB(10, 255, 0, 0), // 🔴 Light red tint
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
                            : Colors.redAccent,
                        width: notification.isRead ? 1 : 2,
                      ),
                    ),
                    child: Icon(
                      Icons.emergency_outlined,
                      color:
                          notification.isRead ? Colors.grey : Colors.redAccent,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          notification.title,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: notification.isRead
                                ? Colors.black87
                                : Colors.redAccent,
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
    );
  }

  Widget _buildEmptyTab(String category) {
    return Center(
      child: Text(
        "No $category SOS notifications.",
        style: const TextStyle(color: Colors.black54, fontSize: 12),
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
                  'No SOS Alerts',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                  ),
                  textAlign: TextAlign.center,
                ),
                const Text(
                  'You currently have no SOS-type notifications.',
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
