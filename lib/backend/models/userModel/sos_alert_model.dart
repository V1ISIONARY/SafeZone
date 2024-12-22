class SOSAlertModel {
  final int id;
  final int userId;
  final String alertTime;
  final double latitude;
  final double longitude;
  final String status;

  SOSAlertModel({
    required this.id,
    required this.userId,
    required this.alertTime,
    required this.latitude,
    required this.longitude,
    required this.status,
  });

  factory SOSAlertModel.fromJson(Map<String, dynamic> json) {
    return SOSAlertModel(
      id: json['id'],
      userId: json['user_id'],
      alertTime: json['alert_time'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'alert_time': alertTime,
      'latitude': latitude,
      'longitude': longitude,
      'status': status,
    };
  }
}
