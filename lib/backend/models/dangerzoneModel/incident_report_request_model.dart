class IncidentReportRequestModel {
  final int userId;
  final int dangerZoneId;
  final String description;
  final String reportDate;
  final String reportTime;
  final List<String>? images;
  final String reportTimestamp;
  final String status;
  final String updatedAt;
  final double latitude;
  final double longitude;
  final double radius;
  final String name;

  IncidentReportRequestModel({
    required this.userId,
    required this.dangerZoneId,
    required this.description,
    required this.reportDate,
    required this.reportTime,
    this.images,
    required this.reportTimestamp,
    required this.status,
    required this.updatedAt,
    required this.latitude,
    required this.longitude,
    required this.radius,
    required this.name,
  });

  factory IncidentReportRequestModel.fromJson(Map<String, dynamic> json) {
    return IncidentReportRequestModel(
      userId: json['user_id'],
      dangerZoneId: json['danger_zone_id'],
      description: json['description'],
      reportDate: json['report_date'],
      reportTime: json['report_time'],
      images: json['images'] != null ? List<String>.from(json['images']) : null,
      reportTimestamp: json['report_timestamp'],
      status: json['status'],
      updatedAt: json['updated_at'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      radius: json['radius'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'danger_zone_id': dangerZoneId,
      'description': description,
      'report_date': reportDate,
      'report_time': reportTime,
      'images': images,
      'report_timestamp': reportTimestamp,
      'status': status,
      'updated_at': updatedAt,
      'latitude': latitude,
      'longitude': longitude,
      'radius': radius,
      'name': name,
    };
  }
}
