import 'package:flutter_bloc/flutter_bloc.dart';
import 'card_schedule_state.dart';
import 'edit_schedule_state.dart';

class EditScheduleCubit extends Cubit<EditScheduleState> {
  EditScheduleCubit() : super(const EditScheduleState());

  void toggleEdit(int index, String day) {
    final current = state.getCardState(index, day);
    final updated = current.copyWith(isAdding: !current.isAdding);
    final newMap =
        Map<String, Map<int, CardScheduleState>>.from(state.cardStates);

    // Pastikan hari sudah ada dalam map
    newMap.putIfAbsent(day, () => {});
    newMap[day]![index] = updated;

    emit(state.copyWith(cardStates: newMap));
  }

  void showPicker(int index, String day) {
    _updateCard(index, day, (c) => c.copyWith(isPickerVisible: true));
  }

  void hidePicker(int index, String day) {
    _updateCard(index, day, (c) => c.copyWith(isPickerVisible: false));
  }

  void updateStartTempTime(int index, String day, DateTime startTime) {
    _updateCard(
        index, day, (c) => c.copyWith(selectedStartTimeTemp: startTime));
  }

  void updateEndTempTime(int index, String day, DateTime endTime) {
    _updateCard(index, day, (c) => c.copyWith(selectedEndTimeTemp: endTime));
  }

  void resetCard(int index, String day) {
    _updateCard(index, day, (_) => const CardScheduleState());
  }

  void _updateCard(int index, String day,
      CardScheduleState Function(CardScheduleState) updater) {
    final current = state.getCardState(index, day);
    final updated = updater(current);
    final newMap =
        Map<String, Map<int, CardScheduleState>>.from(state.cardStates);

    // Pastikan hari sudah ada dalam map sebelum update
    newMap.putIfAbsent(day, () => {});
    newMap[day]![index] = updated;

    emit(state.copyWith(cardStates: newMap));
  }
}
