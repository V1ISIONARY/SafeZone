class SafeZoneModel {
  int? id;
  int? userId;
  bool? isVerified;
  double? latitude;
  double? longitude;
  double? radius;
  String? name;
  double? scale;
  String? description;
  String? timeOfDay;
  String? frequency;
  String? status;
  String? reportTimestamp;
  List<SafeZoneStatusHistoryModel>? statusHistory;

  SafeZoneModel(
      {this.id,
      this.userId,
      this.isVerified,
      this.latitude,
      this.longitude,
      this.radius,
      this.name,
      this.scale,
      this.description,
      this.timeOfDay,
      this.frequency,
      this.status,
      this.reportTimestamp,
      this.statusHistory});

  factory SafeZoneModel.fromJson(Map<String, dynamic> json) {
    return SafeZoneModel(
      id: json['id'],
      userId: json['user_id'],
      isVerified: json['is_verified'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      radius: json['radius'],
      name: json['name'],
      scale: json['scale'],
      description: json['description'],
      timeOfDay: json['time_of_day'],
      frequency: json['frequency'],
      status: json['status'],
      reportTimestamp: json['report_timestamp'],
      statusHistory: json['status_history'] != null
          ? (json['status_history'] as List)
              .map((e) => SafeZoneStatusHistoryModel.fromJson(e))
              .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'is_verified': isVerified,
      'latitude': latitude,
      'longitude': longitude,
      'radius': radius,
      'name': name,
      'scale': scale,
      'description': description,
      'time_of_day': timeOfDay,
      'frequency': frequency,
      'status': status,
      'report_timestamp': reportTimestamp,
      'status_history': statusHistory?.map((e) => e.toJson()).toList(),
    };
  }
}

class SafeZoneStatusHistoryModel {
  final int id;
  final int safeZoneId;
  final String status;
  final String timestamp;
  final String? remarks;

  SafeZoneStatusHistoryModel({
    required this.id,
    required this.safeZoneId,
    required this.status,
    required this.timestamp,
    this.remarks,
  });

  factory SafeZoneStatusHistoryModel.fromJson(Map<String, dynamic> json) {
    return SafeZoneStatusHistoryModel(
      id: json['id'],
      safeZoneId: json['safe_zone_id'],
      status: json['status'],
      timestamp: json['timestamp'],
      remarks: json['remarks'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'safe_zone_id': safeZoneId,
      'status': status,
      'timestamp': timestamp,
      'remarks': remarks,
    };
  }
}
