import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:safezone/backend/architecture/bloc/dangerzoneBloc/dangerzone_bloc.dart';
import 'package:safezone/backend/architecture/bloc/dangerzoneBloc/dangerzone_event.dart';
import 'package:safezone/backend/architecture/bloc/dangerzoneBloc/dangerzone_state.dart';
import 'package:safezone/frontend/platforms/mobile/widgets/cards/identified_zone.dart';

class AdminDangerzones extends StatefulWidget {
  const AdminDangerzones({super.key});

  @override
  State<AdminDangerzones> createState() => _AdminDangerzonesState();
}

class _AdminDangerzonesState extends State<AdminDangerzones> {
  @override
  void initState() {
    super.initState();
    context.read<DangerZoneBloc>().add(FetchDangerZones());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 240, 240, 240),
      body: Container(
        margin: const EdgeInsets.only(top: 15, left: 15, right: 15),
        child: BlocBuilder<DangerZoneBloc, DangerZoneState>(
          builder: (context, state) {
            if (state is DangerZonesLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is DangerZonesLoaded) {
              final dangerZones = state.dangerZones;

              if (dangerZones.isEmpty) {
                return const Center(
                  child: Text('No danger zones found'),
                );
              }

              return ListView.builder(
                itemCount: dangerZones.length,
                itemBuilder: (context, index) {
                  final zone = dangerZones[index];
                  return GestureDetector(
                    onTap: () {
                      context.push('/admin-danger-zone-details', extra: zone);
                    },
                    child: IdentifiedZone(
                      name: zone.name ?? 'Unknown',
                      profileImage: '',
                      location:
                          'Lat: ${zone.latitude}, Long: ${zone.longitude}',
                    ),
                  );
                },
              );
            } else if (state is DangerZonesError) {
              return Center(
                child: Text('Error: ${state.message}'),
              );
            } else {
              return const Center(
                child: Text('Unknown state'),
              );
            }
          },
        ),
      ),
    );
  }
}
