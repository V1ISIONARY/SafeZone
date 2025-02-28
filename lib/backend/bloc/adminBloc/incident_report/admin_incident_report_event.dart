import 'package:equatable/equatable.dart';

abstract class AdminIncidentReportEvent extends Equatable {
  const AdminIncidentReportEvent();

  @override
  List<Object> get props => [];
}

class VerifyIncidentReport extends AdminIncidentReportEvent {
  final int id;

  const VerifyIncidentReport(this.id);

  @override
  List<Object> get props => [id];
}

class RejectIncidentReport extends AdminIncidentReportEvent {
  final int id;

  const RejectIncidentReport(this.id);

  @override
  List<Object> get props => [id];
}

class ReviewIncidentReport extends AdminIncidentReportEvent {
  final int id;

  const ReviewIncidentReport(this.id);

  @override
  List<Object> get props => [id];
}