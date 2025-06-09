import 'package:flutter_bloc/flutter_bloc.dart';

// Ensure NotificationCubit exists
class NotificationCubit extends Cubit<int> {
  NotificationCubit() : super(0);

  void changeSelectedIndex(int index) {
    emit(index);
  }
}

class BottomNavBloc extends Cubit<int> {
  BottomNavBloc() : super(0);

  void changeSelectedIndex(int index) => emit(index);
}