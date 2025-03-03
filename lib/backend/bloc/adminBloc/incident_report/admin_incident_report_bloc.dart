import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safezone/backend/apiservice/adminApi/incident_reportApi/admin_incident_repo.dart';
import 'package:safezone/backend/bloc/adminBloc/incident_report/admin_incident_report_event.dart';
import 'package:safezone/backend/bloc/adminBloc/incident_report/admin_incident_report_state.dart';

class AdminIncidentReportBloc extends Bloc<AdminIncidentReportEvent, AdminIncidentReportState> {
  final AdminIncidentReportRepository incidentReportAdminRepository;

  AdminIncidentReportBloc(this.incidentReportAdminRepository)
      : super(IncidentReportInitial()) {
    on<VerifyIncidentReport>(_onVerifyIncidentReport);
    on<RejectIncidentReport>(_onRejectIncidentReport);
    on<ReviewIncidentReport>(_onReviewIncidentReport);
  }

  Future<void> _onVerifyIncidentReport(
      VerifyIncidentReport event, Emitter<AdminIncidentReportState> emit) async {
    emit(IncidentReportLoading());
    try {
      final updatedReport =
          await incidentReportAdminRepository.verifyIncidentReport(event.id);
      if (updatedReport != null) {
        emit(IncidentReportUpdated(updatedReport, "Report verified successfully."));
      } else {
        emit(IncidentReportError("Failed to verify report."));
      }
    } catch (e) {
      emit(IncidentReportError("Failed to verify report: ${e.toString()}"));
    }
  }

  Future<void> _onRejectIncidentReport(
      RejectIncidentReport event, Emitter<AdminIncidentReportState> emit) async {
    emit(IncidentReportLoading());
    try {
      final updatedReport =
          await incidentReportAdminRepository.rejectIncidentReport(event.id);
      if (updatedReport != null) {
        emit(IncidentReportUpdated(updatedReport, "Report rejected successfully."));
      } else {
        emit(IncidentReportError("Failed to reject report."));
      }
    } catch (e) {
      emit(IncidentReportError("Failed to reject report: ${e.toString()}"));
    }
  }

  Future<void> _onReviewIncidentReport(
      ReviewIncidentReport event, Emitter<AdminIncidentReportState> emit) async {
    emit(IncidentReportLoading());
    try {
      final updatedReport =
          await incidentReportAdminRepository.reviewIncidentReport(event.id);
      if (updatedReport != null) {
        emit(IncidentReportUpdated(updatedReport, "Report under review."));
      } else {
        emit(IncidentReportError("Failed to review report."));
      }
    } catch (e) {
      emit(IncidentReportError("Failed to review report: ${e.toString()}"));
    }
  }
}