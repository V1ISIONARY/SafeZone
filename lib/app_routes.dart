import 'package:go_router/go_router.dart';
import 'package:safezone/frontend/pages/authentication/register.dart';
import 'package:safezone/backend/models/dangerzoneModel/incident_report_model.dart';
import 'package:safezone/frontend/pages/authentication/login.dart';
import 'package:safezone/frontend/pages/main-screen/notification/reports_history_information.dart';
import 'package:safezone/frontend/pages/main-screen/report-danger-zone/create_report.dart';
import 'package:safezone/frontend/pages/main-screen/report-danger-zone/report_success.dart';
import 'package:safezone/frontend/pages/main-screen/notification/reports_history.dart';
import 'package:safezone/frontend/pages/main-screen/report-danger-zone/submit_report.dart';
import 'package:safezone/frontend/pages/main-screen/safe-zone/mark_safe_success.dart';
import 'package:safezone/frontend/pages/main-screen/safe-zone/mark_safe_zone.dart';
import 'package:safezone/frontend/pages/main-screen/sos/sos.dart';
import 'package:safezone/frontend/pages/main-screen/sos/sos_countdown.dart';
import 'package:safezone/frontend/pages/main-screen/sos/sos_success.dart';
import 'package:safezone/frontend/widgets/bottom_navigation.dart';

final GoRouter appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/',
      // builder: (context, state) => const Login(),
      builder: (context, state) => BottomNavigationWidget(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => BottomNavigationWidget(),
    ),
    GoRoute(
      path: '/create-report',
      builder: (context, state) => const CreateReport(),
    ),
    GoRoute(
      path: '/review-report',
      builder: (context, state) => const ReviewReport(),
    ),
    GoRoute(
      path: '/report-success',
      builder: (context, state) => const ReportSuccess(),
    ),
    GoRoute(
      path: '/reports-history',
      builder: (context, state) => const ReportsHistory(),
    ),
    GoRoute(
      path: '/reports-history-details',
      builder: (context, state) {
        final reportInfo = state.extra as IncidentReportModel;
        return ReportsHistoryDetails(reportInfo: reportInfo);
      },
    ),
    GoRoute(
      path: '/mark-safe-zone',
      builder: (context, state) => const MarkSafeZone(),
    ),
    GoRoute(
      path: '/mark-safe-zone-success',
      builder: (context, state) => const MarkSafeSuccess(),
    ),
    GoRoute(
      path: '/sos-page',
      builder: (context, state) => const SosPage(),
    ),
    GoRoute(
      path: '/sos-countdown',
      builder: (context, state) => const SosCountdown(),
    ),
    GoRoute(
      path: '/sos-success',
      builder: (context, state) => const SosSuccess(),
    ),
  ],
);
