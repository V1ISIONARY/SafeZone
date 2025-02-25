class NotificationModel {
  final int id;
  final String title;
  final String message;
  final bool isRead;
  final String createdAt;
  final String type;
  final bool isDone;

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.isRead,
    required this.createdAt,
    required this.type,
    required this.isDone,
  });

  // Fixed copyWith method (added 'type' field)
  NotificationModel copyWith({
    int? id,
    String? title,
    String? message,
    bool? isRead,
    String? createdAt,
    String? type,
    bool? isDone,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
      type: type ?? this.type,
      isDone: isDone ?? this.isDone, // Include type in copyWith
    );
  }

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      title: json['title'],
      message: json['message'],
      isRead: json['is_read'],
      createdAt: json['created_at'],
      type: json['type'],
      isDone: json['is_done'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'is_read': isRead,
      'created_at': createdAt,
      'type': type,
      'is_done': isDone,
    };
  }
}
