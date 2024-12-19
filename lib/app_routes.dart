import 'package:go_router/go_router.dart';
import 'package:safezone/frontend/pages/main-screen/map.dart';
import 'package:safezone/frontend/pages/main-screen/report-danger-zone/create_report.dart';
import 'package:safezone/frontend/pages/main-screen/report-danger-zone/report_success.dart';
import 'package:safezone/frontend/pages/main-screen/report-danger-zone/reports_history.dart';
import 'package:safezone/frontend/pages/main-screen/report-danger-zone/submit_report.dart';
import 'package:safezone/frontend/pages/main-screen/safe-zone/mark_safe_zone.dart';

final GoRouter appRouter = GoRouter(routes: [
  GoRoute(
    path: '/',
    builder: (context, state) => const Map(),
  ),
  GoRoute(
      path: '/create-report',
      builder: (context, state) => const CreateReport()),
  GoRoute(
      path: '/review-report',
      builder: (context, state) => const ReviewReport()),
  GoRoute(
      path: '/report-success',
      builder: (context, state) => const ReportSuccess()),
  GoRoute(
      path: '/reports-history',
      builder: (context, state) => const ReportsHistory()),
  GoRoute(
      path: '/mark-safe-zone',
      builder: (context, state) => const MarkSafeZone()),
]);
