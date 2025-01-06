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

