import 'package:safezone/backend/models/userModel/notifications_model.dart';

abstract class NotificationRepository {
  Future<List<NotificationModel>> getNotifications(int userId);
  Future<bool> markAsRead(int notificationId);
  Future<bool> deleteNotification(int notificationId);
  Future<bool> sendNotification(
      int userId, String title, String message, String type);
  Future<int> getUnreadNotificationsCount(int userId);
  Future<Map<String, dynamic>> getNewUnreadNotifications(
      int userId, String lastChecked);
}
