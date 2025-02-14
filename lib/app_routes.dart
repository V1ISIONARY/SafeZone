import 'package:go_router/go_router.dart';
import 'package:safezone/backend/models/safezoneModel/safezone_model.dart';
import 'package:safezone/frontend/pages/admin/admin_initial_screen.dart';
import 'package:safezone/frontend/pages/admin/admin_reports.dart';
import 'package:safezone/frontend/pages/admin/admin_reports_details.dart';
import 'package:safezone/frontend/pages/admin/admin_safezone_details.dart';
import 'package:safezone/frontend/pages/admin/admin_safezones.dart';
import 'package:safezone/frontend/pages/authentication/register.dart';
import 'package:safezone/backend/models/dangerzoneModel/incident_report_model.dart';
import 'package:safezone/frontend/pages/authentication/login.dart';
import 'package:safezone/frontend/pages/introduction/splash_screen.dart';
import 'package:safezone/frontend/pages/main-screen/notifications_page/reports/reports_history_information.dart';
import 'package:safezone/frontend/pages/main-screen/notifications_page/reports/reports_history.dart';
import 'package:safezone/frontend/pages/main-screen/notifications_page/reports/reports_status_history.dart';
import 'package:safezone/frontend/pages/main-screen/notifications_page/safezone/safe_zone_history_information.dart';
import 'package:safezone/frontend/pages/main-screen/home_page/report-incident/create_report.dart';
import 'package:safezone/frontend/pages/main-screen/home_page/report-incident/report_success.dart';
import 'package:safezone/frontend/pages/main-screen/home_page/report-incident/submit_report.dart';
import 'package:safezone/frontend/pages/main-screen/home_page/safe-zone/mark_safe_success.dart';
import 'package:safezone/frontend/pages/main-screen/home_page/safe-zone/mark_safe_zone.dart';
import 'package:safezone/frontend/pages/main-screen/home_page/safe-zone/review_safe_zone.dart';
import 'package:safezone/frontend/pages/main-screen/notifications_page/safezone/safe_zone_status_history.dart';
import 'package:safezone/frontend/pages/main-screen/sos_page/sos.dart';
import 'package:safezone/frontend/pages/main-screen/sos_page/sos_countdown.dart';
import 'package:safezone/frontend/pages/main-screen/sos_page/sos_success.dart';
import 'package:safezone/frontend/widgets/bottom_navigation.dart';

GoRouter appRouter(bool isFirstRun) => GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) =>
              isFirstRun ? const SplashScreen() : BottomNavigationWidget(userToken: 'guess'),
        ),
        GoRoute(
          path: '/home',
          builder: (context, state) => BottomNavigationWidget(userToken: 'guess'),
        ),
        GoRoute(
          path: '/register',
          builder: (context, state) => const RegisterScreen(),
        ),
        GoRoute(
          path: '/login',
          builder: (context, state) => const Login(),
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
            final incidentReport = state.extra as IncidentReportModel;
            return ReportsHistoryDetails(reportInfo: incidentReport);
          },
        ),
        GoRoute(
          path: '/reports-status-history',
          builder: (context, state) {
            final incidentReport = state.extra as IncidentReportModel;
            return ReportsStatusHistory(reportInfo: incidentReport);
          },
        ),
        GoRoute(
          path: '/mark-safe-zone',
          builder: (context, state) => const MarkSafeZone(),
        ),
        GoRoute(
          path: '/review-safe-zone',
          builder: (context, state) {
            final safeZone = state.extra as SafeZoneModel;
            return ReviewSafezone(safeZone: safeZone);
          },
        ),
        GoRoute(
          path: '/safezone-history-details',
          builder: (context, state) {
            final safezone = state.extra as SafeZoneModel;
            return SafeZoneHistoryDetails(safezonemodel: safezone);
          },
        ),
        GoRoute(
          path: '/safezone-status-history',
          builder: (context, state) {
            final safezone = state.extra as SafeZoneModel;
            return SafeZoneStatusHistory(safezonemodel: safezone);
          },
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

        // ADMIN ROUTES
        GoRoute(
          path: '/admin-initial-screen',
          builder: (context, state) => const AdminInitialScreen(),
        ),
        GoRoute(
          path: '/admin-safezones',
          builder: (context, state) => const AdminSafezones(),
        ),
        GoRoute(
          path: '/admin-reports',
          builder: (context, state) => const AdminReports(),
        ),
        GoRoute(
          path: '/admin-reports-details',
          builder: (context, state) {
            final incidentReport = state.extra as IncidentReportModel;
            return AdminReportsDetails(reportInfo: incidentReport);
          },
        ),
        GoRoute(
          path: '/admin-safezone-details',
          builder: (context, state) {
            final safezone = state.extra as SafeZoneModel;
            return AdminSafezoneDetails(safezonemodel: safezone);
          },
        ),

      ],
    );
