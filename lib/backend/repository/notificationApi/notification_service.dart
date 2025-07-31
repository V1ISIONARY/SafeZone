import 'package:awesome_notifications/awesome_notifications.dart';

class NotificationService {
  static Future<void> createNewNotification({
    required String title,
    required String body,
    required String typeOfNotif,
  }) async {
    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) return;

    String largeIconPath;
    switch (typeOfNotif) {
      case 'SOS':
        largeIconPath =
            'https://firebasestorage.googleapis.com/v0/b/safezone-11724.firebasestorage.app/o/notification_icons%2Fsosnotif.png?alt=media&token=ce18224e-60ae-41b2-a747-e45878f33cb7';
        break;
      case 'Danger':
        largeIconPath =
            'https://firebasestorage.googleapis.com/v0/b/safezone-11724.firebasestorage.app/o/notification_icons%2Fdangerzone.png?alt=media&token=5fe5b7cf-b444-470d-bc10-c2ade958a58c';
        break;
      case 'Safe':
        largeIconPath =
            'https://firebasestorage.googleapis.com/v0/b/safezone-11724.firebasestorage.app/o/notification_icons%2Fsafezone.png?alt=media&token=a36321d7-d56d-4441-ad1d-6d495104665a';
        break;
      case 'Group':
        largeIconPath = 'assets/icons/group_icon.png';
        break;
      case 'Logo':
        largeIconPath =
            'https://firebasestorage.googleapis.com/v0/b/safezone-11724.firebasestorage.app/o/notification_icons%2Flogo.png?alt=media&token=754ec6fe-0ea0-4ae1-b663-533efdb26af9';
        break;
      default:
        largeIconPath =
            'https://firebasestorage.googleapis.com/v0/b/safezone-11724.firebasestorage.app/o/notification_icons%2Flogo.png?alt=media&token=754ec6fe-0ea0-4ae1-b663-533efdb26af9'; // fallback/default
    }

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: DateTime.now()
            .millisecondsSinceEpoch
            .remainder(100000), // Unique ID
        channelKey: 'alerts',
        title: title, // Use the passed title
        body: body, // Use the passed message (renamed to 'body')
        largeIcon: largeIconPath,
        // bigPicture:
        //     'https://storage.googleapis.com/cms-storage-bucket/d406c736e7c4c57f5f61.png',

        notificationLayout: NotificationLayout.BigPicture,
        payload: {'notificationId': '1234567890'},
      ),
      actionButtons: [
        NotificationActionButton(key: 'REDIRECT', label: 'Redirect'),
        NotificationActionButton(
            key: 'REPLY', label: 'Reply', requireInputText: false),
        NotificationActionButton(
            key: 'DISMISS',
            label: 'Dismiss',
            actionType: ActionType.DismissAction,
            isDangerousOption: true),
      ],
    );
  }
}
