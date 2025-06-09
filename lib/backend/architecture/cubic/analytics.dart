import 'package:flutter_bloc/flutter_bloc.dart';

// Ensure AnalyticsCubic exists
class AnalyticsCubic extends Cubit<int> {
  AnalyticsCubic() : super(0);

  void changeSelectedIndex(int index) {
    emit(index);
  }
}

class BottomNavBloc extends Cubit<int> {
  BottomNavBloc() : super(0);

  void changeSelectedIndex(int index) => emit(index);
}
