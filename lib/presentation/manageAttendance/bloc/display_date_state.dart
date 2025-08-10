import 'package:new_sistem_informasi_smanda/domain/entities/attandance/attandance.dart';

abstract class DisplayDateState {}

class DisplayDateLoading extends DisplayDateState {}

class DisplayDateLoaded extends DisplayDateState {
  final List<AttandanceEntity> attendances;
  DisplayDateLoaded({required this.attendances});
}

class DisplayDateFailure extends DisplayDateState {
  final String errorMessage;
  DisplayDateFailure({required this.errorMessage});
}
