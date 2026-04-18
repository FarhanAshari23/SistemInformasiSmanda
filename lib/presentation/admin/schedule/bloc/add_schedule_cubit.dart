import 'package:flutter_bloc/flutter_bloc.dart';
import 'add_schedule_state.dart';
import 'card_schedule_state.dart';

class AddScheduleCubit extends Cubit<AddScheduleState> {
  AddScheduleCubit() : super(const AddScheduleState());

  void toggleAdding(String index) {
    final current = state.getCardState(index);
    final updated = current.copyWith(isAdding: !current.isAdding);
    final newMap = Map<String, CardScheduleState>.from(state.cardStates);
    newMap[index] = updated;
    emit(state.copyWith(cardStates: newMap));
  }

  void showPicker(String index) {
    _updateCard(index, (c) => c.copyWith(isPickerVisible: true));
  }

  void hidePicker(String index) {
    _updateCard(index, (c) => c.copyWith(isPickerVisible: false));
  }

  void updateStartTempTime(String index, DateTime startTime) {
    _updateCard(index, (c) => c.copyWith(selectedStartTimeTemp: startTime));
  }

  void updateEndTempTime(String index, DateTime endTime) {
    _updateCard(index, (c) => c.copyWith(selectedEndTimeTemp: endTime));
  }

  void resetCard(String index) {
    _updateCard(index, (_) => const CardScheduleState());
  }

  void _updateCard(
      String index, CardScheduleState Function(CardScheduleState) updater) {
    final current = state.getCardState(index);
    final updated = updater(current);
    final newMap = Map<String, CardScheduleState>.from(state.cardStates);
    newMap[index] = updated;
    emit(state.copyWith(cardStates: newMap));
  }
}
