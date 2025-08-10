import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_sistem_informasi_smanda/presentation/manageAttendance/bloc/check_press_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CheckPressCubit extends Cubit<CheckPressState> {
  CheckPressCubit() : super(MyWidgetInitial());

  Future<void> checkLastPress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int lastPressTimestamp = prefs.getInt('lastPress') ?? 0;
    DateTime lastPressTime =
        DateTime.fromMillisecondsSinceEpoch(lastPressTimestamp);
    if (lastPressTime.day == DateTime.now().day) {
      emit(MyWidgetPressed());
    } else {
      emit(MyWidgetInitial());
    }
  }

  Future<void> buttonPressed() async {
    if (state is MyWidgetPressed) return;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('lastPress', DateTime.now().millisecondsSinceEpoch);

    emit(MyWidgetPressed());
  }
}
