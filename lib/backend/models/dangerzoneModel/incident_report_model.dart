class IncidentReportModel {
  int? id;
  int? userId;
  int? dangerZoneId;
  String? description;
  String? reportDate;
  String? reportTime;
  List<String>? images;
  String? reportTimestamp;
  String? status;
  final String updatedAt;

  IncidentReportModel({
    required this.id,
    required this.userId,
    required this.dangerZoneId,
    required this.description,
    required this.reportDate,
    required this.reportTime,
    this.images,
    required this.reportTimestamp,
    this.status,
    required this.updatedAt,
  });

  factory IncidentReportModel.fromJson(Map<String, dynamic> json) {
    return IncidentReportModel(
      id: json['id'],
      userId: json['user_id'],
      dangerZoneId: json['danger_zone_id'],
      description: json['description'],
      reportDate: json['report_date'],
      reportTime: json['report_time'],
      images: json['images'] != null ? List<String>.from(json['images']) : null,
      reportTimestamp: json['report_timestamp'],
      status: json['status'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'danger_zone_id': dangerZoneId,
      'description': description,
      'report_date': reportDate,
      'report_time': reportTime,
      'images': images,
      'report_timestamp': reportTimestamp,
      'status': status,
      'updated_at': updatedAt,
    };
  }
}

class DangerZoneModel {
  final int id;
  final bool isVerified;
  final double latitude;
  final double longitude;
  final double radius;
  final String name;

  DangerZoneModel({
    required this.id,
    required this.isVerified,
    required this.latitude,
    required this.longitude,
    required this.radius,
    required this.name,
  });

  factory DangerZoneModel.fromJson(Map<String, dynamic> json) {
    return DangerZoneModel(
      id: json['id'],
      isVerified: json['is_verified'],
      latitude: json['latitude'].toDouble(),
      longitude: json['longitude'].toDouble(),
      radius: json['radius'].toDouble(),
      name: json['name'],
    );
  }
}

class IncidentResponse {
  final IncidentReportModel incidentReport;
  final DangerZoneModel dangerZone;

  IncidentResponse({
    required this.incidentReport,
    required this.dangerZone,
  });

  factory IncidentResponse.fromJson(Map<String, dynamic> json) {
    return IncidentResponse(
      incidentReport: IncidentReportModel.fromJson(json['incident_report']),
      dangerZone: DangerZoneModel.fromJson(json['danger_zone']),
    );
  }
}
