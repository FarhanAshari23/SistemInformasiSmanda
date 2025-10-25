import 'card_schedule_state.dart';

class AddScheduleState {
  final Map<String, CardScheduleState> cardStates;

  const AddScheduleState({this.cardStates = const {}});

  AddScheduleState copyWith({Map<String, CardScheduleState>? cardStates}) {
    return AddScheduleState(
      cardStates: cardStates ?? this.cardStates,
    );
  }

  CardScheduleState getCardState(String index) {
    return cardStates[index] ?? const CardScheduleState();
  }
}
