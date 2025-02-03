import 'package:equatable/equatable.dart';
import 'package:safezone/backend/models/dangerzoneModel/incident_report_request_model.dart';

abstract class IncidentReportEvent extends Equatable {
  const IncidentReportEvent();

  @override
  List<Object?> get props => [];
}

class FetchIncidentReports extends IncidentReportEvent {}

class FetchIncidentReport extends IncidentReportEvent {
  final int id;

  const FetchIncidentReport(this.id);

  @override
  List<Object?> get props => [id];
}

class FetchIncidentReportsByDangerZoneId extends IncidentReportEvent {
  final int id;

  const FetchIncidentReportsByDangerZoneId(this.id);

  @override
  List<Object?> get props => [id];
}

class FetchIncidentReportByStatus extends IncidentReportEvent {
  final String status;

  const FetchIncidentReportByStatus(this.status);

  @override
  List<Object?> get props => [status];
}

class FetchIncidentReportsByUserId extends IncidentReportEvent {
  final int userId;

  const FetchIncidentReportsByUserId(this.userId);

  @override
  List<Object?> get props => [userId];
}

class FetchIncidentStatus extends IncidentReportEvent {
  final int id;

  const FetchIncidentStatus(this.id);

  @override
  List<Object?> get props => [id];
}

class CreateIncidentReport extends IncidentReportEvent {
  final IncidentReportRequestModel incidentReport;

  const CreateIncidentReport(this.incidentReport);

  @override
  List<Object?> get props => [incidentReport];
}

class UpdateIncidentReport extends IncidentReportEvent {
  final IncidentReportRequestModel incidentReport;

  const UpdateIncidentReport(this.incidentReport);

  @override
  List<Object?> get props => [incidentReport];
}

class DeleteIncidentReport extends IncidentReportEvent {
  final int id;

  const DeleteIncidentReport(this.id);

  @override
  List<Object?> get props => [id];
}
