import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safezone/backend/architecture/bloc/adminBloc/users/admin_users_event.dart';
import 'package:safezone/backend/architecture/bloc/adminBloc/users/admin_users_state.dart';
import 'package:safezone/backend/repository/adminApi/usersApi/admin_users_repo.dart';


class AdminUserBloc extends Bloc<AdminUserEvent, AdminUserState> {
  final AdminUserRepository repository;

  AdminUserBloc(this.repository) : super(AdminUserInitial()) {
    on<LoadAdminRequests>(_onLoadAdminRequests);
    on<ApproveAdminUser>(_onApproveAdminUser);
  }

  Future<void> _onLoadAdminRequests(
      LoadAdminRequests event, Emitter<AdminUserState> emit) async {
    emit(AdminUserLoading());
    try {
      final requests = await repository.getAdminRequests();
      emit(AdminRequestsLoaded(requests));
    } catch (e) {
      emit(AdminUserError('Failed to load requests: ${e.toString()}'));
    }
  }

  Future<void> _onApproveAdminUser(
      ApproveAdminUser event, Emitter<AdminUserState> emit) async {
    emit(AdminUserLoading());
    try {
      await repository.approveAdmin(event.userId);
      emit(AdminActionSuccess('User ${event.userId} approved as admin.'));
    } catch (e) {
      emit(AdminUserError('Failed to approve admin: ${e.toString()}'));
    }
  }

}
