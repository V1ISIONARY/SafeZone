class StatusUpdate {
  final String status;
  final DateTime timestamp;
  final String? remarks;

  StatusUpdate({
    required this.status,
    required this.timestamp,
    this.remarks,
  });

  factory StatusUpdate.fromJson(Map<String, dynamic> json) {
    return StatusUpdate(
      status: json['status'],
      timestamp: DateTime.parse(json['timestamp']),
      remarks: json['remarks'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'timestamp': timestamp.toIso8601String(),
      'remarks': remarks,
    };
  }
}

class StatusHistory {
  final int incidentId;
  final List<StatusUpdate> statusUpdates;

  StatusHistory({
    required this.incidentId,
    required this.statusUpdates,
  });

  factory StatusHistory.fromJson(Map<String, dynamic> json) {
    return StatusHistory(
      incidentId: json['incident_id'],
      statusUpdates: (json['status_updates'] as List)
          .map((update) => StatusUpdate.fromJson(update))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'incident_id': incidentId,
      'status_updates': statusUpdates.map((update) => update.toJson()).toList(),
    };
  }
}

class IncidentReportStatusHistoryModel {
  final int id;
  final int incidentReportId;
  final String status;
  final String timestamp;
  final String? remarks;

  IncidentReportStatusHistoryModel({
    required this.id,
    required this.incidentReportId,
    required this.status,
    required this.timestamp,
    this.remarks,
  });

  factory IncidentReportStatusHistoryModel.fromJson(Map<String, dynamic> json) {
    return IncidentReportStatusHistoryModel(
      id: json['id'],
      incidentReportId: json['incident_report_id'],
      status: json['status'],
      timestamp: json['timestamp'],
      remarks: json['remarks'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'incident_report_id': incidentReportId,
      'status': status,
      'timestamp': timestamp,
      'remarks': remarks,
    };
  }
}
