import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:safezone/backend/models/userModel/notifications_model.dart';
import 'package:safezone/backend/repository/notificationApi/notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationPollingService {
  static final NotificationPollingService _instance =
      NotificationPollingService._internal();

  factory NotificationPollingService() {
    return _instance;
  }

  NotificationPollingService._internal();
  final String baseUrl = '${dotenv.env['API_URL']}/notifications';
  Timer? timer;

  /// Start polling and set a flag in SharedPreferences
  void startPolling(int userId, int intervalInSeconds) async {
    if (timer != null) {
      print("Polling already running.");
      return;
    }

    print("Polling started with interval: $intervalInSeconds seconds");

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool("isPollingActive", true);

    timer = Timer.periodic(Duration(seconds: intervalInSeconds), (_) async {
      print("Fetching notifications for userId: $userId");
      try {
        await _fetchAndProcessNotifications(userId);
      } catch (e) {
        print("Error: $e");
      }
    });
  }

  void stopPolling() async {
    // Stop the timer
    timer?.cancel();
    timer = null;
    print("Polling stopped.");

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool("isPollingActive", false);
  }

  Future<bool> isPollingActive() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool("isPollingActive") ?? false;
  }

  void enablePolling() {
    print("Polling enabled.");
  }

  /// Fetch and process unread notifications
  Future<void> _fetchAndProcessNotifications(int userId) async {
    print("Fetching notifications for userId: $userId");

    List<NotificationModel> notifications = await getNotifications(userId);

    if (notifications.isNotEmpty) {
      for (var notification in notifications) {
        if (!notification.isDone && !notification.isRead) {
          if (await _isNotificationProcessed(userId, notification.id)) {
            print(
                "Skipping already processed notification: ${notification.id}");
            continue;
          }

          print(
              "Creating new notification - Title: ${notification.title}, Message: ${notification.message}");
          NotificationService.createNewNotification(
            title: notification.title,
            body: notification.message,
            typeOfNotif: notification.type,
          );

          await _markNotificationAsProcessed(userId, notification.id);
          await _markNotificationAsDone(notification.id);
        }
      }
      _updateLastChecked();
    } else {
      print("No new notifications to process.");
    }
  }

  Future<List<NotificationModel>> getNotifications(int userId) async {
    final String url = '$baseUrl/get_notif/$userId';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData
            .map((item) => NotificationModel.fromJson(item))
            .toList();
      } else {
        print(response.body);
        throw Exception(
            "Failed to load notifications. Status Code: ${response.statusCode}");
      }
    } catch (e) {
      print('$baseUrl/get_notif/$userId');
      print("Error fetching notifications: $e");
      return [];
    }
  }

  Future<bool> _isNotificationProcessed(int userId, int notificationId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String processedNotificationsKey = 'processed_notifications_$userId';
    List<String>? processedNotifications =
        prefs.getStringList(processedNotificationsKey);

    return processedNotifications?.contains(notificationId.toString()) ?? false;
  }

  Future<void> _markNotificationAsProcessed(
      int userId, int notificationId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String processedNotificationsKey = 'processed_notifications_$userId';
    List<String>? processedNotifications =
        prefs.getStringList(processedNotificationsKey);

    processedNotifications ??= [];
    if (!processedNotifications.contains(notificationId.toString())) {
      processedNotifications.add(notificationId.toString());
      await prefs.setStringList(
          processedNotificationsKey, processedNotifications);
    }
  }

  Future<void> _updateLastChecked() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String currentTime = DateTime.now().toIso8601String().split('.')[0];
    print("Updating lastChecked time: $currentTime");
    await prefs.setString('lastChecked', currentTime);
  }

  Future<String> getLastChecked() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String lastChecked =
        prefs.getString('lastChecked') ?? DateTime.now().toIso8601String();
    print("Retrieved lastChecked time: $lastChecked");
    return lastChecked;
  }

  Future<void> _markNotificationAsDone(int notificationId) async {
    final String url = '$baseUrl/mark_done/$notificationId';

    try {
      final response = await http.patch(Uri.parse(url));

      if (response.statusCode == 200) {
        print("Notification $notificationId marked as done.");
      } else {
        print(
            "Failed to mark notification $notificationId as done. Status: ${response.statusCode}");
      }
    } catch (e) {
      print("Error marking notification $notificationId as done: $e");
    }
  }
}
