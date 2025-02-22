import 'package:safezone/backend/models/userModel/circle_model.dart';

abstract class CircleRepository {
  Future<List<CircleModel>> getUserCircles(int userId);
  Future<CircleModel> createCircle(String name, int userId);
  Future<void> joinCircle(int userId, String code);
  Future<Map<String, dynamic>> generateCircleCode(int circleId);
  Future<void> removeMemberFromCircle(int circleId, int userId);
  Future<List<Map<String, dynamic>>> viewMembers(int circleId);
  Future<List<Map<String, dynamic>>> viewGroupMembers(int userId, int circleId);
}
