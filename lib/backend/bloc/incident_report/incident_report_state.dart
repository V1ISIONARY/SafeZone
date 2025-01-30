import 'package:safezone/backend/models/dangerzoneModel/incident_report_model.dart';
import 'package:equatable/equatable.dart';
import 'package:safezone/backend/models/dangerzoneModel/status_update_model.dart';

abstract class IncidentReportState extends Equatable {
  const IncidentReportState();

  @override
  List<Object?> get props => [];
}

class IncidentReportInitial extends IncidentReportState {}

class IncidentReportLoading extends IncidentReportState {}

class IncidentReportLoaded extends IncidentReportState {
  final List<IncidentResponse> incidentReports;

  const IncidentReportLoaded(this.incidentReports);

  @override
  List<Object?> get props => [incidentReports];
}

class SingleIncidentReportLoaded extends IncidentReportState {
  final IncidentReportModel incidentReport;

  const SingleIncidentReportLoaded(this.incidentReport);

  @override
  List<Object?> get props => [incidentReport];
}

class IncidentReportError extends IncidentReportState {
  final String message;

  const IncidentReportError(this.message);

  @override
  List<Object?> get props => [message];
}

class IncidentReportCreated extends IncidentReportState {}

class IncidentReportUpdated extends IncidentReportState {}

class IncidentReportDeleted extends IncidentReportState {}

class IncidentStastusInitial extends IncidentReportState {}

class IncidentStatusLoading extends IncidentReportState {}

class IncidentStatusLoaded extends IncidentReportState {
  final List<StatusHistory> incidentReports;

  const IncidentStatusLoaded(this.incidentReports);

  @override
  List<Object?> get props => [incidentReports];
}

class IncidentStatusError extends IncidentReportState {
  final String message;

  const IncidentStatusError(this.message);

  @override
  List<Object?> get props => [message];
}
