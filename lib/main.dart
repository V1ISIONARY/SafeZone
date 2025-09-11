import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:safezone/backend/architecture/bloc/adminBloc/analytics/analytics_admin_bloc.dart';
import 'package:safezone/backend/architecture/bloc/adminBloc/incident_report/admin_incident_report_bloc.dart';
import 'package:safezone/backend/architecture/bloc/adminBloc/safezone/safezone_admin_bloc.dart';
import 'package:safezone/backend/architecture/bloc/authBloc/auth_bloc.dart';
import 'package:safezone/backend/architecture/bloc/circleBloc/circle_bloc.dart';
import 'package:safezone/backend/architecture/bloc/contactBloc/contact_bloc.dart';
import 'package:safezone/backend/architecture/bloc/dangerzoneBloc/dangerzone_bloc.dart';
import 'package:safezone/backend/architecture/bloc/dangerzoneBloc/dangerzone_event.dart';
import 'package:safezone/backend/architecture/bloc/incident_report/incident_report_bloc.dart';
import 'package:safezone/backend/architecture/bloc/mapBloc/map_bloc.dart';
import 'package:safezone/backend/architecture/bloc/mapBloc/map_event.dart';
import 'package:safezone/backend/architecture/bloc/notificationBloc/notification_bloc.dart';
import 'package:safezone/backend/architecture/bloc/profileBloc/profile_bloc.dart';
import 'package:safezone/backend/architecture/bloc/safezoneBloc/safezone_bloc.dart';
import 'package:safezone/backend/architecture/cubic/analytics.dart';
import 'package:safezone/backend/architecture/cubic/notification.dart';
import 'package:safezone/backend/repository/adminApi/analyticsApi/analytics_impl.dart';
import 'package:safezone/backend/repository/adminApi/incident_reportApi/admin_incident_impl.dart';
import 'package:safezone/backend/repository/adminApi/safezoneApi/safezone_impl.dart';
import 'package:safezone/backend/repository/authApi/auth_impl.dart';
import 'package:safezone/backend/repository/circleApi/circle_impl.dart';
import 'package:safezone/backend/repository/contactApi/contact_impl.dart';
import 'package:safezone/backend/repository/dangerzoneApi/dangerzone_impl.dart';
import 'package:safezone/backend/repository/incident_reportApi/incident_report_impl.dart';
import 'package:safezone/backend/repository/mapApi/map_impl.dart';
import 'package:safezone/backend/repository/notificationApi/notification_impl.dart';
import 'package:safezone/backend/repository/profileApi/profile_impl.dart';
import 'package:safezone/backend/repository/safezoneApi/safezone_impl.dart';
import 'package:safezone/backend/services/app_routes.dart';
import 'package:safezone/backend/services/firebase_options.dart';
import 'package:safezone/backend/services/shake_detector_service.dart';
import 'package:safezone/resource/schema/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize SharedPreferences and dotenv
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isFirstRun = prefs.getBool('isFirstRun') ?? true;
  String userToken = prefs.getString('userToken') ?? 'guest';

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

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatefulWidget {
  final bool isFirstRun;
  final String userToken;

  const MyApp({super.key, required this.isFirstRun, required this.userToken});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late ShakeDetectorService shakeDetector;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      shakeDetector = ShakeDetectorService(context);
    });
  }

  @override
  void dispose() {
    shakeDetector.stopListening();
    super.dispose();
  }

  Future<void> _initializeApp() async {
    await Firebase.initializeApp();
    await dotenv.load(fileName: ".env");
  }


  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializeApp(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MaterialApp(
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
                      combinedZonesRepository: CombinedZonesRepository(),
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
              routerConfig: appRouter(widget.isFirstRun, widget.userToken),
              theme: AppTheme.lightTheme,
              title: "SafeZone",
            ),
          );
        }
      },
    );
  }
}
