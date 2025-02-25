import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:safezone/backend/apiservice/adminApi/safezoneApi/safezone_impl.dart';
import 'package:safezone/backend/apiservice/adminApi/safezoneApi/safezone_repo.dart';
import 'package:safezone/backend/apiservice/circleApi/circle_impl.dart';
import 'package:safezone/backend/apiservice/notificationApi/notification_impl.dart';
import 'package:safezone/backend/apiservice/profileApi/profile_impl.dart';
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

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Ensures that all widgets are properly initialized

  // Initialize SharedPreferences and dotenv
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isFirstRun = prefs.getBool('isFirstRun') ?? true;

  // Load environment variables
  await dotenv.load(fileName: ".env");

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions
        .currentPlatform, // Use the generated options here
  );

  runApp(MyApp(isFirstRun: isFirstRun));
}

class MyApp extends StatelessWidget {
  final bool isFirstRun;

  const MyApp({super.key, required this.isFirstRun});

  Future<void> _initializeApp() async {
    // You can add additional initialization logic here if necessary
    await Firebase.initializeApp();
    await dotenv.load(fileName: ".env");
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializeApp(),
      builder: (context, snapshot) {
        // Show loading spinner while Firebase is initializing
        if (snapshot.connectionState == ConnectionState.waiting) {
          return MaterialApp(
            home: Scaffold(
              body:
                  Center(child: CircularProgressIndicator()), // Loading spinner
            ),
          );
        } else if (snapshot.hasError) {
          // Display error if initialization fails
          return MaterialApp(
            home: Scaffold(
              body: Center(child: Text('Error loading app: ${snapshot.error}')),
            ),
          );
        } else {
          // Once initialized, show the app
          return MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (_) =>
                    AuthenticationBloc(AuthenticationImplementation()),
              ),
              BlocProvider(
                create: (_) => ContactBloc(ContactImplementation()),
              ),
              BlocProvider(
                create: (_) => NotificationCubit(),
              ),
              BlocProvider(
                create: (_) => AnalyticsCubic(),
              ),
              BlocProvider(
                create: (_) => IncidentReportBloc(IncidentRepositoryImpl()),
              ),
              BlocProvider(
                create: (_) => DangerZoneBloc(
                    dangerZoneRepository: DangerZoneRepositoryImpl())
                  ..add(FetchDangerZones()),
              ),
              BlocProvider(
                create: (_) =>
                    SafeZoneBloc(safeZoneRepository: SafeZoneRepositoryImpl()),
              ),
              BlocProvider(
                create: (_) => MapBloc(
                    safeZoneRepository: SafeZoneRepositoryImpl(),
                    dangerZoneRepository: DangerZoneRepositoryImpl(),
                    circleRepository: CircleImplementation())
                  ..add(FetchMapData()),
              ),
              BlocProvider(
                create: (_) => SafeZoneAdminBloc(SafezoneAdminRepositoryImpl()),
              ),
              BlocProvider(
                create: (_) => CircleBloc(CircleImplementation()),
              ),
              BlocProvider(
                create: (_) => ProfileBloc(ProfileImplementation()),
              ),
              BlocProvider(
                create: (_) => NotificationBloc(NotificationImplementation()),
              ),
            ],
            child: MaterialApp.router(
              debugShowCheckedModeBanner: false,
              routerConfig: appRouter(isFirstRun),
              theme: AppTheme.lightTheme,
              title: "SafeZone",
            ),
          );
        }
      },
    );
  }
}
