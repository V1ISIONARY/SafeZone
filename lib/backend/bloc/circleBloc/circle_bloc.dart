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
        await _circleImplementation.addMemberToCircle(
            event.circleId, event.userId);
        emit(CircleUpdatedState(message: 'Member added successfully'));
      } catch (e) {
        emit(CircleErrorState(message: 'Error adding member: ${e.toString()}'));
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
        emit(CircleMembersLoadedState(members: members));
      } catch (e) {
        emit(CircleErrorState(
            message: 'Error fetching members: ${e.toString()}'));
      }
    });
  }
}
