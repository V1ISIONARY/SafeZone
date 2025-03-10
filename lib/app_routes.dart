import 'package:go_router/go_router.dart';
import 'package:safezone/backend/models/dangerzoneModel/incident_report_request_model.dart';
import 'package:safezone/backend/models/safezoneModel/safezone_model.dart';
import 'package:safezone/backend/models/userModel/circle_model.dart';
import 'package:safezone/frontend/pages/admin/admin_initial_screen.dart';
import 'package:safezone/frontend/pages/admin/admin_reports.dart';
import 'package:safezone/frontend/pages/admin/admin_reports_details.dart';
import 'package:safezone/frontend/pages/admin/admin_safezone_details.dart';
import 'package:safezone/frontend/pages/admin/admin_safezones.dart';
import 'package:safezone/frontend/pages/admin/main_analytics.dart';
import 'package:safezone/frontend/pages/authentication/account_details.dart';
//import 'package:safezone/frontend/pages/admin/main_analytics.dart';
import 'package:safezone/frontend/pages/authentication/register.dart';
import 'package:safezone/backend/models/dangerzoneModel/incident_report_model.dart';
import 'package:safezone/frontend/pages/authentication/login.dart';
import 'package:safezone/frontend/pages/introduction/splash_screen.dart';
import 'package:safezone/frontend/pages/introduction/starter.dart';
import 'package:safezone/frontend/pages/main-screen/home_page/circle/create_new_group.dart';
import 'package:safezone/frontend/pages/main-screen/home_page/circle/generate_new_code.dart';
import 'package:safezone/frontend/pages/main-screen/home_page/circle/join_group.dart';
import 'package:safezone/frontend/pages/main-screen/home_page/circle/list_of_groups.dart';
import 'package:safezone/frontend/pages/main-screen/home_page/circle/list_of_members.dart';
import 'package:safezone/frontend/pages/main-screen/notifications_page/reports/reports_history_information.dart';
import 'package:safezone/frontend/pages/main-screen/notifications_page/reports/reports_history.dart';
import 'package:safezone/frontend/pages/main-screen/notifications_page/reports/reports_status_history.dart';
import 'package:safezone/frontend/pages/main-screen/notifications_page/safezone/safe_zone_history.dart';
import 'package:safezone/frontend/pages/main-screen/notifications_page/safezone/safe_zone_history_information.dart';
import 'package:safezone/frontend/pages/main-screen/home_page/report-incident/create_report.dart';
import 'package:safezone/frontend/pages/main-screen/home_page/report-incident/report_success.dart';
import 'package:safezone/frontend/pages/main-screen/home_page/report-incident/review_report.dart';
import 'package:safezone/frontend/pages/main-screen/home_page/safe-zone/mark_safe_success.dart';
import 'package:safezone/frontend/pages/main-screen/home_page/safe-zone/create_safe_zone.dart';
import 'package:safezone/frontend/pages/main-screen/home_page/safe-zone/review_safe_zone.dart';
import 'package:safezone/frontend/pages/main-screen/notifications_page/safezone/safe_zone_status_history.dart';
import 'package:safezone/frontend/pages/main-screen/settings_page/about.dart';
import 'package:safezone/frontend/pages/main-screen/settings_page/privacy_security.dart';
import 'package:safezone/frontend/pages/main-screen/settings_page/term-policy/main_terms_policy.dart';
import 'package:safezone/frontend/pages/main-screen/settings_page/user_guide.dart';
import 'package:safezone/frontend/pages/main-screen/sos_page/sos.dart';
import 'package:safezone/frontend/pages/main-screen/sos_page/sos_cancel.dart';
import 'package:safezone/frontend/pages/main-screen/sos_page/sos_countdown.dart';
import 'package:safezone/frontend/pages/main-screen/sos_page/sos_success.dart';
import 'package:safezone/frontend/widgets/bottom_navigation.dart';

GoRouter appRouter(bool isFirstRun, String? userToken) => GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => isFirstRun
              ? const SplashScreen()
              : BottomNavigationWidget(userToken: userToken ?? 'guest'),
        ),
        // // GoRoute(
        // //   path: '/',
        // //   builder: (context, state) => MainAnalytics(initialPage: 0),
        // // ),
        GoRoute(
            path: '/home',
            builder: (context, state) {
              final token = state.extra as String;
              return BottomNavigationWidget(userToken: token ?? 'guest');
            }),

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
          builder: (context, state) {
            final report = state.extra as IncidentReportRequestModel;
            return ReviewReport(reportInfo: report);
          },
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
          path: '/safezone-history',
          builder: (context, state) => const SafezoneHistory(),
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
        // GoRoute(
        //   path: '/members-list',
        //   builder: (context, state) => const ListOfMembers(),
        // ),
        // GoRoute(
        //   path: '/members-list',
        //   builder: (context, state) {
        //     final groupId = state.extra as Int;
        //     return ListOfMembers(groupID: state.extra);
        //   },
        // ),
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
        GoRoute(
          path: '/sos-cancelled',
          builder: (context, state) => const SosCancelled(),
        ),

        // CIRCLE/GROUP ROUTES

        GoRoute(
          path: '/groups-list',
          builder: (context, state) => const ListOfGroups(),
        ),

        GoRoute(
          path: '/members/:circleId', // Add dynamic route
          builder: (context, state) {
            final circleId = int.parse(state.pathParameters['circleId']!);
            final group = state.extra as CircleModel;
            return ListOfMembers(
              circleId: circleId,
              circleInfo: group,
            ); // Pass circleId to the widget
          },
        ),

        GoRoute(
          path: '/generate-group-code',
          builder: (context, state) => const GenerateNewCode(),
        ),

        GoRoute(
          path: '/create-new-group',
          builder: (context, state) => const CreateNewGroup(),
        ),

        GoRoute(
          path: '/join-group',
          builder: (context, state) => const JoinGroup(),
        ),

        // SETTINGS ROUTES

        GoRoute(
          path: '/accountDetails',
          builder: (context, state) => const AccountDetails(),
        ),
        GoRoute(
          path: '/privacySecurity',
          builder: (context, state) => const PrivacySecurity(),
        ),
        GoRoute(
          path: '/termsPolicy',
          builder: (context, state) => const TermsPolicy(),
        ),
        GoRoute(
          path: '/userGuide',
          builder: (context, state) => const UserGuide(),
        ),
        GoRoute(
          path: '/analytics',
          builder: (context, state) => const MainAnalytics(initialPage: 0),
        ),
        GoRoute(
          path: '/about',
          builder: (context, state) => const About(),
        ),
        GoRoute(
          path: '/starter',
          builder: (context, state) => const Starter(),
        ),
        GoRoute(
          path: '/login',
          builder: (context, state) => const Login(),
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
            final extra = state.extra as Map<String, dynamic>;
            final reportModel = extra['reportModel'] as IncidentReportModel;
            final address = extra['address'] as String;

            return AdminReportsDetails(
                reportInfo: reportModel, address: address);
          },
        ),

        GoRoute(
          path: '/admin-safezone-details',
          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>;
            final safezone = extra['safezone'] as SafeZoneModel;
            final address = extra['address'] as String;
            final Function(SafeZoneModel)? onStatusChanged =
                extra['onStatusChanged'] as Function(SafeZoneModel)?;

            return AdminSafezoneDetails(
              safezonemodel: safezone,
              address: address,
              onStatusChanged: onStatusChanged,
            );
          },
        ),

        GoRoute(
          path: '/admin-reports-details',
          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>;
            final reportModel = extra['reportModel'] as IncidentReportModel;
            final address = extra['address'] as String;
            final Function(IncidentReportModel)? onStatusChanged =
                extra['onStatusChanged'] as Function(IncidentReportModel)?;

            return AdminReportsDetails(
              reportInfo: reportModel,
              address: address,
              onStatusChanged: onStatusChanged,
            );
          },
        ),
      ],
    );
