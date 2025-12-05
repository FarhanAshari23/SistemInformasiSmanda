abstract class GetDistanceState {}

class GetDistanceLoading extends GetDistanceState {}

class GetDistanceLoaded extends GetDistanceState {
  final bool isNear;
  GetDistanceLoaded({
    required this.isNear,
  });
}

class GetDistanceFailure extends GetDistanceState {
  final String errorMessage;
  GetDistanceFailure({
    required this.errorMessage,
  });
}
