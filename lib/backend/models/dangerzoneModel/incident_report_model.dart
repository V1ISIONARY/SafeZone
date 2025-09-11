import 'package:safezone/backend/models/dangerzoneModel/status_update_model.dart';

class IncidentReportModel {
  int? id;
  int? userId;
  int? dangerZoneId;
  String? description;
  String? reportDate;
  String? reportType;
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
    this.reportType,
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
      reportType: json['report_type'],
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
      'report_type': reportType,
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
  final bool showMap;
  final String? status;             // ✅ added
  final String? reportTimestamp;    // ✅ added

  DangerZoneModel({
    required this.id,
    required this.isVerified,
    required this.latitude,
    required this.longitude,
    required this.radius,
    required this.name,
    required this.showMap,
    this.status,
    this.reportTimestamp,
  });

  factory DangerZoneModel.fromJson(Map<String, dynamic> json) {
    return DangerZoneModel(
      id: json['id'],
      isVerified: json['is_verified'],
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
      radius: json['radius']?.toDouble(),
      name: json['name']?.toString(),
      showMap: json['show_map'] ?? false,
      status: json['status']?.toString(),               // ✅ added
      reportTimestamp: json['report_timestamp']?.toString(), // ✅ added
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'is_verified': isVerified,
      'latitude': latitude,
      'longitude': longitude,
      'radius': radius,
      'name': name,
      'show_map': showMap,
      'status': status,
      'report_timestamp': reportTimestamp,
    };
  }
}