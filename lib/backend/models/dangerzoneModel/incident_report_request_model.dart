import 'dart:io';

class IncidentReportRequestModel {
  final int? id;
  final int? userId;
  final int? dangerZoneId;
  final String? description;
  final String? reportDate;
  final String? reportTime;
  final List<File>? images;
  final String? reportTimestamp;
  final double? latitude;
  final double? longitude;
  final double? radius;
  final String? name;

  IncidentReportRequestModel({
    this.id,
    this.userId,
    this.dangerZoneId,
    this.description,
    this.reportDate,
    this.reportTime,
    this.images,
    this.reportTimestamp,
    this.latitude,
    this.longitude,
    this.radius,
    this.name,
  });

  factory IncidentReportRequestModel.fromJson(Map<String, dynamic> json) {
    return IncidentReportRequestModel(
      id: json['id'], 
      userId: json['user_id'],
      dangerZoneId: json['danger_zone_id'],
      description: json['description'],
      reportDate: json['report_date'],
      reportTime: json['report_time'],
      reportTimestamp: json['report_timestamp'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      radius: json['radius'],
      name: json['name'],
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
      'report_timestamp': reportTimestamp,
      'latitude': latitude,
      'longitude': longitude,
      'radius': radius,
      'name': name,
    };
  }
}
