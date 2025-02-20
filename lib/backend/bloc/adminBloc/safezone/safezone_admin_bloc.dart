import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safezone/backend/apiservice/adminApi/safezoneApi/safezone_repo.dart';
import 'safezone_admin_event.dart';
import 'safezone_admin_state.dart';

class SafeZoneAdminBloc extends Bloc<SafeZoneAdminEvent, SafeZoneAdminState> {
  final SafeZoneAdminRepository safeZoneAdminRepository;

  SafeZoneAdminBloc(this.safeZoneAdminRepository)
      : super(SafeZoneAdminInitial()) {
    on<VerifySafeZone>(_onVerifySafeZone);
    on<RejectSafeZone>(_onRejectSafeZone);
    on<ReviewSafeZone>(_onReviewSafeZone);
  }

  Future<void> _onVerifySafeZone(
      VerifySafeZone event, Emitter<SafeZoneAdminState> emit) async {
    print("🔹 VerifySafeZone Event Received: ID = ${event.id}");
    emit(SafeZoneAdminLoading());
    try {
      bool success = await safeZoneAdminRepository.verifySafezone(event.id);
      if (success) {
        print("✅ SafeZone Verified in Database");
        emit(const SafeZoneAdminSuccess("SafeZone verified successfully."));
      } else {
        print("❌ SafeZone Verification Failed");
      }
    } catch (e) {
      print("❌ Error Verifying SafeZone: ${e.toString()}");
      emit(SafeZoneAdminFailure("Failed to verify SafeZone: ${e.toString()}"));
    }
  }

  Future<void> _onRejectSafeZone(
      RejectSafeZone event, Emitter<SafeZoneAdminState> emit) async {
    emit(SafeZoneAdminLoading());
    try {
      bool success = await safeZoneAdminRepository.rejectSafezone(event.id);
      if (success) {
        emit(const SafeZoneAdminSuccess("SafeZone rejected successfully."));
      }
    } catch (e) {
      emit(SafeZoneAdminFailure("Failed to reject SafeZone: ${e.toString()}"));
    }
  }

  Future<void> _onReviewSafeZone(
      ReviewSafeZone event, Emitter<SafeZoneAdminState> emit) async {
    print("🔹 ReviewSafeZone Event Received: ID = ${event.id}");
    emit(SafeZoneAdminLoading());
    try {
      bool success = await safeZoneAdminRepository.reviewSafezone(event.id);
      if (success) {
        print("✅ SafeZone Review in Database");
        emit(const SafeZoneAdminSuccess("SafeZone under review."));
      }
    } catch (e) {
      print("❌ Error Review SafeZone: ${e.toString()}");

      emit(SafeZoneAdminFailure("Failed to review SafeZone: ${e.toString()}"));
    }
  }
}
