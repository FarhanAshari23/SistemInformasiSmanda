import 'package:flutter_bloc/flutter_bloc.dart';
import 'card_schedule_state.dart';
import 'edit_schedule_state.dart';

class EditScheduleCubit extends Cubit<EditScheduleState> {
  EditScheduleCubit() : super(const EditScheduleState());

  void toggleEdit(int index) {
    final current = state.getCardState(index);
    final updated = current.copyWith(isAdding: !current.isAdding);
    final newMap = Map<int, CardScheduleState>.from(state.cardStates);
    newMap[index] = updated;
    emit(state.copyWith(cardStates: newMap));
  }

  void showPicker(int index) {
    _updateCard(index, (c) => c.copyWith(isPickerVisible: true));
  }

  void hidePicker(int index) {
    _updateCard(index, (c) => c.copyWith(isPickerVisible: false));
  }

  void updateStartTempTime(int index, DateTime startTime) {
    _updateCard(index, (c) => c.copyWith(selectedStartTimeTemp: startTime));
  }

  void updateEndTempTime(int index, DateTime endTime) {
    _updateCard(index, (c) => c.copyWith(selectedEndTimeTemp: endTime));
  }

  void resetCard(int index) {
    _updateCard(index, (_) => const CardScheduleState());
  }

  void _updateCard(
      int index, CardScheduleState Function(CardScheduleState) updater) {
    final current = state.getCardState(index);
    final updated = updater(current);
    final newMap = Map<int, CardScheduleState>.from(state.cardStates);
    newMap[index] = updated;
    emit(state.copyWith(cardStates: newMap));
  }
}
