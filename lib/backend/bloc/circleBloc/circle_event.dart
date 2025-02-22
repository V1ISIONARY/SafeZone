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
  final String code;
  final int userId;

  AddMemberEvent({required this.code, required this.userId});
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

// New event for fetching members of a circle
class FetchMembersEvent extends CircleEvent {
  final int circleId;

  FetchMembersEvent({required this.circleId});
}

class GenerateCodeEvent extends CircleEvent {
  final int circleId;

  GenerateCodeEvent({required this.circleId});
}

class ViewGroupMembersEvent extends CircleEvent {
  final int circleId;
  final int userId;

  ViewGroupMembersEvent({required this.circleId, required this.userId});
}
