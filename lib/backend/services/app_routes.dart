import 'package:go_router/go_router.dart';
import 'package:safezone/backend/models/dangerzoneModel/incident_report_request_model.dart';
import 'package:safezone/backend/models/safezoneModel/safezone_model.dart';
import 'package:safezone/backend/models/userModel/circle_model.dart';
import 'package:safezone/backend/models/userModel/notifications_model.dart';
import 'package:safezone/backend/properties/import.dart' hide NotificationModel;
import 'package:safezone/backend/properties/security/backwrapper.dart';
import 'package:safezone/frontend/platforms/desktop/widget/button/sidenav.dart';
import 'package:safezone/frontend/platforms/mobile/pages/admin/admin_initial_screen.dart';
import 'package:safezone/frontend/platforms/mobile/pages/admin/admin_reports.dart';
import 'package:safezone/frontend/platforms/mobile/pages/admin/admin_reports_details.dart';
import 'package:safezone/frontend/platforms/mobile/pages/admin/admin_safezone_details.dart';
import 'package:safezone/frontend/platforms/mobile/pages/admin/admin_safezones.dart';
import 'package:safezone/frontend/platforms/mobile/pages/admin/main_analytics.dart';
import 'package:safezone/frontend/platforms/mobile/pages/authentication/account_details.dart';
//import 'package:safezone/frontend/pages/admin/main_analytics.dart';
import 'package:safezone/frontend/platforms/mobile/pages/authentication/register.dart';
import 'package:safezone/backend/models/dangerzoneModel/incident_report_model.dart';
import 'package:safezone/frontend/platforms/mobile/pages/authentication/login.dart';
import 'package:safezone/frontend/platforms/mobile/pages/introduction/splash_screen.dart';
import 'package:safezone/frontend/platforms/mobile/pages/main-screen/home_page/circle/create_new_group.dart';
import 'package:safezone/frontend/platforms/mobile/pages/main-screen/home_page/circle/generate_new_code.dart';
import 'package:safezone/frontend/platforms/mobile/pages/main-screen/home_page/circle/join_group.dart';
import 'package:safezone/frontend/platforms/mobile/pages/main-screen/home_page/circle/list_of_groups.dart';
import 'package:safezone/frontend/platforms/mobile/pages/main-screen/home_page/circle/list_of_members.dart';
import 'package:safezone/frontend/platforms/mobile/pages/main-screen/notifications_page/main_notifications/notification_details.dart';
import 'package:safezone/frontend/platforms/mobile/pages/main-screen/notifications_page/reports/reports_history_information.dart';
import 'package:safezone/frontend/platforms/mobile/pages/main-screen/notifications_page/reports/reports_history.dart';
import 'package:safezone/frontend/platforms/mobile/pages/main-screen/notifications_page/reports/reports_status_history.dart';
import 'package:safezone/frontend/platforms/mobile/pages/main-screen/notifications_page/safezone/safe_zone_history.dart';
import 'package:safezone/frontend/platforms/mobile/pages/main-screen/notifications_page/safezone/safe_zone_history_information.dart';
import 'package:safezone/frontend/platforms/mobile/pages/main-screen/home_page/report-incident/create_report.dart';
import 'package:safezone/frontend/platforms/mobile/pages/main-screen/home_page/report-incident/report_success.dart';
import 'package:safezone/frontend/platforms/mobile/pages/main-screen/home_page/report-incident/review_report.dart';
import 'package:safezone/frontend/platforms/mobile/pages/main-screen/home_page/safe-zone/mark_safe_success.dart';
import 'package:safezone/frontend/platforms/mobile/pages/main-screen/home_page/safe-zone/create_safe_zone.dart';
import 'package:safezone/frontend/platforms/mobile/pages/main-screen/home_page/safe-zone/review_safe_zone.dart';
import 'package:safezone/frontend/platforms/mobile/pages/main-screen/notifications_page/safezone/safe_zone_status_history.dart';
import 'package:safezone/frontend/platforms/mobile/pages/main-screen/settings_page/about.dart';
import 'package:safezone/frontend/platforms/mobile/pages/main-screen/settings_page/freespace.dart';
import 'package:safezone/frontend/platforms/mobile/pages/main-screen/settings_page/help-center.dart';
import 'package:safezone/frontend/platforms/mobile/pages/main-screen/settings_page/locationservice.dart';
import 'package:safezone/frontend/platforms/mobile/pages/main-screen/settings_page/privacy.dart';
import 'package:safezone/frontend/platforms/mobile/pages/main-screen/settings_page/privacy_security.dart';
import 'package:safezone/frontend/platforms/mobile/pages/main-screen/settings_page/request_admin_access.dart';
import 'package:safezone/frontend/platforms/mobile/pages/main-screen/settings_page/term-policy/main_terms_policy.dart';
import 'package:safezone/frontend/platforms/mobile/pages/main-screen/settings_page/user_guide.dart';
import 'package:safezone/frontend/platforms/mobile/pages/main-screen/sos_page/sos.dart';
import 'package:safezone/frontend/platforms/mobile/pages/main-screen/sos_page/sos_cancel.dart';
import 'package:safezone/frontend/platforms/mobile/pages/main-screen/sos_page/sos_countdown.dart';
import 'package:safezone/frontend/platforms/mobile/pages/main-screen/sos_page/sos_success.dart';
import 'package:safezone/frontend/root/authentication/login.dart';
import 'package:safezone/frontend/root/authentication/starter.dart';
import 'package:safezone/main.dart';

import '../../frontend/root/content/navigation.dart';

GoRouter appRouter(bool isFirstRun, String? userToken) => GoRouter(
  refreshListenable: sharedController.userTokenNotifier,
  navigatorKey: navigatorKey,
  initialLocation: '/',
  redirect: (context, state) async {

    // if (isFirstRun && state.uri.toString() != '/') {
    //   return '/';
    // }

    final token = sharedController.userTokenNotifier.value ?? 'guest';
    if (
      token != "guest" &&
      (state.matchedLocation == '/login' || state.matchedLocation == '/register'
    )) {
      // print("butninam makulit: ${token}");
      return '/home';
    }

    final protectedRoutes = [
      '/create-report', '/review-report', '/report-success',
      '/reports-history', '/reports-history-details', '/reports-status-history',
      '/mark-safe-zone', '/review-safe-zone', '/safezone-history',
      '/safezone-history-details', '/safezone-status-history',
      '/notification-details', '/mark-safe-zone-success',
      '/sos-page', '/sos-countdown', '/sos-success', '/sos-cancelled',
      '/groups-list', '/members/:circleId', '/generate-group-code',
      '/create-new-group', '/join-group',
      '/accountDetails', '/request-admin-access', '/privacySecurity',
      '/location-service', '/privacy', '/termsPolicy', '/help-center',
      '/freespace', '/userGuide', '/analytics', '/about',
      '/starter', '/admin-initial-screen', '/admin-safezones',
      '/admin-reports', '/admin-reports-details', '/admin-safezone-details',
    ];

    if (token == null && protectedRoutes.contains(state.uri.toString())) {
      print('hindi ako mawawala');
      return '/login';
    }
    return null;
  },
  errorBuilder: (context, state) {
    print('object');
    return NavigationRT(userToken: userToken ?? 'guest');
  },
  routes: [
    // Splash or Navigation
    GoRoute(
      path: '/',
      pageBuilder: (context, state) => NoTransitionPage(
        child: NoBackWrapper(
          child: isFirstRun
              ? SplashScreen()
              : NavigationRT(userToken: userToken ?? 'guest'),
        ),
      ),
    ),

    // Home page
    GoRoute(
      path: '/home',
      pageBuilder: (context, state) => NoTransitionPage(
        child: NoBackWrapper(
          child: NavigationRT(
            userToken: sharedController.userTokenNotifier.value ?? 'guest',
          ),
        ),
      ),
    ),

    // Register page
    GoRoute(
      path: '/register',
      pageBuilder: (context, state) => NoTransitionPage(
        child: NoBackWrapper(child: const RegisterMD()),
      ),
    ),

    // Create report
    GoRoute(
      path: '/create-report',
      pageBuilder: (context, state) => NoTransitionPage(
        child: NoBackWrapper(child: const CreateReport()),
      ),
    ),

    // Review report
    GoRoute(
      path: '/review-report',
      pageBuilder: (context, state) => NoTransitionPage(
        child: NoBackWrapper(
          child: ReviewReport(reportInfo: state.extra as IncidentReportRequestModel),
        ),
      ),
    ),

    // Report success
    GoRoute(
      path: '/report-success',
      pageBuilder: (context, state) => NoTransitionPage(
        child: NoBackWrapper(child: const ReportSuccess()),
      ),
    ),

    // Reports history
    GoRoute(
      path: '/reports-history',
      pageBuilder: (context, state) => NoTransitionPage(
        child: NoBackWrapper(
          child: ReportsHistory(fromSuccess: state.extra as bool),
        ),
      ),
    ),

    // Reports history details
    GoRoute(
      path: '/reports-history-details',
      pageBuilder: (context, state) => NoTransitionPage(
        child: NoBackWrapper(
          child: ReportsHistoryDetails(
            reportInfo: state.extra as IncidentReportModel,
          ),
        ),
      ),
    ),

    // Reports status history
    GoRoute(
      path: '/reports-status-history',
      pageBuilder: (context, state) => NoTransitionPage(
        child: NoBackWrapper(
          child: ReportsStatusHistory(
            reportInfo: state.extra as IncidentReportModel,
          ),
        ),
      ),
    ),

    // Mark safe zone
    GoRoute(
      path: '/mark-safe-zone',
      pageBuilder: (context, state) => NoTransitionPage(
        child: NoBackWrapper(child: const MarkSafeZone()),
      ),
    ),

    // Review safe zone
    GoRoute(
      path: '/review-safe-zone',
      pageBuilder: (context, state) => NoTransitionPage(
        child: NoBackWrapper(
          child: ReviewSafezone(safeZone: state.extra as SafeZoneModel),
        ),
      ),
    ),

    // Safezone history
    GoRoute(
      path: '/safezone-history',
      pageBuilder: (context, state) => NoTransitionPage(
        child: NoBackWrapper(
          child: SafezoneHistory(fromSuccess: state.extra as bool),
        ),
      ),
    ),

    // Safezone history details
    GoRoute(
      path: '/safezone-history-details',
      pageBuilder: (context, state) => NoTransitionPage(
        child: NoBackWrapper(
          child: SafeZoneHistoryDetails(
            safezonemodel: state.extra as SafeZoneModel,
          ),
        ),
      ),
    ),

    // Safezone status history
    GoRoute(
      path: '/safezone-status-history',
      pageBuilder: (context, state) => NoTransitionPage(
        child: NoBackWrapper(
          child: SafeZoneStatusHistory(
            safezonemodel: state.extra as SafeZoneModel,
          ),
        ),
      ),
    ),

    // Notification details
    GoRoute(
      path: '/notification-details',
      pageBuilder: (context, state) => NoTransitionPage(
        child: NoBackWrapper(
          child: NotificationDetails(
            notificationModel: state.extra as NotificationModel,
          ),
        ),
      ),
    ),

    // Mark safe zone success
    GoRoute(
      path: '/mark-safe-zone-success',
      pageBuilder: (context, state) => NoTransitionPage(
        child: NoBackWrapper(child: const MarkSafeSuccess()),
      ),
    ),

    // SOS pages
    GoRoute(
      path: '/sos-page',
      pageBuilder: (context, state) => NoTransitionPage(
        child: NoBackWrapper(child: const SosPage()),
      ),
    ),
    GoRoute(
      path: '/sos-countdown',
      pageBuilder: (context, state) => NoTransitionPage(
        child: NoBackWrapper(child: const SosCountdown()),
      ),
    ),
    GoRoute(
      path: '/sos-success',
      pageBuilder: (context, state) => NoTransitionPage(
        child: NoBackWrapper(child: const SosSuccess()),
      ),
    ),
    GoRoute(
      path: '/sos-cancelled',
      pageBuilder: (context, state) => NoTransitionPage(
        child: NoBackWrapper(child: const SosCancelled()),
      ),
    ),

    // Circle / Group routes
    GoRoute(
      path: '/groups-list',
      pageBuilder: (context, state) => NoTransitionPage(
        child: NoBackWrapper(child: const ListOfGroups()),
      ),
    ),
    GoRoute(
      path: '/members/:circleId',
      pageBuilder: (context, state) => NoTransitionPage(
        child: NoBackWrapper(
          child: ListOfMembers(
            circleId: int.parse(state.pathParameters['circleId']!),
            circleInfo: state.extra as CircleModel,
          ),
        ),
      ),
    ),
    GoRoute(
      path: '/generate-group-code',
      pageBuilder: (context, state) => NoTransitionPage(
        child: NoBackWrapper(child: const GenerateNewCode()),
      ),
    ),
    GoRoute(
      path: '/create-new-group',
      pageBuilder: (context, state) => NoTransitionPage(
        child: NoBackWrapper(child: const CreateNewGroup()),
      ),
    ),
    GoRoute(
      path: '/join-group',
      pageBuilder: (context, state) => NoTransitionPage(
        child: NoBackWrapper(child: const JoinGroup()),
      ),
    ),

    // Account and settings
    GoRoute(
      path: '/accountDetails',
      pageBuilder: (context, state) => NoTransitionPage(
        child: NoBackWrapper(child: const AccountDetails()),
      ),
    ),
    GoRoute(
      path: '/request-admin-access',
      pageBuilder: (context, state) => NoTransitionPage(
        child: NoBackWrapper(child: const RequestAdminAccessPage()),
      ),
    ),
    GoRoute(
      path: '/privacySecurity',
      pageBuilder: (context, state) => NoTransitionPage(
        child: NoBackWrapper(child: const PrivacySecurity()),
      ),
    ),
    GoRoute(
      path: '/location-service',
      pageBuilder: (context, state) => NoTransitionPage(
        child: NoBackWrapper(child: const Locationservice()),
      ),
    ),
    GoRoute(
      path: '/privacy',
      pageBuilder: (context, state) => NoTransitionPage(
        child: NoBackWrapper(child: const Privacy()),
      ),
    ),
    GoRoute(
      path: '/termsPolicy',
      pageBuilder: (context, state) => NoTransitionPage(
        child: NoBackWrapper(child: const TermsPolicy()),
      ),
    ),
    GoRoute(
      path: '/help-center',
      pageBuilder: (context, state) => NoTransitionPage(
        child: NoBackWrapper(child: const HelpCenter()),
      ),
    ),
    GoRoute(
      path: '/freespace',
      pageBuilder: (context, state) => NoTransitionPage(
        child: NoBackWrapper(child: const Freespace()),
      ),
    ),
    GoRoute(
      path: '/userGuide',
      pageBuilder: (context, state) => NoTransitionPage(
        child: NoBackWrapper(child: const UserGuide()),
      ),
    ),
    GoRoute(
      path: '/analytics',
      pageBuilder: (context, state) => NoTransitionPage(
        child: NoBackWrapper(
          child: const MainAnalytics(initialPage: 0),
        ),
      ),
    ),
    GoRoute(
      path: '/about',
      pageBuilder: (context, state) => NoTransitionPage(
        child: NoBackWrapper(child: const About()),
      ),
    ),
    GoRoute(
      path: '/starter',
      pageBuilder: (context, state) => NoTransitionPage(
        child: NoBackWrapper(child: const Starter()),
      ),
    ),
    GoRoute(
      path: '/login',
      pageBuilder: (context, state) => NoTransitionPage(
        child: NoBackWrapper(child: const LoginRT()),
      ),
    ),

    // Admin pages
    GoRoute(
      path: '/admin-initial-screen',
      pageBuilder: (context, state) => NoTransitionPage(
        child: NoBackWrapper(child: const AdminInitialScreen()),
      ),
    ),
    GoRoute(
      path: '/admin-safezones',
      pageBuilder: (context, state) => NoTransitionPage(
        child: NoBackWrapper(child: const AdminSafezones()),
      ),
    ),
    GoRoute(
      path: '/admin-reports',
      pageBuilder: (context, state) => NoTransitionPage(
        child: NoBackWrapper(child: const AdminReports()),
      ),
    ),
    GoRoute(
      path: '/admin-reports-details',
      pageBuilder: (context, state) {
        final extra = state.extra as Map<String, dynamic>;
        return NoTransitionPage(
          child: NoBackWrapper(
            child: AdminReportsDetails(
              reportInfo: extra['reportModel'] as IncidentReportModel,
              address: extra['address'] as String,
              onStatusChanged: extra['onStatusChanged'] as Function(IncidentReportModel)?,
            ),
          ),
        );
      },
    ),
    GoRoute(
      path: '/admin-safezone-details',
      pageBuilder: (context, state) {
        final extra = state.extra as Map<String, dynamic>;
        return NoTransitionPage(
          child: NoBackWrapper(
            child: AdminSafezoneDetails(
              safezonemodel: extra['safezone'] as SafeZoneModel,
              address: extra['address'] as String,
              onStatusChanged: extra['onStatusChanged'] as Function(SafeZoneModel)?,
            ),
          ),
        );
      },
    ),
  ],
);