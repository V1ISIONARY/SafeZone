import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:safezone/backend/apiservice/adminApi/analyticsApi/analytics_impl.dart';
import 'package:safezone/backend/apiservice/adminApi/incident_reportApi/admin_incident_impl.dart';
import 'package:safezone/backend/apiservice/adminApi/safezoneApi/safezone_impl.dart';
import 'package:safezone/backend/apiservice/adminApi/safezoneApi/safezone_repo.dart';
import 'package:safezone/backend/apiservice/circleApi/circle_impl.dart';
import 'package:safezone/backend/apiservice/notificationApi/notification_impl.dart';
import 'package:safezone/backend/apiservice/profileApi/profile_impl.dart';
import 'package:safezone/backend/bloc/adminBloc/analytics/analytics_admin_bloc.dart';
import 'package:safezone/backend/bloc/adminBloc/incident_report/admin_incident_report_bloc.dart';
import 'package:safezone/backend/bloc/adminBloc/safezone/safezone_admin_bloc.dart';
import 'package:safezone/backend/bloc/circleBloc/circle_bloc.dart';
import 'package:safezone/backend/bloc/notificationBloc/notification_bloc.dart';
import 'package:safezone/backend/bloc/profileBloc/profile_bloc.dart';
import 'package:safezone/backend/cubic/analytics.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safezone/backend/apiservice/contactApi/contact_impl.dart';
import 'package:safezone/backend/apiservice/dangerzoneApi/dangerzone_impl.dart';
import 'package:safezone/backend/apiservice/incident_reportApi/incident_report_impl.dart';
import 'package:safezone/backend/apiservice/safezoneApi/safezone_impl.dart';
import 'package:safezone/backend/bloc/contactBloc/contact_bloc.dart';
import 'package:safezone/backend/bloc/dangerzoneBloc/dangerzone_bloc.dart';
import 'package:safezone/backend/bloc/dangerzoneBloc/dangerzone_event.dart';
import 'package:safezone/backend/bloc/mapBloc/map_bloc.dart';
import 'package:safezone/backend/bloc/mapBloc/map_event.dart';
import 'package:safezone/backend/bloc/safezoneBloc/safezone_bloc.dart';
import 'package:safezone/backend/cubic/notification.dart';
import 'package:safezone/backend/bloc/incident_report/incident_report_bloc.dart';
import 'package:safezone/backend/apiservice/authApi/auth_impl.dart';
import 'package:safezone/backend/bloc/authBloc/auth_bloc.dart';
import 'package:safezone/app_routes.dart';
import 'package:safezone/resources/schema/app_theme.dart';
import 'firebase_options.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize SharedPreferences and dotenv
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isFirstRun = prefs.getBool('isFirstRun') ?? true;
  String userToken = prefs.getString('userToken') ?? 'guess';

  // Load environment variables
  await dotenv.load(fileName: ".env");

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize Awesome Notifications
  await AwesomeNotifications().initialize(
    null, // Change to your app icon
    [
      NotificationChannel(
        channelKey: 'alerts',
        channelName: 'Alerts',
        channelDescription: 'Notification channel for alerts',
        defaultColor: const Color(0xFF9D50DD),
        ledColor: Colors.white,
        importance: NotificationImportance.Max,
        playSound: true,
      ),
    ],
    debug: true, // Set to false in production
  );

  // Request notification permissions
  await AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
    if (!isAllowed) {
      AwesomeNotifications().requestPermissionToSendNotifications();
    }
  });

  runApp(MyApp(isFirstRun: isFirstRun, userToken: userToken));
}

class MyApp extends StatelessWidget {
  final bool isFirstRun;
  final String userToken;

  const MyApp({super.key, required this.isFirstRun, required this.userToken});

  Future<void> _initializeApp() async {
    await Firebase.initializeApp();
    await dotenv.load(fileName: ".env");
  }

  // Function to trigger a test notification
  Future<void> _sendTestNotification() async {
    // Check if notifications are allowed
    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();

    if (!isAllowed) {
      // Request permission to send notifications
      await AwesomeNotifications().requestPermissionToSendNotifications();
    }

    // Create the notification after permission is granted
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 10,
        channelKey: 'alerts',
        title: 'Welcome to SafeZone!',
        body: 'This is a test notification.',
        notificationLayout: NotificationLayout.Default,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializeApp(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return MaterialApp(
            home: Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
          );
        } else if (snapshot.hasError) {
          return MaterialApp(
            home: Scaffold(
              body: Center(child: Text('Error loading app: ${snapshot.error}')),
            ),
          );
        } else {
          // Trigger the notification test after app initialization
          _sendTestNotification();

          return MultiBlocProvider(
            providers: [
              BlocProvider(
                  create: (_) =>
                      AuthenticationBloc(AuthenticationImplementation())),
              BlocProvider(create: (_) => ContactBloc(ContactImplementation())),
              BlocProvider(create: (_) => NotificationCubit()),
              BlocProvider(create: (_) => AnalyticsCubic()),
              BlocProvider(
                  create: (_) => IncidentReportBloc(IncidentRepositoryImpl())),
              BlocProvider(
                  create: (_) => DangerZoneBloc(
                      dangerZoneRepository: DangerZoneRepositoryImpl())
                    ..add(FetchDangerZones())),
              BlocProvider(
                  create: (_) => SafeZoneBloc(
                      safeZoneRepository: SafeZoneRepositoryImpl())),
              BlocProvider(
                  create: (_) => MapBloc(
                      safeZoneRepository: SafeZoneRepositoryImpl(),
                      dangerZoneRepository: DangerZoneRepositoryImpl(),
                      circleRepository: CircleImplementation())
                    ..add(FetchMapData())),
              BlocProvider(
                  create: (_) =>
                      SafeZoneAdminBloc(SafezoneAdminRepositoryImpl())),
              BlocProvider(create: (_) => CircleBloc(CircleImplementation())),
              BlocProvider(create: (_) => ProfileBloc(ProfileImplementation())),
              BlocProvider(
                  create: (_) =>
                      NotificationBloc(NotificationImplementation())),
              BlocProvider(
                  create: (_) =>
                      AdminBloc(adminRepository: AdminRepositoryImpl())),
              BlocProvider(
                create: (_) => AdminIncidentReportBloc(
                  AdminIncidentRepositoryImpl(),
                ),
              ),
            ],
            child: MaterialApp.router(
              debugShowCheckedModeBanner: false,
              routerConfig: appRouter(isFirstRun, userToken),
              theme: AppTheme.lightTheme,
              title: "SafeZone",
            ),
          );
        }
      },
    );
  }
}
