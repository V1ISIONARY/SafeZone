import 'package:safezone/backend/models/userModel/circle_model.dart';

abstract class CircleRepository {
  Future<List<CircleModel>> getUserCircles(int userId);
  Future<CircleModel> createCircle(String name, int userId);
  Future<void> addMemberToCircle(int circleId, int userId);
  Future<void> removeMemberFromCircle(int circleId, int userId);
}