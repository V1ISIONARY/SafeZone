import 'dart:async';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:safezone/backend/models/userModel/notifications_model.dart';

class NotificationPollingService {
  final String baseUrl = '${dotenv.env['API_URL']}/notifications';
  Timer? _timer;

  /// Start polling for new unread notifications every [intervalInSeconds] seconds
  void startPolling(int userId, String lastChecked, int intervalInSeconds) {
    _timer = Timer.periodic(Duration(seconds: intervalInSeconds), (_) async {
      await _fetchNewUnreadNotifications(userId, lastChecked);
    });
  }

  /// Stop the polling
  void stopPolling() {
    _timer?.cancel();
  }

  /// Fetch new unread notifications
  Future<void> _fetchNewUnreadNotifications(
      int userId, String lastChecked) async {
    final String url = '$baseUrl/unread/$userId?last_checked=$lastChecked';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        Map<String, dynamic> result = {
          'unread_count': data['unread_count'],
          'notifications': (data['notifications'] as List)
              .map((item) => NotificationModel.fromJson(item))
              .toList(),
          'last_checked': data['last_checked'],
        };

        print("Unread Notifications Count: ${result['unread_count']}");
        print("Notifications: ${result['notifications']}");
      } else {
        throw Exception(
            "Failed to load new unread notifications. Status Code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching new unread notifications: $e");
    }
  }
}
