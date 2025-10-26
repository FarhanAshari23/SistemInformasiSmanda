import 'card_schedule_state.dart';

class EditScheduleState {
  final Map<int, CardScheduleState> cardStates;

  const EditScheduleState({this.cardStates = const {}});

  EditScheduleState copyWith({Map<int, CardScheduleState>? cardStates}) {
    return EditScheduleState(
      cardStates: cardStates ?? this.cardStates,
    );
  }

  CardScheduleState getCardState(int index) {
    return cardStates[index] ?? const CardScheduleState();
  }
}
