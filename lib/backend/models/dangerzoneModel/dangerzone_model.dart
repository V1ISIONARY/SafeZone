import 'package:safezone/backend/models/dangerzoneModel/incident_report_model.dart';

class DangerZoneModel {
  final int id;
  final bool isVerified;
  final double latitude;
  final double longitude;
  final double radius;
  final String name;
  final List<IncidentReportModel>? incidentReports;

  DangerZoneModel({
    required this.id,
    required this.isVerified,
    required this.latitude,
    required this.longitude,
    required this.radius,
    required this.name,
    this.incidentReports,
  });

  factory DangerZoneModel.fromJson(Map<String, dynamic> json) {
    return DangerZoneModel(
      id: json['id'],
      isVerified: json['is_verified'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      radius: json['radius'],
      name: json['name'],
      incidentReports: json['incident_reports'] != null
          ? (json['incident_reports'] as List)
              .map((report) => IncidentReportModel.fromJson(report))
              .toList()
          : null,
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
      'incident_reports':
          incidentReports?.map((report) => report.toJson()).toList(),
    };
  }
}
