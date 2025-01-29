import 'package:bloc/bloc.dart';
import 'package:safezone/backend/apiservice/incident_reportApi/incident_report_repo.dart';
import 'package:safezone/backend/bloc/incident_report/incident_report_event.dart';
import 'package:safezone/backend/bloc/incident_report/incident_report_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IncidentReportBloc
    extends Bloc<IncidentReportEvent, IncidentReportState> {
  final IncidentReportRepository _incidentReportRepository;

  IncidentReportBloc(this._incidentReportRepository)
      : super(IncidentReportInitial()) {
        
    on<FetchIncidentReports>((event, emit) async {
      try {
        emit(IncidentReportLoading());
        final incidentReports =
            await _incidentReportRepository.getIncidentReports();
        emit(IncidentReportLoaded(incidentReports));
      } catch (e) {
        emit(IncidentReportError(e.toString()));
      }
    });

    on<FetchIncidentReport>((event, emit) async {
      try {
        emit(IncidentReportLoading());
        final incidentReport =
            await _incidentReportRepository.getIncidentReport(event.id);
        emit(SingleIncidentReportLoaded(incidentReport));
      } catch (e) {
        emit(IncidentReportError(e.toString()));
      }
    });

    on<FetchIncidentReportsByDangerZoneId>((event, emit) async {
      try {
        emit(IncidentReportLoading());
        final incidentReports =
            await _incidentReportRepository.getIncidentReportsByDangerZoneId(
                event.id);
        emit(IncidentReportLoaded(incidentReports));
      } catch (e) {
        emit(IncidentReportError(e.toString()));
      }
    });

    on<FetchIncidentReportByStatus>((event, emit) async {
      try {
        emit(IncidentReportLoading());
        final incidentReports = await _incidentReportRepository
            .getIncidentReportByStatus(event.status);
        emit(IncidentReportLoaded(incidentReports));
      } catch (e) {
        emit(IncidentReportError(e.toString()));
      }
    });

    on<FetchIncidentReportsByUserId>((event, emit) async {
      try {
        emit(IncidentReportLoading());

        final SharedPreferences prefs = await SharedPreferences.getInstance();
        final int? userId = prefs.getInt('id');

        if (userId == null) {
          emit(const IncidentReportError("User ID not found in SharedPreferences"));
          return;
        }

        final incidentReports =
            await _incidentReportRepository.getIncidentReportsByUserId(userId);

        emit(IncidentReportLoaded(incidentReports));
      } catch (e) {
        emit(IncidentReportError(e.toString()));
      }
    });


    on<FetchIncidentStatus>((event, emit) async {
      try {
        emit(IncidentStatusLoading());
        final incidentStatus =
            await _incidentReportRepository.getIncidentStatus(event.id);
        emit(IncidentStatusLoaded(incidentStatus));
      } catch (e) {
        emit(IncidentStatusError(e.toString()));
      }
    });

    on<CreateIncidentReport>((event, emit) async {
      try {
        emit(IncidentReportLoading());
        final incidentReport = await _incidentReportRepository
            .createIncidentReport(event.incidentReport);
        emit(IncidentReportCreated());
      } catch (e) {
        emit(IncidentReportError(e.toString()));
      }
    });

    on<UpdateIncidentReport>((event, emit) async {
      try {
        emit(IncidentReportLoading());
        final incidentReport = await _incidentReportRepository
            .updateIncidentReport(event.incidentReport);
        emit(IncidentReportUpdated());
      } catch (e) {
        emit(IncidentReportError(e.toString()));
      }
    });

    on<DeleteIncidentReport>((event, emit) async {
      try {
        emit(IncidentReportLoading());
        await _incidentReportRepository.deleteIncidentReport(event.id);
        emit(IncidentReportDeleted());
      } catch (e) {
        emit(IncidentReportError(e.toString()));
      }
    });
  }
}
