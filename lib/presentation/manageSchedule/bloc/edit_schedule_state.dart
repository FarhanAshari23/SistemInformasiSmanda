import 'card_schedule_state.dart';

class EditScheduleState {
  final Map<String, Map<int, CardScheduleState>> cardStates;

  const EditScheduleState({this.cardStates = const {}});

  EditScheduleState copyWith({
    Map<String, Map<int, CardScheduleState>>? cardStates,
  }) {
    return EditScheduleState(
      cardStates: cardStates ?? this.cardStates,
    );
  }

  CardScheduleState getCardState(int index, String day) {
    return cardStates[day]?[index] ?? const CardScheduleState();
  }
}
