import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:safezone/backend/apiservice/notificationApi/notification_repo.dart';
import 'package:safezone/backend/models/userModel/notifications_model.dart';

class NotificationImplementation extends NotificationRepository {
  static String baseUrl = '${dotenv.env['API_URL']}/notifications';

  @override
  Future<List<NotificationModel>> getNotifications(int userId) async {
    final String url = '$baseUrl/$userId';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData
            .map((item) => NotificationModel.fromJson(item))
            .toList();
      } else {
        throw Exception(
            "Failed to load notifications. Status Code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching notifications: $e");
      return [];
    }
  }

  @override
  Future<bool> markAsRead(int notificationId) async {
    final String url = '$baseUrl/$notificationId';

    try {
      final response = await http.patch(Uri.parse(url));

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception(
            "Failed to mark notification as read. Status Code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error marking notification as read: $e");
      return false;
    }
  }

  @override
  Future<bool> deleteNotification(int notificationId) async {
    final String url = '$baseUrl/$notificationId';

    try {
      final response = await http.delete(Uri.parse(url));

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception(
            "Failed to delete notification. Status Code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error deleting notification: $e");
      return false;
    }
  }

  @override
  Future<bool> sendNotification(
      int userId, String title, String message, String type) async {
    final String url = baseUrl;

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "user_id": userId,
          "title": title,
          "message": message,
          "type": type,
        }),
      );

      if (response.statusCode == 201) {
        return true;
      } else {
        throw Exception(
            "Failed to send notification. Status Code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error sending notification: $e");
      return false;
    }
  }

  @override
  Future<int> getUnreadNotificationsCount(int userId) async {
    final String url = '$baseUrl/unread-count/$userId';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['unread_count'];
      } else {
        throw Exception(
            "Failed to load unread notifications count. Status Code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching unread notifications count: $e");
      return 0;
    }
  }

  @override
  Future<Map<String, dynamic>> getNewUnreadNotifications(
      int userId, String lastChecked) async {
    final String url = '$baseUrl/unread/$userId?last_checked=$lastChecked';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return {
          'unread_count': data['unread_count'],
          'notifications': (data['notifications'] as List)
              .map((item) => NotificationModel.fromJson(item))
              .toList(),
          'last_checked': data['last_checked'],
        };
      } else {
        throw Exception(
            "Failed to load new unread notifications. Status Code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching new unread notifications: $e");
      return {'unread_count': 0, 'notifications': [], 'last_checked': ''};
    }
  }
}
