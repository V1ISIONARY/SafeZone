import 'package:awesome_notifications/awesome_notifications.dart';

class NotificationService {
  static Future<void> createNewNotification({
    required String title,
    required String body,
  }) async {
    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) return;

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: DateTime.now()
            .millisecondsSinceEpoch
            .remainder(100000), // Unique ID
        channelKey: 'alerts',
        title: title, // Use the passed title
        body: body, // Use the passed message (renamed to 'body')
        bigPicture:
            'https://storage.googleapis.com/cms-storage-bucket/d406c736e7c4c57f5f61.png',
        largeIcon: 'assets/images/logo.png',
        notificationLayout: NotificationLayout.BigPicture,
        payload: {'notificationId': '1234567890'},
      ),
      actionButtons: [
        NotificationActionButton(key: 'REDIRECT', label: 'Redirect'),
        NotificationActionButton(
            key: 'REPLY', label: 'Reply', requireInputText: true),
        NotificationActionButton(
            key: 'DISMISS',
            label: 'Dismiss',
            actionType: ActionType.DismissAction,
            isDangerousOption: true),
      ],
    );
  }
}
