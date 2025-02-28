import 'package:equatable/equatable.dart';
import 'package:safezone/backend/models/dangerzoneModel/incident_report_model.dart';

abstract class AdminIncidentReportState extends Equatable {
  const AdminIncidentReportState();

  @override
  List<Object> get props => [];
}

class IncidentReportInitial extends AdminIncidentReportState {}

class IncidentReportLoading extends AdminIncidentReportState {}

class IncidentReportUpdated extends AdminIncidentReportState {
  final IncidentReportModel reportModel;
  final String message;

  const IncidentReportUpdated(this.reportModel, this.message);

  @override
  List<Object> get props => [reportModel, message];
}

class IncidentReportError extends AdminIncidentReportState {
  final String error;

  const IncidentReportError(this.error);

  @override
  List<Object> get props => [error];
}