// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:safezone/backend/apiservice/contactApi/contact_impl.dart';
import 'package:safezone/backend/apiservice/contactApi/contact_repo.dart';
import 'package:safezone/backend/bloc/contactBloc/contact_bloc.dart';
import 'package:safezone/frontend/widgets/bottom_navigation.dart';
//import 'package:safezone/app_routes.dart';
import 'package:safezone/frontend/pages/introduction/splash_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safezone/backend/apiservice/authApi/auth_impl.dart';
import 'package:safezone/backend/bloc/authBloc/auth_bloc.dart';
import 'package:safezone/app_routes.dart';
import 'package:safezone/resources/schema/app_theme.dart';

void main() {
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => AuthenticationBloc(AuthenticationImplementation()),
        ),
        BlocProvider(
          create: (_) => ContactBloc(ContactImplementation()), // Add ContactBloc
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
