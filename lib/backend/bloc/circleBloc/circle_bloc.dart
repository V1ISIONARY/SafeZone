import 'package:bloc/bloc.dart';
import 'package:safezone/backend/apiservice/circleApi/circle_impl.dart';
import 'circle_event.dart';
import 'circle_state.dart';

class CircleBloc extends Bloc<CircleEvent, CircleState> {
  final CircleImplementation _circleImplementation;

  CircleBloc(this._circleImplementation) : super(CircleInitial()) {
    // Fetch circles for a user
    on<FetchCirclesEvent>((event, emit) async {
      emit(CircleLoadingState());
      try {
        final circles =
            await _circleImplementation.getUserCircles(event.userId);
        emit(CircleLoadedState(circles: circles));
      } catch (e) {
        emit(CircleErrorState(
            message: 'Error fetching circles: ${e.toString()}'));
      }
    });

    // Create a new circle
    on<CreateCircleEvent>((event, emit) async {
      emit(CircleLoadingState());
      try {
        final circle =
            await _circleImplementation.createCircle(event.name, event.userId);
        emit(CircleCreatedState(circle: circle));
      } catch (e) {
        emit(CircleErrorState(
            message: 'Error creating circle: ${e.toString()}'));
      }
    });

    // Add member to the circle
    on<AddMemberEvent>((event, emit) async {
      emit(CircleLoadingState());
      try {
        await _circleImplementation.joinCircle(
          event.userId,
          event.code,
        );
        emit(CircleUpdatedState(message: 'Joining Group successfully'));
      } catch (e) {
        emit(CircleErrorState(message: 'Error Joining Group: ${e.toString()}'));
      }
    });

    // Remove member from the circle
    on<RemoveMemberEvent>((event, emit) async {
      emit(CircleLoadingState());
      try {
        await _circleImplementation.removeMemberFromCircle(
            event.circleId, event.userId);
        emit(CircleUpdatedState(message: 'Member removed successfully'));
      } catch (e) {
        emit(CircleErrorState(
            message: 'Error removing member: ${e.toString()}'));
      }
    });

    // Delete a circle
    on<DeleteCircleEvent>((event, emit) async {
      emit(CircleLoadingState());
      try {
        await _circleImplementation.deleteCircle(event.circleId);
        emit(CircleDeletedState(message: 'Circle deleted successfully'));
      } catch (e) {
        emit(CircleErrorState(
            message: 'Error deleting circle: ${e.toString()}'));
      }
    });

    // Fetch members of a circle
    on<FetchMembersEvent>((event, emit) async {
      emit(CircleLoadingState());
      try {
        final members = await _circleImplementation.viewMembers(event.circleId);
        print("Raw API Response: ${members}");
        emit(CircleMembersLoadedState(members: members));
      } catch (e) {
        emit(CircleErrorState(
            message: 'Error fetching members: ${e.toString()}'));
      }
    });
// Generate a circle code
    on<GenerateCodeEvent>((event, emit) async {
      emit(CircleLoadingState());
      try {
        final response =
            await _circleImplementation.generateCircleCode(event.circleId);
        emit(CircleCodeGeneratedState(
          code: response['code'],
          expiry: response['expiry'],
        ));
      } catch (e) {
        emit(CircleErrorState(
          message: 'Error generating code: ${e.toString()}',
        ));
      }
    });
    on<ViewGroupMembersEvent>((event, emit) async {
      emit(CircleLoadingState());
      try {
        final members = await _circleImplementation.viewGroupMembers(
            event.userId, event.circleId);
        emit(GroupMembersLoadedState(members: members));
      } catch (e) {
        emit(CircleErrorState(
            message: 'Error fetching group members: ${e.toString()}'));
      }
    });
    on<ChangeActiveEvent>((event, emit) async {
      emit(CircleActiveChangingState(
          circleId: event.circleId, isActive: event.isActive));

      try {
        await _circleImplementation.activeCircle(event.userId,
            event.circleId, event.isActive);
        emit(CircleActiveChangedState(
            circleId: event.circleId, isActive: event.isActive));
      } catch (e) {
        emit(CircleErrorState(
          message: 'Error Changing Circle Status: ${e.toString()}',
        ));
      }
    });
  }
}
