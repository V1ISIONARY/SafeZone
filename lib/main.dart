import 'package:flutter/material.dart';
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

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isFirstRun = prefs.getBool('isFirstRun') ?? true;

  runApp(MyApp(isFirstRun: isFirstRun));
}

class MyApp extends StatelessWidget {
  final bool isFirstRun;
  const MyApp({super.key, required this.isFirstRun});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => AuthenticationBloc(AuthenticationImplementation()),
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
            dangerZoneRepository: DangerZoneRepositoryImpl(),
          )..add(FetchDangerZones()),
        ),
        BlocProvider(
          create: (_) => SafeZoneBloc(
            safeZoneRepository: SafeZoneRepositoryImpl(),
          ),
        ),
        BlocProvider(
          create: (_) => MapBloc(
            safeZoneRepository: SafeZoneRepositoryImpl(),
            dangerZoneRepository: DangerZoneRepositoryImpl(),
          )..add(FetchMapData()),
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
}
