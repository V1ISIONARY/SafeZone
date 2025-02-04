// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
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
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safezone/backend/apiservice/authApi/auth_impl.dart';
import 'package:safezone/backend/bloc/authBloc/auth_bloc.dart';
import 'package:safezone/app_routes.dart';
import 'package:safezone/resources/schema/app_theme.dart';

void main() {
  // await dotenv.load(fileName: ".env");

  runApp(
    MultiBlocProvider(
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
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter,
      theme: AppTheme.lightTheme,
      title: "SafeZone",
    );
  }
}
