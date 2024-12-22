class IncidentReportModel {
  final int id;
  final int dangerZoneId;
  final String description;
  final DateTime reportTime;

  IncidentReportModel({
    required this.id,
    required this.dangerZoneId,
    required this.description,
    required this.reportTime,
  });

  factory IncidentReportModel.fromJson(Map<String, dynamic> json) {
    return IncidentReportModel(
      id: json['id'],
      dangerZoneId: json['dangerZone_id'],
      description: json['description'],
      reportTime: DateTime.parse(json['report_time']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dangerZone_id': dangerZoneId,
      'description': description,
      'report_time': reportTime.toIso8601String(),
    };
  }
}
