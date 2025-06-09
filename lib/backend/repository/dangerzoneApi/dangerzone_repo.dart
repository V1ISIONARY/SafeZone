// import 'dart:io';
import 'package:safezone/backend/models/dangerzoneModel/incident_report_model.dart';

abstract class DangerZoneRepository {
  // GET
  Future<List<DangerZoneModel>> getDangerZones();
  Future<List<DangerZoneModel>> getVerifiedDangerZones();
  Future<DangerZoneModel> getDangerZone(int id);
}
