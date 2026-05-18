abstract class ButtonState {}

class ButtonInitialState extends ButtonState {}

class ButtonLoadingState extends ButtonState {}

class ButtonSuccessState extends ButtonState {
  dynamic successMessage;
  ButtonSuccessState({
    this.successMessage = '',
  });
}

class ButtonFailureState extends ButtonState {
  final String errorMessage;
  ButtonFailureState({required this.errorMessage});
}
