// circle_state.dart
import 'package:safezone/backend/models/userModel/circle_model.dart';

abstract class CircleState {}

class CircleInitial extends CircleState {}

class CircleLoadingState extends CircleState {}

class CircleLoadedState extends CircleState {
  final List<CircleModel> circles;

  CircleLoadedState({required this.circles});
}

class CircleErrorState extends CircleState {
  final String message;

  CircleErrorState({required this.message});
}

class CircleCreatedState extends CircleState {
  final CircleModel circle;

  CircleCreatedState({required this.circle});
}

class CircleUpdatedState extends CircleState {
  final String message;

  CircleUpdatedState({required this.message});
}

class CircleDeletedState extends CircleState {
  final String message;

  CircleDeletedState({required this.message});
}

// New state for viewing members of a circle
class CircleMembersLoadedState extends CircleState {
  final List<Map<String, dynamic>> members;

  CircleMembersLoadedState({required this.members});
}

class CircleCodeGeneratedState extends CircleState {
  final String code;
  final String expiry;

  CircleCodeGeneratedState({required this.code, required this.expiry});
}

// New state for when a user is joining a circle
class CircleJoiningState extends CircleState {}

// New state for when a user has successfully joined a circle
class CircleJoinedState extends CircleState {
  final String message;

  CircleJoinedState({required this.message});
}
