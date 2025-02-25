import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:safezone/backend/apiservice/notificationApi/notification_service.dart';
import 'package:safezone/backend/models/userModel/notifications_model.dart';
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

  void startPolling(int userId, int intervalInSeconds) {
    if (timer != null) {
      print("Polling already running or stopped.");
      return;
    }

    print("Polling started with interval: $intervalInSeconds seconds");

    timer = Timer.periodic(Duration(seconds: intervalInSeconds), (_) async {
      print("Fetching notifications for userId: $userId");
      try {
        await _fetchAndProcessNotifications(userId);
      } catch (e) {
        print("Error: $e");
      }
    });
  }

  void stopPolling() {
    timer?.cancel();
    timer = null;
    print("Polling stopped.");
  }

  void enablePolling() {
    // Enable polling again by setting stop to true
    print("Polling enabled.");
  }

  /// Fetch and process unread notifications
  Future<void> _fetchAndProcessNotifications(int userId) async {
    print("Fetching notifications for userId: $userId");

    // Fetch all notifications where isDone and isRead are false
    List<NotificationModel> notifications = await getNotifications(userId);

    if (notifications.isNotEmpty) {
      for (var notification in notifications) {
        // Only process notifications where isDone and isRead are false
        if (!notification.isDone && !notification.isRead) {
          // Check if this notification has already been processed
          if (await _isNotificationProcessed(userId, notification.id)) {
            print(
                "Skipping already processed notification: ${notification.id}");
            continue;
          }

          // Create notification
          print(
              "Creating new notification - Title: ${notification.title}, Message: ${notification.message}");
          NotificationService.createNewNotification(
            title: notification.title,
            body: notification.message,
          );

          // Mark the notification as processed
          await _markNotificationAsProcessed(userId, notification.id);

          // Call the API to mark the notification as done
          await _markNotificationAsDone(notification.id);
        }
      }

      // Optionally update lastChecked time after processing
      _updateLastChecked();
    } else {
      print("No new notifications to process.");
    }
  }

  /// Fetch notifications from the API (same method you provided)
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

  // Check if the notification has already been processed
  Future<bool> _isNotificationProcessed(int userId, int notificationId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String processedNotificationsKey = 'processed_notifications_$userId';
    List<String>? processedNotifications =
        prefs.getStringList(processedNotificationsKey);

    return processedNotifications?.contains(notificationId.toString()) ?? false;
  }

  // Mark the notification as processed by storing its ID
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

  // Update lastChecked time in SharedPreferences without microseconds
  Future<void> _updateLastChecked() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String currentTime =
        DateTime.now().toIso8601String().split('.')[0]; // Exclude microseconds

    print("Updating lastChecked time: $currentTime");

    await prefs.setString('lastChecked', currentTime);
  }

  /// Retrieve the lastChecked time from SharedPreferences
  Future<String> getLastChecked() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String lastChecked =
        prefs.getString('lastChecked') ?? DateTime.now().toIso8601String();
    print("Retrieved lastChecked time: $lastChecked");
    return lastChecked;
  }

  /// Call the API to mark the notification as done
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
