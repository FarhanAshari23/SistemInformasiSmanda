class CardScheduleState {
  final bool isAdding;
  final bool isPickerVisible;
  final DateTime? selectedStartTimeTemp;
  final DateTime? selectedEndTimeTemp;

  const CardScheduleState({
    this.isAdding = false,
    this.isPickerVisible = false,
    this.selectedStartTimeTemp,
    this.selectedEndTimeTemp,
  });

  CardScheduleState copyWith({
    bool? isAdding,
    bool? isPickerVisible,
    DateTime? selectedStartTimeTemp,
    DateTime? selectedEndTimeTemp,
  }) {
    return CardScheduleState(
      isAdding: isAdding ?? this.isAdding,
      isPickerVisible: isPickerVisible ?? this.isPickerVisible,
      selectedStartTimeTemp:
          selectedStartTimeTemp ?? this.selectedStartTimeTemp,
      selectedEndTimeTemp: selectedEndTimeTemp ?? this.selectedEndTimeTemp,
    );
  }
}
