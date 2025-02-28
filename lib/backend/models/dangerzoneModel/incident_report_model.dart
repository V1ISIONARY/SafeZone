import 'package:safezone/backend/models/dangerzoneModel/status_update_model.dart';

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
  String? updatedAt;
  DangerZoneModel? dangerZone;
  List<IncidentReportStatusHistoryModel>? statusHistory;

  IncidentReportModel({
    this.id,
    this.userId,
    this.dangerZoneId,
    this.description,
    this.reportDate,
    this.reportTime,
    this.images,
    this.reportTimestamp,
    this.status,
    this.updatedAt,
    this.dangerZone,
    this.statusHistory,
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
      dangerZone: json['danger_zone'] != null
          ? DangerZoneModel.fromJson(json['danger_zone'])
          : null,
      statusHistory: json['status_history'] != null
          ? (json['status_history'] as List)
              .map((e) => IncidentReportStatusHistoryModel.fromJson(e))
              .toList()
          : [],
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
      'status_history': statusHistory?.map((e) => e.toJson()).toList(),
    };
  }
}

class DangerZoneModel {
  final int id;
  final bool isVerified;
  final double? latitude;
  final double? longitude;
  final double? radius;
  final String? name;

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
      latitude: json['latitude'] != null ? json['latitude'].toDouble() : null, // Handle null
      longitude: json['longitude'] != null ? json['longitude'].toDouble() : null, // Handle null
      radius: json['radius'] != null ? json['radius'].toDouble() : null, // Handle null
      name: json['name'] != null ? json['name'].toString() : null,
    );
  }
}

// class IncidentResponse {
//   final IncidentReportModel incidentReport;
//   final DangerZoneModel dangerZone;

//   IncidentResponse({
//     required this.incidentReport,
//     required this.dangerZone,
//   });

//   factory IncidentResponse.fromJson(Map<String, dynamic> json) {
//     return IncidentResponse(
//       incidentReport: IncidentReportModel.fromJson(json['incident_report']),
//       dangerZone: DangerZoneModel.fromJson(json['danger_zone']),
//     );
//   }
// }
