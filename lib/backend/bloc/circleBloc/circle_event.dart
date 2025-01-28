// circle_event.dart
abstract class CircleEvent {}

class FetchCirclesEvent extends CircleEvent {
  final int userId;

  FetchCirclesEvent({required this.userId});
}

class CreateCircleEvent extends CircleEvent {
  final String name;
  final int userId;

  CreateCircleEvent({required this.name, required this.userId});
}

class AddMemberEvent extends CircleEvent {
  final int circleId;
  final int userId;

  AddMemberEvent({required this.circleId, required this.userId});
}

class RemoveMemberEvent extends CircleEvent {
  final int circleId;
  final int userId;

  RemoveMemberEvent({required this.circleId, required this.userId});
}

class DeleteCircleEvent extends CircleEvent {
  final int circleId;

  DeleteCircleEvent({required this.circleId});
}
