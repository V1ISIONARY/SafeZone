import 'package:go_router/go_router.dart';
import 'package:safezone/backend/models/safezoneModel/safezone_model.dart';
import 'package:safezone/frontend/pages/authentication/register.dart';
import 'package:safezone/backend/models/dangerzoneModel/incident_report_model.dart';
import 'package:safezone/frontend/pages/authentication/login.dart';
import 'package:safezone/frontend/pages/introduction/splash_screen.dart';
import 'package:safezone/frontend/pages/main-screen/notification/reports/reports_history_information.dart';
import 'package:safezone/frontend/pages/main-screen/notification/reports/reports_history.dart';
import 'package:safezone/frontend/pages/main-screen/report-incident/create_report.dart';
import 'package:safezone/frontend/pages/main-screen/report-incident/report_success.dart';
import 'package:safezone/frontend/pages/main-screen/report-incident/submit_report.dart';
import 'package:safezone/frontend/pages/main-screen/safe-zone/mark_safe_success.dart';
import 'package:safezone/frontend/pages/main-screen/safe-zone/mark_safe_zone.dart';
import 'package:safezone/frontend/pages/main-screen/safe-zone/review_safe_zone.dart';
import 'package:safezone/frontend/pages/main-screen/sos/sos.dart';
import 'package:safezone/frontend/pages/main-screen/sos/sos_countdown.dart';
import 'package:safezone/frontend/pages/main-screen/sos/sos_success.dart';
import 'package:safezone/frontend/widgets/bottom_navigation.dart';

GoRouter appRouter(bool isFirstRun) => GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) =>
              isFirstRun ? const SplashScreen() : BottomNavigationWidget(),
        ),
        GoRoute(
          path: '/home',
          builder: (context, state) => BottomNavigationWidget(),
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
            final reportInfo = state.extra as IncidentReportModel;
            return ReportsHistoryDetails(reportInfo: reportInfo);
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
